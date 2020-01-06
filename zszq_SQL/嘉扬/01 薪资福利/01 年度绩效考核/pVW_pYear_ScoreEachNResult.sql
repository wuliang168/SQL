-- pVW_pYear_ScoreEachNResult

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreEachNResult]
AS

select DISTINCT pYear_ID,Score_EID,Score_Type1,Submit 
from PYEAR_SCOREEACHN

Go