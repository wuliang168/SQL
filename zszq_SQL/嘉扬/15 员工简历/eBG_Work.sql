SELECT TOP (100000000) b.EID, b.Badge, b.Name, a.begindate, a.enddate, a.company, a.job, a.Reference,a.tel,a.institution
FROM dbo.eBG_Working AS a 
LEFT OUTER JOIN dbo.eEmployee AS b ON a.EID = b.EID
ORDER BY a.badge, a.begindate