-- Attence_LLMMDep

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[Attence_LLMMDep]
AS

select distinct b.LLMonth as LLMonth,a.Dep1st as Dep1st,a.ReportToDaily as ReportToDaily
from PVW_EMPREPORTTODAILY a,ATTENCE_LLMONTHLY b
where a.EID in 
(select EID from ATTENCE_LLMONTHLY where Dep1st not in (349,392,393,780) and dbo.eFN_getdeptype(Dep1st) in (1,4)
and Dep1st not in (383,394) and COMPID=11 and (ABNORMWORKDAYS<>0 or LATEWORKDAYS<>0 or EARLYWORKDAYS<>0)) and b.WorkCity=45
and a.EID=b.EID

Go