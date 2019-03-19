USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_InsBaseRatio_import_AF]--CSP_InsBaseRatio_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 社保基数和缴费比例导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pInsBaseRatio_import的社保基数和缴费比例到pEmployeeEmolu
    update b
    set b.InsuranceBase=ISNULL(a.InsuranceBase,b.InsuranceBase),b.InsuranceLoc=(select ID from eCD_City where Title=a.InsuranceLoc),
    b.EndowInsRatioEMP=ISNULL(a.EndowInsRatioEMP,b.EndowInsRatioEMP),b.EndowInsRatioGRP=ISNULL(a.EndowInsRatioGRP,b.EndowInsRatioGRP),
    b.MedicalInsRatioEMP=ISNULL(a.MedicalInsRatioEMP,b.MedicalInsRatioEMP),b.MedicalInsRatioGRP=ISNULL(a.MedicalInsRatioGRP,b.MedicalInsRatioGRP),
    b.UnemployInsRatioEMP=ISNULL(a.UnemployInsRatioEMP,b.UnemployInsRatioEMP),b.UnemployInsRatioGRP=ISNULL(a.UnemployInsRatioGRP,b.UnemployInsRatioGRP),
    b.MaternityInsRatioGRP=ISNULL(a.MaternityInsRatioGRP,b.MaternityInsRatioGRP),b.InjuryInsRatioGRP=ISNULL(a.InjuryInsRatioGRP,b.InjuryInsRatioGRP)
    from pInsBaseRatio_import a,pEmployeeEmolu b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工社保基数和缴费比例pInsBaseRatio_import
    delete from pInsBaseRatio_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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