-- pSP_pYear_ScoreYearCalc

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  proc [dbo].[pSP_pYear_ScoreYearCalc]
    @RetVal int=0 output
as
/*
-- Create By wuliang E004205
-- 年度考核评分计算
*/
begin


    BEGIN TRANSACTION

    -------- pYear_Score --------
    update a
    set a.ScoreYear=b.ScoreYear
    from pYear_Score a,(select EID,SUM(ScoreTotal) as ScoreYear from pVW_pYear_ScoreSum_update group by EID) b
    where a.EID=b.EID and a.Score_Status=99
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -- 正常处理流程
    COMMIT TRANSACTION
    Set @Retval = 0
    Return @Retval

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval

end