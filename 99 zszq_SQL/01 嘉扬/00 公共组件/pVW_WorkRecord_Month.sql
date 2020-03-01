-- pvw_Workrecord_Month

select a.EID as EID,a.WorkDay as WorkDay,a.month as mm,a.tianxieday as tianxieday, a.WorkDay-a.tianxieday as diffdays,a.Name as Name,a.depid1 as depid1,a.DepType as DepType,a.xOrder as xOrder
from (select a.EID as EID,(Case When DATEDIFF(mm,b.joindate,GETDATE())<=1 Then  (select COUNT(term) from lCalendar where xType=1 and Datediff(mm,term,GETDATE())=0 and DATEDIFF(DD,b.JoinDate,term)>=0)
ELSE (select COUNT(term) from lCalendar where xType=1 and Datediff(mm,term,GETDATE())=0) End) as WorkDay,
DATEADD(m,0 ,dateadd(dd,-day(getdate())+1,getdate())) as month,
(select COUNT(EID) from Workrecord where EID=a.EID and DATEDIFF(mm,tianxiedate,GETDATE())=0 and id in (select min(id) from Workrecord where DATEDIFF(mm,tianxiedate,GETDATE())=0 group by EID,CONVERT(VARCHAR(10),tianxiedate,110))) as tianxieday, a.Name as Name,a.DepID as depid1,
(select DepAbbr from oDepartment where DepID=a.DepID) as DepAbbr,(select DepType from oDepartment where DepID=a.DepID) as DepType,(select xorder from oJob where JobID=a.JobID) as xOrder
from eEmployee a
inner join eStatus b on a.EID=b.EID
where a.Status not in (4,5)) a