-- pVW_pYear_ScoreEachL

-- 1-总部部门负责人
-- 总部部门负责人 分管领导测评 EachLType=1 Modulus=40%
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,40 as Modulus,1 as EachLType,
N'2-总部部门分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=1 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
AND c.Director2 not in (1026,1027,6012,1033,1425,1028,5587,5014,1022) AND c.Director2 is not NULL
---- 分管领导(Director2)为其他副职领导
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,40 as Modulus,1 as EachLType,
N'2-总部部门分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=1 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
AND c.Director2 in (1026,1027,6012,1033,1425,1028)
---- 分管领导(Director2)为主要领导
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,40 as Modulus,1 as EachLType,
N'2-总部部门分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=1 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
AND c.Director2 in (5587,5014,1022)
-- 总部部门负责人 其他副职领导(副总裁(赵伟江：1026、高玮：1027、程景东：6012、许向军：1033、张辉：1425)、财务总监(盛建龙：1028))考核 EachLType=1 Modulus=40%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,40 as Modulus,1 as EachLType,
N'2-总部部门分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=1 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 总部部门负责人 主要领导(党委书记(李桦：5587)、公司总裁(王青山：5014)、公司董事长(吴承根：1022))考核 EachLType=1 Modulus=40%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,40 as Modulus,1 as EachLType,
N'2-总部部门分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=1 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)

