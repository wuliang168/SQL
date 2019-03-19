---- 总部部门负责人 ----
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'总部部门负责人' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=1 AND a.SCORE_STATUS=3 

---- 总部部门副职 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'总部部门副职' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=2 AND a.SCORE_STATUS=3 

---- 子公司部门负责人 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'子公司部门负责人' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=10 AND a.SCORE_STATUS=3 

---- 分公司负责人 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'分公司负责人' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE IN (24) AND a.SCORE_STATUS=5

---- 一级营业部负责人 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'一级营业部负责人' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE IN (5) AND a.SCORE_STATUS=5

---- 分公司副职 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'分公司副职' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE IN (25) AND a.SCORE_STATUS=3

---- 一级营业部副职 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'一级营业部副职' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE IN (6) AND a.SCORE_STATUS=3

---- 二级营业部经理室 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'二级营业部经理室' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE IN (7) AND a.SCORE_STATUS=3

---- 总部普通员工 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'总部普通员工' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=4 AND a.SCORE_STATUS=2


---- 子公司普通员工 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'子公司普通员工' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=11 AND a.SCORE_STATUS=2 

---- 分公司普通员工 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'分公司普通员工' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE IN (29) AND a.SCORE_STATUS=2 

---- 一级营业部普通员工 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'一级营业部普通员工' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE IN (12) AND a.SCORE_STATUS=2 

---- 二级营业部普通员工 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'二级营业部普通员工' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE IN (13) AND a.SCORE_STATUS=2 AND a.weight=70
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'二级营业部普通员工' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE IN (13) AND a.SCORE_STATUS=3 AND a.weight=40

---- 区域财务经理 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'区域财务经理' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=17 AND a.SCORE_STATUS=3

---- 综合会计（集中） ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'综合会计（集中）' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=19 AND a.SCORE_STATUS=2

---- 综合会计（非集中） ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'综合会计（非集中）' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=20 AND a.SCORE_STATUS=2

---- 营业部合规风控专员 ----
UNION
select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'营业部合规风控专员' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=14 AND a.SCORE_STATUS=3

-------- 排序 --------
order by c.DepAbbr,a.ranking DESC
