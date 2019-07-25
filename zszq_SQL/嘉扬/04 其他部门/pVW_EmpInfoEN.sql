-- pVW_EmpInfoEN

SELECT e.xorder AS xOrder,g.Account as OAAccount,
a.Badge as Badge, a.Name as Name,(select CompAbbr from oCompany where CompID=a.CompID) as CompAbbr, 
(select DepAbbr from oDepartment where DepID=dbo.eFN_getdepid1st(a.DepID)) as DepAbbr1st, (select DepAbbr from oDepartment where DepID=dbo.eFN_getdepid2nd(a.DepID)) as DepAbbr2nd, 
(select DepType from oDepartment where DepID=a.DepID) as DepType,
(select JobAbbr from oJob where JobID=a.JobID) as JobAbbr, (select Title from eCD_EmpGrade where ID=a.EmpGrade) as EmpGrade, (select Title from OCD_MDTYPE where ID=f.MDID) as MDID,
(select Title from ECD_EMPSTATUS where ID=a.Status) as Status, (select Title from eCD_Marriage where ID=c.Marriage) as Marriage,(select Title from eCD_Party where ID=c.party) as Party,
c.Address as Address,(select Title from eCD_City where ID=a.WorkCity) as WorkCity, 
(select Title from eCD_Country where ID=c.Country) as Country, (select Title from eCD_CertType where ID=c.CertType) as CertType, c.CertNo as CertNo, 
(select Title from eCD_Gender where ID=c.Gender) as Gender, c.BirthDay as BirthDay, DATEDIFF(yy, c.BirthDay, GETDATE()) AS Age, 
(select Title from eCD_EduType where ID=c.HighLevel) as HighLevel, (select Title from eCD_DegreeType where ID=c.HighDegree) as HighDegree, 
b.JoinDate as JoinDate, ROUND(DATEDIFF(mm, b.JoinDate, GETDATE()) / 12.00 + ISNULL(b.Cyear_adjust, 0), 2) AS Cyear, 
b.JobBegindate as JobBegindate, ROUND(DATEDIFF(mm, b.JobBegindate, GETDATE())/12.00,2) AS Jyear, 
c.WorkBeginDate as WorkBeginDate,ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) AS Wyear, 
b.isProb as isProb, b.ProbTerm as ProbTerm, b.ProbEndDate as ProbEndDate, 
b.ConCount as ConCount, (select Title from eCD_Contract where ID=b.contract) as contract, (select Title from eCD_ConType where ID=b.ConType) as ConType, 
b.ConProperty as ConProperty, b.ConBeginDate as ConBeginDate, b.ConTerm as ConTerm, b.ConEndDate as ConEndDate,b.LeaDate as LeaDate
FROM dbo.eEmployee AS a 
INNER JOIN dbo.eStatus AS b ON a.EID = b.EID 
INNER JOIN dbo.eDetails AS c ON a.EID = c.EID 
INNER JOIN dbo.oDepartment AS d ON a.DepID = d.DepID 
INNER JOIN dbo.oJob AS e ON a.JobID = e.JobID
INNER JOIN dbo.pEmployeeEmolu AS f ON a.EID=f.EID
INNER JOIN dbo.SkySecUser AS g on a.EID=g.EID
where a.Status not in (5)