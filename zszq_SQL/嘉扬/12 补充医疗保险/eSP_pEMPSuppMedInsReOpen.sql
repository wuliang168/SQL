USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPSuppMedInsReOpen]
-- skydatarefresh eSP_pEMPSuppMedInsReOpen
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 补充医疗保险后台人员重新开启程序
-- @ID 为补充医疗保险后台人员对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新员工年金补充医疗保险状态
    ---- 前台员工
    Update a
    Set a.IsConfirm=NULL
    From pEMPSuppMedIns a
    Where EID=@EID and SMIType=1
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