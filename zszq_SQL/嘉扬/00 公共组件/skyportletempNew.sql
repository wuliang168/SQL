-- skyportletempNew

SELECT a.EID AS id, a.Badge, a.Name, a.age, (CASE WHEN a.Gender = 1 THEN N'男' ELSE N'女' END) AS gender,
a.Mobile, a.office_phone, comp.CompAbbr AS comp, a.JoinDate, b.DepAbbr AS dep, a.depid1,a.depid2, c.Title AS job, 
g.Photo, ISNULL(b.Director2, 0) AS Director2, ISNULL(b.Director, 0) AS Director, h.begindate, h.enddate, h.company AS beforCompany, h.job AS beforJob
FROM dbo.eVW_employee AS a 
LEFT OUTER JOIN dbo.oDepartment AS b ON b.DepID=(case when dbo.eFN_getdeptype(a.DepID) in (1,4) then a.depid1 else a.depid2 end)
LEFT OUTER JOIN dbo.oJob AS c ON a.JobID = c.JobID 
LEFT OUTER JOIN dbo.ePhoto AS g ON a.EID = g.EID 
LEFT OUTER JOIN dbo.eBG_Working AS h ON a.EID = h.EID 
AND h.begindate =(SELECT MAX(begindate) FROM dbo.eBG_Working
WHERE EID = a.EID) 
LEFT OUTER JOIN dbo.oCompany AS comp ON a.CompID = comp.CompID
WHERE DATEDIFF(dd, a.JoinDate, GETDATE()) < 90