USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionConfirm]
-- skydatarefresh eSP_pPensionConfirm
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金员工分配确认程序
-- @ID 为年金员工对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新员工年金确认状态
    ---- 后台员工
    Update a
    Set a.IsPensionConfirm=1
    From pEmployeeEmolu a
    Where a.ID=@ID
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