-- pVW_pYear_ScoreEachL
/*
1-总部部门负责人：      履职情况胜任素质测评(公司班子成员30%、分管领导50%、360度评价20%(部门负责人互评10%、下属员工10%))
2-总部部门副职：        履职情况胜任素质测评(分管领导30%、部门负责人50%、360度评价20%(下属员工20%))
31-一级分支机构负责人：  履职情况胜任素质测评(公司班子领导30%、分管领导50%、360度评价20%(一级分支机构互评10%、分支机构员工10%))
32-一级分支机构副职及二级分支机构经理室成员：   履职情况胜任素质测评(分管领导30%、一级分支机构负责人50%、360度评价20%(下属员工20%))
*/

-- 1-总部部门负责人
---- 公司班子成员 EachLType=110 Modulus=30%
---- 公司董事长(吴承根：1022)、党委书记(李桦：5587)、公司总裁(王青山：5014)、副总裁(赵伟江：1026、高玮：1027、程景东：6012)
---- 财务总监(盛建龙：1028)、合规总监(许向军：1033)、董事会秘书(张辉：1425)
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,d.EID as Score_EID,30 as Modulus,110 as EachLType,
N'110-公司班子成员测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.Score_Type1=1 and a.pstatus=1
and d.EID in (1022,5587,5014,1026,1027,6012,1028,1033,1425)
and a.kpidepidyy=c.DepID and c.Director2<>d.EID
---- 公司班子成员
---- 公司班子成员为分管领导
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,80 as Modulus,110 as EachLType,
N'110-公司班子成员测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c
where a.kpidepidyy=c.DepID and a.Score_Type1=1 and a.pstatus=1
AND c.Director2 in (1022,5587,5014,1026,1027,6012,1028,1033,1425)
---- 分管领导 EachLType=120 Modulus=50%
---- 分管领导非公司班子成员
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,50 as Modulus,120 as EachLType,
N'120-分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c
where a.kpidepidyy=c.DepID and a.Score_Type1=1 and a.pstatus=1
AND c.Director2 not in (1022,5587,5014,1026,1027,6012,1028,1033,1425)
-- 360度评价 总部部门负责人互评 EachLType=130 Modulus=10%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,130 as EachLType,
N'130-360度评价 部门负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b
where a.EID<>b.EID and a.Score_Type1=1 and b.Score_Type1=1 and a.pstatus=1 and b.pstatus=1
-- 360度评价 部门员工测评 EachLType=140 Modulus=10%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,140 as EachLType,
N'140-360度评价 部门员工测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=1 and b.Score_Type1 in (2,4) and a.pstatus=1 and b.pstatus=1

-- 2-总部部门副职
---- 分管领导测评 EachLType=210 Modulus=30%
---- 分管领导非部门负责人
UNION
select N'2-总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,30 as Modulus,210 as EachLType,
N'210-分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=2 and a.pstatus=1 and c.Director2<>c.Director
and a.EID=d.EID and d.Status not in (4,5)
---- 分管领导为部门负责人
UNION
select N'2-总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,80 as Modulus,210 as EachLType,
N'210-分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=2 and a.pstatus=1 and c.Director2=c.Director
and a.EID=d.EID and d.Status not in (4,5)
---- 部门负责人测评 EachLType=220 Modulus=50%
---- 部门负责人非分管领导
UNION
select N'2-总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director as Score_EID,50 as Modulus,220 as EachLType,
N'220-部门负责人测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=2 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 360度评价 部门员工测评 EachLType=240 Modulus=20%
UNION
select N'2-总部部门副职' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,20 as Modulus,240 as EachLType,
N'240-360度评价 部门员工测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=2 and b.Score_Type1=4 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 31-一级分支机构负责人
-- 公司班子成员测评 EachLType=310 Modulus=30%
---- 公司董事长(吴承根：1022)、党委书记(李桦：5587)、公司总裁(王青山：5014)、副总裁(赵伟江：1026、高玮：1027、程景东：6012)
---- 财务总监(盛建龙：1028)、合规总监(许向军：1033)、董事会秘书(张辉：1425)
UNION
select N'31-一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,30 as Modulus,310 as EachLType,
N'310-公司班子成员测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=31 and a.pstatus=1
and a.EID=d.EID and d.EID in (1022,5587,5014,1026,1027,6012,1028,1033,1425)
and c.Director2<>d.EID
---- 公司班子成员为分管领导
UNION
select N'31-一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,80 as Modulus,310 as EachLType,
N'310-公司班子成员测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=31 and a.pstatus=1
and a.EID=d.EID and c.Director2 in (1022,5587,5014,1026,1027,6012,1028,1033,1425)
and a.EID=d.EID and d.Status not in (4,5)
---- 分管领导评测 EachLType=320 Modulus=50%
---- 分管领导非公司班子成员
UNION
select N'31-一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,50 as Modulus,320 as EachLType,
N'320-分管领导评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.Score_Type1=31 and a.pstatus=1
and c.Director2 not in (1022,5587,5014,1026,1027,6012,1028,1033,1425)
and a.EID=d.EID and d.Status not in (4,5)
-- 360度评价 一级分支机构负责人互评 EachLType=330 Modulus=10%
UNION
select N'31-一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,330 as EachLType,
N'330-360度评价 一级分支机构负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.EID<>b.EID and a.Score_Type1=31 and b.Score_Type1=31 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
-- 360度评价 一级分支机构下属员工评测 EachLType=340 Modulus=10%
UNION
select N'31-一级分支机构负责人' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,10 as Modulus,340 as EachLType,
N'340-360度评价 一级分支机构下属员工评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy) = dbo.eFN_getdepid1(b.kpidepidyy) and a.Score_Type1=31 and b.Score_Type1 in (32,33,34) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 32-一级分支机构副职及二级分支机构经理室成员
-- 分管领导评测 EachLType=410 Modulus=30%
UNION
select N'32-一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director2 as Score_EID,30 as Modulus,410 as EachLType,
N'410-分管领导评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy)=c.DepID and a.Score_Type1=32 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 一级分支机构负责人评测 EachLType=420 Modulus=50%
UNION
select N'32-一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,c.Director as Score_EID,50 as Modulus,420 as EachLType,
N'420-一级分支机构负责人评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy)=c.DepID and a.Score_Type1=32 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 360度评价 部门人员评测 EachLType=440 Modulus=20%
UNION
select N'32-一级分支机构副职及二级分支机构经理室成员' AS sEachLType,a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID,20 as Modulus,440 as EachLType,
N'440-360度评价 部门人员评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy) = dbo.eFN_getdepid1(b.kpidepidyy) and a.Score_Type1=32 and b.Score_Type1 in (33,34) and a.pstatus=1 and b.pstatus=1
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
--and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,