USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadGRPFundInsBase_import_AF]--CSP_HeadGRPFundInsBase_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 企业社保公积金缴费基数导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pHeadGRPFundInsBase_import的企业社保公积金缴费基数到pEmployeeEmolu
    update b
    set b.EndowInsGRP=ISNULL(a.EndowInsGRP,b.EndowInsGRP),b.MedicalInsGRP=ISNULL(a.MedicalInsGRP,b.MedicalInsGRP),
    b.UnemployInsGRP=ISNULL(a.UnemployInsGRP,b.UnemployInsGRP),b.MaternityInsGRP=ISNULL(a.MaternityInsGRP,b.MaternityInsGRP),
    b.InjuryInsGRP=ISNULL(a.InjuryInsGRP,b.InjuryInsGRP),b.HousingFundGRP=ISNULL(a.HousingFundGRP,b.HousingFundGRP),
    b.HousingFundOverGRP=ISNULL(a.HousingFundOverGRP,b.HousingFundOverGRP),b.IsConfirm=1
    from pHeadGRPFundInsBase_import a,pEmployeeEmolu b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工企业社保公积金缴费基数pHeadGRPFundInsBase_import
    delete from pHeadGRPFundInsBase_import where HeadContact=(select EID from SkySecUser where ID=@URID)
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