USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_InsuranceRatioLocBSUpdate]
-- skydatarefresh eSP_InsuranceRatioLocBSUpdate
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 社保缴交地比例更新程序
-- @EID 为员工对应EID
*/
Begin
    
    -- 社保缴费地区为空，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID And Place is NULL)
    Begin
        Set @RetVal = 950110
        Return @RetVal
    End

    -- 社保缴费年度为空，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID And Title is NULL)
    Begin
        Set @RetVal = 950120
        Return @RetVal
    End

    -- 社保缴费年度存在重复，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID And InsuranceYear is NULL)
    Begin
        Set @RetVal = 950130
        Return @RetVal
    End

    -- 社保缴费基数上限为空，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID And InsuranceBaseUpLimit is NULL)
    Begin
        Set @RetVal = 950140
        Return @RetVal
    End

    -- 社保缴费基数下限为空，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID And InsuranceBaseDownLimit is NULL)
    Begin
        Set @RetVal = 950150
        Return @RetVal
    End

    -- 社保缴费最低工资为空，无法递交!
    If Exists(Select 1 From oCD_InsuranceRatioLoc_register Where ID=@ID And SalaryLimitLoc is NULL)
    Begin
        Set @RetVal = 950160
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

    -- 更新社保缴费比例表项oCD_InsuranceRatioLoc
    Update a
    Set a.IsDisabled=1
    From oCD_InsuranceRatioLoc a,oCD_InsuranceRatioLoc_register b
    Where b.ID=@ID and a.ID=b.Place and ISNULL(a.IsDisabled,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加社保缴费比例表项oCD_InsuranceRatioLoc
    insert into oCD_InsuranceRatioLoc(Place,Title,InsuranceYear,InsuranceBaseUpLimit,InsuranceBaseDownLimit,SalaryLimitLoc,MedicalInsBaseDownLimit,
    EndowInsRatioEMP,EndowInsRatioGRP,MedicalInsRatioEMP,MedicalInsRatioGRP,UnemployInsRatioEMP,UnemployInsRatioGRP,
    MaternityInsRatioGRP,InjuryInsRatioGRP,MedicalPlusInsRatio,MedicalPlusIns,CalcMethod)
    select a.Place,a.Title,a.InsuranceYear,a.InsuranceBaseUpLimit,a.InsuranceBaseDownLimit,a.SalaryLimitLoc,a.MedicalInsBaseDownLimit,
    a.EndowInsRatioEMP,a.EndowInsRatioGRP,a.MedicalInsRatioEMP,a.MedicalInsRatioGRP,a.UnemployInsRatioEMP,a.UnemployInsRatioGRP,
    a.MaternityInsRatioGRP,a.InjuryInsRatioGRP,a.MedicalPlusInsRatio,a.MedicalPlusIns,a.CalcMethod
    From oCD_InsuranceRatioLoc_register a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 拷贝到社保缴费比例历史表oCD_InsuranceRatioLoc_all
    insert into oCD_InsuranceRatioLoc_all(Place,Title,InsuranceYear,InsuranceBaseUpLimit,InsuranceBaseDownLimit,SalaryLimitLoc,MedicalInsBaseDownLimit,
    EndowInsRatioEMP,EndowInsRatioGRP,MedicalInsRatioEMP,MedicalInsRatioGRP,UnemployInsRatioEMP,UnemployInsRatioGRP,
    MaternityInsRatioGRP,InjuryInsRatioGRP,MedicalPlusInsRatio,MedicalPlusIns,CalcMethod)
    select a.Place,a.Title,a.InsuranceYear,a.InsuranceBaseUpLimit,a.InsuranceBaseDownLimit,a.SalaryLimitLoc,a.MedicalInsBaseDownLimit,
    a.EndowInsRatioEMP,a.EndowInsRatioGRP,a.MedicalInsRatioEMP,a.MedicalInsRatioGRP,a.UnemployInsRatioEMP,a.UnemployInsRatioGRP,
    a.MaternityInsRatioGRP,a.InjuryInsRatioGRP,a.MedicalPlusInsRatio,a.MedicalPlusIns,a.CalcMethod
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