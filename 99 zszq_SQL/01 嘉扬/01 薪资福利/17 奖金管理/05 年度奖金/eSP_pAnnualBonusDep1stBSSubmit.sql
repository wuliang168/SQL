USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pAnnualBonusDep1stBSSubmit]
-- skydatarefresh eSP_pAnnualBonusDep1stBSSubmit
    @leftid varchar(20),  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度奖金递交(基于DepID的leftid)
-- @leftid为DepID信息，表示部门ID
*/
Begin

    declare @DepID int,@ProcessID int
    set @DepID=convert(int,SUBSTRING(@leftid,0,CHARINDEX('-',@leftid)))
    set @ProcessID=convert(int,REVERSE(SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid)))))

    -- 员工年度奖金金额为空，无法递交!
    --If Exists(Select 1 From pYear_AnnualBonus Where dbo.eFN_getdepid1st(AnnualBonusDepID)=@leftid and AnnualBonus is NULL)
    --Begin
    --    Set @RetVal = 930370
    --    Return @RetVal
    --End

    -- 奖金分配员工总额大于奖金分配部门限额，无法递交!
    If Exists(Select 1 From pVW_pAnnualBonusDep Where AnnualBonusDepID=@DepID and ProcessID=@ProcessID and AnnualBonusDEP1stEMPRest<0 and ISNULL(IsClosed,0)=0)
    Begin
        Set @RetVal = 930380
        Return @RetVal
    End


    Begin TRANSACTION

    
    -- 更新部门负责人年度奖金
    --update a
    --set a.AnnualBonus=b.AnnualBonusDirectorTotal
    --from pYear_AnnualBonus a,pYear_AnnualBonusDep b
    --where b.AnnualBonusDepID=a.AnnualBonusDepID and a.AnnualBonusDepID=@leftid
    --and a.EID=b.Director and ISNULL(b.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0
    -- 异常流程
    --If @@Error<>0
    --Goto ErrM

    -- 更新AnnualBonusDepRest
    update a
    set a.AnnualBonusDepRest=b.AnnualBonusDEP1stEMPRest
    from pYear_AnnualBonusDep a,pVW_pAnnualBonusDep b
    where a.AnnualBonusDepID=@DepID and a.AnnualBonusDepID=b.AnnualBonusDepID 
    and ISNULL(a.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0
    and ISNULL(b.IsSubmit,0)=0 and ISNULL(b.IsClosed,0)=0
    and a.ProcessID=@ProcessID and a.ProcessID=b.ProcessID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pYear_AnnualBonusDep
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pYear_AnnualBonusDep a
    where a.AnnualBonusDepID=@DepID and ISNULL(a.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0
    and a.ProcessID=@ProcessID
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