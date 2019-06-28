-- PVW_MONTHCOLLECT

SELECT a.id,a.period,a.badge,a.name,b.kpimonth,a.InitializedTime,a.kpiReportTo,a.ClosedTime,a.SubmitTime,a.pingfen,a.pingyu,a.pingfendate,a.monthID,
a.Initialized,a.Submit,a.Closed,a.kpidepid,(case when pingfen is not NULL then 1 else NULL end) as IsPF
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.pProcess_month AS b ON a.monthID = b.id