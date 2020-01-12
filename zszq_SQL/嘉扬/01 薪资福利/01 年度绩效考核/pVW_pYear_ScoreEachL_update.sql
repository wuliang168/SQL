-- pVW_pYear_ScoreEachL_update

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreEachL_update]
AS

-- 0-公司领导(董事长、党委书记、总裁除外)
select N'公司领导' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,100 as Modulus,010 as EachLType,
N'010-公司领导互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.Score_Type1=3 and b.Score_Type1=3
and a.EID=c.EID and c.status not in (4,5) and b.EID=d.EID and d.status not in (4,5)
and c.EID not in (1022,5587,5014) and d.EID not in (1022,5587,5014) and a.EID<>b.EID

-- 1-总部部门负责人
------ 主要领导 EachLType=110 Modulus=50%
------ 公司董事长(吴承根：1022)、党委书记(李桦：5587)、公司总裁(王青山：5014)
--select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,d.EID as Score_EID,50 as Modulus,110 as EachLType,
--N'110-主要领导测评' as EachLTypeTitle
--from pEmployee_register a,eEmployee d
--where a.Score_Type1=1 and a.pstatus=1
--and d.EID in (1022,5587,5014)
--and a.kpidepidyy<>737
---- 分管领导 EachLType=120 Modulus=30%
UNION
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director2 as Score_EID,20 as Modulus,120 as EachLType,
N'120-分管领导测评' as EachLTypeTitle
from pEmployee_register a,eEmployee c,oDepartment e
where a.kpidepidyy=e.DepID and a.Score_Type1=1 and a.pstatus=1
and a.EID=c.EID and c.Status not in (4,5)
--and a.kpidepidyy<>737
------ 其他领导 EachLType=125 Modulus=10%
------ 副总裁(赵伟江：1026、高玮：1027、程景东：6012)
------ 财务总监(盛建龙：1028)、合规总监(许向军：1033)、董事会秘书(张辉：1425)
--UNION
--select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,d.EID as Score_EID,10 as Modulus,125 as EachLType,
--N'110-公司班子成员测评' as EachLTypeTitle
--from pEmployee_register a,eEmployee d
--where a.Score_Type1=1 and a.pstatus=1
--and d.EID in (1026,1027,6012,1028,1033,1425)
--and a.kpidepidyy<>737
-- 360度评价 总部部门负责人互评 EachLType=130 Modulus=5%
UNION
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,20 as Modulus,130 as EachLType,
N'130-360度评价 部门负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.EID<>b.EID and a.Score_Type1=1 and b.Score_Type1=1 and a.pstatus=1 and b.pstatus=1 and a.kpidepidyy<>737
and a.EID=c.EID and c.status not in (4,5) and b.EID=d.EID and d.status not in (4,5)
-- 360度评价 部门员工测评 EachLType=140 Modulus=5%
UNION
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,140 as EachLType,
N'140-360度评价 部门员工测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=1 and b.Score_Type1 in (2,36,4) and a.pstatus=1 and b.pstatus=1 and a.kpidepidyy<>737
and a.EID=c.EID and c.status not in (4,5) and b.EID=d.EID and d.status not in (4,5)
---- 合规总监测评 EachLType=110 Modulus=100%
---- 合规总监(许向军：1033)
UNION
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,1033 as Score_EID,100 as Modulus,110 as EachLType,
N'110-合规总监测评' as EachLTypeTitle
from pEmployee_register a,eEmployee c
where a.Score_Type1=1 and a.pstatus=1 and a.kpidepidyy=737
and a.EID=c.EID and c.Status not in (4,5)

