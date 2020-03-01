-- pVW_EmpDepSTATALL

declare @calcdate smalldatetime
set @calcdate=GETDATE()

select a.DepType,a.DepID,SUM(a.EMP) as EMPSum,SUM(a.GenderM) as GenderMSum,SUM(a.GenderF) as GenderFSum,SUM(a.EMP*a.AVGAGE)/SUM(a.EMP) as AVGAGESum,
SUM(a.HighLev_ASSTT) as HighLev_ASSTTSum,SUM(a.HighLev_UGTT) as HighLev_UGTTSum,SUM(a.HighLev_MSTT) as HighLev_MSTTSum,SUM(a.HighLev_DTTT) as HighLev_DTTTSum,
SUM(a.WorkDate1YTT) as WorkDate1YTTSum,SUM(a.WorkDate1t5YTT) as WorkDate1t5YTTSum,SUM(a.WorkDate5t10YTT) as WorkDate5t10YTTSum,SUM(a.WorkDate10YTT) as WorkDate10YTTSum,
SUM(a.JoinDate1YTT) as JoinDate1YTTSum,SUM(a.JoinDate1t3YTT) as JoinDate1t3YTTSum,SUM(a.JoinDate3t5YTT) as JoinDate3t5YTTSum,SUM(a.JoinDate5t8YTT) as JoinDate5t8YTTSum,
SUM(a.JoinDate8YTT) as JoinDate8YTTSum
from (select b.DepType,b.DepID,COUNT(a.EID) as EMP,(case when c.Gender=1 then COUNT(a.EID) end) as GenderM,(case when c.Gender=2 then COUNT(a.EID) end) as GenderF,
AVG(DATEDIFF(YY,c.BirthDay,@calcdate)) as AVGAGE,
(case when c.HighLevel in (4,5,6,7,8,9,10) then COUNT(a.EID) end) as HighLev_ASSTT,(case when c.HighLevel=3 then COUNT(a.EID) end) as HighLev_UGTT,
(case when c.HighLevel=2 then COUNT(a.EID) end) as HighLev_MSTT,(case when c.HighLevel=1 then COUNT(a.EID) end) as HighLev_DTTT,
(case when DATEDIFF(YY,c.WorkBeginDate,@calcdate)<1 then COUNT(a.EID) end) as WorkDate1YTT,
(case when DATEDIFF(YY,c.WorkBeginDate,@calcdate)>=1 and DATEDIFF(YY,c.WorkBeginDate,@calcdate)<5 then COUNT(a.EID) end) as WorkDate1t5YTT,
(case when DATEDIFF(YY,c.WorkBeginDate,@calcdate)>=5 and DATEDIFF(YY,c.WorkBeginDate,@calcdate)<10 then COUNT(a.EID) end) as WorkDate5t10YTT,
(case when DATEDIFF(YY,c.WorkBeginDate,@calcdate)>=10 then COUNT(a.EID) end) as WorkDate10YTT,
(case when DATEDIFF(YY,d.JoinDate,@calcdate)<1 then COUNT(a.EID) end) as JoinDate1YTT,
(case when DATEDIFF(YY,d.JoinDate,@calcdate)>=1 and DATEDIFF(YY,d.JoinDate,@calcdate)<3 then COUNT(a.EID) end) as JoinDate1t3YTT,
(case when DATEDIFF(YY,d.JoinDate,@calcdate)>=3 and DATEDIFF(YY,d.JoinDate,@calcdate)<5 then COUNT(a.EID) end) as JoinDate3t5YTT,
(case when DATEDIFF(YY,d.JoinDate,@calcdate)>=5 and DATEDIFF(YY,d.JoinDate,@calcdate)<8 then COUNT(a.EID) end) as JoinDate5t8YTT,
(case when DATEDIFF(YY,d.JoinDate,@calcdate)>=8 then COUNT(a.EID) end) as JoinDate8YTT
from eEmployee a
inner join oDepartment b on dbo.eFN_getdepid1st(a.DepID)=b.DepID and b.DepType=1
inner join eDetails c on a.EID=c.EID
inner join eStatus d on a.EID=d.EID
where DATEDIFF(dd,d.JoinDate,@calcdate)>=0 and (DATEDIFF(dd,d.LeaDate,@calcdate)<0 or d.LeaDate is NULL)
group by b.DepType,b.DepID,c.Gender,c.HighLevel,c.WorkBeginDate,d.JoinDate) a
group by a.DepType,a.DepID