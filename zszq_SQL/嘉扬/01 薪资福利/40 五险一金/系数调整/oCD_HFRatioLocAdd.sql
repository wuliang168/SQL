USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[oCD_HFRatioLocAdd]
-- skydatarefresh oCD_HFRatioLocAdd
    @Place int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 公积金缴交地比例添加程序
-- @Code 为地区对应Code
*/
Begin


    Begin TRANSACTION


    -- 添加公积金缴费比例注册表项oCD_HousingFundRatioLoc_register
    insert into oCD_HousingFundRatioLoc_register(Code,Place,Title,HousingFundYear,HousingFundBaseUpLimit,HousingFundBaseDownLimit,
    HousingFundRatioEMP,HousingFundRatioPlusEMP,HousingFundRatioGRP,HousingFundRatioPlusGRP,CalcMethod)
    select a.Code,a.Place,a.Title,a.HousingFundYear,a.HousingFundBaseUpLimit,a.HousingFundBaseDownLimit,
    a.HousingFundRatioEMP,a.HousingFundRatioPlusEMP,a.HousingFundRatioGRP,a.HousingFundRatioPlusGRP,a.CalcMethod
    From oCD_HousingFundRatioLoc a
    Where a.Place=@Place
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