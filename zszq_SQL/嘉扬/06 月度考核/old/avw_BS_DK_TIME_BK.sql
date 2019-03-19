SELECT     a.Term, b.EID, dbo.eFN_getdepid1(b.DepID) AS depid, b.Name, dbo.aFN_GetWorkday(CASE WHEN DATEDIFF(day, a.BeginDate, b.JoinDate) >= 0 THEN b.JoinDate ELSE a.BeginDate END, 
                      CASE WHEN datediff(day, CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END, isnull(b.leadate, 
                      '2048-01-01')) <= 0 THEN isnull(b.leadate, '2048-01-01') ELSE CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), 
                      GETDATE(), 120) END END) AS YCQ, CAST(ISNULL(c.YCday, 0) AS decimal(4, 2)) AS NoDutyDay, CAST(ISNULL(c1.YCday, 0) AS decimal(4, 2)) AS NoDutyDay1, 
                      CAST(dbo.aFN_GetWorkday(CASE WHEN DATEDIFF(day, a.BeginDate, b.JoinDate) >= 0 THEN b.JoinDate ELSE a.BeginDate END, CASE WHEN datediff(day, CASE WHEN datediff(day, a.enddate, 
                      CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END, isnull(b.leadate, '2048-01-01')) <= 0 THEN isnull(b.leadate, '2048-01-01') 
                      ELSE CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END END) - ISNULL(c.YCday, 0) AS decimal(4, 
                      2)) AS SJCQ, CAST(dbo.aFN_GetWorkday(CASE WHEN DATEDIFF(day, a.BeginDate, b.JoinDate) >= 0 THEN b.JoinDate ELSE a.BeginDate END, CASE WHEN datediff(day, CASE WHEN datediff(day, 
                      a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END, isnull(b.leadate, '2048-01-01')) <= 0 THEN isnull(b.leadate, '2048-01-01') 
                      ELSE CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END END) - ISNULL(c1.YCday, 0) AS decimal(4, 
                      2)) AS SJCQ1
FROM         dbo.Lleave_Periods AS a LEFT OUTER JOIN
                      dbo.aEmployee AS b ON DATEDIFF(day, b.JoinDate, a.EndDate) >= 0 AND DATEDIFF(day, ISNULL(b.LeaDate, '2048-01-01'), a.BeginDate) <= 0 LEFT OUTER JOIN
                          (SELECT     CONVERT(varchar(7), term, 120) + '-01' AS term, eid, COUNT(1) * 0.5 AS YCday
                            FROM          dbo.BS_YC_DK
                            WHERE      (ISNULL(Submit, 0) = 0) OR
                                                   (ISNULL(YCKQJG, N'') = N'不认同，非正常出勤')
                            GROUP BY eid, CONVERT(varchar(7), term, 120)) AS c ON b.EID = c.eid AND DATEDIFF(mm, a.Term, c.term) = 0 LEFT OUTER JOIN
                          (SELECT     CONVERT(varchar(7), term, 120) + '-01' AS term, eid, COUNT(1) * 0.5 AS YCday
                            FROM          dbo.BS_YC_DK AS BS_YC_DK_1
                            WHERE      (ISNULL(Initialized, 0) = 0) OR
                                                   (ISNULL(YCKQJG, N'') = N'不认同，非正常出勤')
                            GROUP BY eid, CONVERT(varchar(7), term, 120)) AS c1 ON b.EID = c1.eid AND DATEDIFF(mm, a.Term, c1.term) = 0
WHERE     (DATEPART(yy, a.Term) = DATEPART(yy, GETDATE())) AND (dbo.eFN_getdepid1(b.DepID) = 357) AND EXISTS
                          (SELECT     1 AS Expr1
                            FROM          dbo.BS_DK_time
                            WHERE      (DATEDIFF(mm, a.Term, term) = 0))