USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_pEMPMonthBonusPerMM_import_AF]--CSP_pEMPMonthBonusPerMM_import_AF()
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 月度员工分配信息导入后
*/
Begin

    Begin TRANSACTION

    -- 更新pEMPMonthBonusPerMM_import的社保信息到pEMPMonthBonusPerMM
    update b
    set b.GeneralBonus=ISNULL(a.GeneralBonus,b.GeneralBonus),b.OneTimeAnnualBonus=ISNULL(a.OneTimeAnnualBonus,b.OneTimeAnnualBonus),
    b.BonusRestMM=ISNULL(b.BonusRest,0)+ISNULL(b.BonusAmountMM,0)-ISNULL(a.GeneralBonus,0)-ISNULL(a.OneTimeAnnualBonus,0)
    from pEMPMonthBonusPerMM_import a,pEMPMonthBonusPerMM b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID
    -- 异常流程
    IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工税后补贴pEMPMonthBonusPerMM_import
    delete from pEMPMonthBonusPerMM_import
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