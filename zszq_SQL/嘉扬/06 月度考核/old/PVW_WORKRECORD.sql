SELECT a.EID, dbo.aFN_GetWorkday(CASE WHEN DATEDIFF(day, d .BeginDate, c.JoinDate) >= 0 THEN c.JoinDate ELSE d .BeginDate END, CASE WHEN datediff(day, CASE WHEN datediff(day, d .enddate, 
CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN d .enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END, isnull(c.leadate, '2048-01-01')) <= 0 THEN isnull(c.leadate, '2048-01-01') 
ELSE CASE WHEN datediff(day, d .enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN d .enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END END) AS workday, d.Term AS mm, 
ISNULL(b.tianxieday, 0) AS tianxieday, c.Name, dbo.eFN_getdepid1_XS(c.DepID) AS depid1, e.DepAbbr, e.DepType, e.xOrder
FROM dbo.Lleave_Periods AS d 
LEFT OUTER JOIN dbo.eVW_employee AS c ON DATEDIFF(day, c.JoinDate, d.EndDate) >= 0 AND DATEDIFF(day, ISNULL(c.LeaDate, '2048-01-01'), d.BeginDate) <= 0 AND c.Status IN (1, 2, 3) 
LEFT OUTER JOIN dbo.pEmployee_register AS a ON a.EID = c.EID 
LEFT OUTER JOIN (SELECT COUNT(DISTINCT CONVERT(varchar(10), tianxiedate, 120)) AS tianxieday, 
EID, CONVERT(VARCHAR(8), tianxiedate, 120) + '01' AS mm
FROM dbo.Workrecord
WHERE (workitem IS NOT NULL)
GROUP BY EID, CONVERT(VARCHAR(8), tianxiedate, 120) + '01') AS b ON b.mm = d.Term AND b.EID = c.EID 
LEFT OUTER JOIN dbo.oDepartment AS e ON dbo.eFN_getdepid1_XS(c.DepID) = e.DepID
WHERE (a.pstatus = 1) AND (DATEDIFF(YYYY, d.Term, '2018-03-01') <= 0) AND (DATEDIFF(b.mm, d.Term, GETDATE()) >= 0)