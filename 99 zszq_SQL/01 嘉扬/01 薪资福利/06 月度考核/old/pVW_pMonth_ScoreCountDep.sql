select a.KPIMonthID as KPIMonthID,b.kpidepid as KPIDepID,COUNT(a.Closed) as ScoreEmpCount
from (select distinct KPIMonthID,EID,Closed from pMonth_Score) a
inner join pEmployee_register as b on a.EID=b.EID
inner join odepartment as c on b.kpidepid=c.DepID
group by a.KPIMonthID,b.kpidepid
order by KPIMonthID,b.kpidepid