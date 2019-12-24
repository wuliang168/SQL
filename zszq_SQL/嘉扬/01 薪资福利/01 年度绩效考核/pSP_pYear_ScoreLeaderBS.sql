USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pYear_ScoreLeaderBS]
    @Score_Status int,    -- leftid实际返回内容为score_status
    @Score_Type int,
    @EID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 年度考核评分递交
*/
Begin

    -------- pYear_Score --------

    -- 考核评分为空，无法递交员工考核评分！
    IF Exists(select 1 from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status AND Score_Type1=@Score_Type AND ScoreTotal is NULL)
    Begin
        Set @RetVal=1002130
        Return @RetVal
    End

    -- 考核评分超出上限，无法递交员工考核评分！
    ---- Score_Type1：总部普通员工-4;一级分支机构普通员工-33;二级分支机构普通员工-34;子公司普通员工-11
    IF Exists(select 1 from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and Score_Type1=@Score_Type
    and (Score1 not between 0 and 50 or Score2 not between 0 and 5
    or Score3 not between 0 and 5 or Score4 not between 0 and 10
    or Score5 not between 0 and 5 or Score6 not between 0 and 5
    or Score7 not between 0 and 10 or Score8 not between 0 and 10)
    AND Score_Type1 in (4,11,33,34))
    Begin
        Set @RetVal=1002120
        Return @RetVal
    End
    ---- Score_Type1：总部部门负责人-1;总部副职-2;
    ---- 一级分支机构负责人-31;一级分支机构副职及二级分支机构经理室成员-32;
    ---- 分支机构区域财务经理-17;分支机构合规风控专员-14;兼职合规管理-35
    ---- 子公司部门负责人-10;
    IF Exists(select 1 from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and Score_Type1=@Score_Type
    and (Score1 not between 0 and 100 or Score2 not between 0 and 100 or Score3 not between 0 and 100)
    AND (Score_Type1 in (1,2,31,32,36,17,14,10) or Score_Type2=35))
    Begin
        Set @RetVal=1002120
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pYear_Score --------
    -- 更新pYear_Score，更新当前阶段递交状态
    ---- Submit=1
    update a
    set a.Submit=1,a.SubmitBy=(select ID from SkySecUser where EID=@EID),a.SubmitTime=GETDATE()
    from pYear_Score a
    where a.Score_EID=@EID and a.Score_Status=@Score_Status 
    and (a.Score_Type1=@Score_Type or a.Score_Type2=@Score_Type)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    
    -- 更新pYear_Score，更新Score_Status=99的初始化状态
    ---- 当员工Score_Status所有非99的Submit均为1时，设置Score_Status=99的Initialized=1
    update a
    set a.Initialized=1
    from pYear_Score a
    where a.Score_Status=99 and 0 not in (select ISNULL(Submit,0) from pYear_Score where EID=a.EID and Score_Status>=2 and Score_Status<>99)
    and a.EID in (select EID from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and (Score_Type1=@Score_Type or Score_Type2=@Score_Type) and Score_Status<>99)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -- 更新最终评分及排名统计分数
    ---- ScoreTotal,ScoreYear
    update a
    set a.ScoreTotal=b.ScoreTotal,a.ScoreYear=b.ScoreYear
    from pYear_Score a,pVW_pYear_ScoreSum b
    where a.EID=b.EID 
    and a.Score_Status=b.Score_Status and a.Score_Status=@Score_Status 
    and ISNULL(a.Score_Type1,a.Score_Type2)=ISNULL(b.Score_Type1,b.Score_Type2) and ISNULL(a.Score_Type1,a.Score_Type2)=@Score_Type
    and a.EID in (select EID from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and (Score_Type1=@Score_Type or Score_Type2=@Score_Type))
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    ---- Score_Status=2时ScoreSTG1
    update a
    set a.ScoreSTG1=b.ScoreSTG1
    from pYear_Score a,pVW_pYear_ScoreSum b
    where a.EID=b.EID and a.Score_Status=99 and b.Score_Status=2
    and a.EID in (select EID from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and (Score_Type1=@Score_Type or Score_Type2=@Score_Type) and Score_Status<>99)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    ---- Score_Status=3时ScoreSTG2
    update a
    set a.ScoreSTG2=b.ScoreSTG2
    from pYear_Score a,pVW_pYear_ScoreSum b
    where a.EID=b.EID and a.Score_Status=99 and b.Score_Status=3
    and a.EID in (select EID from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and (Score_Type1=@Score_Type or Score_Type2=@Score_Type) and Score_Status<>99)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    ---- Score_Status=7时ScoreCompl
    update a
    set a.ScoreCompl=b.ScoreCompl
    from pYear_Score a,pVW_pYear_ScoreSum b
    where a.EID=b.EID and a.Score_Status=99 and b.Score_Status=7
    and a.EID in (select EID from pYear_Score where Score_EID=@EID and Score_Status=@Score_Status and (Score_Type1=@Score_Type or Score_Type2=@Score_Type) and Score_Status<>99)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -- 更新Ranking,RankLevel
    ---- Score_Status=9时
    update a
    set a.Ranking=b.Ranking,a.RankLevel=b.RankLevel
    from pYear_Score a,pVW_pYear_ScoreRanking b
    where a.EID=b.EID and a.Score_Status=9
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -- 正常处理流程
    COMMIT TRANSACTION
    Set @RetVal=0
    Return @RetVal

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    If ISNULL(@RetVal,0)=0
        Set @RetVal=-1
        Return @RetVal
End