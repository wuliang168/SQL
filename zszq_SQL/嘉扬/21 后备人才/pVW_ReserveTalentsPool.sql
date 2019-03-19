-- pVW_ReserveTalentsPool
---- 非资管，非投行
select h.Director as Director,a.EID as EID,a.Badge as Badge,a.Name as Name,a.CompID as CompID, dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
DATEDIFF(yy, b.BirthDay, GETDATE()) AS Age,ROUND(DATEDIFF(mm, c.JoinDate, GETDATE()) / 12.00 + ISNULL(c.Cyear_adjust, 0), 2) AS Cyear,a.JobID as JobID,
b.HighLevel as Education,b.HighDegree as Degree,d.MDID as MDID, 
(case when e.EID is NULL then NULL else ROUND(ISNULL(e.Ranking*1.00/e.TotalRankNum,0),2) end) as LLYAssessRanking,
(case when f.EID is NULL then NULL else ROUND(ISNULL(f.Ranking*1.00/f.TotalRankNum,0),2) end) as BLYAssessRanking,
(case when g.EID is NULL then NULL else ROUND(ISNULL(g.Ranking*1.00/g.TotalRankNum,0),2) end) as LYAssessRanking
from eEmployee a
inner join eDetails as b on a.EID=b.EID
inner join eStatus as c on a.EID=c.EID
inner join pEmployeeEmolu as d on a.EID=d.EID
inner join pVW_ReserveTalentsDep as h on dbo.eFN_getdepid1st(a.DepID)=h.DepID
left join pYear_Score_all as e on a.EID=e.EID and e.Score_Status=9 and e.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=3)
left join pYear_Score_all as f on a.EID=f.EID and f.Score_Status=9 and f.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=2)
left join pYear_Score_all as g on a.EID=g.EID and g.Score_Status=9 and g.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=1)
where a.Status not in (4,5) and a.CompID=11 and ISNULL(dbo.eFN_getdepadmin(a.DepID),0)<>695 and ISNULL(dbo.eFN_getdepadmin(a.DepID),0)<>715

---- 资管
UNION
select h.Director as Director,a.EID as EID,a.Badge as Badge,a.Name as Name,a.CompID as CompID, dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
DATEDIFF(yy, b.BirthDay, GETDATE()) AS Age,ROUND(DATEDIFF(mm, c.JoinDate, GETDATE()) / 12.00 + ISNULL(c.Cyear_adjust, 0), 2) AS Cyear,a.JobID as JobID,
b.HighLevel as Education,b.HighDegree as Degree,d.MDID as MDID, 
(case when e.EID is NULL then NULL else ROUND(ISNULL(e.Ranking*1.00/e.TotalRankNum,0),2) end) as LLYAssessRanking,
(case when f.EID is NULL then NULL else ROUND(ISNULL(f.Ranking*1.00/f.TotalRankNum,0),2) end) as BLYAssessRanking,
(case when g.EID is NULL then NULL else ROUND(ISNULL(g.Ranking*1.00/g.TotalRankNum,0),2) end) as LYAssessRanking
from eEmployee a
inner join eDetails as b on a.EID=b.EID
inner join eStatus as c on a.EID=c.EID
inner join pEmployeeEmolu as d on a.EID=d.EID
inner join pVW_ReserveTalentsDep as h on h.DepID=393
left join pYear_Score_all as e on a.EID=e.EID and e.Score_Status=9 and e.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=3)
left join pYear_Score_all as f on a.EID=f.EID and f.Score_Status=9 and f.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=2)
left join pYear_Score_all as g on a.EID=g.EID and g.Score_Status=9 and g.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=1)
where a.Status not in (4,5) and a.CompID=13

---- 投行银行
UNION
select h.Director as Director,a.EID as EID,a.Badge as Badge,a.Name as Name,a.CompID as CompID, dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
DATEDIFF(yy, b.BirthDay, GETDATE()) AS Age,ROUND(DATEDIFF(mm, c.JoinDate, GETDATE()) / 12.00 + ISNULL(c.Cyear_adjust, 0), 2) AS Cyear,a.JobID as JobID,
b.HighLevel as Education,b.HighDegree as Degree,d.MDID as MDID, 
(case when e.EID is NULL then NULL else ROUND(ISNULL(e.Ranking*1.00/e.TotalRankNum,0),2) end) as LLYAssessRanking,
(case when f.EID is NULL then NULL else ROUND(ISNULL(f.Ranking*1.00/f.TotalRankNum,0),2) end) as BLYAssessRanking,
(case when g.EID is NULL then NULL else ROUND(ISNULL(g.Ranking*1.00/g.TotalRankNum,0),2) end) as LYAssessRanking
from eEmployee a
inner join eDetails as b on a.EID=b.EID
inner join eStatus as c on a.EID=c.EID
inner join pEmployeeEmolu as d on a.EID=d.EID
inner join pVW_ReserveTalentsDep as h on h.DepID=695
left join pYear_Score_all as e on a.EID=e.EID and e.Score_Status=9 and e.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=3)
left join pYear_Score_all as f on a.EID=f.EID and f.Score_Status=9 and f.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=2)
left join pYear_Score_all as g on a.EID=g.EID and g.Score_Status=9 and g.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=1)
where a.Status not in (4,5) and a.CompID=11 and ISNULL(dbo.eFN_getdepadmin(a.DepID),0)=695

---- 财富管理
UNION
select h.Director as Director,a.EID as EID,a.Badge as Badge,a.Name as Name,a.CompID as CompID, dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
DATEDIFF(yy, b.BirthDay, GETDATE()) AS Age,ROUND(DATEDIFF(mm, c.JoinDate, GETDATE()) / 12.00 + ISNULL(c.Cyear_adjust, 0), 2) AS Cyear,a.JobID as JobID,
b.HighLevel as Education,b.HighDegree as Degree,d.MDID as MDID, 
(case when e.EID is NULL then NULL else ROUND(ISNULL(e.Ranking*1.00/e.TotalRankNum,0),2) end) as LLYAssessRanking,
(case when f.EID is NULL then NULL else ROUND(ISNULL(f.Ranking*1.00/f.TotalRankNum,0),2) end) as BLYAssessRanking,
(case when g.EID is NULL then NULL else ROUND(ISNULL(g.Ranking*1.00/g.TotalRankNum,0),2) end) as LYAssessRanking
from eEmployee a
inner join eDetails as b on a.EID=b.EID
inner join eStatus as c on a.EID=c.EID
inner join pEmployeeEmolu as d on a.EID=d.EID
inner join pVW_ReserveTalentsDep as h on h.DepID=715
left join pYear_Score_all as e on a.EID=e.EID and e.Score_Status=9 and e.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=3)
left join pYear_Score_all as f on a.EID=f.EID and f.Score_Status=9 and f.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=2)
left join pYear_Score_all as g on a.EID=g.EID and g.Score_Status=9 and g.pYear_ID=(select ID from pYear_Process where DATEDIFF(YY,Date,GETDATE())=1)
where a.Status not in (4,5) and a.CompID=11 and ISNULL(dbo.eFN_getdepadmin(a.DepID),0)=715