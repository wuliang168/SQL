USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionPerMMClose]
-- skydatarefresh eSP_pDepPensionPerMMClose
    @ID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门年金月度开启程序
-- @ID 为部门年金计划分配月度对应ID
*/
Begin
    
    -- 部门年金月度计划分配已关闭!
    If Exists(Select 1 From pDepPensionPerMM Where ID=@ID And Isnull(IsSubmit,0)=1)
    Begin
        Set @RetVal = 930069
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新年金月度表项pPensionPerMM
    Update a
    Set a.IsSubmit=1
    From pDepPensionPerMM a
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