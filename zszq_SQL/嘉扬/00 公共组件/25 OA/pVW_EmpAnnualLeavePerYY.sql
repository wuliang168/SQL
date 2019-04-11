-- pVW_EmpAnnualLeavePerYY
select distinct a.Name as Name,a.DepAppr as DepAppr,b.LeaveYear as LastYear,NULL as AllocAnnualLeaLY,b.SUM as AnnualLeaLY,
c.LeaveYear as Year,NULL as AllocAnnualLea,c.SUM as AnnualLea
from (select distinct Name,DepAppr from pVW_EmpOAAnnualLeave where YEAR(GETDATE())-LeaveYear<=1 and DepAppr is not NULL) a
left join (
    select LeaveYear,Name,DepAppr,SUM(LeaveDays) as SUM from pVW_EmpOAAnnualLeave 
    where YEAR(GETDATE())-LeaveYear=1 
    group by LeaveYear,Name,DepAppr) b on b.Name=a.name and b.DepAppr=a.DepAppr
left join (
    select LeaveYear,Name,DepAppr,SUM(LeaveDays) as SUM from pVW_EmpOAAnnualLeave 
    where YEAR(GETDATE())-LeaveYear=0 
    group by LeaveYear,Name,DepAppr) c on c.name=a.name and c.DepAppr=a.DepAppr