-- 2-总部部门副职
------ 主要领导 EachLType=205 Modulus=30%
------ 公司董事长(吴承根：1022)、党委书记(李桦：5587)、公司总裁(王青山：5014)
--UNION
--select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,d.EID as Score_EID,30 as Modulus,205 as EachLType,
--N'205-主要领导测评' as EachLTypeTitle
--from pEmployee_register a,eEmployee d
--where a.Score_Type1=2 and a.pstatus=1
--and d.EID in (1022,5587,5014) and a.kpidepidyy<>737
---- 分管领导测评 EachLType=210 Modulus=30%
---- 分管领导非部门负责人
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director2 as Score_EID,20 as Modulus,210 as EachLType,
N'210-分管领导测评' as EachLTypeTitle
from pEmployee_register a,eEmployee d,oDepartment e
where a.kpidepidyy=e.DepID and a.Score_Type1=2 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and a.kpidepidyy<>737
---- 部门负责人测评 EachLType=220 Modulus=30%
--UNION
--select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director as Score_EID,30 as Modulus,220 as EachLType,
--N'220-部门负责人测评' as EachLTypeTitle
--from pEmployee_register a,eEmployee d,oDepartment e
--where a.kpidepidyy=e.DepID and a.Score_Type1=2 and a.pstatus=1
--and a.EID=d.EID and d.Status not in (4,5) and a.kpidepidyy<>737
-- 360度评价 总部部门副职互评 EachLType=230 Modulus=0%
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,20 as Modulus,230 as EachLType,
N'230-360度评价 总部部门副职互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.EID<>b.EID and a.Score_Type1=2 and b.Score_Type1=2 and a.pstatus=1 and b.pstatus=1 and a.kpidepidyy<>737 and b.kpidepidyy<>737
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
-- 360度评价 部门员工测评 EachLType=240 Modulus=10%
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,240 as EachLType,
N'240-360度评价 部门员工测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=2 and b.Score_Type1 in (36,4) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5) and a.kpidepidyy<>737
---- 合规总监测评 EachLType=210 Modulus=100%
---- 合规总监(许向军：1033)
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,1033 as Score_EID,100 as Modulus,210 as EachLType,
N'210-合规总监测评' as EachLTypeTitle
from pEmployee_register a,eEmployee c
where a.Score_Type1=2 and a.pstatus=1 and a.kpidepidyy=737
and a.EID=c.EID and c.Status not in (4,5)

