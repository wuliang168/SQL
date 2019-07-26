USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pAnnualBonusAddDepEMP]
-- skydatarefresh eSP_pAnnualBonusAddDepEMP
    @leftid varchar(20), 
    @EID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度奖金员工增加(基于leftid的DepID)
-- @leftid为DepID信息，表示部门ID
*/
Begin

    declare @DepID int,@ProcessID int
    set @DepID=convert(int,SUBSTRING(@leftid,0,CHARINDEX('-',@leftid)))
    set @ProcessID=convert(int,SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid))))

    -- 员工已存在，无法新增该员工!
    --If Exists(Select 1 From pYear_AnnualBonus Where AnnualBonusDepID=@leftid and EID=@EID)
    --Begin
    --    Set @RetVal = 930390
    --    Return @RetVal
    --End


    Begin TRANSACTION

    -- 更新pYear_AnnualBonus
    insert into pYear_AnnualBonus(ProcessID,Year,Date,AnnualBonusDepID,EMPDepID,EID,AnnualBonusType)
    select @ProcessID,
    (select Year from pYear_AnnualBonusDep where AnnualBonusDepID=@DepID and ProcessID=@ProcessID and ISNULL(IsClosed,0)=0),
    (select Date from pYear_AnnualBonusDep where AnnualBonusDepID=@DepID and ProcessID=@ProcessID and ISNULL(IsClosed,0)=0),
    @DepID,(select DepID from pVW_Employee where EID=@EID),@EID,
    (select AnnualBonusType from pYear_AnnualBonusDep where AnnualBonusDepID=@DepID and ProcessID=@ProcessID and ISNULL(IsClosed,0)=0)
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