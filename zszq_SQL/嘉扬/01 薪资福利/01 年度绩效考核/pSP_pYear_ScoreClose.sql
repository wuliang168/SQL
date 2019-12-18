USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pYear_ScoreClose]
    @id int,
    @URID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 年度考核关闭
*/
Begin

    -- 本年度未开启，无法执行封账！
    if exists (select 1 from pYear_Process where id=@id and isnull(Submit,0)=0)
    Begin
        Set @RetVal=1001100
        Return @RetVal
    End

    -- 本年度已封帐，无法重复封账！
    if exists (select 1 from pYear_Process where id=@id and isnull(Closed,0)=1)
    Begin
        Set @RetVal=1001100
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pYear_KPI_all --------
    -- 拷贝pYear_KPI到pYear_KPI_all
    insert into pYear_KPI_all (EID,pYear_ID,Xorder,Title,KPI,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)
    select EID,pYear_ID,Xorder,Title,KPI,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,1,@URID,GETDATE()
    from pYear_KPI
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_Summary_all --------
    -- 拷贝pYear_Summary到pYear_Summary_all
    insert into pYear_Summary_all (EID,pYear_ID,Summary,WordsCount,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)
    select EID,pYear_ID,Summary,WordsCount,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,1,@URID,GETDATE()
    from pYear_Summary
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_ScoreEachN_all --------
    -- 拷贝pYear_ScoreEachN到pYear_ScoreEachN_all
    insert into pYear_ScoreEachN_all (EID,pYear_ID,Score_EID,Score_Type1,
    ScoreWorkPerf,ScoreWorkDiscip,ScoreAmbitious,ScoreInitiative,ScoreCommCoord,ScoreTeamWork,ScoreLearnDev,ScoreTotal,Remark,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)
    select EID,pYear_ID,Score_EID,Score_Type1,
    ScoreWorkPerf,ScoreWorkDiscip,ScoreAmbitious,ScoreInitiative,ScoreCommCoord,ScoreTeamWork,ScoreLearnDev,ScoreTotal,Remark,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,1,@URID,GETDATE()
    from pYear_ScoreEachN
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_ScoreEachL_all --------
    -- 拷贝pYear_ScoreEachL到pYear_ScoreEachL_all
    insert into pYear_ScoreEachL_all (EID,pYear_ID,Score_EID,Score_Type1,EachLType,ScorePerfDuty,
    ScoreTeamLead,ScoreTargetExec,ScoreSysThinking,ScoreInnovation,ScoreTraining,ScoreTotal,Modulus,Remark,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)
    select EID,pYear_ID,Score_EID,Score_Type1,EachLType,ScorePerfDuty,
    ScoreTeamLead,ScoreTargetExec,ScoreSysThinking,ScoreInnovation,ScoreTraining,ScoreTotal,Modulus,Remark,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,1,@URID,GETDATE()
    from pYear_ScoreEachL
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_Score_all --------
    -- 拷贝pYear_Score到pYear_Score_all
    insert into pYear_Score_all (EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_EID,Score_DepID,
    Score1,Score2,Score3,Score4,Score5,Score6,Score7,Score8,ScoreTotal,
    ScoreEach,ScoreSTG1,ScoreSTG2,ScoreSTG3,ScoreSTG4,ScoreSTG5,ScoreCompl,ScoreParty,
    Weight1,Weight2,Weight3,Modulus,TotalNum,TotalRankNum,ScoreYear,isRanking,Ranking,RankLevel,Remark,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)
    select EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_EID,Score_DepID,
    Score1,Score2,Score3,Score4,Score5,Score6,Score7,Score8,ScoreTotal,
    ScoreEach,ScoreSTG1,ScoreSTG2,ScoreSTG3,ScoreSTG4,ScoreSTG5,ScoreCompl,ScoreParty,
    Weight1,Weight2,Weight3,Modulus,TotalNum,TotalRankNum,ScoreYear,isRanking,Ranking,RankLevel,Remark,
    Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,1,@URID,GETDATE()
    from pYear_Score
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -------- pYear_Process --------
    -- 更新
    update a
    set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    from pYear_Process a
    where id=@id
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -------- pYear_KPI --------
    -- 删除pYear_KPI
    delete from pYear_KPI where pYear_ID=@ID
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_Summary --------
    -- 删除pYear_Summary
    delete from pYear_Summary where pYear_ID=@ID
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_ScoreEachN --------
    -- 删除pYear_ScoreEachN
    delete from pYear_ScoreEachN where pYear_ID=@ID
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_ScoreEachL --------
    -- 删除pYear_ScoreEachL
    delete from pYear_ScoreEachL where pYear_ID=@ID
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_Score --------
    -- 删除pYear_Score
    delete from pYear_Score where pYear_ID=@ID
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