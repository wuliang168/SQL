-- pVW_CompOfficer
select distinct a.EID as EID,a.Badge as Badge,a.Name as Name,DATEDIFF(yy, d.BirthDay, GETDATE()) AS age,
a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
(select MAX(DepType) from oDepartment where HGEID=b.HGEID) as DepType,a.JobID as JobID,a.Major as Major,
a.WorkYears as WorkYears,a.Cyear as Cyear,c.xorder as JobxOrder
from eVW_employee as a
inner join oDepartment as b on a.EID=b.HGEID
inner join oJob as c on a.JobID=c.JobID
inner join eDetails as d on a.EID=d.EID