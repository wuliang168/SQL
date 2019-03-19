-- Attence_LastMonthly
select a.EID as EID,a.Badge as Badge,a.Name as Name,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,a.JobID as JobID,a.WorkCity as WorkCity,
(select COUNT(term) from lCalendar where xType=1 and Datediff(mm,term,GETDATE())=1) as ToWorkDays,CONVERT(DECIMAL(3,1),ISNULL(b.DKFDays*1.0,0)+ISNULL(c.DKHDays*1.0/2,0)) as WorkDays,
ISNULL(d.YCADays,0) as AbnormWorkDays,ISNULL(e.YCACDays,0) as AbnormConfirmWorkDays
from eEmployee a
left join (select EID,COUNT(EID) as DKFDays from BS_DK_time where Datediff(mm,term,GETDATE())=1 and beginTime is not NULL and endTime is not NULL group by EID) b on b.eid=a.EID
left join (select EID,COUNT(EID) as DKHDays from BS_DK_time where Datediff(mm,term,GETDATE())=1 and (beginTime is NULL or endTime is NULL) group by EID) c on c.eid=a.EID
left join (select EID,COUNT(EID) as YCADays from BS_YC_DK where Datediff(mm,term,GETDATE())=1 group by EID) d on d.eid=a.EID
left join (select EID,COUNT(EID) as YCACDays from BS_YC_DK where Datediff(mm,term,GETDATE())=1 and ISNULL(Submit,0)=1 group by EID) e on e.eid=a.EID
where a.Status not in (4,5)