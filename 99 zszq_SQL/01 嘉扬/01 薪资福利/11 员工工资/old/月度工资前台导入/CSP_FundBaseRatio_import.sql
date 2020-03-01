USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_FundBaseRatio_import]--CSP_FundBaseRatio_import()
    @URID int,
    @leftid int,
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

    -- 将导入的文件插入到pFundBaseRatio_import表项中
    insert into pFundBaseRatio_import (SalaryPayID,SalaryContact,Badge,HousingFundBase,HousingFundLoc,HousingFundRatioEMP,HousingFundRatioGRP)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@HousingFundBase,@HousingFundLoc,@HousingFundRatioEMP,@HousingFundRatioGRP
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