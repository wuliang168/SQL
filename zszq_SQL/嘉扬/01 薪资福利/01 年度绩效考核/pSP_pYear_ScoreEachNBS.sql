USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pYear_ScoreEachNBS]
    @URID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 年度考核员工互评递交
*/
Begin

    -- 互评得分为空，无法递交员工互评！
    IF Exists(select 1 from pYear_ScoreEachN where ISNULL(ScoreTotal,0)=0 
    and Score_EID=(select EID from SkySecUser where ID=@URID))
    Begin
        Set @RetVal=1002080
        Return @RetVal
    End

    -- 互评得分超过上限，无法递交员工互评！
    IF Exists(select 1 from pYear_ScoreEachN where Score_EID=(select EID from SkySecUser where ID=@URID)
    and ((ISNULL(ScoreWorkPerf,0) not between 0 and 50) or (ISNULL(ScoreWorkDiscip,0) not between 0 and 5)
    or (ISNULL(ScoreAmbitious,0) not  between 0 and 5) or (ISNULL(ScoreInitiative,0) not between 0 and 10)
    or (ISNULL(ScoreCommCoord,0) not between 0 and 10) or (ISNULL(ScoreTeamWork,0) not between 0 and 10)
    or (ISNULL(ScoreLearnDev,0) not between 0 and 10)))
    Begin
        Set @RetVal=1002090
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pYear_ScoreEachN --------
    -- 更新员工互评
    update a
    set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    from pYear_ScoreEachN a
    where Score_EID=(select EID from SkySecUser where ID=@URID)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -------- pYear_Score --------
    -- 更新员工考核评分表和递交状态
    -- Score_Status=1时ScoreTotal
    ---- Submit=1
    update a
    set a.ScoreTotal=b.EachNSubAVG,a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    from pYear_Score a,pVW_pYear_ScoreEachSumN b
    where a.EID=b.EID and a.Score_Status=1
    and a.EID in (select EID from pYear_ScoreEachN where Score_EID=(select EID from SkySecUser where ID=@URID))
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -- Score_Status=9时ScoreEach，员工互评分用于最终评分及排名统计使用
    update a
    set a.ScoreEach=b.EachNSubAVG*b.EachNWeight/100
    from pYear_Score a,pVW_pYear_ScoreEachSumN b
    where a.EID=b.EID and a.Score_Status=9
    and a.EID in (select EID from pYear_ScoreEachN where Score_EID=(select EID from SkySecUser where ID=@URID))
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