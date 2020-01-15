-- pVW_pFDAppraise
-- 职能部门具体考核

/* 
    总分=（效率指标*85%+服务支持*15%）*质量系数
    1.  效率指标：基本职责(50分)、重点工作(30分)、基础管理(20分)
    2.  质量系数：达标要求(20%)、工作规划(20%)、安全管理(40%)、党风廉政(20%)
    3.  服务支持：服务意思(100分*30%)、专业技能(100分*30%)、工作效率(100分*40%)
*/

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pFDAppraise]
AS

-- 部门负责人自评
---- 1.     效率指标
---- 1.1    基本职责(50分)
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,8 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 1.2    重点工作(30分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,9 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 1.3    基础管理
---- 1.3.1  成本管控(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,10 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 1.3.2  团队管理(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,17 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 1.3.3  内部协同(10分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,18 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 2.     质量系数
---- 2.1    达标要求(20%)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,11 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 2.2    工作规划(20%)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,12 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 2.3    安全管理(40%)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,13 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 2.4    党风廉政(20%)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,14 as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 3.     服务支持(15分)
---- 3.1    服务意思(30%)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,3 as FDAppraiseType,1 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745)
and b.DepID in (702,355,356,354,360,350,351,352,669,353,744,745,737,359,358)
and a.Director<>b.Director
---- 3.2    专业技能(30%)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,15 as FDAppraiseType,1 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745)
and b.DepID in (702,355,356,354,360,350,351,352,669,353,744,745,737,359,358)
and a.Director<>b.Director
---- 3.3    工作效率(40%)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,16 as FDAppraiseType,1 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745)
and b.DepID in (702,355,356,354,360,350,351,352,669,353,744,745,737,359,358)
and a.Director<>b.Director

-- 业务部门负责人评测
---- 3.     服务支持(15分)
---- 3.1    服务意思(30%)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,3 as FDAppraiseType,2 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745)
-------- 浙商证券研究所(361)、网点运营管理总部(362)、财富管理中心（事业部）(715)、投资银行(695->683)、投资银行质量控制总部(670)、投资银行内核办公室(786)
-------- 证券投资部(380)、融资融券部(381)、衍生品经纪业务总部(382)、FICC事业部(383)、金融衍生品部(394)、经纪业务总部(738)、托管业务部(789)
-------- 浙商资管(393->544)、浙商资本(392)
and b.DepID in (361,362,715,683,670,786,380,381,382,383,394,738,789,544,392)
and a.Director<>b.Director
---- 3.2    专业技能(30%)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,15 as FDAppraiseType,2 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)、浙商证券研究所(361)、网点运营管理总部(362)、财富管理中心（事业部）(715)、投资银行(695->683)、投资银行质量控制总部(670)、投资银行内核办公室(786)
-------- 证券投资部(380)、融资融券部(381)、衍生品经纪业务总部(382)、FICC事业部(383)、金融衍生品部(394)、经纪业务总部(738)、托管业务部(789)
-------- 浙商资管(393->544)、浙商资本(392)
and b.DepID in (737,359,358,361,362,715,683,670,786,380,381,382,383,394,738,789,544,392)
and a.Director<>b.Director
---- 3.3    工作效率(40%)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,16 as FDAppraiseType,2 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)、浙商证券研究所(361)、网点运营管理总部(362)、财富管理中心（事业部）(715)、投资银行(695->683)、投资银行质量控制总部(670)、投资银行内核办公室(786)
-------- 证券投资部(380)、融资融券部(381)、衍生品经纪业务总部(382)、FICC事业部(383)、金融衍生品部(394)、经纪业务总部(738)、托管业务部(789)
-------- 浙商资管(393->544)、浙商资本(392)
and b.DepID in (737,359,358,361,362,715,683,670,786,380,381,382,383,394,738,789,544,392)
and a.Director<>b.Director

------ 其他部门评测
-------- 效率指标：基础管理：成本管控     计划财务部(355)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,10 as FDAppraiseType,3 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
and b.DepID in (355)
--and a.Director<>b.Director
------ 质量系数：安全管理               法律合规部(737)、风险管理部(359)、审计部(358)、<行政管理总部(352)>、<信息技术运保部(744)>
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,13 as FDAppraiseType,3 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
and b.DepID in (737,359,358)
--,352,744)
--and a.Director<>b.Director
------ 质量系数：党风廉政               党群部(353)、纪检监察室(792)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.Director as FDAppraiseEID,b.DepID as FDAppraiseDepID,14 as FDAppraiseType,3 as Status
from oDepartment a,oDepartment b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
and b.DepID in (353,792)
--and a.Director<>b.Director


