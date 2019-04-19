USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[oCD_InsurRatioLocConfirm]
-- skydatarefresh oCD_InsurRatioLocConfirm
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 社保缴交地系数比例更新程序
-- @ID 为系数调整对应的ID
-- @URID为系数调整人对应的URID
*/
Begin

    -- 社保缴费年度为空，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID And InsuranceYear is NULL)
    Begin
        Set @RetVal = 950120
        Return @RetVal
    End

    -- 社保缴费基数上下限为空，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID 
    And (InsuranceBaseUpLimit is NULL or InsuranceBaseDownLimit is NULL))
    Begin
        Set @RetVal = 950140
        Return @RetVal
    End

    -- 社保缴费计算方式为空，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID And CalcMethod is NULL)
    Begin
        Set @RetVal = 950170
        Return @RetVal
    End

    -- 社保缴费缴费比例为空，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID 
    And (EndowInsRatioEMP is NULL) or (EndowInsRatioGRP is NULL) or (MedicalInsRatioEMP is NULL)
    or (MedicalInsRatioGRP is NULL) or (UnemployInsRatioEMP is NULL) or (UnemployInsRatioGRP is NULL)
    or (MaternityInsRatioGRP is NULL) or (InjuryInsRatioGRP is NULL))
    Begin
        Set @RetVal = 950180
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新oCD_InsuranceRatioLoc_register
    update a
    set IsSubmit=1,SubmitBy=@URID,SubmitTime=GETDATE()
    from oCD_InsuranceRatioLoc_register a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新社保缴费比例表项oCD_InsuranceRatioLoc
    Update a
    Set a.IsDisabled=1
    From oCD_InsuranceRatioLoc a,oCD_InsuranceRatioLoc_register b
    Where b.ID=@ID and a.Place=b.Place and ISNULL(a.IsDisabled,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加社保缴费比例表项oCD_InsuranceRatioLoc
    insert into oCD_InsuranceRatioLoc(Code,Place,Title,InsuranceYear,InsuranceBaseUpLimit,InsuranceBaseDownLimit,SalaryLimitLoc,MedicalInsBaseDownLimit,
    EndowInsRatioEMP,EndowInsRatioGRP,MedicalInsRatioEMP,MedicalInsRatioGRP,UnemployInsRatioEMP,UnemployInsRatioGRP,MaternityInsRatioGRP,InjuryInsRatioGRP,
    MedicalPlusInsRatioEMP,MedicalPlusInsEMP,MedicalPlusInsRatioGRP,MedicalPlusInsGRP,MedicalPlusInsType,CalcMethod,Remark)
    select a.Code,a.Place,a.Title,a.InsuranceYear,a.InsuranceBaseUpLimit,a.InsuranceBaseDownLimit,a.SalaryLimitLoc,a.MedicalInsBaseDownLimit,
    a.EndowInsRatioEMP,a.EndowInsRatioGRP,a.MedicalInsRatioEMP,a.MedicalInsRatioGRP,a.UnemployInsRatioEMP,a.UnemployInsRatioGRP,a.MaternityInsRatioGRP,a.InjuryInsRatioGRP,
    a.MedicalPlusInsRatioEMP,a.MedicalPlusInsEMP,a.MedicalPlusInsRatioGRP,a.MedicalPlusInsGRP,a.MedicalPlusInsType,a.CalcMethod,a.Remark
    From oCD_InsuranceRatioLoc_register a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 拷贝到社保缴费比例历史表oCD_InsuranceRatioLoc_all
    insert into oCD_InsuranceRatioLoc_all(Code,Place,Title,InsuranceYear,InsuranceBaseUpLimit,InsuranceBaseDownLimit,SalaryLimitLoc,MedicalInsBaseDownLimit,
    EndowInsRatioEMP,EndowInsRatioGRP,MedicalInsRatioEMP,MedicalInsRatioGRP,UnemployInsRatioEMP,UnemployInsRatioGRP,MaternityInsRatioGRP,InjuryInsRatioGRP,
    MedicalPlusInsRatioEMP,MedicalPlusInsEMP,MedicalPlusInsRatioGRP,MedicalPlusInsGRP,MedicalPlusInsType,CalcMethod,Remark,IsSubmit,SubmitBy,SubmitTime)
    select a.Code,a.Place,a.Title,a.InsuranceYear,a.InsuranceBaseUpLimit,a.InsuranceBaseDownLimit,a.SalaryLimitLoc,a.MedicalInsBaseDownLimit,
    a.EndowInsRatioEMP,a.EndowInsRatioGRP,a.MedicalInsRatioEMP,a.MedicalInsRatioGRP,a.UnemployInsRatioEMP,a.UnemployInsRatioGRP,a.MaternityInsRatioGRP,a.InjuryInsRatioGRP,
    a.MedicalPlusInsRatioEMP,a.MedicalPlusInsEMP,a.MedicalPlusInsRatioGRP,a.MedicalPlusInsGRP,a.MedicalPlusInsType,a.CalcMethod,a.Remark,a.IsSubmit,a.SubmitBy,a.SubmitTime
    From oCD_InsuranceRatioLoc_register a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除社保缴费比例注册表oCD_InsuranceRatioLoc_register
    delete from oCD_InsuranceRatioLoc_register 
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