SELECT a.term, b.eid, dbo.eFN_getdepid1st(b.depid) AS depid, b.name, 
dbo.afn_getworkday(
    CASE WHEN DATEDIFF(day, a.BeginDate, b.JoinDate) >= 0 THEN b.JoinDate ELSE a.BeginDate END, 
    CASE WHEN datediff(day, 
        CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END, 
        isnull(b.leadate, dateAdd(yy,1,CONVERT(char(5), a.term, 120) + '12-31'))) <= 0 THEN isnull(b.leadate, dateAdd(yy,1,CONVERT(char(5), a.term, 120) + '12-31')) 
        ELSE CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END END) AS YCQ, 
cast(isnull(c.YCday, 0) AS decimal(4, 2)) AS NoDutyDay, cast(isnull(c1.YCday, 0) AS decimal(4, 2)) AS NoDutyDay1, 
CAST(dbo.afn_getworkday(
    CASE WHEN DATEDIFF(day, a.BeginDate, b.JoinDate) >= 0 THEN b.JoinDate ELSE a.BeginDate END, 
    CASE WHEN datediff(day, 
        CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END, 
        isnull(b.leadate,dateAdd(yy,1,CONVERT(char(5), a.term, 120) + '12-31'))) <= 0 THEN isnull(b.leadate, dateAdd(yy,1,CONVERT(char(5), a.term, 120) + '12-31')) 
        ELSE CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10),GETDATE(), 120) END END) - isnull(c.YCday, 0) AS decimal(4, 2)) AS SJCQ, 
CAST(dbo.afn_getworkday(
    CASE WHEN DATEDIFF(day, a.BeginDate, b.JoinDate) >= 0 THEN b.JoinDate ELSE a.BeginDate END, 
    CASE WHEN datediff(day, 
        CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END, 
        isnull(b.leadate, dateAdd(yy,1,CONVERT(char(5), a.term, 120) + '12-31'))) <= 0 THEN isnull(b.leadate, dateAdd(yy,1,CONVERT(char(5), a.term, 120) + '12-31')) 
        ELSE CASE WHEN datediff(day, a.enddate, CONVERT(varchar(10), GETDATE(), 120)) > 0 THEN a.enddate ELSE CONVERT(varchar(10), GETDATE(), 120) END END) - isnull(c1.YCday, 0) AS decimal(4, 2)) AS SJCQ1
FROM lleave_Periods a
LEFT JOIN aemployee b ON datediff(day, b.joindate, enddate) >= 0 AND datediff(day, isnull(b.leadate, dateAdd(yy,1,CONVERT(char(5), a.term, 120) + '12-31')), begindate) <= 0 
/*领导未审核或不认可的异常说明  */ 
LEFT JOIN ( SELECT CONVERT(varchar(7), term, 120) + '-01' AS term, eid, COUNT(1) * 0.5 AS YCday
            FROM BS_YC_DK WHERE isnull(submit, 0) = 0 OR isnull(YCKQJG, N'') = N'不认同，非正常出勤'
            GROUP BY eid, CONVERT(varchar(7), term, 120)) c ON b.EID = c.eid AND datediff(mm, a.Term, c.term) = 0 
/*员工未提交或不认可的异常说明  */ 
LEFT JOIN ( SELECT CONVERT(varchar(7), term, 120) + '-01' AS term, eid, COUNT(1) * 0.5 AS YCday
            FROM BS_YC_DK WHERE isnull(Initialized, 0) = 0 OR isnull(YCKQJG, N'') = N'不认同，非正常出勤'
            GROUP BY eid, CONVERT(varchar(7), term, 120)) c1 ON b.EID = c1.eid AND datediff(mm, a.Term, c1.term) = 0
WHERE EXISTS (  SELECT 1
                FROM BS_DK_time
                WHERE DATEDIFF(mm, a.term, term) = 0) and DATEDIFF(mm, a.term, getdate()) < 2