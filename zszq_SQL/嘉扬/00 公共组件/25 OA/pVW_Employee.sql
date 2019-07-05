-- pVW_Employee

---- 理顾
select b.xOrder*10000+4010 as JobxOrder,NULL as EID,a.BID as BID,NULL as HRLID,NULL as Badge,a.Identification as Identification,ID as CRMID,a.Name as Name,b.CompID as CompID,
a.DepID as DepID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,b.DepType as DepType,
NULL as KPIDepID,b.DepAbbr as DepTitle,NULL as DepProperty1,a.JobTitle as JobTitle,a.Status as Status,NULL as EmpGrade,
NULL as CompPartTime,a.JoinDate as JoinDate,a.LeaDate as LeaDate,NULL as WorkCity
from pCRMStaff a,oDepartment b
where a.Status=1 and a.DepID=b.DepID and a.JobTitle not in (N'经纪人',N'分支机构副总,总助（业务型）',N'客户服务部经理',N'机构业务部经理',N'综合服务人员',N'财富管理中心负责人')
--and a.Identification not in (select a.Certno from eDetails a,eEmployee b where a.EID=b.EID and b.Status in (1,2,3))

---- 非理顾
UNION
select c.xOrder as JobxOrder,a.EID as EID,NULL as BID,a.HRLID as HRLID,a.Badge as Badge,NULL as Identification,NULL as CRMID,a.Name as Name,d.CompID as CompID,
a.DepID as DepID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,d.DepType as DepType,
e.kpiDepID as KPIDepID,d.DepAbbr as DepTitle,d.DepProperty1 as DepProperty1,c.Title as JobTitle,a.Status as Status,a.EmpGrade as EmpGrade,
ISNULL(e.pegroup,e.perole) as CompPartTime,b.JoinDate as JoinDate,b.LeaDate as LeaDate,a.WorkCity as WorkCity
from eEmployee a,eStatus b,oJob c,oDepartment d,pEmployee_register e
where a.EID=b.EID and a.JobID=c.JobID and a.DepID=d.DepID
and a.EID=e.EID