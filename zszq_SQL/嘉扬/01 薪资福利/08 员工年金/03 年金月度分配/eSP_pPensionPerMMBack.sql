USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionPerMMBack]
-- skydatarefresh eSP_pPensionPerMMBack
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配月度退回程序
-- @ID 为年金计划分配月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 月度年金计划分配未关闭，无法退回!
    If Exists(Select 1 From pPensionPerMM Where ID=@ID And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930060
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新年金月度表项pPensionPerMM
    Update a
    Set a.Closed=NULL,ClosedBy=NULL,ClosedTime=NULL
    From pPensionPerMM a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新部门年金月度表项pDepPensionPerMM
    update a
    set a.IsClosed=NULL
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and DATEDIFF(MM,a.PensionMonth,b.PensionMonth)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 插入年金月度历史数据表项
    -- 插入后台人员月度历史数据表项pEmpPensionPerMM_all
    insert pEmpPensionPerMM_register(pProcessID,PensionMonth,EID,BID,SalaryPayID,DepID,GrpPensionPerMM,EmpPensionPerMMBTax,EmpPensionPerMMATax,
    GrpPensionMonthTotal,GrpPensionMonthRest,EmpPensionMonthTotal,EmpPensionMonthRest,Remark,PensionContact,IsWayside,Submit,SubmitBy,SubmitTime)
    select a.pProcessID,a.PensionMonth,a.EID,a.BID,a.SalaryPayID,a.DepID,a.GrpPensionPerMM,a.EmpPensionPerMMBTax,a.EmpPensionPerMMATax,a.GrpPensionMonthTotal,
    a.GrpPensionMonthRest,a.EmpPensionMonthTotal,a.EmpPensionMonthRest,a.Remark,a.PensionContact,a.IsWayside,a.Submit,a.SubmitBy,a.SubmitTime
    from pEmpPensionPerMM_all a
    where a.pProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 删除年金月度数据表项
    -- 删除后台人员月度数据表项pEmpPensionPerMM_register
    delete from pEmpPensionPerMM_register
    where pProcessID=@ID
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