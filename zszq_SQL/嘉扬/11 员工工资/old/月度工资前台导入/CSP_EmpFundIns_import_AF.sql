USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EmpFundIns_import_AF]--CSP_EmpFundIns_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 五险一金(个人)导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pEmpFundIns_import的五险一金(个人)到pEmployeeEmolu
    update b
    set b.EndowInsEMP=ISNULL(a.EndowInsEMP,b.EndowInsEMP),b.EndowInsEMPPlus=ISNULL(a.EndowInsEMPPlus,b.EndowInsEMPPlus),
    b.MedicalInsEMP=ISNULL(a.MedicalInsEMP,b.MedicalInsEMP),b.MedicalInsEMPPlus=ISNULL(a.MedicalInsEMPPlus,b.MedicalInsEMPPlus),
    b.UnemployInsEMP=ISNULL(a.UnemployInsEMP,b.UnemployInsEMP),b.UnemployInsEMPPlus=ISNULL(a.UnemployInsEMPPlus,b.UnemployInsEMPPlus),
    b.HousingFundEMP=ISNULL(a.HousingFundEMP,b.HousingFundEMP),b.HousingFundEMPPlus=ISNULL(a.HousingFundEMPPlus,b.HousingFundEMPPlus),
    b.FundInsEMPTotal=ISNULL(a.EndowInsEMP,ISNULL(b.EndowInsEMP,0))+ISNULL(a.MedicalInsEMP,ISNULL(b.MedicalInsEMP,0))
    +ISNULL(a.UnemployInsEMP,ISNULL(b.UnemployInsEMP,0))+ISNULL(a.HousingFundEMP,ISNULL(b.HousingFundEMP,0)),
    b.FundInsEMPPlusTotal=ISNULL(a.EndowInsEMPPlus,ISNULL(b.EndowInsEMPPlus,0))+ISNULL(a.MedicalInsEMPPlus,ISNULL(b.MedicalInsEMPPlus,0))
    +ISNULL(a.UnemployInsEMPPlus,ISNULL(b.UnemployInsEMPPlus,0))+ISNULL(a.HousingFundEMPPlus,ISNULL(b.HousingFundEMPPlus,0)),
    b.Remark=ISNULL(a.Remark,b.Remark)
    from pEmpFundIns_import a,pEmployeeEmoluFundIns b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工五险一金(个人)pEmpFundIns_import
    delete from pEmpFundIns_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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