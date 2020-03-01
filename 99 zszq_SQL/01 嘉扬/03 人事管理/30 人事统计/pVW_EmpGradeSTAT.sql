-- pVW_EmpGradeSTAT

select b.DepType,a.EmpGrade,COUNT(a.EID) as EMP,(case when c.Gender=1 then COUNT(a.EID) end) as GenderM,(case when c.Gender=2 then COUNT(a.EID) end) as GenderF,
AVG(DATEDIFF(YY,c.BirthDay,GETDATE())) as AVGAGE,
(case when c.HighLevel in (4,5,6,7,8,9,10) then COUNT(a.EID) end) as HighLev_ASSTT,(case when c.HighLevel=3 then COUNT(a.EID) end) as HighLev_UGTT,
(case when c.HighLevel=2 then COUNT(a.EID) end) as HighLev_MSTT,(case when c.HighLevel=1 then COUNT(a.EID) end) as HighLev_DTTT,
(case when DATEDIFF(YY,c.WorkBeginDate,GETDATE())<1 then COUNT(a.EID) end) as WorkDate1YTT,
(case when DATEDIFF(YY,c.WorkBeginDate,GETDATE())>=1 and DATEDIFF(YY,c.WorkBeginDate,GETDATE())<5 then COUNT(a.EID) end) as WorkDate1t5YTT,
(case when DATEDIFF(YY,c.WorkBeginDate,GETDATE())>=5 and DATEDIFF(YY,c.WorkBeginDate,GETDATE())<10 then COUNT(a.EID) end) as WorkDate5t10YTT,
(case when DATEDIFF(YY,c.WorkBeginDate,GETDATE())>=10 then COUNT(a.EID) end) as WorkDate10YTT,
(case when DATEDIFF(YY,d.JoinDate,GETDATE())<1 then COUNT(a.EID) end) as JoinDate1YTT,
(case when DATEDIFF(YY,d.JoinDate,GETDATE())>=1 and DATEDIFF(YY,d.JoinDate,GETDATE())<3 then COUNT(a.EID) end) as JoinDate1t3YTT,
(case when DATEDIFF(YY,d.JoinDate,GETDATE())>=3 and DATEDIFF(YY,d.JoinDate,GETDATE())<5 then COUNT(a.EID) end) as JoinDate3t5YTT,
(case when DATEDIFF(YY,d.JoinDate,GETDATE())>=5 and DATEDIFF(YY,d.JoinDate,GETDATE())<8 then COUNT(a.EID) end) as JoinDate5t8YTT,
(case when DATEDIFF(YY,d.JoinDate,GETDATE())>=8 then COUNT(a.EID) end) as JoinDate8YTT
from eEmployee a
left join oDepartment b on a.DepID=b.DepID
left join eDetails c on a.EID=c.EID
left join eStatus d on a.EID=d.EID
where a.Status not in (4,5)
group by a.EmpGrade,b.DepType,c.Gender,c.HighLevel,c.WorkBeginDate,d.JoinDate