select KPIMonthID as KPIMonthID,KPIDepID as KPIDepID,kpiReportTo as KPIReportTo,
已开启月度考核 as MonthProcessStart,已填写月度计划 as PlanSummFIN,已填写月度自评 as MonthScoopFIN,已完成考核评审 as MonthGradeFIN,已关闭月度考核 as MonthProcessClose,
已开启月度考核+已填写月度计划+已填写月度自评+已完成考核评审+已关闭月度考核 as MonthProcessDepSUM,
CONVERT(decimal(5,4),(已填写月度计划+已填写月度自评+已完成考核评审+已关闭月度考核)*1.0/(已开启月度考核+已填写月度计划+已填写月度自评+已完成考核评审+已关闭月度考核)) as PlanSummRatio,
CONVERT(decimal(5,4),(已填写月度自评+已完成考核评审+已关闭月度考核)*1.0/(已开启月度考核+已填写月度计划+已填写月度自评+已完成考核评审+已关闭月度考核)) as MonthScoopRatio,
CONVERT(decimal(5,4),(已完成考核评审+已关闭月度考核)*1.0/(已开启月度考核+已填写月度计划+已填写月度自评+已完成考核评审+已关闭月度考核)) as MonthGradeRatio
from
(SELECT a.KPIMonthID,b.kpidepid,b.kpiReportTo,
CASE 
WHEN a.KPIStatus IN (1) THEN N'已开启月度考核' 
WHEN a.KPIStatus IN (2) THEN N'已填写月度计划' 
WHEN a.KPIStatus IN (3) THEN N'已填写月度自评'
WHEN a.KPIStatus IN (4) THEN N'已完成考核评审'
WHEN a.KPIStatus IN (5) THEN N'已关闭月度考核'
END as KPIStatus
FROM pMonth_Score a 
inner join pEmployee_register b on a.EID=b.EID and b.pstatus=1
) as a
PIVOT (count(KPIStatus) FOR KPIStatus IN (已开启月度考核,已填写月度计划,已填写月度自评,已完成考核评审,已关闭月度考核)) as b