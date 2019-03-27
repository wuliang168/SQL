-- pVW_pEMPEmolu

select a.EID as EID,b.HRLID as HRLID,b.Badge as Badge,b.Name as Name,j.Gender as Gender,a.IsAppraised as IsAppraised,a.AppraisedDate as AppraisedDate,j.CertNo as CertNo,
b.CompID as CompID,dbo.eFN_getdepid1st(b.DepID) as DepID1,dbo.eFN_getdepid2nd(b.DepID) as DepID2,dbo.eFN_getdepid3th(b.DepID) as DepID3,dbo.eFN_getdepid4th(b.DepID) as DepID4,
h.DepType as DepType,h.DepProperty as DepProperty,b.JobID as JobID,g.JobProperty1 as JobProperty,
(case when b.EmpGrade=3 then l.Title else m.Title end) as EmpGrade,
i.JoinDate as JoinDate,i.LeaDate as LeaDate,b.Status as Status,i.LeaReason as LeaReason,
b.WorkCity as WorkCity,j.HighLevel, j.HighDegree,DATEDIFF(yy, j.BirthDay, GETDATE()) AS Age,
ROUND(ISNULL(j.workyear_adjust, 0) + ROUND(DATEDIFF(mm, j.WorkBeginDate, GETDATE()) / 12.00, 2), 2) AS WorkYears,
ROUND(DATEDIFF(dd, i.JoinDate, DATEADD(day,10,DATEADD(day,-DAY(GETDATE()),GETDATE()))) / 365.00 + ISNULL(i.Cyear_adjust, 0), 2) AS Cyear,
a.SalaryPayID as SalaryPayID,j.Country as Country,a.SalaryPerMM as SalaryPerMM,a.SponsorAllowance as SponsorAllowance,a.CheckUpSalary as CheckUpSalary,
a.LastYearAdminID as LastYearAdminID,c.AdminModulus as LastYearAdminModulus,a.LastYearMDID as LastYearMDID,d.MDModulus as LastYearMDModulus,
(case when ISNULL(c.AdminModulus,0)>ISNULL(d.MDModulus,0) then ISNULL(c.AdminModulus,0) else ISNULL(d.MDModulus,0) end) as LastYearPostModulus,
a.AdminID as AdminID,e.AdminModulus as AdminModulus,a.MDID as MDID,f.MDModulus as MDModulus,
(case when ISNULL(e.AdminModulus,0)>ISNULL(f.MDModulus,0) then ISNULL(e.AdminModulus,0) else ISNULL(f.MDModulus,0) end) as PostModulus,
a.IsPension as IsPension,a.GrpPensionYearRest as GrpPensionYearRest,
(case when b.status=5 then 0 else a.GrpPensionYearRest/4 end) as EmpPensionYearRest,
a.GrpPensionTotal as GrpPensionTotal,a.EmpPensionTotal as EmpPensionTotal,a.GrpPensionFrozen as GrpPensionFrozen,a.EmpPensionFrozen as EmpPensionFrozen,
a.Remark as Remark,g.xorder as jobxorder
from pEmployeeEmolu as a
inner join eemployee as b on a.eid=b.EID
left join oCD_AdminType as c on a.LastYearAdminID=c.ID
left join oCD_MDType as d on a.LastYearMDID=d.ID
left join oCD_AdminType as e on a.AdminID=e.ID
left join oCD_MDType as f on a.MDID=f.ID
inner join ojob as g on b.jobid=g.jobid
inner join odepartment as h on b.depid=h.depid
inner join eStatus as i on a.eid=i.eid
inner join eDetails as j on a.eid=j.eid
inner join pEmployee_Register as k on a.EID=k.EID
inner join eCD_EmpGrade as l on l.ID=b.EmpGrade
left join pCD_PeRole as m on m.ID=k.perole