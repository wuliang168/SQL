USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_HousingFundRatioLocBSUpdate]
-- skydatarefresh eSP_HousingFundRatioLocBSUpdate
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 公积金缴交地比例更新程序
-- @EID 为员工对应EID
*/
Begin
    
    -- 公积金缴费地区为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID And Place is NULL)
    Begin
        Set @RetVal = 950110
        Return @RetVal
    End

    -- 公积金缴费年度为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID And Title is NULL)
    Begin
        Set @RetVal = 950120
        Return @RetVal
    End

    -- 公积金缴费年度存在重复，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID And HousingFundYear is NULL)
    Begin
        Set @RetVal = 950130
        Return @RetVal
    End

    -- 公积金缴费基数上限为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID And HousingFundBaseUpLimit is NULL)
    Begin
        Set @RetVal = 950140
        Return @RetVal
    End

    -- 公积金缴费基数下限为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID And HousingFundBaseDownLimit is NULL)
    Begin
        Set @RetVal = 950150
        Return @RetVal
    End

    -- 公积金缴费计算方式为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID And CalcMethod is NULL)
    Begin
        Set @RetVal = 950170
        Return @RetVal
    End

    -- 公积金缴费缴费比例为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID 
    And (HousingFundRatioEMP is NULL) or (HousingFundRatioGRP is NULL))
    Begin
        Set @RetVal = 950180
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新公积金缴费比例表项oCD_HousingFundRatioLoc
    Update a
    Set a.IsDisabled=1
    From oCD_HousingFundRatioLoc a,oCD_HousingFundRatioLoc_register b
    Where b.ID=@ID and a.ID=b.Place and ISNULL(a.IsDisabled,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加公积金缴费比例表项oCD_HousingFundRatioLoc
    insert into oCD_HousingFundRatioLoc(Place,Title,HousingFundYear,HousingFundBaseUpLimit,HousingFundBaseDownLimit,
    HousingFundRatioEMP,HousingFundRatioGRP,CalcMethod)
    select a.Place,a.Title,a.HousingFundYear,a.HousingFundBaseUpLimit,a.HousingFundBaseDownLimit,
    a.HousingFundRatioEMP,a.HousingFundRatioGRP,a.CalcMethod
    From oCD_HousingFundRatioLoc_register a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 拷贝到公积金缴费比例历史表oCD_HousingFundRatioLoc_all
    insert into oCD_HousingFundRatioLoc_all(Place,Title,HousingFundYear,HousingFundBaseUpLimit,HousingFundBaseDownLimit,
    HousingFundRatioEMP,HousingFundRatioGRP,CalcMethod)
    select a.Place,a.Title,a.HousingFundYear,a.HousingFundBaseUpLimit,a.HousingFundBaseDownLimit,
    a.HousingFundRatioEMP,a.HousingFundRatioGRP,a.CalcMethod
    From oCD_HousingFundRatioLoc_register a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除公积金缴费比例注册表oCD_HousingFundRatioLoc_register
    delete from oCD_HousingFundRatioLoc_register 
    where ID=@ID
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