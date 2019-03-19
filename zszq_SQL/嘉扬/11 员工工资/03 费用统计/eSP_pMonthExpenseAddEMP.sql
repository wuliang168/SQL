USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pMonthExpenseAddEMP]
-- skydatarefresh eSP_pMonthExpenseAddEMP
    @leftid int, 
    @Month smalldatetime,
    @EID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度费用员工增加(基于DepID的leftid)
-- @leftid为DepID信息，表示部门ID
*/
Begin


    Begin TRANSACTION

    -- 更新pMonthExpensePerMM
    insert into pMonthExpensePerMM(EID,MonthExpenseDepID,Month)
    values (@EID,@leftid,@Month)
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