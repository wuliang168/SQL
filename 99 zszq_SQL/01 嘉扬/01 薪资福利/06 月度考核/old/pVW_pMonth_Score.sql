SELECT a.id as ID, a.period as Period, b.kpimonth as KPIMonth, a.monthID as MonthID, NULL AS XID, a.badge as Badge, a.name as Name,
a.kpiReportTo as KPIReportTo, a.kpidepid as KPIDepID, a.pingfen as Score, a.pingyu as Comment, a.pingfendate as ScoreTime,
a.Initialized as Initialized, a.InitializedTime as InitializedTime, a.Submit as Submit, a.SubmitTime as SubmitTime, a.Closed as Closed, a.ClosedTime as ClosedTime
FROM dbo.pMonth_Score AS a
INNER JOIN dbo.pProcess_month AS b ON a.monthID = b.id