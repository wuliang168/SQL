USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionUpdateDepOpen]
-- skydatarefresh eSP_pPensionUpdateDepOpen
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金前台人员重新开启程序
-- @ID 为年金前台人员对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新员工年金确认状态
    ---- 前台员工
    Update a
    Set a.IsSubmit=NULL,a.IsEmpSubmit=NULL,a.IsSDMSubmit=NULL
    From pPensionUpdatePerDep a
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