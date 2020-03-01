-- Attence_MonthlyALL

select a.EID as EID,a.Badge as Badge,a.Name as Name,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,a.JobID as JobID,a.WorkCity as WorkCity,
(Case When DATEDIFF(mm,m.joindate,z.term)<=0 Then  (select COUNT(term) from lCalendar where xType=1 and Datediff(mm,term,z.term)=0 and DATEDIFF(DD,m.JoinDate,term)>=0)
ELSE (select COUNT(term) from lCalendar where xType=1 and Datediff(mm,term,z.term)=0) End) as ToWorkDays,
---- 实际工作日=上午下午均打卡(DKFDays)+上午或下午打卡(DKHDays)+未打卡(确认)(YCACDays)/2-迟到(未确认)(YCLateDays)/2-早退(未确认)(YCEarlyDays)/2
CONVERT(DECIMAL(3,1),COUNT(b.EID*1.0)+COUNT(c.EID)*1.0/2.0+COUNT(e.YCACDays)*1.0/2.0-COUNT(g.YCLateDays)*1.0/2.0-COUNT(h.YCEarlyDays)*1.0/2.0) as WorkDays,
---- 未出勤天数=未打卡(未确认)(YCADays)/2
CONVERT(DECIMAL(3,1),COUNT(f.YCADays)*1.0/2.0) as AbnormWorkDays,
---- 迟到次数(未确认)=迟到(未确认)(YCLateDays)
COUNT(g.YCLateDays) as LateWorkDays,
---- 早退次数(未确认)=早退(未确认)(YCEarlyDays)
COUNT(h.YCEarlyDays) as EarlyWorkDays,
---- 比较日期
z.term
from eEmployee a
inner join lCalendar as z on z.Term is not NULL
---- 上午下午均打卡 DKFDays
left join (select EID,term as DKFDays from BS_DK_time where beginTime is not NULL and endTime is not NULL) b on b.eid=a.EID and Datediff(mm,b.DKFDays,z.Term)=0
---- 上午或下午打卡 DKHDays
left join (select EID,term as DKHDays from BS_DK_time where ((beginTime is NULL and endTime is not NULL) or (endTime is NULL and beginTime is not NULL))) c on c.eid=a.EID and Datediff(mm,DKHDays,z.Term)=0
---- 上午和下午均未打卡 DKFNDays
left join (select EID,term as DKFNDays from BS_DK_time where (beginTime is NULL and endTime is NULL) group by EID,term) d on d.eid=a.EID and Datediff(mm,d.DKFNDays,z.Term)=0
---- 未打卡(确认) YCACDays
left join (select EID,term as YCACDays from BS_YC_DK where YCKQNX=N'未打卡' and ISNULL(Submit,0)=1 and YCKQJG=N'情况属实，正常出勤') e on e.eid=a.EID and Datediff(mm,e.YCACDays,z.Term)=0
---- 未打卡(未确认) YCADays
left join (select EID,term as YCADays from BS_YC_DK where YCKQNX=N'未打卡' and ISNULL(Submit,0)=0) f on f.eid=a.EID and Datediff(mm,f.YCADays,z.Term)=0
---- 迟到(未确认) YCLateDays
left join (select EID,term as YCLateDays from BS_YC_DK where YCKQNX=N'迟到' and ISNULL(Submit,0)=0) g on g.eid=a.EID and Datediff(mm,g.YCLateDays,z.Term)=0
---- 早退(未确认) YCEarlyDays
left join (select EID,term as YCEarlyDays from BS_YC_DK where YCKQNX=N'早退' and ISNULL(Submit,0)=0) h on h.eid=a.EID and Datediff(mm,h.YCEarlyDays,z.Term)=0
---- 排序
inner join eStatus m on a.EID=m.EID
where a.Status not in (4,5)
group by a.EID,a.Badge,a.Name,a.CompID,a.DepID,a.JobID,a.WorkCity,z.term,m.joindate