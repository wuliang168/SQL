USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PensionDep_import_AF]--CSP_PensionDep_import_AF()
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


    -- 拷贝pEmpPensionDep_import的企业年金到pEmpPensionPerMM_register
    update b
    set b.EmpPensionPerMMBTax=ISNULL(a.EmpPensionPerMMBTax,0),b.EmpPensionPerMMATax=ISNULL(a.EmpPensionPerMMATax,0),
    b.EmpPensionMonthRest=ISNULL(b.EmpPensionMonthTotal,0)-(ISNULL(a.EmpPensionPerMMBTax,0)+ISNULL(a.EmpPensionPerMMATax,0)),
    b.Remark=a.Remark
    from pEmpPensionDep_import a,pEmpPensionPerMM_register b
    where ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID) 
    and a.DepID=b.DepID and a.DepID=@DepID
    and (b.SalaryPayID=6 or ISNULL(b.SalaryPayID,0)=0)
    and a.PensionContact=b.PensionContact and a.PensionContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM

    -- 清除导入员工企业年金pEmpPensionDep_import
    delete from pEmpPensionDep_import where DepID=@DepID and PensionContact=(select EID from SkySecUser where ID=@URID)
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