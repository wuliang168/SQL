-- pVW_pYear_ScoreEachL
/*
1-总部部门负责人：      履职情况胜任素质测评(公司班子成员30%、分管领导50%、360度评价20%(部门负责人互评10%、下属员工10%))
2-总部部门副职：        履职情况胜任素质测评(分管领导30%、部门负责人50%、360度评价20%(下属员工20%))
31-一级分支机构负责人：  履职情况胜任素质测评(公司班子领导30%、分管领导50%、360度评价20%(一级分支机构互评10%、分支机构员工10%))
32-一级分支机构副职及二级分支机构经理室成员：   履职情况胜任素质测评(分管领导30%、一级分支机构负责人50%、360度评价20%(下属员工20%))
*/

-- 1-总部部门负责人
-- 总部部门负责人 分管领导测评 EachLType=130 Modulus=15%
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,15 as Modulus,130 as EachLType,
N'分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c
where a.kpidepidyy=c.DepID and a.perole=1 and a.pstatus=1
AND c.Director2 not in (1026,1027,6012,1033,1425,1028,5587,5014,1022) AND c.Director2 is not NULL
---- 分管领导(Director2)为其他副职领导 EachLType=120 Modulus=15%+15%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,30 as Modulus,120 as EachLType,
N'分管领导(其他副职领导)测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c
where a.kpidepidyy=c.DepID and a.perole=1 and a.pstatus=1
AND c.Director2 in (1026,1027,6012,1033,1425,1028)
---- 分管领导(Director2)为主要领导 EachLType=110 Modulus=15%+30%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,45 as Modulus,110 as EachLType,
N'分管领导(主要领导)测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c
where a.kpidepidyy=c.DepID and a.perole=1 and a.pstatus=1
AND c.Director2 in (5587,5014,1022)
-- 总部部门负责人 其他副职领导(副总裁(赵伟江：1026、高玮：1027、程景东：6012、许向军：1033、张辉：1425)、财务总监(盛建龙：1028))考核 EachLType=120 Modulus=15%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,d.EID as Score_EID,15 as Modulus,120 as EachLType,
N'其他副职领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.perole=1 and a.pstatus=1
and d.EID in (1026,1027,6012,1033,1425,1028)
and a.kpidepidyy=c.DepID and c.Director2 not in (1026,1027,6012,1033,1425,1028)
-- 总部部门负责人 主要领导(党委书记(李桦：5587)、公司总裁(王青山：5014)、公司董事长(吴承根：1022))考核 EachLType=110 Modulus=30%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,d.EID as Score_EID,30 as Modulus,110 as EachLType,
N'主要领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.perole=1 and a.pstatus=1
and d.EID in (5587,5014,1022)
and a.kpidepidyy=c.DepID and c.Director2 not in (5587,5014,1022)
--总部部门负责人 总部部门负责人互评 EachLType=140 Modulus=20%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,20 as Modulus,140 as EachLType,
N'部门负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b
where a.EID<>b.EID and a.perole=1 and b.perole=1 and a.pstatus=1 and b.pstatus=1
-- 总部部门负责人 总部部门内下属员工360度测评 EachLType=150 Modulus=20%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,20 as Modulus,150 as EachLType,
N'下属员工360度测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b
where a.kpidepidyy=b.kpidepidyy and a.perole=1 and b.perole in (2,4) and a.pstatus=1 and b.pstatus=1

-- 2-总部部门副职
-- 总部部门副职 总部部门分管领导测评 EachLType=230 Modulus=40%
---- 总部部门分管领导<>总部部门负责人
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,40 as Modulus,230 as EachLType,
N'分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.perole=2 and a.pstatus=1 and c.Director2<>c.Director
and a.EID=d.EID and d.Status not in (4,5)
-- 总部部门副职 总部部门分管领导测评 EachLType=230 Modulus=40%+30%
---- 总部部门分管领导=总部部门负责人
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,70 as Modulus,230 as EachLType,
N'分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.perole=2 and a.pstatus=1 and c.Director2=c.Director
and a.EID=d.EID and d.Status not in (4,5)
-- 总部部门副职 总部部门负责人测评 EachLType=240 Modulus=30%
---- 总部部门分管领导<>总部部门负责人
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director as Score_EID,30 as Modulus,240 as EachLType,
N'部门负责人测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.perole=2 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 总部部门副职 总部部门内下属员工360度测评 EachLType=250 Modulus=30%
UNION
select N'总部部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,30 as Modulus,250 as EachLType,
N'下属员工360度测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.perole=2 and b.perole=4 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 31-一级分支机构负责人
-- 分公司负责人 分公司分管领导评测 EachLType=530 Modulus=60%
UNION
select N'分公司负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,60 as Modulus,530 as EachLType,
N'分管领导评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.perole=24 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 分公司负责人 分公司及二级营业部人员(包括二级营业部经理室)评测 EachLType=540 Modulus=40%
UNION
select N'分公司负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,40 as Modulus,540 as EachLType,
N'分支机构人员评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy) = dbo.eFN_getdepid1(b.kpidepidyy) and a.perole=24 and b.perole in (25,7,13) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 32-一级分支机构副职及二级分支机构经理室成员
-- 分公司副职 分公司负责人评测 EachLType=640 Modulus=60%
UNION
select N'分公司副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director as Score_EID,60 as Modulus,640 as EachLType,
N'分公司负责人评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.perole=25 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 分公司副职 分公司及二级营业部人员(包括二级营业部经理室)评测 EachLType=650 Modulus=40%
UNION
select N'分公司副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,40 as Modulus,650 as EachLType,
N'分支机构人员评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.kpidepidyy) = dbo.eFN_getdepid1(b.kpidepidyy) and a.perole=25 and b.perole in (29,7,13) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 10-子公司部门行政负责人
-- 子公司部门负责人 子公司总经理测评 EachLType=330 Modulus=40%
---- 资管子公司总经理DepID:393;资本子公司总经理DepID:392
UNION
select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,
(case when c.CompID=13 then (select Director from oDepartment where DepID=393) else (select Director from oDepartment where DepID=392) end) as Score_EID,
40 as Modulus,330 as EachLType,
N'总经理测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.kpidepidyy=c.DepID and a.perole=10 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 子公司部门负责人 子公司部门负责人互评 EachLType=340 Modulus=30%
UNION
select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,30 as Modulus,340 as EachLType,
N'部门负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.EID<>b.EID and a.perole=10 and b.perole=10 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
-- 子公司部门负责人 部门内下属员工360度测评 EachLType=350 Modulus=30%
UNION
select N'子公司部门行政负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,30 as Modulus,350 as EachLType,
N'下属员工360度测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.perole=10 and b.perole=11 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)