USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_GrpFundIns_import_AF]--CSP_GrpFundIns_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 五险一金(公司)导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pGrpFundIns_import的五险一金(公司)到pEmployeeEmolu
    update b
    set b.EndowInsGRP=ISNULL(a.EndowInsGRP,b.EndowInsGRP),b.EndowInsGRPPlus=ISNULL(a.EndowInsGRPPlus,b.EndowInsGRPPlus),
    b.MedicalInsGRP=ISNULL(a.MedicalInsGRP,b.MedicalInsGRP),b.MedicalInsGRPPlus=ISNULL(a.MedicalInsGRPPlus,b.MedicalInsGRPPlus),
    b.UnemployInsGRP=ISNULL(a.UnemployInsGRP,b.UnemployInsGRP),b.UnemployInsGRPPlus=ISNULL(a.UnemployInsGRPPlus,b.UnemployInsGRPPlus),
    b.MaternityInsGRP=ISNULL(a.MaternityInsGRP,b.MaternityInsGRP),b.MaternityInsGRPPlus=ISNULL(a.MaternityInsGRPPlus,b.MaternityInsGRPPlus),
    b.InjuryInsGRP=ISNULL(a.InjuryInsGRP,b.InjuryInsGRP),b.InjuryInsGRPPlus=ISNULL(a.InjuryInsGRPPlus,b.InjuryInsGRPPlus),
    b.HousingFundGRP=ISNULL(a.HousingFundGRP,b.HousingFundGRP),b.HousingFundGRPPlus=ISNULL(a.HousingFundGRPPlus,b.HousingFundGRPPlus),
    b.FundInsGRPTotal=ISNULL(a.EndowInsGRP,ISNULL(b.EndowInsGRP,0))+ISNULL(a.MedicalInsGRP,ISNULL(b.MedicalInsGRP,0))
    +ISNULL(a.UnemployInsGRP,ISNULL(b.UnemployInsGRP,0))+ISNULL(a.MaternityInsGRP,ISNULL(b.MaternityInsGRP,0))
    +ISNULL(a.InjuryInsGRP,ISNULL(b.InjuryInsGRP,0))+ISNULL(a.HousingFundGRP,ISNULL(b.HousingFundGRP,0)),
    b.FundInsGRPPlusTotal=ISNULL(a.EndowInsGRPPlus,ISNULL(b.EndowInsGRPPlus,0))+ISNULL(a.MedicalInsGRPPlus,ISNULL(b.MedicalInsGRPPlus,0))
    +ISNULL(a.UnemployInsGRPPlus,ISNULL(b.UnemployInsGRPPlus,0))+ISNULL(a.MaternityInsGRPPlus,ISNULL(b.MaternityInsGRPPlus,0))
    +ISNULL(a.InjuryInsGRPPlus,ISNULL(b.InjuryInsGRPPlus,0))+ISNULL(a.HousingFundGRPPlus,ISNULL(b.HousingFundGRPPlus,0)),
    b.Remark=ISNULL(a.Remark,b.Remark)
    from pGrpFundIns_import a,pEmployeeEmoluFundIns b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工五险一金(公司)pGrpFundIns_import
    delete from pGrpFundIns_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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