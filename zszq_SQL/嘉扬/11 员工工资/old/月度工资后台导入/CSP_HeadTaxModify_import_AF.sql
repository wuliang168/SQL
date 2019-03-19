USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadTaxModify_import_AF]--CSP_HeadTaxModify_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室税务调整导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pHeadTaxModify_import的税务调整到pEmployeeEmoluTax
    update b
    set b.TaxDeductionModifAT=ISNULL(a.TaxDeductionModifAT,b.TaxDeductionModifAT),
    b.TaxFeeReturnAT=ISNULL(a.TaxFeeReturnAT,b.TaxFeeReturnAT),b.TaxAllowanceAT=ISNULL(a.TaxAllowanceAT,b.TaxAllowanceAT),
    b.DonationRebateBT=ISNULL(a.DonationRebateBT,b.DonationRebateBT),b.Remark=ISNULL(a.Remark,b.Remark)
    from pHeadTaxModify_import a,pEmployeeEmoluTax b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.HeadContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工税务调整pHeadTaxModify_import
    delete from pHeadTaxModify_import where HeadContact=(select EID from SkySecUser where ID=@URID)
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