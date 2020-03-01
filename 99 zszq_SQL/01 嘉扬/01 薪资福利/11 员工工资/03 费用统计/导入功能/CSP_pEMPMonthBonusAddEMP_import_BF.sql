USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_pEMPMonthBonusAddEMP_import_BF]--CSP_pEMPMonthBonusAddEMP_import_BF()
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 月度奖金员工增加导入前
-- leftid 为 月度奖金归属部门DepID
*/
Begin

    Begin TRANSACTION

    -- 清空leftid对应的Badge
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