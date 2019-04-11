USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pAnnualBonusAddDepSDM]
-- skydatarefresh eSP_pAnnualBonusAddDepSDM
    @leftid int, 
    @Identification varchar(100), 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度奖金员工增加(基于leftid的DepID)
-- @leftid为DepID信息，表示部门ID
*/
Begin

    -- 员工已存在，无法新增该员工!
    --If Exists(Select 1 From pYear_AnnualBonus Where AnnualBonusDepID=@leftid and Identification=@Identification)
    --Begin
    --    Set @RetVal = 930390
    --    Return @RetVal
    --End


    Begin TRANSACTION

    -- 更新pYear_AnnualBonus
    insert into pYear_AnnualBonus(Year,Date,AnnualBonusDepID,EMPDepID,Identification)
    select (select Year from pYear_AnnualBonusDep where AnnualBonusDepID=@leftid and ISNULL(IsClosed,0)=0),
    (select Date from pYear_AnnualBonusDep where AnnualBonusDepID=@leftid and ISNULL(IsClosed,0)=0),
    @leftid,(select DepID from pVW_Employee where Identification=@Identification),@Identification
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