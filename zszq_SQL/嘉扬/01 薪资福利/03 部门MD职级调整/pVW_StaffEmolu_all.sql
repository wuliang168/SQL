-- pVW_StaffEmolu_all

select a.EID as EID, NULL as BID,a.Badge as Badge,a.Name as Name,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,
dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,a.Status as Status,b.AdminID as AdminID,b.MDID as MDID,c.SalaryPerMM as SalaryPerMM,
c.SalaryPerMMLoc as SalaryPerMMLoc,c.SponsorAllowance as SponsorAllowance,c.CheckUpSalary as CheckUpSalary,d.xOrder as JobxOrder
from eEmployee a,pEMPAdminIDMD b,pEMPSalary c,oJob d
where a.EID=b.EID and a.EID=c.EID and a.JobID=d.JobID