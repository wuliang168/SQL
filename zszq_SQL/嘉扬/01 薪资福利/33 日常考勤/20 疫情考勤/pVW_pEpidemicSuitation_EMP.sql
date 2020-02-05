-- pVW_pEpidemicSuitation_EMP

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pEpidemicSuitation_EMP]
AS

select a.EID as EID,a.BID as BID,a.Name as Name,a.CompID as CompID,a.DepID as DepID,
a.DepID1st as DepID1st,a.DepID2nd as DepID2nd,a.ESDate as ESDate
from pEpidemicSuitation a
where ESDate is not NULL

Go