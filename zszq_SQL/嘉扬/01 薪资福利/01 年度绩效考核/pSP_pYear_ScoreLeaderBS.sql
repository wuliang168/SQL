USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pYear_ScoreLeaderBS]
    @Score_Status int,
    @Score_Type int,
    @Score_DepID int,
    @EID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- ScoreTotal,ScoreYear,Ranking,RankLevel Submit
*/
Begin

    -------- pYear_Score --------

    -- 考核评分为空，无法递交员工考核评分！
    ---- 非普通员工 或 普通员工 合规部门
    IF Exists(select 1 from pYear_Score a,pVW_pYear_ScoreSum b
    where a.Score_EID=@EID and a.Score_Status=@Score_Status AND a.Score_Type1=@Score_Type 
    AND (a.Score_Type1 not in (4,33,11) or (a.Score_Type1 in (4,33,11) AND a.Score_DepID in (542,666,737)))
    AND a.Score_EID=b.Score_EID AND a.Score_Status=b.Score_Status AND a.Score_Type1=b.Score_Type1 AND a.Score_DepID=b.Score_DepID
    AND b.ScoreTotal is NULL
    AND a.Score_Status<>7)
    Begin
        Set @RetVal=1002130
        Return @RetVal
    End
    ---- 普通员工 非合规部门
    IF Exists(select 1 from pYear_Score a,pVW_pYear_ScoreSum b
    where a.Score_EID=@EID and a.Score_Status=@Score_Status AND a.Score_Type1=@Score_Type 
    AND a.Score_DepID=@Score_DepID AND a.Score_Type1 in (4,33,11) AND a.Score_EID=b.Score_EID 
    AND a.Score_Status=b.Score_Status AND a.Score_Type1=b.Score_Type1 AND a.Score_DepID=b.Score_DepID AND a.Score_Status<>7
    AND b.ScoreTotal is NULL
    and a.Score_DepID not in (542,666,737))
    Begin
        Set @RetVal=1002130
        Return @RetVal
    End
    ---- 兼职合规
    IF Exists(select 1 from pYear_Score a,pVW_pYear_ScoreSum b
    where a.Score_EID=@EID and a.Score_Status=@Score_Status AND a.Score_Type1=@Score_Type 
    AND a.Score_EID=b.Score_EID AND a.Score_Status=7 AND a.Score_DepID=b.Score_DepID
    AND a.Score_Type2=b.Score_Type2 AND b.ScoreTotal is NULL)
    Begin
        Set @RetVal=1002130
        Return @RetVal
    End

    -- 考核评分超出上限，无法递交员工考核评分！
    ---- Score_Type1：总部普通员工-4;分支机构普通员工-33;子公司普通员工-11
    IF Exists(select 1 from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and Score_Type1=@Score_Type
    and Score_DepID=@Score_DepID AND Score_DepID=@Score_DepID
    and (Score1 not between 0 and 50 or Score2 not between 0 and 5
    or Score3 not between 0 and 5 or Score4 not between 0 and 10
    or Score5 not between 0 and 10 or Score6 not between 0 and 10
    or Score7 not between 0 and 10)
    AND Score_Type1 in (4,11,33) and Score_DepID not in (542,666,737))
    Begin
        Set @RetVal=1002120
        Return @RetVal
    End
    -- 合规部门员工
    IF Exists(select 1 from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and Score_Type1=@Score_Type
    and (Score1 not between 0 and 100 or Score2 not between 0 and 100 or Score3 not between 0 and 100) AND Score_DepID=@Score_DepID
    AND Score_Type1 in (4,11,33) and Score_DepID in (542,666,737))
    Begin
        Set @RetVal=1002120
        Return @RetVal
    End
    ---- Score_Type1：总部部门负责人-1;总部副职-2;
    ---- 一级分支机构负责人-31;一级分支机构副职及二级分支机构经理室成员-32;
    ---- 分支机构区域财务经理-17;分支机构合规风控专员-14
    ---- 子公司部门负责人-10;
    ---- 兼职合规管理-35;
    IF Exists(select 1 from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and Score_Type1=@Score_Type
    and (Score1 not between 0 and 100 or Score2 not between 0 and 100 or Score3 not between 0 and 100)
    AND (Score_Type1 in (1,2,31,32,17,14,10) or Score_Type2=35))
    Begin
        Set @RetVal=1002120
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pYear_Score --------
    -- Set Current Submit=1
    ---- 非合规普通员工
    update a
    set a.Submit=1,a.SubmitBy=(select ID from SkySecUser where EID=@EID),a.SubmitTime=GETDATE()
    from pYear_Score a
    where a.Score_EID=@EID and a.Score_Status=@Score_Status 
    and a.Score_DepID=@Score_DepID and a.Score_Type1 in (4,33,11) and Score_DepID not in (542,666,737)
    and (a.Score_Type1=@Score_Type or a.Score_Type2=@Score_Type)
    -- Exception
    IF @@Error <> 0
    Goto ErrM
    ---- 合规员工及其他员工
    update a
    set a.Submit=1,a.SubmitBy=(select ID from SkySecUser where EID=@EID),a.SubmitTime=GETDATE()
    from pYear_Score a
    where a.Score_EID=@EID and a.Score_Status=@Score_Status 
    AND (a.Score_Type1 not in (4,33,11) or (a.Score_Type1 in (4,33,11) AND a.Score_DepID in (542,666,737)))
    and (a.Score_Type1=@Score_Type or a.Score_Type2=@Score_Type)
    -- Exception
    IF @@Error <> 0
    Goto ErrM
    ---- 兼职合规员工
    update a
    set a.Submit=1,a.SubmitBy=(select ID from SkySecUser where EID=@EID),a.SubmitTime=GETDATE()
    from pYear_Score a
    where a.Score_EID=@EID and a.Score_Status=@Score_Status and a.Score_Status=7
    AND a.Score_Type2=@Score_Type and a.Score_Type2=35
    -- Exception
    IF @@Error <> 0
    Goto ErrM
    -- Set Next Initialized=1
    update a
    set a.Initialized=1
    from pYear_Score a
    where a.Score_Status=99 and 0 not in (select ISNULL(Submit,0) from pYear_Score where EID=a.EID and Score_Status>=2 and Score_Status<>99)
    and a.EID in (select EID from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and (Score_Type1=@Score_Type or Score_Type2=@Score_Type) and Score_Status<>99)
    -- Exception
    IF @@Error <> 0
    Goto ErrM


    -- Update ScoreTotal,ScoreYear,ScoreSTG1,ScoreSTG2,ScoreCompl
    ---- Update Score_Status=@Score_Status ScoreTotal,ScoreYear
    update a
    set a.ScoreTotal=b.ScoreTotal,a.ScoreYear=b.ScoreYear
    from pYear_Score a,pVW_pYear_ScoreSum b
    where a.EID=b.EID 
    and a.Score_Status=b.Score_Status and a.Score_Status=@Score_Status 
    and a.Score_Type1=b.Score_Type1 and a.Score_Type1=@Score_Type
    and a.Score_EID=@EID and a.EID=b.EID
    -- Exception
    IF @@Error <> 0
    Goto ErrM
    ---- Update Score_Status=99 ScoreCompl,ScoreSTG1,ScoreSTG2
    update a
    set a.ScoreCompl=b.ScoreCompl,a.ScoreSTG1=b.ScoreSTG1,a.ScoreSTG2=b.ScoreSTG2,a.ScoreSTG3=b.ScoreSTG3
    from pYear_Score a,pVW_pYear_ScoreSum b
    where a.EID=b.EID 
    and b.Score_Status<>99 and a.Score_Status=99
	and a.Score_Type1=b.Score_Type1 and ISNULL(a.Score_Type2,0)=ISNULL(b.Score_Type2,0)
    and ((b.Score_Type1=@Score_Type and b.Score_Status<>7) 
    OR (b.Score_Type2=@Score_Type and b.Score_Status=7))
    and b.Score_EID=@EID
    -- Exception
    IF @@Error <> 0
    Goto ErrM


    -- Update Ranking,RankLevel
    ---- Score_Status=99
    update a
    set a.Ranking=b.Ranking,a.RankLevel=b.RankLevel
    from pYear_Score a,pVW_pYear_ScoreRanking b
    where a.EID=b.EID and a.Score_Status=99
    -- Exception
    IF @@Error <> 0
    Goto ErrM


    -- Common Control Flow
    COMMIT TRANSACTION
    Set @RetVal=0
    Return @RetVal

    -- Exception Control Flow
    ErrM:
    ROLLBACK TRANSACTION
    If ISNULL(@RetVal,0)=0
        Set @RetVal=-1
        Return @RetVal
End