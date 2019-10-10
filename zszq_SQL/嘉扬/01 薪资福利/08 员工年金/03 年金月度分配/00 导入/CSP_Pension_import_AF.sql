USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_Pension_import_AF]--CSP_Pension_import_AF()
    @URID int,
    @leftid varchar(20),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 企业年金导入后
*/
Begin

    declare @DepID int,@SalaryPayID int
    set @DepID=convert(int,SUBSTRING(@leftid,0,CHARINDEX('-',@leftid)))
    set @SalaryPayID=convert(int,REVERSE(SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid)))))

    Begin TRANSACTION


    -- 拷贝pEmpPension_import的企业年金到pEmpPensionPerMM_register
    update b
    set b.EmpPensionPerMMBTax=ISNULL(a.EmpPensionPerMMBTax,0),b.EmpPensionPerMMATax=ISNULL(a.EmpPensionPerMMATax,0),
    b.EmpPensionMonthRest=ISNULL(b.EmpPensionMonthTotal,0)-(ISNULL(a.EmpPensionPerMMBTax,0)+ISNULL(a.EmpPensionPerMMATax,0)),
    b.Remark=a.Remark
    from pEmpPension_import a,pEmpPensionPerMM_register b
    where ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID)
    and a.PensionContact=b.PensionContact and a.PensionContact=(select EID from SkySecUser where ID=@URID) and @DepID=0
    and ((a.SalaryPayID in (1,2,3,10,11,12,13,14,15,16,19,17) and @SalaryPayID=1) or (a.SalaryPayID in (4,5) and @SalaryPayID=4) 
    or (a.SalaryPayID=7 and @SalaryPayID=7))
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM

    -- 清除导入员工企业年金pEmpPension_import
    delete from pEmpPension_import 
    where @DepID=0 and SalaryPayID=@SalaryPayID
    and PensionContact=(select EID from SkySecUser where ID=@URID)
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