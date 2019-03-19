-- pvw_Workrecord
SELECT a.EID,
dbo.aFN_GetWorkday(
    CASE WHEN DATEDIFF(day,c.JoinDate,d.BeginDate)>=0 THEN d.BeginDate ELSE c.JoinDate END,
    CASE WHEN datediff(day,getdate(),d.EndDate)<=0 THEN d.EndDate ELSE getdate() END) AS workday, 
    d.Term AS mm,
    ISNULL(b.tianxieday, 0) AS tianxieday, 
    f.Name, dbo.eFN_getdepid1_XS(f.DepID) AS depid1
    , e.DepAbbr, e.DepType, e.xOrder
FROM dbo.Lleave_Periods AS d 
LEFT OUTER JOIN dbo.eStatus AS c ON DATEDIFF(day, c.JoinDate, d.EndDate) >= 0 AND DATEDIFF(day, getdate(), d.BeginDate) <= 0
inner join eEmployee f on f.EID=c.EID AND f.Status IN (1,2,3)
inner join dbo.pEmployee_register AS a ON a.EID = c.EID 
LEFT OUTER JOIN (SELECT COUNT(DISTINCT CONVERT(varchar(10), tianxiedate, 120)) AS tianxieday, EID, CONVERT(VARCHAR(8), tianxiedate, 120) + '01' AS mm 
FROM dbo.Workrecord WHERE (workitem IS NOT NULL) and datediff(m,GETDATE(),tianxiedate)>=-1  GROUP BY EID, CONVERT(VARCHAR(8), tianxiedate, 120) + '01') AS b ON b.mm = d.Term AND b.EID = c.EID 
inner join dbo.oDepartment AS e ON dbo.eFN_getdepid1_XS(f.DepID) = e.DepID
WHERE DATEDIFF(YY,d.term,GETDATE())=0 AND a.pstatus = 1