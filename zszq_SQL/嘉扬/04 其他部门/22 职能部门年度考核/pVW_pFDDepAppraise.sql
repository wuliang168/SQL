-- pVW_pFDDepAppraise

-- 职能部门部门考核
---- 部门负责人考核阶段：1
---- 计划财务部考核阶段：2
---- 法律合规部、风险管理部、审计部、行政管理部、信息技术事业部考核阶段：2
---- 党群部、纪检监察室考核阶段：2
---- 分管领导考核阶段：3
---- 党委班子考核阶段：3
---- 党委书记考核阶段：4
---- 总裁考核阶段：5
---- 董事长确认阶段：6


---- 部门负责人考评
select distinct a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,NULL as FDAppraiseType,1 as Status
from oDepartment a
-------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
-------- 行政管理总部(352)、党群部(353)、纪检监察室(792)、信息技术运保部(744)、信息技术开发部(745)
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
where a.DepID in (702,355,356,354,360,350,351,352,353,792,744,745,737,359,358)


---- 业务部门负责人考评
------ 服务支持
UNION
select distinct a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,NULL as FDAppraiseType,2 as Status
from oDepartment a
-------- 浙商证券研究所(361)、网点运营管理总部(362)、财富管理中心（事业部）(715)、投资银行(695->683)、托管业务部(789)、投资银行内核办公室(786)
-------- 证券投资部(380)、融资融券部(381)、衍生品经纪业务总部(382)、FICC事业部(383)、金融衍生品部(394)、经纪业务总部(738)、浙商资管(393->544)、浙商资本(392)
where a.DepID in (361,362,715,683,670,789,786,380,381,382,383,394,738,544,392)


------ 其他部门评测
-------- 效率指标：基础管理：成本管控     计划财务部(355)
UNION
select distinct a.Director as FDAppraiseEID,a.DepID as FDAppraiseDepID,10 as FDAppraiseType,3 as Status
from oDepartment a
where a.DepID in (737,359,358,792)
------ 质量系数：安全管理               法律合规部(737)、风险管理部(359)、审计部(358)、行政管理总部(352)、信息技术运保部(744)
UNION
select distinct a.Director as FDAppraiseEID,NULL as FDAppraiseDepID,13 as FDAppraiseType,3 as Status
from oDepartment a
where a.DepID in (350)
------ 质量系数：党风廉政               党群部(353)、纪检监察室(792)
UNION
select distinct a.Director as FDAppraiseEID,NULL as FDAppraiseDepID,14 as FDAppraiseType,3 as Status
from oDepartment a
where a.DepID in (702)


------ 部门分管领导评测
--UNION
--select distinct a.Director2 as FDAppraiseEID,(select DepID from eEmployee where EID=a.Director2) as FDAppraiseDepID,4 as FDAppraiseType,3 as Status
--from oDepartment a
---------- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
---------- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
---------- 法律合规部(737)、风险管理部(359)、审计部(358)
--where a.DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358)


------ 党委书记考评(5587)
--UNION
--select distinct 5587 as FDAppraiseEID,349 as FDAppraiseDepID,NULL as FDAppraiseType,4 as Status
--from oDepartment a

------ 总裁考评(5014)
--UNION
--select distinct 5014 as FDAppraiseEID,349 as FDAppraiseDepID,NULL as FDAppraiseType,5 as Status
--from oDepartment a

------ 董事长考评(1022)
--UNION
--select distinct 1022 as FDAppraiseEID,349 as FDAppraiseDepID,NULL as FDAppraiseType,6 as Status
--from oDepartment a