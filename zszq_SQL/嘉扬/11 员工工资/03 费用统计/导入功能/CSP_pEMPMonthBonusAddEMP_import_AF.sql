USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_pEMPMonthBonusAddEMP_import_AF]--CSP_pEMPMonthBonusAddEMP_import_AF()
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 月度奖金员工信息导入后
-- leftid 为 月度奖金归属部门DepID
*/
Begin

    Begin TRANSACTION

    -- 将pEMPMonthBonusAddEMP_import的月度奖金员工信息插入到pEmpMonthBonusPerMMAdd
    insert into pEmpMonthBonusPerMMAdd(EID,BonusYear,BonusType,BonusAmount,BonusDepID,Remark)
    select (select EID from eEmployee where Badge=a.Badge),a.BonusYear,a.BonusType,a.BonusAmount,a.BonusDepID,a.Remark
    from pEMPMonthBonusAddEMP_import a
    where a.BonusDepID=@leftid
    -- 异常流程
    IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工月度奖金增加表项pEMPMonthBonusAddEMP_import
    delete from pEMPMonthBonusAddEMP_import where BonusDepID=@leftid
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