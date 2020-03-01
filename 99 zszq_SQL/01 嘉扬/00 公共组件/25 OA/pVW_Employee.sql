-- pVW_Employee

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_Employee]
AS

---- 理顾
select b.xOrder*10000+4010 as JobxOrder,NULL as EID,a.BID as BID,NULL as HRLID,NULL as Badge,a.Identification as Identification,a.Identification_update as Identification_update,
ID as CRMID,a.Name as Name,b.CompID as CompID,a.DepID as DepID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
b.DepType as DepType,b.DepGrade as DepGrade,NULL as KPIDepID,b.DepAbbr as DepTitle,b.DepProperty as DepProperty,b.DepProperty1 as DepProperty1,
NULL as JobID,a.JobTitle as JobTitle,a.Status as Status,a.Status_update as Status_update,NULL as EmpGrade,
NULL as CompPartTime,a.JoinDate as JoinDate,a.LeaDate as LeaDate,NULL as WorkCity,a.Mobile as Mobile,a.Account as Account,NULL as ResidentAddress
from pCRMStaff a,oDepartment b
where a.DepID=b.DepID
--and a.Identification not in (select a.Certno from eDetails a,eEmployee b where a.EID=b.EID and b.Status in (1,2,3))

---- 非理顾
UNION
select c.xOrder as JobxOrder,a.EID as EID,NULL as BID,a.HRLID as HRLID,a.Badge as Badge,f.CertNo as Identification,f.CertNo as Identification_update,
NULL as CRMID,a.Name as Name,d.CompID as CompID,a.DepID as DepID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
d.DepType as DepType,d.DepGrade as DepGrade,e.kpiDepID as KPIDepID,d.DepAbbr as DepTitle,d.DepProperty as DepProperty,d.DepProperty1 as DepProperty1,
c.JobID as JobID,c.Title as JobTitle,a.Status as Status,a.Status as Status_update,a.EmpGrade as EmpGrade,ISNULL(e.pegroup,e.perole) as CompPartTime,
b.JoinDate as JoinDate,b.LeaDate as LeaDate,a.WorkCity as WorkCity,f.Mobile as Mobile,g.Account as Account,f.residentAddress as ResidentAddress
from eEmployee a,eStatus b,oJob c,oDepartment d,pEmployee_register e,eDetails f,SkySecUser g
where a.EID=b.EID and a.JobID=c.JobID and a.DepID=d.DepID
and a.EID=e.EID and a.EID=f.EID and a.EID=g.EID

Go