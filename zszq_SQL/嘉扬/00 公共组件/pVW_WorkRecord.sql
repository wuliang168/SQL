-- pvw_Workrecord

SELECT f.EID,
    (select COUNT(term)
    from lCalendar
    where XTYPE=1 and DATEDIFF(DD,Term,(CASE WHEN DATEDIFF(day,c.JoinDate,d.BeginDate)>=0 THEN d.BeginDate ELSE c.JoinDate END))<=0 and datediff(dd,term,(CASE WHEN datediff(day,getdate(),d.EndDate)<=0 THEN d.EndDate ELSE getdate() END))>=0)  AS workday,
    d.Term AS mm,
    ISNULL(b.tianxieday, 0) AS tianxieday,
    (select COUNT(term)
    from lCalendar
    where XTYPE=1 and DATEDIFF(DD,Term,(CASE WHEN DATEDIFF(day,c.JoinDate,d.BeginDate)>=0 THEN d.BeginDate ELSE c.JoinDate END))<=0 and datediff(dd,term,(CASE WHEN datediff(day,getdate(),d.EndDate)<=0 THEN d.EndDate ELSE getdate() END))>=0)-ISNULL(b.tianxieday, 0)  AS diffdays,
    f.Name, f.DepID AS depid1
    , e.DepAbbr, e.DepType, e.xOrder
FROM dbo.Lleave_Periods AS d
    left JOIN dbo.eStatus AS c ON DATEDIFF(day, c.JoinDate, d.EndDate) >= 0
    inner join eEmployee f on f.EID=c.EID AND f.Status IN (1,2,3)
    left join dbo.pEmployee_register AS a ON a.EID = c.EID
    left JOIN (SELECT COUNT(DISTINCT CONVERT(varchar(10), tianxiedate, 120)) AS tianxieday, EID, CONVERT(VARCHAR(8), tianxiedate, 120) + '01' AS month
    FROM dbo.Workrecord
    WHERE (workitem IS NOT NULL) and datediff(m,GETDATE(),tianxiedate)>=-1
    GROUP BY EID, CONVERT(VARCHAR(8), tianxiedate, 120) + '01') AS b ON b.month = d.Term AND b.EID = c.EID
    inner join dbo.oDepartment AS e ON f.DepID = e.DepID
WHERE DATEDIFF(MM,d.term,GETDATE())=1
    AND a.pstatus = 1