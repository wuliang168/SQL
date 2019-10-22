USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[oCD_InsurRatioLocAdd]
-- skydatarefresh oCD_InsurRatioLocAdd
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 社保缴交地比例添加程序
-- @Code 为地区对应Code
*/
Begin


    Begin TRANSACTION


    -- 添加社保缴费比例注册表项oCD_InsuranceRatioLoc_register
    insert into oCD_InsuranceRatioLoc_register(ID_Orig,Code,Place,Title,InsDepID,InsuranceYear,
    InsuranceBaseUpLimit,InsuranceBaseDownLimit,SalaryLimitLoc,MedicalInsBaseUpLimit,MedicalInsBaseDownLimit,
    EndowInsRatioEMP,EndowInsRatioGRP,EndowInsCalcMethod,MedicalInsRatioEMP,MedicalInsRatioGRP,MedicalInsCalcMethod,
    UnemployInsRatioEMP,UnemployInsRatioGRP,UnemployInsCalcMethod,MaternityInsRatioGRP,MaternityInsCalcMethod,InjuryInsRatioGRP,InjuryInsCalcMethod,
    MedicalPlusInsRatioEMP,MedicalPlusInsEMP,MedicalPlusInsRatioGRP,MedicalPlusInsGRP,MedicalPlusInsType,CalcMethod)
    select a.ID,a.Code,a.Place,a.Title,a.InsDepID,a.InsuranceYear,a.InsuranceBaseUpLimit,a.InsuranceBaseDownLimit,
    a.SalaryLimitLoc,a.MedicalInsBaseUpLimit,a.MedicalInsBaseDownLimit,
    a.EndowInsRatioEMP,a.EndowInsRatioGRP,a.EndowInsCalcMethod,a.MedicalInsRatioEMP,a.MedicalInsRatioGRP,a.MedicalInsCalcMethod,
    a.UnemployInsRatioEMP,a.UnemployInsRatioGRP,a.UnemployInsCalcMethod,a.MaternityInsRatioGRP,a.MaternityInsCalcMethod,a.InjuryInsRatioGRP,a.InjuryInsCalcMethod,
    a.MedicalPlusInsRatioEMP,a.MedicalPlusInsEMP,a.MedicalPlusInsRatioGRP,a.MedicalPlusInsGRP,a.MedicalPlusInsType,a.CalcMethod
    From oCD_InsuranceRatioLoc a
    Where a.ID=@ID and ISNULL(a.IsDisabled,0)=0
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