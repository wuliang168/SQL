USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pMonthExpensePerMMBSSubmit]
-- skydatarefresh eSP_pMonthExpensePerMMBSSubmit
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度奖金递交(基于DepID的leftid)
-- @leftid为DepID信息，表示部门ID
*/
Begin

    -- 员工费用类型为空，无法递交!
    If Exists(Select 1 From pMonthExpensePerMM Where MonthExpenseDepID=@leftid and MonthExpenseType is NULL)
    Begin
        Set @RetVal = 930369
        Return @RetVal
    End

    -- 员工费用金额为空，无法递交!
    If Exists(Select 1 From pMonthExpensePerMM Where MonthExpenseDepID=@leftid and MonthExpense is NULL)
    Begin
        Set @RetVal = 930370
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pMonthExpenseDep
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pMonthExpenseDep a
    where ISNULL(a.DepID2nd,a.DepID1st)=@leftid and ISNULL(a.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0
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