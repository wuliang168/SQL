USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadBackPay_import]--CSP_HeadBackPay_import()
    @URID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @ProbationBackPay decimal(10,2),
    @NewStaffBackPay decimal(10,2),
    @AppointBackPay decimal(10,2),
    @AppraisalBackPay decimal(10,2),
    @ToSponsorBackPay decimal(10,2),
    @OvertimeBackPay decimal(10,2),
    @TransPostBackPay decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室补发工资导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pHeadBackPay_import表项中
    insert into pHeadBackPay_import (HeadContact,Badge,ProbationBackPay,NewStaffBackPay,
    AppointBackPay,AppraisalBackPay,ToSponsorBackPay,OvertimeBackPay,TransPostBackPay,Remark)
    select (select EID from SkySecUser where ID=@URID),@Badge,@ProbationBackPay,@NewStaffBackPay,@AppointBackPay,
    @AppraisalBackPay,@ToSponsorBackPay,@OvertimeBackPay,@TransPostBackPay,@Remark
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