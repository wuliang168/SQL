USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pExpensesSummClose]
-- skydatarefresh eSP_pExpensesSummClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 费用统计流程关闭程序
-- @ID 为费用统计流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 费用统计流程未开启!
    If Exists(Select 1 From pExpensesSumm_Process Where ID=@ID and Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930250
        Return @RetVal
    End

    -- 费用统计流程已关闭!
    If Exists(Select 1 From pExpensesSumm_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930260
        Return @RetVal
    End

    Begin TRANSACTION

    -- 插入费用统计流程的历史表项pExpensesSumm_all
    insert into pExpensesSumm_all(Date,DepID1st,DepID2nd,SalaryContact,ExpensesToReimburse,ExpensesToSalary,ExpensesUnissued)
    select a.Date,a.DepID1st,DepID2nd,a.SalaryContact,a.ExpensesToReimburse,a.ExpensesToSalary,a.ExpensesUnissued
    from pExpensesSumm_register a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pExpensesSummDep
    update b
    set b.IsClosed=1
    from pExpensesSumm_Process a,pExpensesSummDep b
    where a.ID=@ID and a.Date=b.Date

    -- 更新费用流程状态
    update a
    set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    from pExpensesSumm_Process a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除费用统计表项
    delete from pSalaryPerMMSumm_register
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