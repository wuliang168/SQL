-- pVW_EmpGradeSTAT

select (select Title from oCD_DepType where ID=b.DepType) as 项目,a.Title as 类别,SUM(b.EIDTT) as 人数,SUM(GenderM) as 性别_男,SUM(GenderF) as 性别_女,
AVG(AVGAge) as 平均年龄,SUM(HighLev_ASSTT) as 学历_大专及以下,SUM(HighLev_UGTT) as 学历_本科,SUM(HighLev_MSTT) as 学历_硕士,SUM(HighLev_DTTT) as 学历_博士,
SUM(WorkDate1t5YTT) as 从业年限_工龄1到5年,SUM(WorkDate5t10YTT) as 从业年限_工龄5到10年,SUM(WorkDate10YTT) as 从业年限_工龄10年以上,SUM(JoinDate3YTT) as 从业年限_司龄3年以上,
COUNT(c.JoinMM) as 当月入职人数,COUNT(c.JoinYY) as 当年入职人数合计,COUNT(d.LeaMM) as 当月离职人数,COUNT(d.LeaYY) as 当年离职人数合计,b.EmpGrade,a.xOrder
from eCD_EmpGrade a
inner join (select p.DepType,m.EmpGrade,m.Badge,COUNT(m.EID) as EIDTT,(case when n.Gender=1 then COUNT(m.EID) end) as GenderM,(case when n.Gender=2 then COUNT(m.EID) end) as GenderF,
AVG(DATEDIFF(YY,n.BirthDay,GETDATE())) as AVGAge,(case when n.HighLevel in (4,5,6,7,8,9,10) then COUNT(m.EID) end) as HighLev_ASSTT,(case when n.HighLevel=3 then COUNT(m.EID) end) as HighLev_UGTT,
(case when n.HighLevel=2 then COUNT(m.EID) end) as HighLev_MSTT,(case when n.HighLevel=1 then COUNT(m.EID) end) as HighLev_DTTT,
(case when DATEDIFF(YY,n.WorkBeginDate,GETDATE())>=1 and DATEDIFF(YY,n.WorkBeginDate,GETDATE())<5 then COUNT(m.EID) end) as WorkDate1t5YTT,
(case when DATEDIFF(YY,n.WorkBeginDate,GETDATE())>=5 and DATEDIFF(YY,n.WorkBeginDate,GETDATE())<10 then COUNT(m.EID) end) as WorkDate5t10YTT,
(case when DATEDIFF(YY,n.WorkBeginDate,GETDATE())>=10 then COUNT(m.EID) end) as WorkDate10YTT,(case when DATEDIFF(YY,o.JoinDate,GETDATE())>=3 then COUNT(m.EID) end) as JoinDate3YTT
from eEmployee m,eDetails n,eStatus o,oDepartment p where m.EID=n.EID and m.EID=o.EID and m.DepID=p.DepID and m.Status not in (4,5) 
group by p.DepType,m.EmpGrade,m.Badge,n.Gender,n.HighLevel,n.WorkBeginDate,o.JoinDate) b on b.EmpGrade=a.ID
left join (select Badge,EmpGrade,(case when DATEDIFF(MM,conBeginDate,GETDATE())=0 then COUNT(conBeginDate) end) as JoinMM,(case when DATEDIFF(YY,conBeginDate,GETDATE())=0 then COUNT(conBeginDate) end) as JoinYY from eStaff_all group by conBeginDate,Badge,EmpGrade) c on a.ID=c.EmpGrade and b.Badge=c.Badge
left join (select m.Badge,n.EmpGrade,(case when DATEDIFF(MM,m.leavedate,GETDATE())=0 then COUNT(m.leavedate) end) as LeaMM,(case when DATEDIFF(YY,m.leavedate,GETDATE())=0 then COUNT(m.leavedate) end) as LeaYY from eLeave_all m,eEmployee n where m.badge=n.Badge group by m.leavedate,m.Badge,n.EmpGrade) d on a.ID=c.EmpGrade and b.Badge=d.Badge
group by b.DepType,a.Title,a.xorder,b.EmpGrade