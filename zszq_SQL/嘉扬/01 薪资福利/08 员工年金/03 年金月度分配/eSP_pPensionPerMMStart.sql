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
    If Exists(Select 1 From pPensionPerMM Where ID=@ID And ISNULL(Submit,0)=1)
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
    insert into pDepPensionPerMM(pProcessID,PensionMonth,SupDepID,DepID,Status,SalaryPayID,PensionContact,Remark)
    select a.ID,a.PensionMonth,b.SupDepID,b.DepID,b.Status,b.SalaryPayID,b.PensionContact,c.Instruction
    from pPensionPerMM a,pVW_DepPensionContact b,pPensionInfo c
    where a.ID=@ID and c.ID=1 and b.Status<>5
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入人员年金月度分配注册表pEmpPensionPerMM_register
    insert into pEmpPensionPerMM_register(pProcessID,PensionMonth,EID,BID,DepID,SalaryPayID,EmpPensionMonthTotal,EmpPensionMonthRest,PensionContact)
    select a.ID,a.PensionMonth,b.EID,b.BID,c.DepID,(case when b.BID is NULL then (select SalaryPayID from pEMPSalary where EID=b.EID) else 6 end),
    b.EmpPensionPerYYRST,b.EmpPensionPerYYRST,
    (case when b.BID is not NULL or (select SalaryPayID from pEMPSalary where EID=b.EID)=6
    then (select DepPensionContact from oDepartment where DepID=(select DepID from pVW_employee where ISNULL(EID,BID)=ISNULL(b.EID,b.BID)))
    when (select SalaryPayID from pEMPSalary where EID=b.EID)<>6
    then (select PensionContact from oCD_SalaryPayType where ID=(select SalaryPayID from pEMPSalary where EID=b.EID)) end)
    from pPensionPerMM a,pVW_pPensionPerMM b,pVW_employee c
    where a.ID=@ID and ISNULL(b.EmpPensionPerYYRST,0)>0 and ISNULL(b.EID,b.BID)=ISNULL(c.EID,c.BID)
    and ISNULL(b.EID,b.BID) not in (select ISNULL(EID,BID) from pEmpPensionPerMM_register)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新部门年金月度表项pDepPensionPerMM
    ---- 如无任何需要递交的员工，则直接关闭该部门
    update a
    set a.IsClosed=1
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and DATEDIFF(YY,a.PensionMonth,b.PensionMonth)=0
    and ((a.SalaryPayID=6 and (select COUNT(ISNULL(EID,BID)) from pEmpPensionPerMM_register where PensionContact=a.PensionContact and DepID=ISNULL(a.DepID,a.SupDepID))=0)
    or ((a.SalaryPayID in (4,5) or a.SalaryPayID in (1,2,3,10,11,12,13,14,15,16,19) or a.SalaryPayID=7)
    and (select COUNT(ISNULL(EID,BID)) from pEmpPensionPerMM_register where PensionContact=a.PensionContact and a.SalarypayID=SalarypayID)=0))
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