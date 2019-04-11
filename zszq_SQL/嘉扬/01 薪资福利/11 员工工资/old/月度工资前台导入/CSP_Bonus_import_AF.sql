USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_Bonus_import_AF]--CSP_Bonus_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 奖金导入
*/
Begin

    Begin TRANSACTION

    -- 拷贝pBonus_import的奖金到pEmployeeEmoluBonus
    update b
    set b.GeneralBonus=ISNULL(a.GeneralBonus+b.BonusTotalMM-ISNULL(b.BonusTotalMM,0),ISNULL((b.BonusTotalMM-a.OneTimeAnnualBonus),b.GeneralBonus)),
    b.OneTimeAnnualBonus=ISNULL(a.OneTimeAnnualBonus+b.BonusTotalMM-ISNULL(b.BonusTotalMM,0),ISNULL((b.BonusTotalMM-a.GeneralBonus),b.OneTimeAnnualBonus)),
    b.Remark=a.Remark
    from pBonus_import a,pEmployeeEmoluBonus b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工奖金pBonus_import
    delete from pBonus_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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