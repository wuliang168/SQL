---------------- 年度考核评分 ----------------
-- 总裁未评分：5
-- 财务总监未评分：4
-- 合规风控总监未评分：4
-- 分管领导未评分：4
-- 总部部门负责人未评分：2
-- 计划财务部负责人未评分：2
-- 子公司部门负责人未评分：2
-- 子公司总经理未评分：3
-- 网点运营管理总部未评分：2
-- 合规审计部未评分：1
-- 分公司/一级营业部负责人未评分：2
-- 二级营业部经理室成员考核未评分：1
-- 区域财务经理未评分：0

-------- 总部部门负责人 --------
-- 总部部门负责人 分管领导评分
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 4 as slevel, N'总部部门负责人考核评分 分管领导未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (1) and a.SCORE_STATUS=2
-- 总部部门负责人 总裁评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 5 as slevel,N'总部部门负责人考核评分 总裁未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (1) and a.SCORE_STATUS=3

-------- 总部部门副职 --------
-- 总部部门副职 总部部门负责人评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile,2 as slevel, N'总部部门副职考核评分 总部部门负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (2) and a.SCORE_STATUS=2
-- 总部部门副职 分管领导评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 4 as slevel,N'总部部门副职考核评分 分管领导未评分' as reason
from pscore as a
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (2) and a.SCORE_STATUS=3

-------- 子公司部门负责人 --------
-- 子公司部门负责人 子公司总经理评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 3 as slevel,N'子公司部门负责人考核评分 子公司总经理未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (10) and a.SCORE_STATUS=2
-- 子公司部门负责人 总裁评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 5 as slevel,N'子公司部门负责人考核评分 总裁未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (10) and a.SCORE_STATUS=3

-------- 分公司负责人/一级营业部负责人 --------
-- 分公司负责人/一级营业部负责人 网点运营管理总部评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'分公司负责人/一级营业部负责人考核评分 网点运营管理总部未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (24,5) and a.SCORE_STATUS=2
-- 分公司负责人/一级营业部负责人 合规审计部评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'分公司负责人/一级营业部负责人考核评分 合规审计部未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (24,5) and a.SCORE_STATUS=3
-- 分公司负责人/一级营业部负责人 分管领导评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 4 as slevel,N'分公司负责人/一级营业部负责人考核评分 分管领导未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (24,5) and a.SCORE_STATUS=4
-- 分公司负责人/一级营业部负责人 总裁评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile,5 as slevel, N'分公司负责人/一级营业部负责人考核评分 总裁未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (24,5) and a.SCORE_STATUS=5

-------- 分公司副职/一级营业部副职/二级营业部经理室 --------
-- 分公司副职/一级营业部副职/二级营业部经理室 分公司/一级营业部负责人评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'分公司副职/一级营业部副职/二级营业部经理室考核评分 分公司/一级营业部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (25,6,7) and a.SCORE_STATUS=2
-- 分公司副职/一级营业部副职/二级营业部经理室 分管领导评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 4 as slevel,N'分公司副职/一级营业部副职/二级营业部经理室考核评分 分管领导未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
inner join pscore as e on e.EID=a.EID
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN (25,6,7) and a.SCORE_STATUS=3 and e.SCORE_STATUS=1 AND ISNULL(e.submit,0)=1

-------- 总部普通员工 --------
-- 总部普通员工 总部部门负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'总部普通员工考核评分 总部部门负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE=4 and a.SCORE_STATUS=2

-------- 子公司普通员工 --------
-- 子公司普通员工 子公司部门负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'子公司普通员工考核评分 子公司部门负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE=11 and a.SCORE_STATUS=2

-------- 分公司/一级营业部/二级营业部普通员工 --------
-- 分公司/一级营业部/二级营业部普通员工 分公司/一级营业部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'分公司/一级营业部/二级营业部普通员工考核评分 分公司/一级营业部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
left join pscore as e on a.eid=e.eid and e.SCORE_STATUS=7
where isnull(a.submit,0)=0 
and ((a.SCORE_TYPE IN (29,12) and a.SCORE_STATUS=2 and (isnull(a.compliance,0)=0 OR (isnull(a.compliance,0)=15 and isnull(e.submit,0)=1)))
OR (a.SCORE_TYPE=13 and a.SCORE_STATUS=2 AND a.weight=70 and (isnull(a.compliance,0)=0 OR (isnull(a.compliance,0)=15 and isnull(e.submit,0)=1)))
OR (a.SCORE_TYPE=13 and a.SCORE_STATUS=3 AND a.weight=40 and (isnull(a.compliance,0)=0 OR (isnull(a.compliance,0)=15 and isnull(e.submit,0)=1))))

-------- 二级营业部普通员工 --------
-- 二级营业部普通员工 二级营业部经理室成员未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 1 as slevel,N'二级营业部普通员工考核评分 二级营业部经理室成员未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE=13 and a.SCORE_STATUS=2 AND a.weight=30

-------- 区域财务经理 --------
-- 区域财务经理 二级营业部负责人考核未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 1 as slevel,N'区域财务经理考核评分 二级营业部经理室成员考核未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid AND d.depgrade in (1)
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(17) and a.SCORE_STATUS=1
-- 区域财务经理 分公司/一级营业部负责人考核未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'区域财务经理考核评分 分公司/一级营业部负责人考核未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid AND d.depgrade in (1,0)
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(17) and a.SCORE_STATUS=1
-- 区域财务经理 计划财务部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'区域财务经理考核评分 计划财务部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(17) and a.SCORE_STATUS=2
-- 区域财务经理 财务总监未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 4 as slevel,N'区域财务经理考核评分 财务总监未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(17) and a.SCORE_STATUS=3

