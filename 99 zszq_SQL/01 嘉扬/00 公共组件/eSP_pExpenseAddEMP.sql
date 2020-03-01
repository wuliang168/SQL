USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pExpenseAddEMP]
-- skydatarefresh eSP_pExpenseAddEMP
    @EID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
*/
Begin


    Begin TRANSACTION

    -- 更新pMonthExpensePerMM
    insert into pExpenseTMP(EID)
    values (@EID)
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