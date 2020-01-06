-- pVW_pYear_DepScoreEachN

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_DepScoreEachN]
AS

select pYear_ID as pYear_ID,Score_DepID as Score_DepID,COUNT(Score_DepID) as TotalNum,COUNT(Submit) as TotalScoreEachNNum
from pYear_Score
where Score_Status=1 and Score_Type1 in (4,11,33)
group by pYear_ID,Score_DepID

GO