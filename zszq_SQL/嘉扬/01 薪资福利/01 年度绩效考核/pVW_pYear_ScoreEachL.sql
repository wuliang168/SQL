-- pVW_pYear_ScoreEachL

/*
存在考核类型重复的现象。例如，分管领导可能是部门负责人，或者分管领导是主要领导的现象。
本视图不考虑重叠现象，在以下方式中处理
待办事项(取EachLtype最小的进行考核评分)
确认递交(针对相同类型考核的人，如果存在多个相同考核人，不同EachLType的话，将其中一个打分拷贝到另一个为NULL的项中)

1-总部部门负责人：      履职情况胜任素质测评(公司班子成员30%、分管领导50%、360度评价20%(部门负责人互评10%、下属员工10%))
2-总部部门副职：        履职情况胜任素质测评(分管领导30%、部门负责人50%、360度评价20%(下属员工20%))
36-总部部门助理：        履职情况胜任素质测评(分管领导30%、部门负责人50%、360度评价20%(下属员工20%))
31-一级分支机构负责人：  履职情况胜任素质测评(公司班子领导30%、分管领导50%、360度评价20%(一级分支机构互评10%、分支机构员工10%))
32-一级分支机构副职及二级分支机构经理室成员：   履职情况胜任素质测评(分管领导30%、一级分支机构负责人50%、360度评价20%(下属员工20%))
*/

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreEachL]
AS
-- 1-总部部门负责人
---- 主要领导 EachLType=110 Modulus=50%
---- 公司董事长(吴承根：1022)、党委书记(李桦：5587)、公司总裁(王青山：5014)
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,d.EID as Score_EID,50 as Modulus,110 as EachLType,
N'110-主要领导测评' as EachLTypeTitle
from pEmployee_register a,eEmployee d
where a.Score_Type1=1 and a.pstatus=1
and d.EID in (1022,5587,5014)
and a.kpidepidyy<>737
---- 分管领导 EachLType=120 Modulus=30%
UNION
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,30 as Modulus,120 as EachLType,
N'120-分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c
where a.kpidepidyy=c.DepID and a.Score_Type1=1 and a.pstatus=1
and a.kpidepidyy<>737
---- 其他领导 EachLType=125 Modulus=10%
---- 副总裁(赵伟江：1026、高玮：1027、程景东：6012)
---- 财务总监(盛建龙：1028)、合规总监(许向军：1033)、董事会秘书(张辉：1425)
UNION
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,d.EID as Score_EID,10 as Modulus,125 as EachLType,
N'110-公司班子成员测评' as EachLTypeTitle
from pEmployee_register a,eEmployee d
where a.Score_Type1=1 and a.pstatus=1
and d.EID in (1026,1027,6012,1028,1033,1425)
and a.kpidepidyy<>737
-- 360度评价 总部部门负责人互评 EachLType=130 Modulus=5%
UNION
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,5 as Modulus,130 as EachLType,
N'130-360度评价 部门负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b
where a.EID<>b.EID and a.Score_Type1=1 and b.Score_Type1=1 and a.pstatus=1 and b.pstatus=1 and a.kpidepidyy<>737
-- 360度评价 部门员工测评 EachLType=140 Modulus=5%
UNION
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,5 as Modulus,140 as EachLType,
N'140-360度评价 部门员工测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=1 and b.Score_Type1 in (2,36,4) and a.pstatus=1 and b.pstatus=1 and a.kpidepidyy<>737
---- 合规总监测评 EachLType=110 Modulus=100%
---- 合规总监(许向军：1033)
UNION
select N'总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,d.EID as Score_EID,100 as Modulus,110 as EachLType,
N'110-公司班子成员测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.Score_Type1=1 and a.pstatus=1
and d.EID=1033
and a.kpidepidyy=c.DepID and a.kpidepidyy=737

-- 2-总部部门副职
---- 主要领导 EachLType=205 Modulus=30%
---- 公司董事长(吴承根：1022)、党委书记(李桦：5587)、公司总裁(王青山：5014)
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,d.EID as Score_EID,30 as Modulus,205 as EachLType,
N'205-主要领导测评' as EachLTypeTitle
from pEmployee_register a,eEmployee d
where a.Score_Type1=2 and a.pstatus=1
and d.EID in (1022,5587,5014) and a.kpidepidyy<>737
---- 分管领导测评 EachLType=210 Modulus=30%
---- 分管领导非部门负责人
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,30 as Modulus,210 as EachLType,
N'210-分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=2 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and a.kpidepidyy<>737
---- 部门负责人测评 EachLType=220 Modulus=30%
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director as Score_EID,30 as Modulus,220 as EachLType,
N'220-部门负责人测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=2 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and a.kpidepidyy<>737
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
select N'总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,100 as Modulus,210 as EachLType,
N'210-分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=2 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and a.kpidepidyy=737

