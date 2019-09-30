-- pVW_EmpDepSTAT

select (select Title from oCD_DepType where ID=a.DepType) as 项目,a.Title as 类别,SUM(b.EIDTT) as 人数,SUM(GenderM) as 性别_男,SUM(GenderF) as 性别_女,
AVG(AVGAge) as 平均年龄,SUM(HighLev_ASSTT) as 学历_大专及以下,SUM(HighLev_UGTT) as 学历_本科,SUM(HighLev_MSTT) as 学历_硕士,SUM(HighLev_DTTT) as 学历_博士,
SUM(WorkDate1t5YTT) as 从业年限_工龄1到5年,SUM(WorkDate5t10YTT) as 从业年限_工龄5到10年,SUM(WorkDate10YTT) as 从业年限_工龄10年以上,SUM(JoinDate3YTT) as 从业年限_司龄3年以上,
COUNT(c.JoinMM) as 当月入职人数,COUNT(c.JoinYY) as 当年入职人数合计,COUNT(d.LeaMM) as 当月离职人数,COUNT(d.LeaYY) as 当年离职人数合计,a.xOrder
from oDepartment a
inner join (select dbo.eFN_getdepid1st(m.DepID) as DepID1st,m.Badge,COUNT(m.EID) as EIDTT,(case when n.Gender=1 then COUNT(m.EID) end) as GenderM,(case when n.Gender=2 then COUNT(m.EID) end) as GenderF,
AVG(DATEDIFF(YY,n.BirthDay,GETDATE())) as AVGAge,(case when n.HighLevel in (4,5,6,7,8,9,10) then COUNT(m.EID) end) as HighLev_ASSTT,(case when n.HighLevel=3 then COUNT(m.EID) end) as HighLev_UGTT,
(case when n.HighLevel=2 then COUNT(m.EID) end) as HighLev_MSTT,(case when n.HighLevel=1 then COUNT(m.EID) end) as HighLev_DTTT,
(case when DATEDIFF(YY,n.WorkBeginDate,GETDATE())>=1 and DATEDIFF(YY,n.WorkBeginDate,GETDATE())<5 then COUNT(m.EID) end) as WorkDate1t5YTT,
(case when DATEDIFF(YY,n.WorkBeginDate,GETDATE())>=5 and DATEDIFF(YY,n.WorkBeginDate,GETDATE())<10 then COUNT(m.EID) end) as WorkDate5t10YTT,
(case when DATEDIFF(YY,n.WorkBeginDate,GETDATE())>=10 then COUNT(m.EID) end) as WorkDate10YTT,(case when DATEDIFF(YY,o.JoinDate,GETDATE())>=3 then COUNT(m.EID) end) as JoinDate3YTT
from eEmployee m,eDetails n,eStatus o where m.EID=n.EID and m.EID=o.EID and m.Status not in (4,5) 
group by dbo.eFN_getdepid1st(m.DepID),m.Badge,n.Gender,n.HighLevel,n.WorkBeginDate,o.JoinDate) b on b.DepID1st=a.DepID
left join (select Badge,dbo.eFN_getdepid1st(DepID) as DepID1st,(case when DATEDIFF(MM,conBeginDate,GETDATE())=0 then COUNT(conBeginDate) end) as JoinMM,(case when DATEDIFF(YY,conBeginDate,GETDATE())=0 then COUNT(conBeginDate) end) as JoinYY from eStaff_all group by conBeginDate,Badge,DepID) c on a.DepID=c.DepID1st and b.Badge=c.Badge
left join (select Badge,dbo.eFN_getdepid1st(DepID) as DepID1st,(case when DATEDIFF(MM,leavedate,GETDATE())=0 then COUNT(leavedate) end) as LeaMM,(case when DATEDIFF(YY,leavedate,GETDATE())=0 then COUNT(leavedate) end) as LeaYY from eLeave_all  group by leavedate,Badge,dbo.eFN_getdepid1st(DepID)) d on a.DepID=c.DepID1st and b.Badge=d.Badge
where a.deptype=1
group by a.DepType,a.Title,a.xOrder