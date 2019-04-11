select a.KPIMonth as KPIMonth,a.EID as EID,b.KPIDepID as KPIDepID,b.KPIStatus as KPIStatus,b.KPIReportTo as KPIReportTo,b.Score as Score
from pMonth_PlanSumm as a
inner join pMonth_ProcessScore as b on a.EID=b.EID