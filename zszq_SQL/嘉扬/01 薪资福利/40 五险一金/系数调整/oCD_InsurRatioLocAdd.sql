USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[oCD_InsurRatioLocAdd]
-- skydatarefresh oCD_InsurRatioLocAdd
    @Place int,
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
    insert into oCD_InsuranceRatioLoc_register(Code,Place,Title,InsuranceYear,InsuranceBaseUpLimit,InsuranceBaseDownLimit,SalaryLimitLoc,MedicalInsBaseDownLimit,
    EndowInsRatioEMP,EndowInsRatioGRP,MedicalInsRatioEMP,MedicalInsRatioGRP,UnemployInsRatioEMP,UnemployInsRatioGRP,MaternityInsRatioGRP,InjuryInsRatioGRP,
    MedicalPlusInsRatioEMP,MedicalPlusInsEMP,MedicalPlusInsRatioGRP,MedicalPlusInsGRP,MedicalPlusInsType,CalcMethod)
    select a.Code,a.Place,a.Title,a.InsuranceYear,a.InsuranceBaseUpLimit,a.InsuranceBaseDownLimit,a.SalaryLimitLoc,a.MedicalInsBaseDownLimit,
    a.EndowInsRatioEMP,a.EndowInsRatioGRP,a.MedicalInsRatioEMP,a.MedicalInsRatioGRP,a.UnemployInsRatioEMP,a.UnemployInsRatioGRP,a.MaternityInsRatioGRP,a.InjuryInsRatioGRP,
    a.MedicalPlusInsRatioEMP,a.MedicalPlusInsEMP,a.MedicalPlusInsRatioGRP,a.MedicalPlusInsGRP,a.MedicalPlusInsType,a.CalcMethod
    From oCD_InsuranceRatioLoc a
    Where a.Place=@Place and ISNULL(a.IsDisabled,0)=0
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