-------- 部门分管领导评测
---- 1.     效率指标
---- 1.1    基本职责(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director2 as FDAppraiseEID,a.DepID as FDAppraiseDepID,8 as FDAppraiseType,4 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 1.2    重点工作(30分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director2 as FDAppraiseEID,a.DepID as FDAppraiseDepID,9 as FDAppraiseType,4 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 1.3    基础管理
---- 1.3.1  成本管控(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director2 as FDAppraiseEID,a.DepID as FDAppraiseDepID,10 as FDAppraiseType,4 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 1.3.2  团队管理(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director2 as FDAppraiseEID,a.DepID as FDAppraiseDepID,17 as FDAppraiseType,4 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)
---- 1.3.3  内部协同(10分)
UNION
select distinct a.DepID as DepID,a.Director as Director,a.Director2 as FDAppraiseEID,a.DepID as FDAppraiseDepID,18 as FDAppraiseType,4 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)


-------- 班子成员评测
---- 1.     效率指标
---- 1.1    基本职责(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.EID as FDAppraiseEID,a.DepID as FDAppraiseDepID,8 as FDAppraiseType,6 as Status
from oDepartment a,eEmployee b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
and b.EID in (1026,1027,1028,6012,1033,1317) and b.EID<>a.Director2
---- 1.2    重点工作(30分)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.EID as FDAppraiseEID,a.DepID as FDAppraiseDepID,9 as FDAppraiseType,6 as Status
from oDepartment a,eEmployee b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
and b.EID in (1026,1027,1028,6012,1033,1317) and b.EID<>a.Director2
---- 1.3    基础管理
---- 1.3.1  成本管控(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.EID as FDAppraiseEID,a.DepID as FDAppraiseDepID,10 as FDAppraiseType,6 as Status
from oDepartment a,eEmployee b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
and b.EID in (1026,1027,1028,6012,1033,1317) and b.EID<>a.Director2
---- 1.3.2  团队管理(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.EID as FDAppraiseEID,a.DepID as FDAppraiseDepID,17 as FDAppraiseType,6 as Status
from oDepartment a,eEmployee b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
and b.EID in (1026,1027,1028,6012,1033,1317) and b.EID<>a.Director2
---- 1.3.3  内部协同(10分)
UNION
select distinct a.DepID as DepID,a.Director as Director,b.EID as FDAppraiseEID,a.DepID as FDAppraiseDepID,18 as FDAppraiseType,6 as Status
from oDepartment a,eEmployee b
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
and b.EID in (1026,1027,1028,6012,1033,1317) and b.EID<>a.Director2


-------- 党委书记(5587)
---- 1.     效率指标
---- 1.1    基本职责(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5587 as FDAppraiseEID,a.DepID as FDAppraiseDepID,8 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
---- 1.2    重点工作(30分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5587 as FDAppraiseEID,a.DepID as FDAppraiseDepID,9 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
---- 1.3    基础管理
---- 1.3.1  成本管控(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5587 as FDAppraiseEID,a.DepID as FDAppraiseDepID,10 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
---- 1.3.2  团队管理(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5587 as FDAppraiseEID,a.DepID as FDAppraiseDepID,17 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
---- 1.3.3  内部协同(10分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5587 as FDAppraiseEID,a.DepID as FDAppraiseDepID,18 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)


-------- 总裁(5014)
---- 1.     效率指标
---- 1.1    基本职责(50分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5014 as FDAppraiseEID,a.DepID as FDAppraiseDepID,8 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
---- 1.2    重点工作(30分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5014 as FDAppraiseEID,a.DepID as FDAppraiseDepID,9 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
---- 1.3    基础管理
---- 1.3.1  成本管控(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5014 as FDAppraiseEID,a.DepID as FDAppraiseDepID,10 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
---- 1.3.2  团队管理(5分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5014 as FDAppraiseEID,a.DepID as FDAppraiseDepID,17 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
---- 1.3.3  内部协同(10分)
UNION
select distinct a.DepID as DepID,a.Director as Director,5014 as FDAppraiseEID,a.DepID as FDAppraiseDepID,18 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)


-------- 董事长(1022)
---- 1.     效率指标
---- 1.1    基本职责(50分)
--UNION
--select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,a.DepID as FDAppraiseDepID,14 as FDAppraiseType,5 as Status
--from oDepartment a
---------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
---------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
---------- 风险管理部(359)、审计部(358)
--where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
------ 1.2    重点工作(30分)
--UNION
--select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,a.DepID as FDAppraiseDepID,9 as FDAppraiseType,5 as Status
--from oDepartment a
---------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
---------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
---------- 风险管理部(359)、审计部(358)
--where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
------ 1.3    基础管理
------ 1.3.1  成本管控(5分)
--UNION
--select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,a.DepID as FDAppraiseDepID,10 as FDAppraiseType,5 as Status
--from oDepartment a
---------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
---------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
---------- 风险管理部(359)、审计部(358)
--where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
------ 1.3.2  团队管理(5分)
--UNION
--select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,a.DepID as FDAppraiseDepID,17 as FDAppraiseType,5 as Status
--from oDepartment a
---------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
---------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
---------- 风险管理部(359)、审计部(358)
--where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
------ 1.3.3  内部协同(10分)
--UNION
--select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,a.DepID as FDAppraiseDepID,18 as FDAppraiseType,5 as Status
--from oDepartment a
---------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
---------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
---------- 风险管理部(359)、审计部(358)
--where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)
UNION
select distinct a.DepID as DepID,a.Director as Director,1022 as FDAppraiseEID,a.DepID as FDAppraiseDepID,21 as FDAppraiseType,5 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,359,358)

Go