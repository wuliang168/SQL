-- pVW_EmpDepDate

select m.DepType,m.DepID,
(case when DATEDIFF(MM,o.JoinDate,GETDATE())=0 then COUNT(n.EID) end) as JoinMM,
(case when DATEDIFF(YY,o.JoinDate,GETDATE())=0 then COUNT(n.EID) end) as JoinYY,
(case when DATEDIFF(MM,o.LeaDate,GETDATE())=0 then COUNT(n.EID) end) as LeaMM,
(case when DATEDIFF(YY,o.LeaDate,GETDATE())=0 then COUNT(n.EID) end) as LeaYY
from eEmployee n,oDepartment m,eStatus o 
where dbo.eFN_getdepid1st(n.DepID)=m.DepID and n.EID=o.EID 
group by m.DepType,m.DepID,o.JoinDate,o.LeaDate