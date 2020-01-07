-- pVW_pYear_ScoreEachN
/*
4-总部普通员工：
11-子公司普通员工：
33-一级分支机构普通员工：
34-二级分支机构普通员工：
*/

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreEachN]
AS

-- 4-总部普通员工
---- 不包含合规部门
select a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,b.Score_Type1 as ScoreEID_Type1
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=4 and b.Score_Type1 in (4,2) and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
and a.kpidepidyy<>737

-- 11-子公司普通员工
---- 不包含合规部门
UNION
select a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,b.Score_Type1 as ScoreEID_Type1
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=11 and b.Score_Type1=11 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
and a.kpidepidyy not in (666,542)

-- 33-分支机构普通员工
UNION
select a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,b.Score_Type1 as ScoreEID_Type1
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=33 and b.Score_Type1=33 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

GO