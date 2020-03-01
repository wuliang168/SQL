-- pVW_pEpidemicSuitation_Report

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pEpidemicSuitation_Report]
AS

---- 公司总部
select ESDATE,N'公司总部' as Dep,ISNULL(SUM(DepCount),0) as DepSum,1 as xorder
from pVW_pEpidemicSuitation_Dep
where dbo.eFN_getdeptype(DepID)=1
group by ESDATE
---- 分支机构
UNION
select ESDATE,N'分支机构' as Dep,ISNULL(SUM(DepCount),0) as DepSum,2 as xorder
from pVW_pEpidemicSuitation_Dep
where dbo.eFN_getdeptype(DepID) in (2,3)
group by ESDATE
---- 浙商资本
UNION
select ESDATE,N'浙商资本' as Dep,ISNULL(SUM(DepCount),0) as DepSum,3 as xorder
from pVW_pEpidemicSuitation_Dep
where CompID=12
group by ESDATE
---- 浙商投资
UNION
select ESDATE,N'浙商投资' as Dep,ISNULL(SUM(DepCount),0) as DepSum,4 as xorder
from pVW_pEpidemicSuitation_Dep
where CompID=20
group by ESDATE
---- 浙商资管
UNION
select ESDATE,N'浙商资管' as Dep,ISNULL(SUM(DepCount),0) as DepSum,5 as xorder
from pVW_pEpidemicSuitation_Dep
where CompID=13
group by ESDATE


Go