USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_DeductionAT_import_AF]--CSP_DeductionAT_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 税后扣款导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pDeductionAT_import的税后扣款到pEmployeeEmoluDeductionBT
    update b
    set b.ComputerDeductionAT=ISNULL(a.ComputerDeductionAT,b.ComputerDeductionAT),b.TaxDeductionAT=ISNULL(a.TaxDeductionAT,b.TaxDeductionAT),
    b.OthersDeductionAT=ISNULL(a.OthersDeductionAT,b.OthersDeductionAT),
    b.DeductionATTotal=ISNULL(a.ComputerDeductionAT,ISNULL(b.ComputerDeductionAT,0))+ISNULL(a.TaxDeductionAT,ISNULL(b.TaxDeductionAT,0))
    +ISNULL(a.OthersDeductionAT,ISNULL(b.OthersDeductionAT,0)),b.Remark=ISNULL(a.Remark,b.Remark)
    from pDeductionAT_import a,pEmployeeEmoluDeductionAT b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工税后扣款pDeductionAT_import
    delete from pDeductionAT_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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