USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEmoluEmpConfirm]
-- skydatarefresh eSP_pEmoluEmpConfirm
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金员工分配确认程序
-- @ID 为年金员工对应ID
*/
Begin

    -- 员工行政职级已确认!
    ---- 后台员工
    If Exists(Select 1 From pEmployeeEmolu a Where a.EID=@EID And Isnull(a.IsConfirm,0)=1)
    Begin
        Set @RetVal = 930071
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新员工年金确认状态
    ---- 后台员工
    Update a
    Set a.IsConfirm=1
    From pEmployeeEmolu a
    Where a.EID=@EID
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