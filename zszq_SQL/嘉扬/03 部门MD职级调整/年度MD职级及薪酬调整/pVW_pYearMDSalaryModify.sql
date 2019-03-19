-- pVW_pYearMDSalaryModify
select ISNULL(b.Date,GETDATE()) as Date,a.EID as EID,a.Badge as Badge,a.Name as Name,
dbo.eFN_getdepid1st(a.DepID) AS depid1, dbo.eFN_getdepid2nd(a.DepID) AS depid2, dbo.eFN_getdepid3th(a.DepID) AS depid3, dbo.eFN_getdepid4th(a.DepID) AS depid4,a.status as Status,
a.WorkCity as WorkCity,a.JobID as JobID,f.MDID as MDID,f.SalaryPayID as SalaryPayID,b.HRMDIDAM as HRMDIDAM,f.SalaryPerMM as SalaryPerMM,b.HRSalaryPerMMAM as HRSalaryPerMMAM,
(CASE when e.DepType in (2,3) then c.Ratio else NULL end) as WorkCityRatio,
(CASE when e.DepType in (2,3) then ROUND(ISNULL(b.HRSalaryPerMMAM,f.SalaryPerMM)*c.Ratio,-2) else NULL end) as SalaryPerMMCity, d.xorder as JobXorder
from eemployee as a
left join pYear_MDSalaryModify_register as b on b.EID=a.EID
left join eCD_City as c on a.WorkCity=c.ID
left join oJob as d on a.JobID=d.JobID
left join odepartment as e on a.DepID=e.DepID
left join pEmployeeEmolu as f on a.eid=f.eid
where a.Status not in (4,5)