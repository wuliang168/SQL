USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PITSpclMinus_import_BF]--CSP_PITSpclMinus_import_BF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 专项附加扣除导入前
*/
Begin

    Begin TRANSACTION

    -- 清空URID对应的Badge
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