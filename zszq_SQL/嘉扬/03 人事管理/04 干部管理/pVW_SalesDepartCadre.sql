SELECT DISTINCT a.EID, a.Badge, a.Name, a.CompID, dbo.eFN_getdepid1(a.DepID) AS SupDepID, a.DepID, a.JobID, a.Status, b.JoinDate, b.JobBegindate, 
isnull(b.JobRepostdate,b.JobBegindate) AS JobRepostdate,b.JobLeavedate, DATEADD(year, 3, isnull(b.JobLeavedate,b.JobBegindate)) AS JobPreLeavedate
FROM dbo.eEmployee AS a
INNER JOIN dbo.eStatus AS b ON a.EID = b.EID
INNER JOIN dbo.oDepartment AS c ON a.EID = c.Director
WHERE (a.Status NOT IN (4, 5)) AND (c.DepType IN (2, 3))