USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PensionAdmin_import]--CSP_PensionAdmin_import()
    @URID int,
    @Badge varchar(10),
    @Name nvarchar(10),
    @LastYearAdminID nvarchar(100),
    @LastYearMDID nvarchar(100),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 行政职级导入
*/
Begin

    Begin TRANSACTION

    -- 将导入的文件插入到pEmpAdmin_import表项中
    insert into pEmpAdmin_import (Operator,Badge,Name,LastYearAdminID,LastYearMDID,Remark)
    select (select EID from SkySecUser where ID=@URID),@Badge,@Name,@LastYearAdminID,@LastYearMDID,@Remark
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