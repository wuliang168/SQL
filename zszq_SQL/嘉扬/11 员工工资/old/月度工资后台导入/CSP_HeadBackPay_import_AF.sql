USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadBackPay_import_AF]--CSP_HeadBackPay_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室补发工资导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pHeadBackPay_import的补发工资到pEmployeeEmoluBackPay
    update b
    set b.ProbationBackPay=ISNULL(a.ProbationBackPay,b.ProbationBackPay),b.NewStaffBackPay=ISNULL(a.NewStaffBackPay,b.NewStaffBackPay),
    b.AppointBackPay=ISNULL(a.AppointBackPay,b.AppointBackPay),b.AppraisalBackPay=ISNULL(a.AppraisalBackPay,b.AppraisalBackPay),
    b.ToSponsorBackPay=ISNULL(a.ToSponsorBackPay,b.ToSponsorBackPay),b.OvertimeBackPay=ISNULL(a.OvertimeBackPay,b.OvertimeBackPay),
    b.TransPostBackPay=ISNULL(a.TransPostBackPay,b.TransPostBackPay),
    b.BackPayTotal=ISNULL(a.ProbationBackPay,ISNULL(b.ProbationBackPay,0))+ISNULL(a.NewStaffBackPay,ISNULL(b.NewStaffBackPay,0))
    +ISNULL(a.AppointBackPay,ISNULL(b.AppointBackPay,0))+ISNULL(a.AppraisalBackPay,ISNULL(b.AppraisalBackPay,0))
    +ISNULL(a.ToSponsorBackPay,ISNULL(b.ToSponsorBackPay,0))+ISNULL(a.OvertimeBackPay,ISNULL(b.OvertimeBackPay,0))
    +ISNULL(a.TransPostBackPay,ISNULL(b.TransPostBackPay,0)),b.Remark=ISNULL(a.Remark,b.Remark)
    from pHeadBackPay_import a,pEmployeeEmoluBackPay b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.HeadContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工补发工资pHeadBackPay_import
    delete from pHeadBackPay_import where HeadContact=(select EID from SkySecUser where ID=@URID)
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