-- 36-总部部门助理
---- 分管领导测评 EachLType=215 Modulus=30%
---- 分管领导非部门负责人
UNION
select N'总部部门助理' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,30 as Modulus,215 as EachLType,
N'215-分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=36 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and a.kpidepidyy<>737
---- 部门负责人测评 EachLType=225 Modulus=50%
UNION
select N'总部部门助理' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director as Score_EID,50 as Modulus,225 as EachLType,
N'225-部门负责人测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=36 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and a.kpidepidyy<>737
-- 360度评价 部门员工测评 EachLType=245 Modulus=20%
UNION
select N'总部部门助理' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,20 as Modulus,245 as EachLType,
N'245-360度评价 部门员工测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=36 and b.Score_Type1 in (2,4) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5) and a.kpidepidyy<>737
---- 合规总监测评 EachLType=215 Modulus=100%
---- 合规总监(许向军：1033)
UNION
select N'总部部门助理' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,100 as Modulus,215 as EachLType,
N'215-分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=36 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5) and a.kpidepidyy=737

-- 31-一级分支机构负责人
-- 主要领导测评 EachLType=310 Modulus=50%
---- 公司董事长(吴承根：1022)、党委书记(李桦：5587)、公司总裁(王青山：5014)
UNION
select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,50 as Modulus,310 as EachLType,
N'310-主要领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=31 and a.pstatus=1
and a.EID=d.EID and d.EID in (1022,5587,5014)
---- 分管领导评测 EachLType=320 Modulus=30%
---- 分管领导非公司班子成员
UNION
select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,30 as Modulus,320 as EachLType,
N'320-分管领导评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=31 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 360度评价 一级分支机构负责人互评 EachLType=330 Modulus=10%
UNION
select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,330 as EachLType,
N'330-360度评价 一级分支机构负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.EID<>b.EID and a.Score_Type1=31 and b.Score_Type1=31 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
-- 360度评价 一级分支机构下属员工评测 EachLType=340 Modulus=10%
UNION
select N'一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,340 as EachLType,
N'340-360度评价 一级分支机构下属员工评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy) = dbo.eFN_getdepid1(b.kpidepidyy) and a.Score_Type1=31 and b.Score_Type1 in (32,33) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 32-一级分支机构副职及二级分支机构经理室成员
-- 分管领导评测 EachLType=410 Modulus=30%
UNION
select N'一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,30 as Modulus,410 as EachLType,
N'410-分管领导评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy)=c.DepID and a.Score_Type1=32 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 一级分支机构负责人评测 EachLType=420 Modulus=50%
UNION
select N'一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director as Score_EID,50 as Modulus,420 as EachLType,
N'420-一级分支机构负责人评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy)=c.DepID and a.Score_Type1=32 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 360度评价 部门人员评测 EachLType=440 Modulus=20%
UNION
select N'一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,20 as Modulus,440 as EachLType,
N'440-360度评价 部门人员评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy) = dbo.eFN_getdepid1(b.kpidepidyy) and a.Score_Type1=32 and b.Score_Type1=33 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

---- 10-子公司部门行政负责人
---- 子公司部门负责人 子公司总经理测评 EachLType=330 Modulus=40%
------ 资管子公司总经理DepID:393;资本子公司总经理DepID:392
--UNION
--select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,
--(case when c.CompID=13 then (select Director from oDepartment where DepID=393) else (select Director from oDepartment where DepID=392) end) as Score_EID,
--40 as Modulus,330 as EachLType,
--N'总经理测评' as EachLTypeTitle
--from pEmployee_register a,oDepartment c,eEmployee d
--where a.kpidepidyy=c.DepID and a.Score_Type1=10 and a.pstatus=1
--and a.EID=d.EID and d.Status not in (4,5)
---- 子公司部门负责人 子公司部门负责人互评 EachLType=340 Modulus=30%
--UNION
--select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,30 as Modulus,340 as EachLType,
--N'部门负责人互评' as EachLTypeTitle
--from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
--where a.EID<>b.EID and a.Score_Type1=10 and b.Score_Type1=10 and a.pstatus=1 and b.pstatus=1
--and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
---- 子公司部门负责人 部门内下属员工360度测评 EachLType=350 Modulus=30%
--UNION
--select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,30 as Modulus,350 as EachLType,
--N'下属员工360度测评' as EachLTypeTitle
--from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
--where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=10 and b.Score_Type1=11 and a.pstatus=1 and b.pstatus=1
--and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

GO