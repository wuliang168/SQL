USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pMonthExpenseDepReClose]
-- skydatarefresh eSP_pMonthExpenseDepReClose
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门月度奖金重新关闭程序
-- @ID 为部门月度奖金统计对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新部门月度奖金状态
    Update a
    Set a.IsSubmit=1
    From pMonthExpenseDep a
    Where ID=@ID
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