declare @mm int
set @mm=7
-- Attence_LastMonthly
select a.Name as Name,(select CompAbbr from oCompany where CompID=a.CompID) as CompAbbr,(select DepAbbr from oDepartment where DepID=dbo.eFN_getdepid1st(a.DepID)) as DepAbbr,(select Title from eCD_City where ID=a.WorkCity) as WorkCity,DATEADD(MM,0-@mm,GETDATE()),
(Case When DATEDIFF(MM,m.joindate,GETDATE())<=@mm Then  (select COUNT(term) from lCalendar where xType=1 and Datediff(mm,term,GETDATE())=@mm and DATEDIFF(DD,m.JoinDate,term)>=0)
ELSE (select COUNT(term) from lCalendar where xType=1 and Datediff(mm,term,GETDATE())=@mm) End) as ToWorkDays,
CONVERT(DECIMAL(3,1),ISNULL(b.DKFDays*1.0,0)+ISNULL(c.DKHDays*1.0/2.0,0)+ISNULL(e.YCACDays*1.0/2.0,0)-ISNULL(g.YCLateDays*1.0/2.0,0)-ISNULL(h.YCEarlyDays*1.0/2.0,0)) as WorkDays,
CONVERT(DECIMAL(3,1),ISNULL(f.YCADays*1.0/2.0,0)) as AbnormWorkDays,ISNULL(g.YCLateDays,0) as LateWorkDays,ISNULL(h.YCEarlyDays,0) as EarlyWorkDays
from eEmployee a
---- 上午下午均打卡 DKFDays
left join (select EID,COUNT(EID) as DKFDays from BS_DK_time where Datediff(mm,term,GETDATE())=@mm and beginTime is not NULL and endTime is not NULL group by EID) b on b.eid=a.EID
---- 上午或下午打卡 DKHDays
left join (select EID,COUNT(EID) as DKHDays from BS_DK_time where Datediff(mm,term,GETDATE())=@mm and ((beginTime is NULL and endTime is not NULL) or (endTime is NULL and beginTime is not NULL)) group by EID) c on c.eid=a.EID
---- 上午和下午均未打卡 DKFNDays
left join (select EID,COUNT(EID) as DKFNDays from BS_DK_time where Datediff(mm,term,GETDATE())=@mm and (beginTime is NULL and endTime is NULL) group by EID) d on d.eid=a.EID
---- 未打卡(确认) YCACDays
left join (select EID,COUNT(EID) as YCACDays from BS_YC_DK where Datediff(mm,term,GETDATE())=@mm and YCKQNX=N'未打卡' and ISNULL(Submit,0)=1 group by EID) e on e.eid=a.EID
---- 未打卡(未确认) YCADays
left join (select EID,COUNT(EID) as YCADays from BS_YC_DK where Datediff(mm,term,GETDATE())=@mm and YCKQNX=N'未打卡' and ISNULL(Submit,0)=0 group by EID) f on f.eid=a.EID
---- 迟到(未确认) YCLateDays
left join (select EID,COUNT(EID) as YCLateDays from BS_YC_DK where Datediff(mm,term,GETDATE())=@mm and YCKQNX=N'迟到' and ISNULL(Submit,0)=0 group by EID) g on g.eid=a.EID
---- 早退(未确认) YCEarlyDays
left join (select EID,COUNT(EID) as YCEarlyDays from BS_YC_DK where Datediff(mm,term,GETDATE())=@mm and YCKQNX=N'早退' and ISNULL(Submit,0)=0 group by EID) h on h.eid=a.EID
---- 排序
inner join eStatus m on a.EID=m.EID
inner join oJob n on a.JobID=n.JobID
where a.Status not in (4,5) and dbo.eFN_getdeptype(a.DepID) in (1,4) and a.DepID<>349
order by n.xorder