USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EMPInsurancePerMMPlus_import_AF]--CSP_EMPInsurancePerMMPlus_import_AF()
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 社保信息导入后
*/
Begin

    Begin TRANSACTION

    -- 更新pEMPInsurancePerMMPlus_import的社保信息到pEMPInsurancePerMM
    update b
    set b.EndowInsEMPPlus=ISNULL(a.EndowInsEMPPlus,b.EndowInsEMPPlus),b.MedicalInsEMPPlus=ISNULL(a.MedicalInsEMPPlus,b.MedicalInsEMPPlus),
    b.UnemployInsEMPPlus=ISNULL(a.UnemployInsEMPPlus,b.UnemployInsEMPPlus),b.EndowInsGRPPlus=ISNULL(a.EndowInsGRPPlus,b.EndowInsGRPPlus),
    b.MedicalInsGRPPlus=ISNULL(a.MedicalInsGRPPlus,b.MedicalInsGRPPlus),b.UnemployInsGRPPlus=ISNULL(a.UnemployInsGRPPlus,b.UnemployInsGRPPlus),
    b.MaternityInsGRPPlus=ISNULL(a.MaternityInsGRPPlus,b.MaternityInsGRPPlus),b.InjuryInsGRPPlus=ISNULL(a.InjuryInsGRPPlus,b.InjuryInsGRPPlus),
    b.InsEMPPlusTotal=ISNULL(a.EndowInsEMPPlus,b.EndowInsEMPPlus)+ISNULL(a.MedicalInsEMPPlus,b.MedicalInsEMPPlus)+ISNULL(a.UnemployInsEMPPlus,b.UnemployInsEMPPlus),
    b.InsGRPPlusTotal=ISNULL(a.EndowInsGRPPlus,b.EndowInsGRPPlus)+ISNULL(a.MedicalInsGRPPlus,b.MedicalInsGRPPlus)+ISNULL(a.UnemployInsGRPPlus,b.UnemployInsGRPPlus)
    +ISNULL(a.MaternityInsGRPPlus,b.MaternityInsGRPPlus)+ISNULL(a.InjuryInsGRPPlus,b.InjuryInsGRPPlus)
    from pEMPInsurancePerMMPlus_import a,pEMPInsurancePerMM b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.EMPInsuranceDepart=@leftid
    -- 异常流程
    IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工税后补贴pEMPInsurancePerMMPlus_import
    delete from pEMPInsurancePerMMPlus_import where EMPInsuranceDepart=@leftid
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