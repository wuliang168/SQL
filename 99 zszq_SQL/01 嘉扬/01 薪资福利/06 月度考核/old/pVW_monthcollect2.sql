-- pVW_monthcollect2
SELECT a.id, a.period, a.badge, a.name, b.kpimonth, a.InitializedTime, a.kpiReportTo, a.ClosedTime, a.SubmitTime, a.pingfen, a.pingyu, a.pingfendate, a.monthID, 
a.Initialized, a.Submit, a.Closed, a.kpidepid
FROM dbo.pEmpProcess_Month AS a
INNER JOIN dbo.pProcess_month AS b ON a.monthID = b.id
WHERE a.monthID = (select id from pProcess_month where DATEDIFF(MM,kpimonth,GETDATE())=1)