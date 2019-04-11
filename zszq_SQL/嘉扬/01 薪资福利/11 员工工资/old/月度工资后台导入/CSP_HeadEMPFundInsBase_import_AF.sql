USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadEMPFundInsBase_import_AF]--CSP_HeadEMPFundInsBase_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 个人社保公积金缴费基数导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pHeadEMPFundInsBase_import的个人社保公积金缴费基数到pEmployeeEmolu
    update b
    set b.EndowInsEMP=ISNULL(a.EndowInsEMP,b.EndowInsEMP),b.MedicalInsEMP=ISNULL(a.MedicalInsEMP,b.MedicalInsEMP),
    b.UnemployInsEMP=ISNULL(a.UnemployInsEMP,b.UnemployInsEMP),b.HousingFundEMP=ISNULL(a.HousingFundEMP,b.HousingFundEMP),
    b.HousingFundOverEMP=ISNULL(a.HousingFundOverEMP,b.HousingFundOverEMP),
    b.HousingFundLoc=(select ID from eCD_City where Title=a.HousingFundLoc and ISNULL(isDisabled,0)=0),
    b.InsuranceLoc=(select ID from eCD_City where Title=a.InsuranceLoc and ISNULL(isDisabled,0)=0),
    b.IsConfirm=1
    from pHeadEMPFundInsBase_import a,pEmployeeEmolu b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工个人社保公积金缴费基数pHeadEMPFundInsBase_import
    delete from pHeadEMPFundInsBase_import where HeadContact=(select EID from SkySecUser where ID=@URID)
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