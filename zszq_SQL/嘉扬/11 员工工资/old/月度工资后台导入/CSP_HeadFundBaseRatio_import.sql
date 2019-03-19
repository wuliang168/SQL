USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadFundBaseRatio_import]--CSP_HeadFundBaseRatio_import()
    @URID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @HousingFundBase decimal(10,2),
    @HousingFundLoc nvarchar(100),
    @HousingFundRatioEMP decimal(5,4),
    @HousingFundRatioGRP decimal(5,4),
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

    -- 将导入的文件插入到pHeadFundBaseRatio_import表项中
    insert into pHeadFundBaseRatio_import (HeadContact,Badge,HousingFundBase,HousingFundLoc,HousingFundRatioEMP,HousingFundRatioGRP)
    select (select EID from SkySecUser where ID=@URID),@Badge,@HousingFundBase,@HousingFundLoc,@HousingFundRatioEMP,@HousingFundRatioGRP
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