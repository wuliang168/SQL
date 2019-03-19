USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_AllowanceBT_import]--CSP_AllowanceBT_import()
    @URID int,
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @SponsorAllowanceBT decimal(10,2),
    @DirverAllowanceBT decimal(10,2),
    @ComplAllowanceBT decimal(10,2),
    @RegFinMGAllowanceBT decimal(10,2),
    @SalesMGAllowanceBT decimal(10,2),
    @CommAllowanceBT decimal(10,2),
    @CommAllowancePlus decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 税前补贴导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pAllowanceBT_import表项中
    insert into pAllowanceBT_import (SalaryPayID,SalaryContact,Badge,SponsorAllowanceBT,DirverAllowanceBT,
    ComplAllowanceBT,RegFinMGAllowanceBT,SalesMGAllowanceBT,CommAllowanceBT,CommAllowancePlus,Remark)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@SponsorAllowanceBT,@DirverAllowanceBT,
    @ComplAllowanceBT,@RegFinMGAllowanceBT,@SalesMGAllowanceBT,@CommAllowanceBT,@CommAllowancePlus,@Remark
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