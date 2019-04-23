USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[oCD_HFRatioLocConfirm]
-- skydatarefresh oCD_HFRatioLocConfirm
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 公积金缴交地系数比例更新程序
-- @ID 为系数调整对应的ID
-- @URID为系数调整人对应的URID
*/
Begin

    -- 缴费年度为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID And HousingFundYear is NULL)
    Begin
        Set @RetVal = 950120
        Return @RetVal
    End

    -- 缴费基数上下限为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID 
    And (HousingFundBaseUpLimit is NULL or HousingFundBaseDownLimit is NULL))
    Begin
        Set @RetVal = 950140
        Return @RetVal
    End

    -- 缴费计算方式为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID And CalcMethod is NULL)
    Begin
        Set @RetVal = 950170
        Return @RetVal
    End

    -- 缴费缴费比例为空，无法递交!
    If Exists(Select 1 From oCD_HousingFundRatioLoc_register Where ID=@ID 
    And (HousingFundRatioEMP is NULL) or (HousingFundRatioGRP is NULL))
    Begin
        Set @RetVal = 950180
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新oCD_HousingFundRatioLoc_register
    update a
    set IsSubmit=1,SubmitBy=@URID,SubmitTime=GETDATE()
    from oCD_HousingFundRatioLoc_register a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新社保缴费比例表项oCD_HousingFundRatioLoc
    Update a
    Set a.IsDisabled=1
    From oCD_HousingFundRatioLoc a,oCD_HousingFundRatioLoc_register b
    Where b.ID=@ID and a.Place=b.Place and ISNULL(a.IsDisabled,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加社保缴费比例表项oCD_HousingFundRatioLoc
    insert into oCD_HousingFundRatioLoc(Code,Place,Title,HousingFundYear,HousingFundBaseUpLimit,HousingFundBaseDownLimit,
    HousingFundRatioEMP,HousingFundRatioPlusEMP,HousingFundRatioGRP,HousingFundRatioPlusGRP,CalcMethod,Remark)
    select a.Code,a.Place,a.Title,a.HousingFundYear,a.HousingFundBaseUpLimit,a.HousingFundBaseDownLimit,
    a.HousingFundRatioEMP,a.HousingFundRatioPlusEMP,a.HousingFundRatioGRP,a.HousingFundRatioPlusGRP,a.CalcMethod,a.Remark
    From oCD_HousingFundRatioLoc_register a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 拷贝到社保缴费比例历史表oCD_HousingFundRatioLoc_all
    insert into oCD_HousingFundRatioLoc_all(Code,Place,Title,HousingFundYear,HousingFundBaseUpLimit,HousingFundBaseDownLimit,
    HousingFundRatioEMP,HousingFundRatioPlusEMP,HousingFundRatioGRP,HousingFundRatioPlusGRP,CalcMethod,Remark,IsSubmit,SubmitBy,SubmitTime)
    select a.Code,a.Place,a.Title,a.HousingFundYear,a.HousingFundBaseUpLimit,a.HousingFundBaseDownLimit,
    a.HousingFundRatioEMP,a.HousingFundRatioPlusEMP,a.HousingFundRatioGRP,a.HousingFundRatioPlusGRP,a.CalcMethod,a.Remark,a.IsSubmit,a.SubmitBy,a.SubmitTime
    From oCD_HousingFundRatioLoc_register a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除社保缴费比例注册表oCD_HousingFundRatioLoc_register
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