--总部部门负责人 总部部门负责人互评 EachLType=2 Modulus=20%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,30 as Modulus,2 as EachLType,
N'1-总部部门负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.EID<>b.EID and a.perole=1 and b.perole=1 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
-- 总部部门负责人 总部部门内下属员工360度测评 EachLType=3 Modulus=20%
UNION
select N'1-总部部门负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,30 as Modulus,3 as EachLType,
N'0-总部部门内下属员工360度测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=1 and b.perole in (2,4) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 2-总部部门副职
-- 总部部门副职 总部部门分管领导测评 EachLType=5 Modulus=40%
---- 总部部门分管领导<>总部部门负责人
UNION
select N'2-总部部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,40 as Modulus,5 as EachLType,
N'2-总部部门分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=2 and a.pstatus=1 and c.Director2<>c.Director
and a.EID=d.EID and d.Status not in (4,5)
-- 总部部门副职 总部部门分管领导测评 EachLType=5 Modulus=70%
---- 总部部门分管领导=总部部门负责人
UNION
select N'2-总部部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,70 as Modulus,5 as EachLType,
N'2-总部部门分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=2 and a.pstatus=1 and c.Director2=c.Director
and a.EID=d.EID and d.Status not in (4,5)
-- 总部部门副职 总部部门负责人测评 EachLType=6 Modulus=30%
---- 总部部门分管领导<>总部部门负责人
UNION
select N'2-总部部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director as Score_EID,30 as Modulus,6 as EachLType,
N'1-总部部门负责人测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=2 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 总部部门副职 总部部门内下属员工360度测评 EachLType=7 Modulus=30%
UNION
select N'2-总部部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,30 as Modulus,7 as EachLType,
N'0-总部部门内下属员工360度测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=2 and b.perole=4 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 10-子公司部门行政负责人
-- 子公司部门负责人 子公司总经理测评 EachLType=11 Modulus=40%
---- 资管子公司总经理DepID:393;资本子公司总经理DepID:392
UNION
select N'10-子公司部门行政负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,
(case when c.CompID=13 then (select Director from oDepartment where DepID=393) else (select Director from oDepartment where DepID=392) end) as Score_EID,
40 as Modulus,11 as EachLType,
N'2-子公司总经理测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=10 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 子公司部门负责人 子公司部门负责人互评 EachLType=12 Modulus=30%
UNION
select N'10-子公司部门行政负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,30 as Modulus,12 as EachLType,
N'1-子公司部门负责人互评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.EID<>b.EID and a.perole=10 and b.perole=10 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)
-- 子公司部门负责人 部门内下属员工360度测评 EachLType=13 Modulus=30%
UNION
select N'10-子公司部门行政负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,30 as Modulus,13 as EachLType,
N'0-子公司部门内下属员工360度测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=10 and b.perole=11 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 2-子公司部门副职
-- 子公司部门副职 子公司部门分管领导测评 EachLType=5 Modulus=40%
---- 子公司部门分管领导<>子公司部门负责人
UNION
select N'30-子公司部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,40 as Modulus,15 as EachLType,
N'2-子公司部门分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=30 and a.pstatus=1 and c.Director2<>c.Director
and a.EID=d.EID and d.Status not in (4,5)
-- 子公司部门副职 子公司部门分管领导测评 EachLType=5 Modulus=70%
---- 子公司部门分管领导=子公司部门负责人
UNION
select N'30-子公司部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,70 as Modulus,15 as EachLType,
N'2-子公司部门分管领导测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=30 and a.pstatus=1 and c.Director2=c.Director
and a.EID=d.EID and d.Status not in (4,5)
-- 子公司部门副职 子公司部门负责人测评 EachLType=6 Modulus=30%
---- 子公司部门分管领导<>子公司部门负责人
UNION
select N'30-子公司部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director as Score_EID,30 as Modulus,16 as EachLType,
N'1-子公司部门负责人测评' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=30 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 子公司部门副职 子公司部门内下属员工360度测评 EachLType=7 Modulus=30%
UNION
select N'30-子公司部门副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,30 as Modulus,17 as EachLType,
N'0-子公司部门内下属员工360度测评' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=30 and b.perole=4 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 24-分公司负责人
-- 分公司负责人 分公司分管领导评测 EachLType=21 Modulus=60%
UNION
select N'24-分公司负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,60 as Modulus,21 as EachLType,
N'1-分公司分管领导评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=24 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 分公司负责人 分公司及二级营业部人员(包括二级营业部经理室)评测 EachLType=22 Modulus=40%
UNION
select N'24-分公司负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,40 as Modulus,22 as EachLType,
N'0-分公司及二级营业部人员评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.KPIDepID) = dbo.eFN_getdepid1(b.KPIDepID) and a.perole=24 and b.perole in (25,7,13) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 25-分公司副职
-- 分公司副职 分公司负责人评测 EachLType=25 Modulus=60%
UNION
select N'25-分公司副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director as Score_EID,60 as Modulus,25 as EachLType,
N'1-分公司负责人评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=25 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 分公司副职 分公司及二级营业部人员(包括二级营业部经理室)评测 EachLType=26 Modulus=40%
UNION
select N'25-分公司副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,40 as Modulus,26 as EachLType,
N'0-分公司及二级营业部人员评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.KPIDepID) = dbo.eFN_getdepid1(b.KPIDepID) and a.perole=25 and b.perole in (29,7,13) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 5-一级营业部负责人
-- 一级营业部负责人 分管领导评测 EachLType=31 Modulus=60%
UNION
select N'5-一级营业部负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director2 as Score_EID,60 as Modulus,31 as EachLType,
N'1-一级营业部分管领导评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=5 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 一级营业部负责人 一二级营业部人员评测 EachLType=32 Modulus=40%
UNION
select N'5-一级营业部负责人' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,40 as Modulus,32 as EachLType,
N'0-一二级营业部人员评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.KPIDepID) = dbo.eFN_getdepid1(b.KPIDepID) and a.perole=5 and b.perole in (6,7,13) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 6-一级营业部副职
-- 一级营业部副职 一级营业部负责人评测 EachLType=35 Modulus=60%
UNION
select N'6-一级营业部副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director as Score_EID,60 as Modulus,35 as EachLType,
N'1-一级营业部负责人评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where a.KPIDepID=c.DepID and a.perole=6 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 一级营业部副职 一级营业部人员(不包括一级营业部副职)及二级营业部人员(包括二级营业部经理室)评测 EachLType=36 Modulus=40%
UNION
select N'6-一级营业部副职' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,40 as Modulus,36 as EachLType,
N'0-一级营业部人员及二级营业部人员评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where dbo.eFN_getdepid1(a.KPIDepID) = dbo.eFN_getdepid1(b.KPIDepID) and a.perole=6 and b.perole in (7,12,13) and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 7-二级营业部经理室成员
-- 二级营业部经理室成员 分公司/一级营业部负责人评测 EachLType=41 Modulus=60%
UNION
select N'7-二级营业部经理室成员' AS sEachLType,a.EID as EID,a.perole as Score_Type1,c.Director as Score_EID,60 as Modulus,41 as EachLType,
N'1-分公司/一级营业部负责人评测' as EachLTypeTitle
from pEmployee_register a,oDepartment c,eEmployee d
where dbo.eFN_getdepid1st(a.KPIDepID)=c.DepID and a.perole=7 and a.pstatus=1
and a.EID=d.EID and d.Status not in (4,5)
-- 二级营业部经理室成员 二级营业部人员(不包括二级营业部经理室)评测 EachLType=42 Modulus=40%
UNION
select N'7-二级营业部经理室成员' AS sEachLType,a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID,40 as Modulus,42 as EachLType,
N'0-二级营业部人员评测' as EachLTypeTitle
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=7 and b.perole=13 and a.pstatus=1 and b.pstatus=1
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)