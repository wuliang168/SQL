USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pYear_ScoreEachLBS]
    @leftid int,
    @URID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 年度考核员工胜任素质测评递交
*/
Begin

    -- 胜任素质评测得分为空，无法递交员工胜任素质评测！
    IF Exists(select 1 from pYear_ScoreEachL where ISNULL(ScoreTotal,0)=0 
    and Score_EID=(select EID from SkySecUser where ID=@URID) and EachLType=@leftid)
    Begin
        Set @RetVal=1002100
        Return @RetVal
    End

    -- 胜任素质评测得分超过上限，无法递交员工胜任素质评测！
    IF Exists(select 1 from pYear_ScoreEachL where Score_EID=(select EID from SkySecUser where ID=@URID) and EachLType=@leftid
    and ((ISNULL(ScoreTeamLead,0) not between 0 and 20) or (ISNULL(ScoreTargetExec,0) not between 0 and 20)
    or (ISNULL(ScoreSysThinking,0) not  between 0 and 20) or (ISNULL(ScoreInnovation,0) not between 0 and 20)
    or (ISNULL(ScoreTraining,0) not between 0 and 20)))
    Begin
        Set @RetVal=1002110
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pYear_ScoreEachL --------
    -- 更新员工胜任素质评测
    update a
    set a.SUBMIT=1,a.Submitby=@URID,a.SubmitTime=GETDATE()
    from pYear_ScoreEachL a
    where a.Score_EID=(select EID from SkySecUser where ID=@URID) and a.EachLType=@leftid
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -------- pYear_Score --------
    -- 更新员工考核评分表和递交状态
    -- Score_Status=1时ScoreTotal
    ---- Submit=1
    update a
    set a.ScoreTotal=ISNULL(b.EachLEpAVG,0)+ISNULL(b.EachLSubAVG,0)+ISNULL(b.EachLSupAVG,0),a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    from pYear_Score a,pVW_pYear_ScoreEachSumL b
    where a.EID=b.EID and a.SCORE_STATUS=1
    and a.EID in (select EID from pYear_ScoreEachL a where Score_EID=(select EID from SkySecUser where ID=@URID) and EachLType=@leftid)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -- Score_Status=9时ScoreEach，员工胜任素质测评分用于最终评分及排名统计使用
    update a
    set a.ScoreEach=(ISNULL(b.EachLEpAVG,0)+ISNULL(b.EachLSubAVG,0)+ISNULL(b.EachLSupAVG,0))*b.EachLWeight/100
    from pYear_Score a,pVW_pYear_ScoreEachSumL b
    where a.EID=b.EID and a.Score_Status=9
    and a.EID in (select EID from pYear_ScoreEachL a where Score_EID=(select EID from SkySecUser where ID=@URID) and EachLType=@leftid)
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
    If isnull(@RetVal,0)=0
      Set @RetVal=-1
      Return @RetVal

end