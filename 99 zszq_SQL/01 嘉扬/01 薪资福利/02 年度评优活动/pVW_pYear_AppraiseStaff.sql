-- pVW_pYear_AppraiseStaff

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_AppraiseStaff]
AS

---- 理顾
select NULL as JobxOrder,NULL as EID,BID as BID,a.Identification as Identification,a.Name as Name,a.DepID as DepID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
NULL as KPIDepID,b.DepAbbr as DepTitle,NULL as DepProperty1,a.JobTitle as JobTitle,a.Status as Status,NULL as EmpGrade,NULL as CompPartTime,a.JoinDate as JoinDate
from pCRMStaff a,oDepartment b
where a.Status in (1) and a.DepID=b.DepID and a.JobTitle not in (N'经纪人',N'分支机构副总,总助（业务型）',N'客户服务部经理',N'机构业务部经理',N'综合服务人员',N'财富管理中心负责人')
and a.Identification not in (select a.Certno from eDetails a,eEmployee b where a.EID=b.EID and b.Status not in (4,5))
and Datediff(MM,(select Convert(smalldatetime,CONVERT(varchar(4),Year(Date))+'-01-01',110) from pYear_AppraiseProcess where ISNULL(Submit,0)=1 and ISNULL(Closed,0)=0),a.JoinDate)<=0

---- 非理顾
UNION
select c.xOrder as JobxOrder,a.EID as EID,NULL as BID,NULL as Identification,a.Name as Name,a.DepID as DepID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
e.kpidepidYY as KPIDepID,d.DepAbbr as DepTitle,d.DepProperty1 as DepProperty1,c.Title as JobTitle,a.Status as Status,a.EmpGrade as EmpGrade,ISNULL(e.Score_Type2,e.Score_Type1) as CompPartTime,b.JoinDate as JoinDate
from eEmployee a,eStatus b,oJob c,oDepartment d,pEmployee_register e
where a.EID=b.EID and a.JobID=c.JobID and a.Status not in (4,5) and a.DepID=d.DepID
and a.EID=e.EID and a.DepID not in (349)
and Datediff(MM,(select Convert(smalldatetime,CONVERT(varchar(4),Year(Date))+'-01-01',110) from pYear_AppraiseProcess where ISNULL(Submit,0)=1 and ISNULL(Closed,0)=0),b.JoinDate)<=0

Go