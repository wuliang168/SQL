USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PensionDep_import_BF]--CSP_PensionDep_import_BF()
    @URID int,
    @leftid varchar(20),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 企业年金导入前
*/
Begin

    declare @DepID int,@SalaryPayID int
    set @DepID=convert(int,SUBSTRING(@leftid,0,CHARINDEX('-',@leftid)))
    set @SalaryPayID=convert(int,REVERSE(SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid)))))

    Begin TRANSACTION

    -- 清空URID和leftid对应的Badge
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