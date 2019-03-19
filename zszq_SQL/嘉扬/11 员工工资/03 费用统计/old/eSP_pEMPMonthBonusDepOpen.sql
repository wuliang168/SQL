USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPMonthBonusDepOpen]
-- skydatarefresh eSP_pEMPMonthBonusDepOpen
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门月度奖金解封程序
-- @ID 为部门月度奖金统计对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新部门月度奖金状态
    Update a
    Set a.IsClosed=NULL
    From pEMPMonthBonusDep a
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