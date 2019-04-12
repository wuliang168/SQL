USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_RecruitNotice_import_BF]--CSP_RecruitNotice_import_BF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 招聘通知导入前
*/
Begin

    Begin TRANSACTION

    -- 清空URID对应的导入信息
    delete from pRecruitNotice_import where RecruitContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
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