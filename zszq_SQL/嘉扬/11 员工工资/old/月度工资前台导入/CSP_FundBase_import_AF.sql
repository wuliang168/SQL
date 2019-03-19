USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_FundBase_import_AF]--CSP_FundBase_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 公积金缴费金额导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pFundBase_import的公积金缴费金额到pEmployeeEmolu
    update b
    set b.HousingFundLoc=(select ID from eCD_City where Title=a.HousingFundLoc),
    b.HousingFundEMP=ISNULL(a.HousingFundEMP,b.HousingFundEMP),b.HousingFundGRP=ISNULL(a.HousingFundGRP,b.HousingFundGRP)
    from pFundBase_import a,pEmployeeEmolu b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工公积金缴费金额pFundBase_import
    delete from pFundBase_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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