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
    insert into pDepPensionPerMM(PensionMonth,SupDepID,DepID,Status,SalaryPayID,PensionContact,Remark)
    select a.PensionMonth,b.SupDepID,b.DepID,b.Status,b.SalaryPayID,b.PensionContact,c.Instruction
    from pPensionPerMM a,pVW_DepPensionContact b,pPensionInfo c
    where a.ID=@ID and c.ID=1 and b.Status<>5
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 插入后台人员年金月度分配注册表pEmpPensionPerMM_register
    -- 薪酬类型非营业部;
    insert into pEmpPensionPerMM_register(PensionMonth,EID,BID,EmpPensionMonthTotal,EmpPensionMonthRest,PensionContact)
    select a.PensionMonth,b.EID,b.BID,b.EmpPensionYearRest,b.EmpPensionYearRest,
    (case when BID is not NULL or (select SalaryPayID from pEMPSalary where EID=b.EID)=6 
    then (select DepPensionContact from oDepartment where DepID=(select DepID from pVW_employee where ISNULL(EID,BID)=ISNULL(b.EID,b.BID))) 
    when (select SalaryPayID from pEMPSalary where EID=b.EID)=6 
    then (select PensionContact from oCD_SalaryPayType where ID=(select SalaryPayID from pEMPSalary where EID=b.EID)) end)
    from pPensionPerMM a,pEMPPension b
    where a.ID=@ID and ISNULL(b.EmpPensionYearRest,0)>0
    and ISNULL(b.EID,b.BID) not in (select ISNULL(EID,BID) from pEmpPensionPerMM_register)
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