-- 31-一级分支机构负责人
---- 主要领导测评 EachLType=310 Modulus=50%
------ 公司董事长(吴承根：1022)、党委书记(李桦：5587)、公司总裁(王青山：5014)
--UNION
--select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director2 as Score_EID,50 as Modulus,310 as EachLType,
--N'310-主要领导测评' as EachLTypeTitle
--from pEmployee_register a,eEmployee d,oDepartment e
--where a.kpidepidyy=e.DepID and a.Score_Type1=31 and a.pstatus=1
--and a.EID=d.EID and d.EID in (1022,5587,5014)
---- 分管领导评测 EachLType=320 Modulus=30%
---- 分管领导非公司班子成员
UNION
select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director2 as Score_EID,20 as Modulus,320 as EachLType,
N'320-分管领导评测' as EachLTypeTitle
from pEmployee_register a,eEmployee c,oDepartment e
where a.kpidepidyy=e.DepID and a.Score_Type1=31 and a.pstatus=1
and a.EID=c.EID and c.Status not in (4,5)
-- 360度评价 一级分支机构负责人互评 EachLType=330 Modulus=10%
--UNION
--select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,330 as EachLType,
--N'330-360度评价 一级分支机构负责人互评' as EachLTypeTitle
--from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
--where a.EID<>b.EID and a.Score_Type1=31 and b.Score_Type1=31 and a.pstatus=1 and b.pstatus=1
--and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
---- 专业管理部门评测 EachLType=335 Modulus=20%
------ 专业管理部门(财富管理事业部、网点运营管理总部、信用业务部、衍生品经纪业务总部、风险管理部、人力资源部、计划财务部)
UNION
select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director as Score_EID,20 as Modulus,335 as EachLType,
N'430-专业管理部门评测' as EachLTypeTitle
from pEmployee_register a,eEmployee d,oDepartment e
where a.Score_Type1=31 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
and e.DepID in (811,362,381,382,359,354,355)
-- 360度评价 一级分支机构下属员工评测 EachLType=340 Modulus=10%
UNION
select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,340 as EachLType,
N'340-360度评价 分支机构员工评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy) = dbo.eFN_getdepid1(b.kpidepidyy) and a.Score_Type1=31 and b.Score_Type1 in (32,33) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 32-一级分支机构副职及二级分支机构经理室成员
---- 主要领导测评 EachLType=405 Modulus=50%
------ 公司董事长(吴承根：1022)、党委书记(李桦：5587)、公司总裁(王青山：5014)
--UNION
--select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director2 as Score_EID,50 as Modulus,310 as EachLType,
--N'405-主要领导测评' as EachLTypeTitle
--from pEmployee_register a,eEmployee d,oDepartment e
--where a.kpidepidyy=e.DepID and a.Score_Type1=32 and a.pstatus=1
--and a.EID=d.EID and d.EID in (1022,5587,5014)
---- 分管领导评测 EachLType=410 Modulus=30%
UNION
select N'一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director2 as Score_EID,20 as Modulus,410 as EachLType,
N'410-分管领导评测' as EachLTypeTitle
from pEmployee_register a,eEmployee d,oDepartment e
where dbo.eFN_getdepid1(a.kpidepidyy)=e.DepID and a.Score_Type1=32 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
---- 一级分支机构负责人评测 EachLType=420 Modulus=50%
--UNION
--select N'一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director as Score_EID,50 as Modulus,420 as EachLType,
--N'420-一级分支机构负责人评测' as EachLTypeTitle
--from pEmployee_register a,eEmployee d,oDepartment e
--where dbo.eFN_getdepid1(a.kpidepidyy)=e.DepID and a.Score_Type1=32 and a.pstatus=1
--and a.EID=d.EID and d.Status not in (4,5)
---- 专业管理部门评测 EachLType=430 Modulus=20%
------ 专业管理部门(财富管理事业部、网点运营管理总部、信用业务部、衍生品经纪业务总部、风险管理部、人力资源部、计划财务部)
UNION
select N'一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director as Score_EID,20 as Modulus,430 as EachLType,
N'430-专业管理部门评测' as EachLTypeTitle
from pEmployee_register a,eEmployee d,oDepartment e
where a.Score_Type1=32 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
and e.DepID in (811,362,381,382,359,354,355)
-- 360度评价 部门员工评测 EachLType=440 Modulus=20%
UNION
select N'一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,440 as EachLType,
N'440-360度评价 分支机构员工评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where (a.kpidepidyy = b.kpidepidyy or a.kpidepidyy = dbo.eFN_getdepid1(b.kpidepidyy)) and a.Score_Type1=32 and b.Score_Type1=33 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 10-子公司部门行政负责人
-- 子公司部门负责人 子公司总经理测评 EachLType=610 Modulus=40%
---- 资管子公司总经理(盛建龙：1028)
UNION
select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,1028 as Score_EID,40 as Modulus,610 as EachLType,
N'610-子公司总经理评价' as EachLTypeTitle
from pEmployee_register a,eEmployee d,oDepartment e
where a.kpidepidyy=e.DepID and a.Score_Type1=10 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and e.CompID=13
-- 子公司部门负责人 子公司分管领导测评 EachLType=620 Modulus=20%
UNION
select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director2 as Score_EID,20 as Modulus,620 as EachLType,
N'620-子公司分管领导评价' as EachLTypeTitle
from pEmployee_register a,eEmployee d,oDepartment e
where a.kpidepidyy=e.DepID and a.Score_Type1=10 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and e.CompID=13 and e.Director2 is not NULL
-- 子公司部门负责人 子公司部门负责人互评 EachLType=630 Modulus=20%
UNION
select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,20 as Modulus,630 as EachLType,
N'630-子公司部门负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d,oDepartment e,oDepartment f
where a.EID<>b.EID and a.Score_Type1=10 and b.Score_Type1=10 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
and a.kpidepidyy=e.DepID and e.CompID=13 and b.kpidepidyy=f.DepID and f.CompID=13
-- 子公司部门负责人 子公司部门员工评价 EachLType=640 Modulus=20%
UNION
select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,20 as Modulus,640 as EachLType,
N'640-子公司部门员工评价' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d,oDepartment e,oDepartment f
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=10 and b.Score_Type1 in (11,30) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
and a.kpidepidyy=e.DepID and e.CompID=13 and b.kpidepidyy=f.DepID and f.CompID=13

-- 30-子公司部门副职
-- 子公司部门副职 子公司分管领导测评 EachLType=710 Modulus=40%
UNION
select N'子公司部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director2 as Score_EID,40 as Modulus,710 as EachLType,
N'710-子公司分管领导测评' as EachLTypeTitle
from pEmployee_register a,eEmployee d,oDepartment e
where a.kpidepidyy=e.DepID and a.Score_Type1=30 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and e.CompID=13 and e.Director2 is not NULL
-- 子公司部门副职 子公司部门负责人测评 EachLType=720 Modulus=30%
UNION
select N'子公司部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,e.Director as Score_EID,30 as Modulus,720 as EachLType,
N'720-子公司部门负责人测评' as EachLTypeTitle
from pEmployee_register a,eEmployee d,oDepartment e
where a.kpidepidyy=e.DepID and a.Score_Type1=30 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and e.CompID=13 and e.Director2 is not NULL
-- 子公司部门副职 子公司部门员工测评 EachLType=730 Modulus=30%
UNION
select N'子公司部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,30 as Modulus,730 as EachLType,
N'730-子公司部门员工测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d,oDepartment e,oDepartment f
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=30 and b.Score_Type1=11 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
and a.kpidepidyy=e.DepID and e.CompID=13 and b.kpidepidyy=f.DepID and f.CompID=13

GO