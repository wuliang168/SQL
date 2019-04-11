USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_ChangeMDtoModifyDepBack]
-- skydatarefresh eSP_ChangeMDtoModifyDepBack
    @EID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级及薪酬调整的部门返回程序
-- @EID 为MD职级及薪酬调整的部门负责人EID为MD职级调整添加的ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 部门负责人未完成MD职级及薪酬调整!
    If Exists(Select 1 From pMDtoModify_register Where Director=@EID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930046
        Return @RetVal
    End

    Begin TRANSACTION

    -- 更新MD职级及薪酬调整表项pMDtoModify_register
    Update a
    Set a.Submit=NULL
    From pMDtoModify_register a
    Where a.Director=@EID AND a.pYearLevel in ('A','B','C')
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