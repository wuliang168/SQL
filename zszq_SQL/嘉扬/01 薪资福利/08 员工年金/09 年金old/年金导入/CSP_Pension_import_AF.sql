USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_Pension_import_AF]--CSP_Pension_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 企业年金导入后
*/
Begin

    Begin TRANSACTION


    -- 拷贝pEmpPension_import的企业年金到pEmpPensionPerMM_register
    update b
    set b.GrpPensionPerMM=(ISNULL(a.EmpPensionPerMMBTax,0)+ISNULL(a.EmpPensionPerMMATax,0))*4,
    b.EmpPensionPerMMBTax=ISNULL(a.EmpPensionPerMMBTax,0),b.EmpPensionPerMMATax=ISNULL(a.EmpPensionPerMMATax,0),
    b.GrpPensionMonthRest=ISNULL(b.GrpPensionMonthTotal,0)-(ISNULL(a.EmpPensionPerMMBTax,0)+ISNULL(a.EmpPensionPerMMATax,0))*4,
    b.EmpPensionMonthRest=ISNULL(b.EmpPensionMonthTotal,0)-(ISNULL(a.EmpPensionPerMMBTax,0)+ISNULL(a.EmpPensionPerMMATax,0)),
    b.Remark=a.Remark
    from pEmpPension_import a,pEmpPensionPerMM_register b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID
    and a.PensionContact=b.PensionContact and a.PensionContact=(select EID from SkySecUser where ID=@URID)
    and ((a.SalaryPayID in (1,2,3,10,11,12,13,14,15,16) and @leftid=1) or (a.SalaryPayID in (4,5) and @leftid=4) 
    or (a.SalaryPayID=7 and @leftid=7) or (a.SalaryPayID=8 and @leftid=8))
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM

    -- 清除导入员工企业年金pEmpPension_import
    delete from pEmpPension_import where SalaryPayID=@leftid and PensionContact=(select EID from SkySecUser where ID=@URID)
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