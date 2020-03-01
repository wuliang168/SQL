USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadInsBaseRatio_import]--CSP_HeadInsBaseRatio_import()
    @URID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @InsuranceBase decimal(10,2),
    @InsuranceLoc nvarchar(100),
    @EndowInsRatioEMP decimal(5,4),
    @EndowInsRatioGRP decimal(5,4),
    @MedicalInsRatioEMP decimal(5,4),
    @MedicalInsRatioGRP decimal(5,4),
    @UnemployInsRatioEMP decimal(5,4),
    @UnemployInsRatioGRP decimal(5,4),
    @MaternityInsRatioGRP decimal(5,4),
    @InjuryInsRatioGRP decimal(5,4),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 公积金基数和缴费比例导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pHeadInsBaseRatio_import表项中
    insert into pHeadInsBaseRatio_import (HeadContact,Badge,InsuranceBase,InsuranceLoc,EndowInsRatioEMP,EndowInsRatioGRP,
    MedicalInsRatioEMP,MedicalInsRatioGRP,UnemployInsRatioEMP,UnemployInsRatioGRP,MaternityInsRatioGRP,InjuryInsRatioGRP)
    select (select EID from SkySecUser where ID=@URID),@Badge,@InsuranceBase,@InsuranceLoc,@EndowInsRatioEMP,@EndowInsRatioGRP,
    @MedicalInsRatioEMP,@MedicalInsRatioGRP,@UnemployInsRatioEMP,@UnemployInsRatioGRP,@MaternityInsRatioGRP,@InjuryInsRatioGRP
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