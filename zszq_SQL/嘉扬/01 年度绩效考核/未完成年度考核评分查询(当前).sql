---------------- 年度考核评分 ----------------
-- 董事长评分：1
-- 总裁未评分：2
-- 财务总监未评分：3
-- 合规风控总监未评分：3
-- 分管领导未评分：3
-- 总部部门负责人未评分：4
-- 计划财务部负责人未评分：4
-- 子公司部门负责人未评分：4
-- 子公司总经理未评分：3
-- 网点运营管理总部未评分：4
-- 法律合规部未评分：4
-- 分公司/一级营业部负责人未评分：4
-- 二级营业部经理室成员考核未评分：5
-- 区域财务经理未评分：6

-------- 总部部门负责人 --------
-- 总部部门负责人 分管领导评分
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,3 as Level,N'总部部门负责人考核评分 分管领导未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (1) and a.SCORE_STATUS=2 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 总部部门负责人 总裁评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,2 as Level,N'总部部门负责人考核评分 总裁未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (1) and a.SCORE_STATUS=3 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 总部部门负责人 董事长评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,1 as Level,N'总部部门负责人考核评分 董事长未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (1) and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 总部部门副职 --------
-- 总部部门副职 总部部门负责人评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'总部部门副职考核评分 总部部门负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (2) and a.SCORE_STATUS=2 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 总部部门副职 分管领导评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,3 as Level,N'总部部门副职考核评分 分管领导未评分' as reason
from pYear_Score as a
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (2) and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 子公司部门负责人 --------
-- 子公司部门负责人 合规评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'子公司部门负责人考核评分 合规未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (10) and a.SCORE_STATUS=2 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 子公司部门负责人 子公司总经理评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,3 as Level,N'子公司部门负责人考核评分 子公司总经理未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (10) and a.SCORE_STATUS=3 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 子公司部门负责人 董事长评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,1 as Level,N'子公司部门负责人考核评分 董事长未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (10) and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 分公司负责人/一级营业部负责人 --------
-- 分公司负责人/一级营业部负责人 网点运营管理总部评分
UNION
select distinct a.Score_EID,b.Name,NULL,NULL,d.title,c.Mobile,4 as Level,N'分公司负责人/一级营业部负责人考核评分 网点运营管理总部未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (24,5) and a.SCORE_STATUS=2 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 分公司负责人/一级营业部负责人 法律合规部评分
UNION
select distinct a.Score_EID,b.Name,NULL,NULL,d.title,c.Mobile,4 as Level,N'分公司负责人/一级营业部负责人考核评分 法律合规部未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (24,5) and a.SCORE_STATUS=3 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 分公司负责人/一级营业部负责人 分管领导评分
UNION
select distinct a.Score_EID,b.Name,NULL,NULL,d.title,c.Mobile,3 as Level,N'分公司负责人/一级营业部负责人考核评分 分管领导未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (24,5) and a.SCORE_STATUS=4 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 分公司负责人/一级营业部负责人 总裁评分
UNION
select distinct a.Score_EID,b.Name,NULL,NULL,d.title,c.Mobile,2 as Level,N'分公司负责人/一级营业部负责人考核评分 总裁未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (24,5) and a.SCORE_STATUS=5 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 分公司负责人/一级营业部负责人 董事长评分
UNION
select distinct a.Score_EID,b.Name,NULL,NULL,d.title,c.Mobile,1 as Level,N'分公司负责人/一级营业部负责人考核评分 董事长未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (24,5) and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 分公司副职/一级营业部副职/二级营业部经理室 --------
-- 分公司副职/一级营业部副职/二级营业部经理室 分公司/一级营业部负责人评分
UNION
select distinct a.Score_EID,b.Name,NULL,NULL,d.title,c.Mobile,4 as Level,N'分公司副职/一级营业部副职/二级营业部经理室考核评分 分公司/一级营业部负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 IN (25,6,7) and a.SCORE_STATUS=2 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 分公司副职/一级营业部副职/二级营业部经理室 分管领导评分
UNION
select distinct a.Score_EID,b.Name,NULL,NULL,d.title,c.Mobile,3 as Level,N'分公司副职/一级营业部副职/二级营业部经理室考核评分 分管领导未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
inner join pYear_Score as e on e.EID=a.EID
where a.SCORE_TYPE1 IN (25,6,7) and a.SCORE_STATUS=9 and e.SCORE_STATUS=1 AND ISNULL(e.submit,0)=1 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 总部普通员工 --------
-- 总部普通员工 总部部门负责人未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'总部普通员工考核评分 总部部门负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=4 and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 子公司普通员工 --------
-- 子公司普通员工 子公司部门负责人未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'子公司普通员工考核评分 子公司部门负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=11 and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 分公司/一级营业部/二级营业部普通员工 --------
-- 分公司/一级营业部/二级营业部普通员工 分公司/一级营业部负责人未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'分公司/一二级营业部普通员工考核评分 分公司/一级营业部负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1 in (29,12,13) and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 二级营业部普通员工 --------
-- 二级营业部普通员工 二级营业部经理室成员未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,5 as Level,N'二级营业部普通员工考核评分 二级营业部负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=13 and a.SCORE_STATUS=2 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 区域财务经理 --------
-- 区域财务经理 分公司/一二级营业部负责人考核未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'区域财务经理考核评分 分公司/一二级营业部负责人考核未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=17 and a.SCORE_STATUS=2 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 区域财务经理 计划财务部负责人未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'区域财务经理考核评分 计划财务部负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=17 and a.SCORE_STATUS=3 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 区域财务经理 财务总监未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,3 as Level,N'区域财务经理考核评分 财务总监未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=17 and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 综合会计 --------
-- 综合会计 区域财务经理未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,5 as Level,N'综合会计考核评分 区域财务经理未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=19 and a.SCORE_STATUS=2 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 综合会计 计划财务部负责人未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'综合会计考核评分 计划财务部负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=19 and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 营业部合规风控专员 --------
-- 营业部合规风控专员 分公司/一二级营业部负责人未评分
--UNION
--select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'营业部合规风控专员考核评分 分公司/一二级营业部负责人未评分' as reason
--from pYear_Score as a 
--inner join eemployee as b on a.Score_EID=b.eid
--inner join eDetails as c on a.Score_EID=c.EID
--inner join odepartment as d on b.DepID=d.depid
--where a.SCORE_TYPE1=14 and a.SCORE_STATUS=2 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 营业部合规风控专员 法律合规部负责人未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,4 as Level,N'营业部合规风控专员考核评分 法律合规部负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=14 and a.SCORE_STATUS=3 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0
-- 营业部合规风控专员 合规风控总监未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,NULL,d.title,c.Mobile,3 as Level,N'营业部合规风控专员考核评分 合规风控总监未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where a.SCORE_TYPE1=14 and a.SCORE_STATUS=9 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 营业部合规风控联络人 --------
-- 营业部合规联系人 法律合规部负责人未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,a.SCORE_TYPE2,d.title,c.Mobile,4 as Level,N'营业部合规联系人 法律合规部负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where NULL=15 and a.SCORE_STATUS=7 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0

-------- 总部兼职合规 --------
-- 总部兼职合规专员 法律合规部负责人未评分
UNION
select distinct a.Score_EID,b.Name,a.SCORE_TYPE1,a.SCORE_TYPE2,d.title,c.Mobile,4 as Level,N'总部兼职合规专员 法律合规部负责人未评分' as reason
from pYear_Score as a 
inner join eemployee as b on a.Score_EID=b.eid
inner join eDetails as c on a.Score_EID=c.EID
inner join odepartment as d on b.DepID=d.depid
where NULL=16 and a.SCORE_STATUS=7 and ISNULL(a.Initialized,0)=1 and ISNULL(a.Submit,0)=0