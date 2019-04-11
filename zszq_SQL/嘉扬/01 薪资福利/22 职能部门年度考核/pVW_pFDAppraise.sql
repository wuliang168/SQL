-- pVW_pFDAppraise
-- 职能部门具体考核

---- 部门负责人自评
------ 基本职责(50分)
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,4 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
------ 年度重点(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,5 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
------ 创新加分(10分) 7
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,7 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
------ 服务支持(15分) 3
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,3 as FDAppraiseType,1 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)、浙商证券研究所(361)、网点运营管理总部(362)、财富管理中心（事业部）(715)、投资银行(695->683)、投资银行质量控制总部(670)、投资银行内核办公室(786)
-------- 证券投资部(380)、融资融券部(381)、衍生品经纪业务总部(382)、FICC事业部(383)、金融衍生品部(394)、经纪业务总部(738)、托管业务部(789)
-------- 浙商资管(393->544)、浙商资本(392)
and b.DepID in (737,359,358,361,362,715,683,670,786,380,381,382,383,394,738,789,702,355,356,354,360,350,351,352,669,353,744,745,544,392)
and a.Director<>b.Director


------ 投行质控内核(100分) 3 80%
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,3 as FDAppraiseType,12 as Status
from oDepartment a,oDepartment b
-------- 投资银行质量控制总部(670)、投资银行内核办公室(786)
where a.DepID in (670,786)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)、投行管理总部(683)、投资银行质量控制总部(670)、投资银行内核办公室(786)
and b.DepID in (737,359,358,683,670,786)
and a.Director<>b.Director
------ 投行质控内核(100分) 3 20%
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,3 as FDAppraiseType,11 as Status
from oDepartment a,oDepartment b
-------- 投资银行质量控制总部(670)、投资银行内核办公室(786)
where a.DepID in (670,786)
-------- 投行各部门(投行管理总部(683)、投资银行质量控制总部(670)、投资银行内核办公室(786)以外)
and b.DepID in (select DepID from oDepartment where AdminID=695 and xOrder<>9999999999999 and DepID not in (683,670,786) and Director is not NULL)
and a.Director<>b.Director


------ 合规纪检部门评测
---- 基础管理(-20~0分)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,6 as FDAppraiseType,2 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)、纪检监察室(792)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745) 
and b.DepID in (737,359,358,792)


------ 办公室评测
---- 年度重点(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,5 as FDAppraiseType,2 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358) 
and b.DepID in (350)


------ 战略企划部评测
---- 年度重点(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,5 as FDAppraiseType,2 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,359,358) 
and b.DepID in (702)
------ 创新加分(10分)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,7 as FDAppraiseType,2 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,359,358) 
and b.DepID in (702)


------ 部门分管领导评测
---- 基本职责(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,ISNULL(a.Director2,(select Director2 from oDepartment where DepID=a.AdminID)) as FDAppraiseEID,
349 as FDAppraiseDepID,4 as FDAppraiseType,3 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
------ 年度重点(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,ISNULL(a.Director2,(select Director2 from oDepartment where DepID=a.AdminID)) as FDAppraiseEID,
349 as FDAppraiseDepID,5 as FDAppraiseType,3 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)


------ 党委书记(5587)
---- 年度重点(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5587 as FDAppraiseEID,349 as FDAppraiseDepID,5 as FDAppraiseType,4 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
---- 基础管理(-20~0分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5587 as FDAppraiseEID,349 as FDAppraiseDepID,6 as FDAppraiseType,4 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745)


------ 总裁(5014)
---- 基本职责(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5014 as FDAppraiseEID,349 as FDAppraiseDepID,4 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
---- 年度重点(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5014 as FDAppraiseEID,349 as FDAppraiseDepID,5 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
------ 创新加分(10分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5014 as FDAppraiseEID,349 as FDAppraiseDepID,7 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
------ 服务支持(15分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5014 as FDAppraiseEID,349 as FDAppraiseDepID,3 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)


------ 董事长(1022)
---- 基本职责(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,349 as FDAppraiseDepID,4 as FDAppraiseType,6 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
---- 年度重点(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,349 as FDAppraiseDepID,5 as FDAppraiseType,6 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
------ 创新加分(10分)
UNION
select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,349 as FDAppraiseDepID,7 as FDAppraiseType,6 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)
------ 服务支持(15分)
UNION
select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,349 as FDAppraiseDepID,3 as FDAppraiseType,6 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)