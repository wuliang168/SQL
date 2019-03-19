USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pMonthExpenseClose]
-- skydatarefresh eSP_pMonthExpenseClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度费用流程关闭程序
-- @ID 为月度费用流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 月度费用流程未开启!
    If Exists(Select 1 From pMonthExpense_Process Where ID=@ID and Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930360
        Return @RetVal
    End

    -- 月度费用流程已关闭!
    If Exists(Select 1 From pMonthExpense_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930340
        Return @RetVal
    End


    Begin TRANSACTION


    -- 插入月度费用分配历史表项pMonthExpensePerMM_all
    insert into pMonthExpensePerMM_all(EID,Month,MonthExpenseDepID,MonthExpenseType,MonthExpense,Remark)
    select a.EID,a.Month,a.MonthExpenseDepID,a.MonthExpenseType,a.MonthExpense,a.Remark
    from pMonthExpensePerMM a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pMonthExpenseDep
    update b
    set b.IsClosed=1
    from pMonthExpense_Process a,pMonthExpenseDep b
    where a.ID=@ID and a.Month=b.Month and ISNULL(b.IsClosed,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新月度费用流程状态
    update a
    set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    from pMonthExpense_Process a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除月度费用分配表项
    delete from pMonthExpensePerMM
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