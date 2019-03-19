SELECT a.kpidepid AS KPIDepID, b.Title AS KPIDepAbbr, COUNT(a.EID) AS EmpCount
FROM dbo.pEmployee_register AS a 
INNER JOIN dbo.oDepartment AS b ON a.kpidepid = b.DepID
WHERE (a.pstatus = 1) AND (ISNULL(b.isDisabled, 0) = 0)
GROUP BY a.kpidepid, b.Title