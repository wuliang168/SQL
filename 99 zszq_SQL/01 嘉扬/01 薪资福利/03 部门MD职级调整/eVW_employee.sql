-- eVW_Employee

SELECT a.EID, a.Badge, a.Name, a.EName, a.CompID, a.DepID, a.JobID, a.Status, a.ReportTo, a.wfreportto, 
a.EmpType, a.EmpGrade, a.EmpCategory, a.EmpProperty, a.EmpGroup, a.EmpKind, a.WorkCity, 
a.Remark, a.EZID, d.DepEmp as HRG, a.VirtualDep, b.JoinDate, ISNULL(b.Cyear_adjust, 0) AS cyear_adjust, 
ROUND(DATEDIFF(mm, b.JoinDate, GETDATE()) / 12.00 + ISNULL(b.Cyear_adjust, 0), 2) AS Cyear, 
b.JobBegindate, d.xOrder, e.xorder AS joborder, ROUND(DATEDIFF(mm, b.JobBegindate, GETDATE())/12.00,2) AS Jyear, 
b.isPrac, b.PracTerm, b.PracEndDate, b.PracConfDate, b.isProb, b.ProbTerm, b.ProbEndDate, 
b.ProbConfDate, b.ConCount, b.contract, b.ConType, b.ConNo, b.ConProperty, b.ConBeginDate, b.ConTerm, b.ConEndDate, 
b.isLeave, b.LeaDate, b.LeaType, b.LeaReason, b.IsBlackList, c.Country, 
c.CertType, c.CertNo, c.Gender, c.BirthDay, DATEDIFF(yy, c.BirthDay, GETDATE()) AS age, c.HighLevel, c.HighDegree, c.HighTitle,c.Major, c.WorkBeginDate, c.workyear_adjust, 
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) AS WorkYears, c.Mobile, c.email, 
dbo.eFN_getdepid1st(a.DepID) AS depid1, dbo.eFN_getdepid2nd(a.DepID) AS depid2, dbo.eFN_getdepid3th(a.DepID) AS depid3, dbo.eFN_getdepid4th(a.DepID) AS depid4,
dbo.eFN_getdepid1_XS(a.DepID) AS depid1_xs, c.schoolname, c.party, c.office_phone, c.OA, c.TEL, c.Marriage, c.partydate, c.Nation, c.residentAddress,
b.RetireYears, b.RetireDate,c.Place
FROM dbo.eEmployee AS a INNER JOIN
dbo.eStatus AS b ON a.EID = b.EID INNER JOIN
dbo.eDetails AS c ON a.EID = c.EID INNER JOIN
dbo.oDepartment AS d ON a.DepID = d.DepID INNER JOIN
dbo.oJob AS e ON a.JobID = e.JobID