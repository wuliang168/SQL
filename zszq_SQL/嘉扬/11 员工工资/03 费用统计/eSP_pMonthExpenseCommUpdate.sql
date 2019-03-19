USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pMonthExpenseCommUpdate]
-- skydatarefresh eSP_pMonthExpenseCommUpdate
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度费用通讯费更新程序
-- @ID 为月度费用流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin


    Begin TRANSACTION


    -- 更新pMonthExpensePerMM
    update b
    set b.MonthExpense=a.CommAllowance
    from pEMPTrafficComm a,pMonthExpensePerMM b
    where a.EID=b.EID and a.EID=@EID and b.MonthExpenseType=16
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