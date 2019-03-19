-- pVW_pFDAppraiseAssess
-- 评分说明

---- 部门自评和互评
------ 基本职责(50分)
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,b.FDAppraiseType as FDAppraiseType,1 as Status,
b.AppraiseTarget as AppraiseIndex,b.Xorder as xOrder
from oDepartment a,pFDAppraiseInstruc b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,669,353,744,745,737,359,358) and b.FDAppraiseType=4
and ISNULL(b.IsDisabled,0)=0 and a.DepID=b.DepID and ISNULL(b.IsDisabled,0)=0
------ 年度重点(50分)
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
Union
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,b.FDAppraiseType as FDAppraiseType,1 as Status,
b.AppraiseTarget as AppraiseIndex,b.Xorder as xOrder
from oDepartment a,pFDAppraiseInstruc b
where a.DepID in (702,355,356,354,360,350,351,352,669,353,744,745,737,359,358) and a.DepID=b.DepID
and b.FDAppraiseType=5 and ISNULL(b.IsDisabled,0)=0
------ 创新加分(10分)
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
Union
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,b.FDAppraiseType as FDAppraiseType,1 as Status,
b.AppraiseTarget as AppraiseIndex,b.Xorder as xOrder
from oDepartment a,pFDAppraiseInstruc b
where a.DepID in (702,355,356,354,360,350,351,352,669,353,744,745,737,359,358)
and b.FDAppraiseType=7 and ISNULL(b.IsDisabled,0)=0


---- 合规部门评测
------ 基础管理(-20~0分)
UNION
SELECT a.DepID AS DepID, a.Director AS Director, b.Director AS FDAppraiseEID, b.DepID AS FDAppraiseDepID, c.FDAppraiseType AS FDAppraiseType, 2 AS Status, 
c.AppraiseTarget AS AppraiseIndex, c.Xorder AS xOrder
FROM oDepartment a, oDepartment b, pFDAppraiseInstruc c
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
WHERE a.DepID IN (702, 355, 356, 354, 360, 350, 351, 352, 353, 744, 745) 
------ 法律合规部(737)、风险管理部(359)、审计部(358)、纪检监察室(792)
AND b.DepID IN (737, 359, 358, 792) 
AND c.FDAppraiseType = 6 AND c.xOrder = 1

---- 办公室评测
------ 年度重点(50分)
UNION
SELECT DISTINCT a.DepID AS DepID, a.Director AS Director, b.Director AS FDAppraiseEID, b.DepID AS FDAppraiseDepID, c.FDAppraiseType AS FDAppraiseType, 2 AS Status, 
c.AppraiseTarget AS AppraiseIndex, c.Xorder AS xOrder
FROM oDepartment a, oDepartment b,pFDAppraiseInstruc c
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
WHERE a.DepID IN (702, 355, 356, 354, 360, 350, 351, 352, 353, 744, 745, 737, 359, 358) 
-------- 办公室(350)
AND b.DepID=350 and a.DepID=c.DepID
AND c.FDAppraiseType = 5
---- 战略企划部评测
------ 年度重点(50分)
UNION
SELECT DISTINCT a.DepID AS DepID, a.Director AS Director, b.Director AS FDAppraiseEID, b.DepID AS FDAppraiseDepID, c.FDAppraiseType AS FDAppraiseType, 2 AS Status, 
c.AppraiseTarget AS AppraiseIndex, c.Xorder AS xOrder
FROM oDepartment a, oDepartment b, pFDAppraiseInstruc c
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
WHERE a.DepID IN (702, 355, 356, 354, 360, 350, 351, 352, 353, 744, 745, 737, 359, 358) 
-------- 战略企划部(702)
AND b.DepID=702 and a.DepID=c.DepID
AND c.FDAppraiseType = 5


---- 分管领导评测
------ 基本职责(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director2 as FDAppraiseEID,a.DepID as FDAppraiseDepID,b.FDAppraiseType as FDAppraiseType,3 as Status,
b.AppraiseTarget as AppraiseIndex,b.Xorder as xOrder
from oDepartment a,pFDAppraiseInstruc b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,669,353,744,745,737,359,358) and b.FDAppraiseType=4
and ISNULL(b.IsDisabled,0)=0 and a.DepID=b.DepID and ISNULL(b.IsDisabled,0)=0
------ 年度重点(50分)
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
Union
select distinct a.DepID as DepID,a.Director as Director,a.Director2 as FDAppraiseEID,a.DepID as FDAppraiseDepID,b.FDAppraiseType as FDAppraiseType,3 as Status,
b.AppraiseTarget as AppraiseIndex,b.Xorder as xOrder
from oDepartment a,pFDAppraiseInstruc b
where a.DepID in (702,355,356,354,360,350,351,352,669,353,744,745,737,359,358) and a.DepID=b.DepID
and b.FDAppraiseType=5 and ISNULL(b.IsDisabled,0)=0


---- 党委书记评测
------ 年度重点(50分)
------ 党委书记：李桦(5587)
UNION
SELECT DISTINCT a.DepID AS DepID, a.Director AS Director, 5587 AS FDAppraiseEID, b.DepID AS FDAppraiseDepID, c.FDAppraiseType AS FDAppraiseType, 4 AS Status, 
c.AppraiseTarget AS AppraiseIndex, c.Xorder AS xOrder
FROM oDepartment a, oDepartment b, pFDAppraiseInstruc c
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
WHERE a.DepID IN (702, 355, 356, 354, 360, 350, 351, 352, 353, 744, 745, 737, 359, 358) 
-------- 战略企划部(702)
AND b.DepID=349 and a.DepID=c.DepID
AND c.FDAppraiseType = 5
------ 基础管理(-20~0分)
UNION
SELECT a.DepID AS DepID, a.Director AS Director, 5587 AS FDAppraiseEID, b.DepID AS FDAppraiseDepID, c.FDAppraiseType AS FDAppraiseType, 4 AS Status, 
c.AppraiseTarget AS AppraiseIndex, c.Xorder AS xOrder
FROM oDepartment a, oDepartment b, pFDAppraiseInstruc c
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
WHERE a.DepID IN (702, 355, 356, 354, 360, 350, 351, 352, 353, 744, 745) 
------ 法律合规部(737)、风险管理部(359)、审计部(358)、纪检监察室(792)
AND b.DepID=349
AND c.FDAppraiseType = 6 AND c.xOrder = 2