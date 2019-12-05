-- pVW_pEMPEmolu

select a.EID as EID,a.HRLID as HRLID,a.Badge as Badge,a.Name as Name,j.Gender as Gender,b1.IsAppraised as IsAppraised,b1.AppraisedDate as AppraisedDate,j.CertNo as CertNo,
a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1,dbo.eFN_getdepid2nd(a.DepID) as DepID2,dbo.eFN_getdepid3th(a.DepID) as DepID3,dbo.eFN_getdepid4th(a.DepID) as DepID4,
h.DepType as DepType,h.DepProperty as DepProperty,a.JobID as JobID,g.JobProperty1 as JobProperty,
(case when a.EmpGrade=3 then l.Title else m.Title end) as EmpGrade,
i.JoinDate as JoinDate,i.LeaDate as LeaDate,a.Status as Status,i.LeaReason as LeaReason,
a.WorkCity as WorkCity,j.HighLevel, j.HighDegree,DATEDIFF(yy, j.BirthDay, GETDATE()) AS Age,
ROUND(ISNULL(j.workyear_adjust, 0) + ROUND(DATEDIFF(mm, j.WorkBeginDate, GETDATE()) / 12.00, 2), 2) AS WorkYears,
ROUND(DATEDIFF(dd, i.JoinDate, DATEADD(day,10,DATEADD(day,-DAY(GETDATE()),GETDATE()))) / 365.00 + ISNULL(i.Cyear_adjust, 0), 2) AS Cyear,
b1.SalaryPayID as SalaryPayID,j.Country as Country,b1.SalaryPerMM as SalaryPerMM,b1.SponsorAllowance as SponsorAllowance,b1.CheckUpSalary as CheckUpSalary,
b2.LastYearAdminID as LastYearAdminID,c.AdminModulus as LastYearAdminModulus,b2.LastYearMDID as LastYearMDID,d.MDModulus as LastYearMDModulus,
(case when ISNULL(c.AdminModulus,0)>ISNULL(d.MDModulus,0) then ISNULL(c.AdminModulus,0) else ISNULL(d.MDModulus,0) end) as LastYearPostModulus,
b2.AdminID as AdminID,e.AdminModulus as AdminModulus,a.MDID as MDID,f.MDModulus as MDModulus,
(case when ISNULL(e.AdminModulus,0)>ISNULL(f.MDModulus,0) then ISNULL(e.AdminModulus,0) else ISNULL(f.MDModulus,0) end) as PostModulus,
a.Remark as Remark,g.xorder as jobxorder
from eemployee as a
inner join pEMPSalary as b1 on a.eid=b1.EID
inner join pEMPAdminIDMD as b2 on a.eid=b2.EID
left join oCD_AdminType as c on b2.LastYearAdminID=c.ID
left join oCD_MDType as d on b2.LastYearMDID=d.ID
left join oCD_AdminType as e on b2.AdminID=e.ID
left join oCD_MDType as f on a.MDID=f.ID
inner join ojob as g on a.jobid=g.jobid
inner join odepartment as h on a.depid=h.depid
inner join eStatus as i on a.eid=i.eid
inner join eDetails as j on a.eid=j.eid
inner join pEmployee_Register as k on a.EID=k.EID
inner join eCD_EmpGrade as l on l.ID=a.EmpGrade
left join pCD_PeRole as m on m.ID=k.perole