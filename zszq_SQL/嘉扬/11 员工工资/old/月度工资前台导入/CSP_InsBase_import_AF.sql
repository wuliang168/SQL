USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_InsBase_import_AF]--CSP_InsBase_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 社保缴费金额导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pInsBase_import的社保缴费金额到pEmployeeEmolu
    update b
    set b.InsuranceLoc=(select ID from eCD_City where Title=a.InsuranceLoc),
    b.EndowInsEMP=ISNULL(a.EndowInsEMP,b.EndowInsEMP),b.EndowInsGRP=ISNULL(a.EndowInsGRP,b.EndowInsGRP),
    b.MedicalInsEMP=ISNULL(a.MedicalInsEMP,b.MedicalInsEMP),b.MedicalInsGRP=ISNULL(a.MedicalInsGRP,b.MedicalInsGRP),
    b.UnemployInsEMP=ISNULL(a.UnemployInsEMP,b.UnemployInsEMP),b.UnemployInsGRP=ISNULL(a.UnemployInsGRP,b.UnemployInsGRP),
    b.MaternityInsGRP=ISNULL(a.MaternityInsGRP,b.MaternityInsGRP),b.InjuryInsGRP=ISNULL(a.InjuryInsGRP,b.InjuryInsGRP)
    from pInsBase_import a,pEmployeeEmolu b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工社保缴费金额pInsBase_import
    delete from pInsBase_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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