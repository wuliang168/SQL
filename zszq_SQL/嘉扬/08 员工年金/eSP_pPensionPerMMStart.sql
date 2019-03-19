USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionPerMMStart]
-- skydatarefresh eSP_pPensionPerMMStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配月度开启程序
-- @ID 为年金计划分配月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
    
    -- 月度年金计划分配已开启!
    If Exists(Select 1 From pPensionPerMM Where ID=@ID And Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930065
        Return @RetVal
    End

    -- 月度年金计划分配未选择月份!
    If Exists(Select 1 From pPensionPerMM Where ID=@ID And PensionMonth is NULL)
    Begin
        Set @RetVal = 930066
        Return @RetVal
    End

    -- 上月度年金计划分配未关闭!
    If Exists(Select 1 From pPensionPerMM Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930070
        Return @RetVal
    End


    Begin TRANSACTION


    -- 插入部门年金月度表项pDepPensionPerMM
    insert into pDepPensionPerMM(PensionMonth,SupDepID,DepID,Status,SalaryPayID,PensionContact,IsSubmit)
    select a.PensionMonth,b.SupDepID,b.DepID,b.Status,b.SalaryPayID,b.PensionContact,1
    from pPensionPerMM a,pVW_DepPensionContact b
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新营业部中后台和投理顾递交标记
    update a
    set a.IsEmpSubmit=1,a.IsSDMSubmit=1
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and a.PensionMonth=b.PensionMonth


    ---- 更新年金填写说明信息
    update a
    set a.Remark=b.Instruction
    from pDepPensionPerMM a,pPensionInfo b,pPensionPerMM c
    where b.ID=1 and c.ID=@ID and a.PensionMonth=c.PensionMonth
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 插入后台人员年金月度分配注册表pEmpPensionPerMM_register
    -- 薪酬类型非营业部;
    insert into pEmpPensionPerMM_register(PensionMonth,EID,GrpPensionMonthTotal,GrpPensionMonthRest,EmpPensionMonthTotal,EmpPensionMonthRest,PensionContact)
    select a.PensionMonth,b.EID,b.GrpPensionYearRest,b.GrpPensionYearRest,b.EmpPensionYearRest,b.EmpPensionYearRest,d.PensionContact
    from pPensionPerMM a,pEmployeeEmolu b,eEmployee c,oCD_SalaryPayType d
    where a.ID=@ID and ISNULL(b.GrpPensionYearRest,0)>0 and b.eid=c.eid and ISNULL(b.GrpPensionYearRest,0)<>0 and c.status not in (4)
    and b.SalaryPayID=d.ID and b.SalaryPayID not in (6) and b.GrpPensionYearRest>0.03
    and b.EID not in (select EID from pEmpPensionPerMM_register)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 薪酬类型营业部;
    insert into pEmpPensionPerMM_register(PensionMonth,EID,GrpPensionMonthTotal,GrpPensionMonthRest,EmpPensionMonthTotal,EmpPensionMonthRest,PensionContact)
    select a.PensionMonth,b.EID,b.GrpPensionYearRest,b.GrpPensionYearRest,b.EmpPensionYearRest,b.EmpPensionYearRest,d.DepPensionContact
    from pPensionPerMM a,pEmployeeEmolu b,eEmployee c,odepartment d
    where a.ID=@ID and ISNULL(b.GrpPensionYearRest,0)>0 and b.eid=c.eid and ISNULL(b.GrpPensionYearRest,0)<>0 and c.status not in (4)
    and c.DepID=d.DepID and b.SalaryPayID in (6) and b.GrpPensionYearRest>0.03
    and b.EID not in (select EID from pEmpPensionPerMM_register)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入投理顾人员年金月度分配注册表pSDMarketerPensionPerMM_register
    insert into pSDMarketerPensionPerMM_register(PensionMonth,Name,Status,SupDepID,DepID,JobID,SalaryPayID,Gender,Identification,
    JoinDate,LeaveDate,IsPension,GrpPensionMonthTotal,GrpPensionMonthRest,EmpPensionMonthTotal,EmpPensionMonthRest,PensionContact)
    select a.PensionMonth,b.Name,b.Status,b.SupDepID,b.DepID,b.JobID,b.SalaryPayID,b.Gender,b.Identification,
    b.JoinDate,b.LeaveDate,b.IsPension,b.GrpPensionYearRest,b.GrpPensionYearRest,b.EmpPensionYearRest,b.EmpPensionYearRest,c.DepPensionContact
    from pPensionPerMM a,pSalesDepartMarketerEmolu b,odepartment c
    where a.ID=@ID and ISNULL(b.GrpPensionYearRest,0)>0 and c.DepID=ISNULL(b.DepID,b.SupDepID) and ISNULL(b.GrpPensionYearRest,0)<>0 
    and b.status not in (4) and b.GrpPensionYearRest>0.03
    and b.Identification not in (select Identification from pSDMarketerPensionPerMM_register)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 开启无企业年金分配员工的部门pDepPensionPerMM
    ---- 薪酬类型非营业部
    ------ 总部
    update a
    set a.IsSubmit=NULL
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and a.PensionMonth=b.PensionMonth and ISNULL(a.DepID,a.SupDepID) is NULL
    and a.SalaryPayID in (select 1 from pEmployeeEmolu where EID in (select EID from pEmpPensionPerMM_register) and SalaryPayID in (1,2,3,10,11,12,13,14,15,16))
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ------ 资管
    update a
    set a.IsSubmit=NULL
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and a.PensionMonth=b.PensionMonth and ISNULL(a.DepID,a.SupDepID) is NULL
    and a.SalaryPayID in (select 4 from pEmployeeEmolu where EID in (select EID from pEmpPensionPerMM_register) and SalaryPayID in (4,5))
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ------ 资本
    update a
    set a.IsSubmit=NULL
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and a.PensionMonth=b.PensionMonth and ISNULL(a.DepID,a.SupDepID) is NULL
    and a.SalaryPayID in (select 7 from pEmployeeEmolu where EID in (select EID from pEmpPensionPerMM_register) and SalaryPayID in (7))
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ------ 退休
    update a
    set a.IsSubmit=NULL
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and a.PensionMonth=b.PensionMonth and ISNULL(a.DepID,a.SupDepID) is NULL
    and a.SalaryPayID in (select 8 from pEmployeeEmolu where EID in (select EID from pEmpPensionPerMM_register) and SalaryPayID in (8))
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    --- 薪酬类型营业部
    ---- 开启中后台
    update a
    set a.IsSubmit=NULL,a.IsEmpSubmit=NULL
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and a.PensionMonth=b.PensionMonth and ISNULL(a.DepID,a.SupDepID) is not NULL
    and a.PensionContact in (select PensionContact from pEmpPensionPerMM_register 
    where ISNULL(SupDepID,0)=ISNULL(a.SupDepID,0) and ISNULL(DepID,0)=ISNULL(a.DepID,0))
    and ISNULL(a.DepID,a.SupDepID) in (select b.DepID from pEmpPensionPerMM_register a,eEmployee b where a.EID=b.EID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 开启投理顾
    update a
    set a.IsSubmit=NULL,a.IsSDMSubmit=NULL
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and a.PensionMonth=b.PensionMonth and ISNULL(a.DepID,a.SupDepID) is not NULL
    and a.PensionContact in (select PensionContact from pSDMarketerPensionPerMM_register 
    where ISNULL(SupDepID,0)=ISNULL(a.SupDepID,0) and ISNULL(DepID,0)=ISNULL(a.DepID,0))
    and ISNULL(a.DepID,a.SupDepID) in (select ISNULL(DepID,SupDepID) from pSDMarketerPensionPerMM_register)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度工资年金数据到月度年金分配数据
    ---- 月度工资已开启并未关闭
    update a
    set a.EmpPensionPerMMBTax=b.PensionEMPBT,a.EmpPensionPerMMATax=b.PensionEMPAT
    from pEmpPensionPerMM_register a,pEmployeePension b
    where a.EID=b.EID and DATEDIFF(mm,b.Date,a.PensionMonth)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 月度工资已开启并已关闭
    update a
    set a.EmpPensionPerMMBTax=b.PensionEMPBT,a.EmpPensionPerMMATax=b.PensionEMPAT
    from pEmpPensionPerMM_register a,pEmployeePension_all b
    where a.EID=b.EID and DATEDIFF(mm,b.Date,a.PensionMonth)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    
    -- 更新年金月度表项pPensionPerMM
    Update a
    Set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    From pPensionPerMM a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 递交
    COMMIT TRANSACTION

    -- 正常处理流程
    Set @Retval = 0
    Return @Retval

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval

End