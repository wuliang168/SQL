USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pReserveTalentsDepReOpen]
-- skydatarefresh eSP_pReserveTalentsDepReOpen
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门后备人才重新开启程序
-- @ID 为部门工资统计对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新部门后备人才状态
    Update a
    Set a.IsSubmit=NULL
    From pReserveTalentsDep a
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