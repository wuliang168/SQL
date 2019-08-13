USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadFestivalFee_import_AF]--CSP_HeadFestivalFee_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室过节费导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pHeadFestivalFee_import的过节费到pEmployeeEmoluFestivalFee
    update b
    set b.FestivalFeeType1=(select ID from oCD_FestivalFeeType where Title=a.FestivalFeeType1),
    b.FestivalFeeType2=(select ID from oCD_FestivalFeeType where Title=a.FestivalFeeType2),
    b.FestivalFeeType3=(select ID from oCD_FestivalFeeType where Title=a.FestivalFeeType3),
    b.FestivalFee1=ISNULL(a.FestivalFee1,(select Fee from oCD_FestivalFeeType where Title=a.FestivalFeeType1)),
    b.FestivalFee2=ISNULL(a.FestivalFee2,(select Fee from oCD_FestivalFeeType where Title=a.FestivalFeeType2)),
    b.FestivalFee3=ISNULL(a.FestivalFee3,(select Fee from oCD_FestivalFeeType where Title=a.FestivalFeeType3)),
    --b.BenefitsInKind=ISNULL(a.BenefitsInKind,b.BenefitsInKind),
    b.FestivalFeeTotal=ISNULL(ISNULL(a.FestivalFee1,(select Fee from oCD_FestivalFeeType where Title=a.FestivalFeeType1)),0)
    +ISNULL(ISNULL(a.FestivalFee2,(select Fee from oCD_FestivalFeeType where Title=a.FestivalFeeType2)),0)
    +ISNULL(ISNULL(a.FestivalFee3,(select Fee from oCD_FestivalFeeType where Title=a.FestivalFeeType3)),0),b.Remark=a.Remark
    from pHeadFestivalFee_import a,pEmployeeEmoluFestivalFee b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and HeadContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工过节费HeadpFestivalFee_import
    delete from pHeadFestivalFee_import where HeadContact=(select EID from SkySecUser where ID=@URID)
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