SELECT a.EID as EID, b.Badge as Badge, b.Name as Name, b.CompID as CompID, dbo.eFN_getdepid1(b.DepID) AS SupDepID, b.DepID as DepID, 
b.JobID as JobID, b.Status as Status, e.DepType as DepType, b.EmpGrade as EmpGrade, d.HighLevel as Education, d.HighDegree as Degree,
c.JoinDate as JoinDate, ROUND(DATEDIFF(mm, c.JoinDate, GETDATE()) / 12.00, 2) AS ServingAge, 
ROUND(ROUND(DATEDIFF(mm, d.WorkBeginDate, GETDATE()) / 12.00, 2), 2) AS Seniority, d.CertNo as CertNo, a.MDID as MDID,
e.xOrder AS deporder, f.xorder AS joborder
FROM pEmployeeEmolu AS a
INNER JOIN eemployee AS b on a.EID=b.EID
INNER JOIN eStatus AS c ON a.EID = c.EID
INNER JOIN eDetails AS d ON a.EID = d.EID
INNER JOIN oDepartment AS e ON b.DepID = e.DepID
INNER JOIN oJob AS f ON b.JobID = f.JobID
WHERE b.status not in (4,5)