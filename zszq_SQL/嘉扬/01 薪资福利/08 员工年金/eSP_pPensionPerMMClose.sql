USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionPerMMClose]
-- skydatarefresh eSP_pPensionPerMMClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配月度关闭程序
-- @ID 为年金计划分配月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 月度年金计划分配未开启!
    If Exists(Select 1 From pPensionPerMM Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930067
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新年金月度表项pPensionPerMM
    Update a
    Set a.Closed=1,ClosedBy=@URID,ClosedTime=GETDATE()
    From pPensionPerMM a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新部门年金月度表项pDepPensionPerMM
    update a
    set a.IsSubmit=1
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and a.PensionMonth=b.PensionMonth
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 插入年金月度历史数据表项
    -- 插入后台人员月度历史数据表项pEmpPensionPerMM_all
    insert pEmpPensionPerMM_all(PensionMonth,EID,GrpPensionPerMM,EmpPensionPerMMBTax,EmpPensionPerMMATax,GrpPensionMonthTotal,
    GrpPensionMonthRest,EmpPensionMonthTotal,EmpPensionMonthRest,Remark,PensionContact,Submit,SubmitBy,SubmitTime)
    select a.PensionMonth,a.EID,a.GrpPensionPerMM,a.EmpPensionPerMMBTax,a.EmpPensionPerMMATax,a.GrpPensionMonthTotal,
    a.GrpPensionMonthRest,a.EmpPensionMonthTotal,a.EmpPensionMonthRest,a.Remark,a.PensionContact,
    a.Submit,a.SubmitBy,a.SubmitTime
    from pEmpPensionPerMM_register a
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 插入投理顾人员月度历史数据表项pSDMarketerPensionPerMM_all
    insert pSDMarketerPensionPerMM_all(PensionMonth,Name,Identification,Status,SupDepID,DepID,JobID,SalaryPayID,Gender,
    JoinDate,LeaveDate,IsPension,GrpPensionPerMM,EmpPensionPerMMBTax,EmpPensionPerMMATax,GrpPensionMonthTotal,GrpPensionMonthRest,
    EmpPensionMonthTotal,EmpPensionMonthRest,Remark,PensionContact,Submit,SubmitBy,SubmitTime)
    select a.PensionMonth,a.Name,a.Identification,a.Status,a.SupDepID,a.DepID,a.JobID,a.SalaryPayID,a.Gender,
    a.JoinDate,a.LeaveDate,a.IsPension,a.GrpPensionPerMM,a.EmpPensionPerMMBTax,a.EmpPensionPerMMATax,a.GrpPensionMonthTotal,
    a.GrpPensionMonthRest,a.EmpPensionMonthTotal,a.EmpPensionMonthRest,a.Remark,a.PensionContact,a.Submit,a.SubmitBy,a.SubmitTime
    from pSDMarketerPensionPerMM_register a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新投理顾员工在职状态、离职时间
    update a
    set a.Status=b.Status,a.LeaveDate=b.LeaveDate
    from pSalesDepartMarketerEmolu a,pSDMarketerPensionPerMM_register b
    where a.Identification=b.Identification and b.Status=4


    -- 将月度年金分配的企业年金、个人年金和企业剩余年金添加到员工公司年金累计中
    ---- 中后台员工
    ---- 更新pEmpPensionPerMM_register的GrpPensionPerMM到pEmployeeEmolu的GrpPensionTotal
    ---- 更新pEmpPensionPerMM_register的EmpPensionPerMMBTax+EmpPensionPerMMATax到pEmployeeEmolu的EmpPensionTotal
    ---- 更新pEmpPensionPerMM_register的GrpPensionMonthRest到pEmployeeEmolu的GrpPensionYearRest
    update a
    set a.GrpPensionTotal=ISNULL(a.GrpPensionTotal,0)+ISNULL(b.GrpPensionPerMM,0),
    a.EmpPensionTotal=ISNULL(a.EmpPensionTotal,0)+ISNULL(b.EmpPensionPerMMBTax,0)+ISNULL(b.EmpPensionPerMMATax,0),
    a.GrpPensionYearRest=ISNULL(b.GrpPensionMonthRest,0),a.EmpPensionYearRest=ISNULL(b.EmpPensionMonthRest,0)
    from pEmployeeEmolu a,pEmpPensionPerMM_register b
    where a.EID=b.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 将月度年金分配的公司年金添加到员工公司年金累计中
    ---- 投理顾员工
    ---- 更新pSDMarketerPensionPerMM_register的GrpPensionPerMM到pSalesDepartMarketerEmolu的GrpPensionTotal
    ---- 更新pSDMarketerPensionPerMM_register的EmpPensionPerMMBTax+EmpPensionPerMMATax到pSalesDepartMarketerEmolu的EmpPensionTotal
    ---- 更新pSDMarketerPensionPerMM_register的GrpPensionMonthRest到pSalesDepartMarketerEmolu的GrpPensionYearRest
    update a
    set a.GrpPensionTotal=ISNULL(a.GrpPensionTotal,0)+ISNULL(b.GrpPensionPerMM,0),
    a.EmpPensionTotal=ISNULL(a.EmpPensionTotal,0)+ISNULL(b.EmpPensionPerMMBTax,0)+ISNULL(b.EmpPensionPerMMATax,0),
    a.GrpPensionYearRest=ISNULL(b.GrpPensionMonthRest,0),a.EmpPensionYearRest=ISNULL(b.EmpPensionMonthRest,0)
    from pSalesDepartMarketerEmolu a,pSDMarketerPensionPerMM_register b
    where a.Identification=b.Identification
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 年金分配期间人员前台与后台变更
    ---- 同步后台至前台
    update a
    set a.GrpPensionTotal=ISNULL(a.GrpPensionTotal,0)+ISNULL(b.GrpPensionPerMM,0),
    a.EmpPensionTotal=ISNULL(a.EmpPensionTotal,0)+ISNULL(b.EmpPensionPerMMBTax,0)+ISNULL(b.EmpPensionPerMMATax,0),
    a.GrpPensionYearRest=ISNULL(b.GrpPensionMonthRest,0),a.EmpPensionYearRest=ISNULL(b.EmpPensionMonthRest,0)
    from pSalesDepartMarketerEmolu a,pEmpPensionPerMM_register b,eDetails c
    where b.EID=c.EID and c.CertNo=a.Identification
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 同步前台至后台
    update a
    set a.GrpPensionTotal=ISNULL(a.GrpPensionTotal,0)+ISNULL(b.GrpPensionPerMM,0),
    a.EmpPensionTotal=ISNULL(a.EmpPensionTotal,0)+ISNULL(b.EmpPensionPerMMBTax,0)+ISNULL(b.EmpPensionPerMMATax,0),
    a.GrpPensionYearRest=ISNULL(b.GrpPensionMonthRest,0),a.EmpPensionYearRest=ISNULL(b.EmpPensionMonthRest,0)
    from pEmployeeEmolu a,pSDMarketerPensionPerMM_register b,eDetails c
    where a.EID=c.EID and c.CertNo=b.Identification 
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 将月度年金分配的个人年金税前和税后更新到员工个人月工资年金中
    --update a
    --set a.PensionEMPBT=b.EmpPensionPerMMBTax,a.PensionEMPAT=b.EmpPensionPerMMATax
    --from pEmployeePension a,pEmpPensionPerMM_register b
    --where a.EID=b.EID and DATEDIFF(mm,a.Date,b.PensionMonth)=0
    -- 异常流程
    --If @@Error<>0
    --Goto ErrM


    -- 设置月度年金统计数据
    ---- 企业年金实际分配总额数据
    ---- 个人年金税前实际分配总额数据
    ---- 个人年金税后实际分配总额数据
    ---- 企业年金分配剩余总额数据
    update a
    set a.GrpPensionTotalMM=(select ISNULL(SUM(GrpPensionPerMM),0) from pEmpPensionPerMM_register) + (select ISNULL(SUM(GrpPensionPerMM),0) from pSDMarketerPensionPerMM_register),
    a.EmpPensionBTTotalMM=(select ISNULL(SUM(EmpPensionPerMMBTax),0) from pEmpPensionPerMM_register)+(select ISNULL(SUM(EmpPensionPerMMBTax),0) from pSDMarketerPensionPerMM_register),
    a.EmpPensionATTotalMM=(select ISNULL(SUM(EmpPensionPerMMATax),0) from pEmpPensionPerMM_register) + (select ISNULL(SUM(EmpPensionPerMMATax),0) from pSDMarketerPensionPerMM_register),
    a.GrpPensionRestTotalMM=(select ISNULL(SUM(GrpPensionMonthRest),0) from pEmpPensionPerMM_register) + (select ISNULL(SUM(GrpPensionMonthRest),0) from pSDMarketerPensionPerMM_register)
    from pPensionPerMM a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 删除年金月度数据表项
    -- 删除后台人员月度数据表项pEmpPensionPerMM_register
    delete from pEmpPensionPerMM_register
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 删除投理顾人员月度数据表项pSDMarketerPensionPerMM_register
    delete from pSDMarketerPensionPerMM_register
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