USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_RecruitNotice_import]--CSP_RecruitNotice_import()
    @URID int,
    @RecruitYear varchar(4),
    @Name nvarchar(10),
    @Mobile varchar(30),
    @RecruitScore int,
    @RecruitDate varchar(20),
    @RecruitLoc nvarchar(100),
    @RecruitType nvarchar(100),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 招聘通知导入
*/
Begin


    Begin TRANSACTION

    -- 将导入的文件插入到pRecruitNotice_import表项中
    insert into pRecruitNotice_import (RecruitContact,RecruitYear,Name,Mobile,RecruitScore,RecruitDate,RecruitLoc,RecruitType)
    select (select EID from SkySecUser where ID=@URID),@RecruitYear,@Name,@Mobile,@RecruitScore,@RecruitDate,@RecruitLoc,@RecruitType
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