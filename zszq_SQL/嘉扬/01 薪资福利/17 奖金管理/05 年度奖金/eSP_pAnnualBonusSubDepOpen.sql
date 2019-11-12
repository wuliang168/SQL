USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pAnnualBonusSubDepOpen]
-- skydatarefresh eSP_pAnnualBonusSubDepOpen
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 二级部门年度奖金开启程序
-- @ID 为部门工资统计对应ID
*/
Begin


    -- 待分配奖金上限大于分支机构剩余奖金，二级分支机构奖金分配无法开启!
    If Exists(Select 1 From pVW_pAnnualBonusDep a,pYear_AnnualBonusDep b
    Where a.AnnualBonusDEP2ndRest<0 and a.AnnualBonusDepID=b.AnnualBonusDepID and a.ProcessID=b.ProcessID and b.ID=@ID)
    Begin
        Set @RetVal = 930361
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新部门年度奖金状态
    Update a
    Set a.IsSubmit=0
    From pYear_AnnualBonusDep a
    Where ID=@ID
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