USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadFestivalFee_import]--CSP_HeadFestivalFee_import()
    @URID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @FestivalFeeType1 nvarchar(100),
    @FestivalFee1 decimal(10, 2),
    @FestivalFeeType2 nvarchar(100),
    @FestivalFee2 decimal(10, 2),
    @FestivalFeeType3 nvarchar(100),
    @FestivalFee3 decimal(10, 2),
    @BenefitsInKind decimal(10, 2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室过节费导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pHeadFestivalFee_import表项中
    insert into pHeadFestivalFee_import (HeadContact,Badge,FestivalFeeType1,FestivalFee1,
    FestivalFeeType2,FestivalFee2,FestivalFeeType3,FestivalFee3,BenefitsInKind,Remark)
    select (select EID from SkySecUser where ID=@URID),@Badge,@FestivalFeeType1,@FestivalFee1,
    @FestivalFeeType2,@FestivalFee2,@FestivalFeeType3,@FestivalFee3,@BenefitsInKind,@Remark
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