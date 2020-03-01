select a.eid as EID,a.badge as Badge,a.Name as Name,c.DepAbbr as UpDep,b.DepAbbr as Dep,N'总部普通员工' as Job,
a.ScoreTotal as ScoreTotal,a.isRanking as isRanking,a.ranking as Ranking,d.totalnum as totalnum,
a.remark as Remark
from pscore as a
inner join odepartment as b on a.KpiDep=b.DepID
inner join odepartment as c on dbo.eFN_getdepid1(a.KpiDep)=c.DepID
left join pvw_ranking as d on a.eid=d.eid
where a.SCORE_TYPE=4 AND a.SCORE_STATUS=2 
order by c.DepAbbr,isnull(ranking,9999)