USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pAnnualBonusAddEMP]
-- skydatarefresh eSP_pAnnualBonusAddEMP
    @EID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度奖金员工增加(基于员工的DepID)
-- @leftid为DepID信息，表示部门ID
*/
Begin

    -- 员工已存在，无法新增该员工!
    --If Exists(Select 1 From pYear_AnnualBonus Where AnnualBonusDepID=@leftid and EID=@EID)
    --Begin
    --    Set @RetVal = 930390
    --    Return @RetVal
    --End


    Begin TRANSACTION

    -- 更新pYear_AnnualBonus_all
    insert into pYear_AnnualBonus_all(EMPDepID,EID)
    select (select DepID from eEmployee where EID=@EID),@EID
    -- 异常流程
    If @@Error<>0
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