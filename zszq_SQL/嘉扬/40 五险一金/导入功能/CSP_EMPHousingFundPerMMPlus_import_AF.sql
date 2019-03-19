USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EMPHousingFundPerMMPlus_import_AF]--CSP_EMPHousingFundPerMMPlus_import_AF()
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 公积金信息导入后
*/
Begin

    Begin TRANSACTION

    -- 更新pEMPHousingFundPerMMPlus_import的公积金信息到pEMPHousingFundPerMM
    update b
    set b.HousingFundEMPPlus=ISNULL(a.HousingFundEMPPlus,b.HousingFundEMPPlus),
    b.HousingFundGRPPlus=(case when ISNULL(ISNULL(a.HousingFundEMPPlus,b.HousingFundGRPPlus),0)>0 then ISNULL(ISNULL(a.HousingFundEMPPlus,b.HousingFundGRPPlus),0) else 0 end),
    b.HousingFundEMPPlusTotal=ISNULL(a.HousingFundEMPPlus,b.HousingFundEMPPlusTotal),
    b.HousingFundGRPPlusTotal=(case when ISNULL(ISNULL(a.HousingFundEMPPlus,b.HousingFundGRPPlusTotal),0)>0 then ISNULL(ISNULL(a.HousingFundEMPPlus,b.HousingFundGRPPlusTotal),0) else 0 end)
    from pEMPHousingFundPerMMPlus_import a,pEMPHousingFundPerMM b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.EMPHousingFundDepart=@leftid
    -- 异常流程
    IF @@Error <> 0
	Goto ErrM


    -- 清除导入公积金信息pEMPHousingFundPerMMPlus_import
    delete from pEMPHousingFundPerMMPlus_import where EMPHousingFundDepart=@leftid
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