USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadDeductionAT_import]--CSP_HeadDeductionAT_import()
    @URID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @ComputerDeductionAT decimal(10,2),
    @TaxDeductionAT decimal(10,2),
    @OthersDeductionAT decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室税后扣款导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pHeadDeductionAT_import表项中
    insert into pHeadDeductionAT_import (HeadContact,Badge,ComputerDeductionAT,TaxDeductionAT,
    OthersDeductionAT,Remark)
    select (select EID from SkySecUser where ID=@URID),@Badge,@ComputerDeductionAT,@TaxDeductionAT,@OthersDeductionAT,
    @Remark
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