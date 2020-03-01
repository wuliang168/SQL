-- pVW_UserRole
select b.EID as EID,b.Badge as Badge,b.Name as Name,b.CompID as CompID,
dbo.eFN_getdepid1st(b.DepID) as DepID1,dbo.eFN_getdepid2nd(b.DepID) as DepID2,dbo.eFN_getdepid3th(b.DepID) as DepID3,
b.JobID as JobID,b.EmpGrade as EmpGrade,(case when b.EID=c.Director then 1 else NULL end) as Director,(case when b.EID=c.DepKPI then 1 else NULL end) as DepKPI,
(case when b.EID=c.DepEMP then 1 else NULL end) as DepEMP,(case when dbo.eFN_getdepid1st(b.DepID)=354 then 1 else NULL end) as HRID,
(case when b.EID=c.HGEID then 1 else NULL end) as HGEID,(case when b.EID=c.CWEID then 1 else NULL end) as CWEID,b.Status as Status,a.RUID as RUID
from skySecRoleMember a
inner join eEmployee b on a.URID=(select ID from skySecUser where EID=b.EID)
left join oDepartment c on b.DepID=c.DepID