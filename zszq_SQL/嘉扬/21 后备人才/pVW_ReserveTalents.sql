-- pVW_ReserveTalents
---- pReserveTalents_Register
------ A
select a.Date,a.Director,a.EID,a.Badge,a.Name,a.CompID,a.DepID1st,a.DepID2nd,a.Age,a.cYear,a.JobID,a.Education,a.Degree,a.MDID,
a.LLYAssessRanking,a.BLYAssessRanking,a.LYAssessRanking,
(case when a.LLYAssessRanking is NULL then 3 when a.LLYAssessRanking=0 then 2 when a.LLYAssessRanking>b.limit and a.LLYAssessRanking is not NULL then 0 else 1 end) as LLYIsMatch,
(case when a.BLYAssessRanking is NULL then 3 when a.BLYAssessRanking=0 then 2 when a.BLYAssessRanking>b.limit and a.BLYAssessRanking is not NULL then 0 else 1 end) as BLYIsMatch,
(case when a.LYAssessRanking is NULL then 3 when a.LYAssessRanking=0 then 2 when a.LYAssessRanking>b.limit and a.LYAssessRanking is not NULL then 0 else 1 end) as LYIsMatch,
a.ReserveTalentsType,a.Remark
from pReserveTalents_Register a,oCD_ReserveTalentsType b
where a.ReserveTalentsType=b.ID and b.ID=1
------ B,C
UNION
select a.Date,a.Director,a.EID,a.Badge,a.Name,a.CompID,a.DepID1st,a.DepID2nd,a.Age,a.cYear,a.JobID,a.Education,a.Degree,a.MDID,
a.LLYAssessRanking,a.BLYAssessRanking,a.LYAssessRanking,
NULL as LLYIsMatch,
(case when a.BLYAssessRanking is NULL then 3 when a.BLYAssessRanking=0 then 2 when a.BLYAssessRanking>b.limit and a.BLYAssessRanking is not NULL then 0 else 1 end) as BLYIsMatch,
(case when a.LYAssessRanking is NULL then 3 when a.LYAssessRanking=0 then 2 when a.LYAssessRanking>b.limit and a.LYAssessRanking is not NULL then 0 else 1 end) as LYIsMatch,
a.ReserveTalentsType,a.Remark
from pReserveTalents_Register a,oCD_ReserveTalentsType b
where a.ReserveTalentsType=b.ID and b.ID<>1

---- pReserveTalents_all
------ A
UNION
select a.Date,a.Director,a.EID,a.Badge,a.Name,a.CompID,a.DepID1st,a.DepID2nd,a.Age,a.cYear,a.JobID,a.Education,a.Degree,a.MDID,
a.LLYAssessRanking,a.BLYAssessRanking,a.LYAssessRanking,
(case when a.LLYAssessRanking is NULL then 3 when a.LLYAssessRanking=0 then 2 when a.LLYAssessRanking>b.limit and a.LLYAssessRanking is not NULL then 0 else 1 end) as LLYIsMatch,
(case when a.BLYAssessRanking is NULL then 3 when a.BLYAssessRanking=0 then 2 when a.BLYAssessRanking>b.limit and a.BLYAssessRanking is not NULL then 0 else 1 end) as BLYIsMatch,
(case when a.LYAssessRanking is NULL then 3 when a.LYAssessRanking=0 then 2 when a.LYAssessRanking>b.limit and a.LYAssessRanking is not NULL then 0 else 1 end) as LYIsMatch,
a.ReserveTalentsType,a.Remark
from pReserveTalents_all a,oCD_ReserveTalentsType b
where a.ReserveTalentsType=b.ID and b.ID=1
------ B,C
UNION
select a.Date,a.Director,a.EID,a.Badge,a.Name,a.CompID,a.DepID1st,a.DepID2nd,a.Age,a.cYear,a.JobID,a.Education,a.Degree,a.MDID,
a.LLYAssessRanking,a.BLYAssessRanking,a.LYAssessRanking,
NULL as LLYIsMatch,
(case when a.BLYAssessRanking is NULL then 3 when a.BLYAssessRanking=0 then 2 when a.BLYAssessRanking>b.limit and a.BLYAssessRanking is not NULL then 0 else 1 end) as BLYIsMatch,
(case when a.LYAssessRanking is NULL then 3 when a.LYAssessRanking=0 then 2 when a.LYAssessRanking>b.limit and a.LYAssessRanking is not NULL then 0 else 1 end) as LYIsMatch,
a.ReserveTalentsType,a.Remark
from pReserveTalents_all a,oCD_ReserveTalentsType b
where a.ReserveTalentsType=b.ID and b.ID<>1