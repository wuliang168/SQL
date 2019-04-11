select a.KPIMonthID as KPIMonthID,b.kpidepid as KPIDepID,COUNT(a.EID) as PlanSummEmpCount
from (select distinct KPIMonthID,EID from pMonth_PlanSumm) a
inner join pEmployee_register as b on a.EID=b.EID
inner join odepartment as c on b.kpidepid=c.DepID
group by a.KPIMonthID,b.kpidepid