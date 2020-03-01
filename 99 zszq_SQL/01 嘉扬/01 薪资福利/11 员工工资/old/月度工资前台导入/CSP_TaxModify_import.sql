USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_TaxModify_import]--CSP_TaxModify_import()
    @URID int,
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @TaxDeductionModifAT decimal(10,2),
    @TaxFeeReturnAT decimal(10,2),
    @TaxAllowanceAT decimal(10,2),
    @DonationRebateBT decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 税务调整导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pTaxModify_import表项中
    insert into pTaxModify_import (SalaryPayID,SalaryContact,Badge,TaxDeductionModifAT,TaxFeeReturnAT,
    TaxAllowanceAT,DonationRebateBT,Remark)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@TaxDeductionModifAT,@TaxFeeReturnAT,
    @TaxAllowanceAT,@DonationRebateBT,@Remark
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