USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PITSpclMinus_import_AF]--CSP_PITSpclMinus_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 专项附加扣除导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pPITSpclMinus_import的专项附加扣除项到pPITSpclMinusPerMM
    update b
    set b.Date=(select Date from pSalaryPerMonth where ISNULL(Submit,0)=1 and ISNULL(Closed,0)=0),
    b.ChildEdu=ISNULL(a.ChildEdu,0),b.ContEdu=ISNULL(a.ContEdu,0),b.CritiIll=ISNULL(a.CritiIll,0),
    b.HousLoanInte=ISNULL(a.HousLoanInte,0),b.HousRent=ISNULL(a.HousRent,0),b.SuppElder=ISNULL(a.SuppElder,0),
    b.SalaryContact=(select EID from SkySecUser where ID=@URID)
    from pPITSpclMinus_import a,pPITSpclMinusPerMM b
    where (select EID from eEmployee where EID in (select EID from eDetails where CertNo=a.CertNo) and status in (1,2,3))=b.EID 
    and a.HeadContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工税后补贴pPITSpclMinus_import
    delete from pPITSpclMinus_import where HeadContact=(select EID from SkySecUser where ID=@URID)
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