-------- 综合会计（集中） --------
-- 综合会计（集中） 区域财务经理未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile,0 as slevel, N'综合会计（集中）考核评分 区域财务经理未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(19) and a.SCORE_STATUS=1
-- 综合会计（集中） 计划财务部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'综合会计（集中）考核评分 计划财务部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(19) and a.SCORE_STATUS=2

-------- 综合会计（非集中） --------
-- 综合会计（集中） 区域财务经理未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 0 as slevel,N'综合会计（集中）考核评分 区域财务经理未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(20) and a.SCORE_STATUS=1
-- 综合会计（非集中） 二级营业部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 1 as slevel,N'综合会计（非集中）考核评分 二级营业部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid and isnull(d.depgrade,0) in (2)
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(20) and a.SCORE_STATUS=2
-- 综合会计（非集中） 分公司/一级营业部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'综合会计（非集中）考核评分 分公司/一级营业部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid and isnull(d.depgrade,0) in (0,1)
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(20) and a.SCORE_STATUS=2

-------- 营业部合规风控专员 --------
-- 营业部合规风控专员 二级营业部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 1 as slevel,N'营业部合规风控专员考核评分 二级营业部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid AND isnull(d.depgrade,0) in (2)
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(14) and a.SCORE_STATUS=1
-- 营业部合规风控专员 一级营业部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'营业部合规风控专员考核评分 分公司/一级营业部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid and isnull(d.depgrade,0) in (0,1)
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(14) and a.SCORE_STATUS=1
-- 营业部合规风控专员 合规审计部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 1 as slevel,N'营业部合规风控专员考核评分 合规审计部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(14) and a.SCORE_STATUS=2
-- 营业部合规风控专员 合规风控总监未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 4 as slevel,N'营业部合规风控专员考核评分 合规风控总监未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.SCORE_TYPE IN(14) and a.SCORE_STATUS=3

-------- 营业部合规风控联络人 --------
-- 营业部合规联系人 合规审计部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile, 1 as slevel,N'营业部合规联系人 合规审计部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.compliance IN (15) and a.SCORE_STATUS=7

-------- 总部兼职合规 --------
-- 总部兼职合规专员 合规审计部负责人未评分
UNION
select distinct a.score_eid,b.Name,d.title,c.office_phone,c.Mobile,1 as slevel, N'总部兼职合规专员 合规审计部负责人未评分' as reason
from pscore as a 
inner join eemployee as b on a.score_eid=b.eid
inner join eDetails as c on a.score_eid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.compliance IN (16) and a.SCORE_STATUS=7


---------------- 胜任素质 ----------------
-- 总部部门分管领导未测评：4
-- 总部部门负责人未测评：2
-- 子公司总经理未测评：3
-- 子公司部门负责人未互评：2
-- 分公司分管领导未测评：4
-- 一级营业部分管领导未测评：4
-- 分公司负责人未测评：1
-- 一级营业部负责人未测评：1
-- 分公司/一级营业部负责人未测评：1

-------- 总部部门负责人 --------
-- 总部部门负责人胜任素质 总部部门分管领导未测评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile,4 as slevel, N'总部部门负责人胜任素质 总部部门分管领导未测评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=1
-- 总部部门负责人胜任素质 总部部门负责人未互评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile,2 as slevel, N'总部部门负责人胜任素质 总部部门负责人未互评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=2

-------- 总部部门副职 --------
-- 总部部门副职胜任素质 分管领导未测评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile, 4 as slevel,N'总部部门副职胜任素质 分管领导未测评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=5
-- 总部部门副职胜任素质 总部部门负责人未测评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile, 2 as slevel,N'总部部门副职胜任素质 总部部门负责人未测评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=6

-------- 子公司部门负责人 --------
-- 子公司部门负责人胜任素质 子公司总经理未测评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile,3 as slevel, N'子公司部门负责人胜任素质 子公司总经理未测评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=11
-- 子公司部门负责人胜任素质 子公司部门负责人未互评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile,2 as slevel, N'子公司部门负责人胜任素质 子公司部门负责人未互评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=12

-------- 分公司负责人 --------
-- 分公司负责人胜任素质 分公司分管领导未测评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile,4 as slevel, N'分公司负责人胜任素质 分公司分管领导未测评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=21

-------- 分公司副职 --------
-- 分公司副职胜任素质 分公司负责人未测评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile,1 as slevel, N'分公司副职胜任素质 分公司负责人未测评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=25

-------- 一级营业部负责人 --------
-- 一级营业部负责人胜任素质 一级营业部分管领导未测评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile, 4 as slevel,N'一级营业部负责人胜任素质 一级营业部分管领导未测评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=31

-------- 一级营业部副职 --------
-- 一级营业部副职胜任素质 一级营业部负责人未测评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile,1 as slevel, N'一级营业部副职胜任素质 一级营业部负责人未测评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=35

-------- 二级营业部经理室成员 --------
-- 二级营业部经理室成员胜任素质 分公司/一级营业部负责人未测评
UNION
select distinct a.scoreeid,b.Name,d.title,c.office_phone,c.Mobile,1 as slevel, N'二级营业部经理室成员胜任素质 分公司/一级营业部负责人未测评' as reason
from pscore_each as a 
inner join eemployee as b on a.scoreeid=b.eid
inner join eDetails as c on a.scoreeid=c.EID
inner join odepartment as d on b.DepID=d.depid
where isnull(a.submit,0)=0 and a.EachType=41

