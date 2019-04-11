USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadComm_import]--CSP_HeadComm_import()
    @URID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @CommAllowance decimal(10,2),
    @CommAllowanceType nvarchar(100),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室通讯费导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pHeadComm_import表项中
    insert into pHeadComm_import (HeadContact,Badge,CommAllowance,CommAllowanceType)
    select (select EID from SkySecUser where ID=@URID),@Badge,@CommAllowance,@CommAllowanceType
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