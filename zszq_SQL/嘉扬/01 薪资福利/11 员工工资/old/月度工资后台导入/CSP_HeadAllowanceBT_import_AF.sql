USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadAllowanceBT_import_AF]--CSP_HeadAllowanceBT_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室税前补贴导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pHeadAllowanceBT_import的税前补贴到pEmployeeEmoluAllowanceBT
    update b
    set b.SponsorAllowanceBT=ISNULL(a.SponsorAllowanceBT,b.SponsorAllowanceBT),b.DirverAllowanceBT=ISNULL(a.DirverAllowanceBT,b.DirverAllowanceBT),
    b.ComplAllowanceBT=ISNULL(a.ComplAllowanceBT,b.ComplAllowanceBT),b.RegFinMGAllowanceBT=ISNULL(a.RegFinMGAllowanceBT,b.RegFinMGAllowanceBT),
    b.SalesMGAllowanceBT=ISNULL(a.SalesMGAllowanceBT,b.SalesMGAllowanceBT),b.CommAllowanceBT=ISNULL(a.CommAllowanceBT,b.CommAllowanceBT),
    b.CommAllowancePlus=ISNULL(a.CommAllowancePlus,b.CommAllowancePlus),
    b.AllowanceBTTotal=ISNULL(a.DirverAllowanceBT,ISNULL(b.DirverAllowanceBT,0))
    +ISNULL(a.ComplAllowanceBT,ISNULL(b.ComplAllowanceBT,0))+ISNULL(a.RegFinMGAllowanceBT,ISNULL(b.RegFinMGAllowanceBT,0))
    +ISNULL(a.SalesMGAllowanceBT,ISNULL(b.SalesMGAllowanceBT,0))+ISNULL(a.CommAllowanceBT,ISNULL(b.CommAllowanceBT,0))
    +ISNULL(a.CommAllowancePlus,ISNULL(b.CommAllowancePlus,0)),b.Remark=ISNULL(a.Remark,b.Remark)
    from pHeadAllowanceBT_import a,pEmployeeEmoluAllowanceBT b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.HeadContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工税前补贴pHeadAllowanceBT_import
    delete from pHeadAllowanceBT_import where HeadContact=(select EID from SkySecUser where ID=@URID)
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