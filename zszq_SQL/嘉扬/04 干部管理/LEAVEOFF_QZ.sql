select distinct a.Badge as Badge,a.Name as Name,a.CompID as CompID,dbo.eFN_getdepid1(a.DepID) as SupDepID,a.DepID as DepID,a.JobID as JobID,
a.Status as Status,b.JoinDate as JoinDate,b.JobBegindate as JobBegindate,dateadd(year,3,b.JobBegindate) as JobPreEnddate,b.LeaDate as LeaveDate
from eemployee as a
inner join eStatus as b on a.EID=b.EID
inner join Odepartment as c on a.EID=c.director
where a.Status not in (4,5) AND c.DepType in (2,3)