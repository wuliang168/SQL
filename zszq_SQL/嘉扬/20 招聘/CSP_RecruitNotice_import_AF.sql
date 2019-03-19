USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_RecruitNotice_import_AF]--CSP_RecruitNotice_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 招聘通知导入后
*/
Begin

    Begin TRANSACTION

    -- 插入pRecruitNotice_import的招聘通知信息到pRecruitNotice
    insert into pRecruitNotice(RecruitYear,Name,Mobile,RecruitScore,RecruitDate,RecruitLoc,RecruitType)
    select CONVERT(datetime,a.RecruitYear+'-1-1',120),a.Name,a.Mobile,a.RecruitScore,
    CONVERT(datetime,a.RecruitDate,120),a.RecruitLoc,(select ID from oCD_RecruitType where Title=a.RecruitType)
    from pRecruitNotice_import a
    where a.RecruitContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


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