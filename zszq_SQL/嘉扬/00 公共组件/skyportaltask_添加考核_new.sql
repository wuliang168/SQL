-- skyportaltask

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[skyportaltask]
AS

-- 
-- SELECT N'<a href="#" onclick="PortalUtil.LoadURL(''../flow/runtime/taskmain.aspx?flowid=' + cast(flowid AS varchar(10)) + N''')">您有<font color="red">' +
-- cast(count(*) AS varchar(10)) + N'</font>条待处理的' + caption + '</a>' AS url, approver, 1 AS id
-- FROM (SELECT b.flowid, 5256 approver, c.caption, a.instancEID
-- FROM skywftask a JOIN skywfInstance b ON a.instancEID = b.InstancEID JOIN skywfflow c ON b.flowid = c.id
-- UNION
-- SELECT b.flowid, agent, c.caption, a.instancEID
-- FROM skywftask a JOIN skywfInstance b ON a.instancEID = b.InstancEID JOIN skywfflow c ON b.flowid = c.id
-- WHERE AgentStartDate IS NOT NULL AND AgentEndDate IS NOT NULL AND AgentStartDate <= getdate()
-- AND AgentEndDate >= getdate())
-- a GROUP BY approver, flowid, caption


-- 异常考勤确认
SELECT DISTINCT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600052'',''考勤确认'')">请您确认的异常考勤</a>' AS url,
ISNULL(a.ReportToDaily,5256) AS approver,2 AS id
from BS_YC_DK a
where ISNULL(Initialized, 0) = 1 AND ISNULL(SUBMIT, 0) = 0 AND ISNULL(OUTID,0)=0

-- 异常考勤说明
UNION
SELECT DISTINCT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600051'',''异常考勤说明'')">请您说明未打卡原因或补充外出登记</a>' AS url,
ISNULL(a.EID, 5256) AS approver,2 AS id
FROM BS_YC_DK a
WHERE ISNULL(a.Initialized, 0) = 0 AND ISNULL(a.SUBMIT, 0) = 0
---- 仅限今年
AND datediff(yy,a.TERM,getdate())<1

-- 外出登记确认
UNION
SELECT distinct N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600201'',''外出考勤确认'')">请您确认的外出记录</a>' AS url, 
a.ReportTo approver, 2 AS id
FROM aOut_register a
WHERE ISNULL(a.Initialized, 0)=1 AND ISNULL(a.SUBMIT, 0) = 0 and a.ReportTo is not NULL

-- 月工作计划与汇总(旧)
UNION
SELECT DISTINCT 
N'<a href="#" onclick="moveTo(''1.0.600020'',''leftid^' + cast(a.MonthID AS nvarchar(15)) + 
N''',''绩效首页'')">请您于本月15日前制定' + cast(month(a.period) AS varchar(10)) + N'月份工作计划</a>' AS url, 
ISNULL(a.EID, 5256) AS approver,3 AS id
FROM PEMPPROCESS_MONTH a
WHERE ISNULL(a.Initialized,0) = 0 AND ISNULL(a.Closed,0) = 0 
AND a.monthID=(select id from pProcess_month where ISNULL(Initialized,0)=1 and ISNULL(Submit,0)=0)


-- 月工作计划与汇总_上月(旧)
UNION
SELECT DISTINCT 
N'<a href="#" onclick="moveTo(''1.0.600020'',''leftid^' + cast(a.MonthID AS nvarchar(15)) + 
N''',''绩效首页'')">请您先修改' + cast(month(a.period) AS varchar(10)) + N'月份工作计划，再'
+ cast(month(DATEADD(mm,1,a.period)) AS varchar(10)) + N'对月份工作计划进行评分</a>' AS url, 
ISNULL(a.EID, 5256) AS approver,2 AS id
FROM PEMPPROCESS_MONTH a
WHERE ISNULL(a.Initialized, 0) = 0 AND ISNULL(a.Closed, 0) = 1 AND a.pStatus=2

-- 月工作计划与汇总(新)
--UNION
--SELECT DISTINCT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.540010'',''绩效首页'')">请您于本月15日前制定' + 
--cast(MONTH(a.KPIMonth) AS varchar(10)) + N'月份工作计划</a>' AS url, 
--a.EID AS approver,3 AS id
--FROM pMonth_Score a
--WHERE ISNULL(a.Initialized, 0) = 0 AND ISNULL(a.Closed, 0) = 0 
--AND YEAR(a.KPIMonth)=YEAR(getdate()) AND MONTH(a.KPIMonth)=MONTH(getdate()) AND DATEPART(dd,getdate()) BETWEEN 1 AND 15

-- 月工作计划与汇总(个人修改)
--UNION
--SELECT DISTINCT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600120'',''绩效首页'')">请您制定' + 
--cast(month(a.period) AS varchar(10)) + N'月份工作计划</a>' AS url, 
--b.EID AS approver,3 AS id
--FROM PEMPPROCESS_MONTH a, eemployee b
--WHERE a.badge = b.Badge  AND ISNULL(a.Initialized, 0) = 0
--AND a.monthID IN (43) AND a.depid=357

-- 月工作计划评分(旧)
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.600021'',''leftid^' + cast(a.MonthID AS nvarchar(15)) + 
N''',''月度计划评分'')">请您于本月底前考核下属上月度工作完成情况</a>' AS url, 
ISNULL(a.kpiReportTo, 5256) AS approver, 3 AS id
FROM pEmpProcess_Month a
WHERE (a.pstatus in (0,1) or (a.pstatus=3 and ISNULL(a.IsReSubmit,0)=1))
AND A.MONTHID=(select id from pProcess_month where DATEDIFF(mm,kpimonth,getdate())=1)
AND DATEPART(dd,GETDATE()) BETWEEN 16 AND 31
AND ISNULL(a.kpiReportTo,0) <> 0 and a.EID is not NULL

-- 月工作计划评分(历史)(旧)
UNION
SELECT DISTINCT 
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600090'',''月度计划评分(历史)'')">请您考核下属月度工作(历史)完成情况</a>' AS url,
ISNULL(a.kpiReportTo, 5256) AS approver, 3 AS id
FROM pEmpProcess_Month a
WHERE A.pstatus=4
AND ISNULL(a.kpiReportTo,0) <> 0

-- 月工作计划评分(新)
--UNION
--SELECT DISTINCT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.540020'',''月度计划评分'')">请您于本月30日前考核下属上月度工作完成情况</a>' AS url, 
--a.kpiReportTo AS approver, 3 AS id
--FROM pMonth_Score a
--WHERE ISNULL(a.Closed, 0)  = 0
--AND A.MONTHID=(select id from pProcess_month where DATEPART(yy,kpimonth)=DATEPART(yy,getdate()) AND DATEPART(mm,kpimonth)=DATEPART(mm,getdate())-1)
--AND DATEPART(dd,GETDATE()) BETWEEN 16 AND 31
--AND ISNULL(a.kpiReportTo,0) <> 0

-- 月度工作日志空缺超过5天(待后续优化)
UNION
SELECT DISTINCT 
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600067'',''绩效首页'')">您' + 
cast(datepart(m, mm) AS varchar(10)) + N'月工作日志空缺超过5天，请补充。</a>' AS url, 
ISNULL(b.EID, 5256) AS approver, 7 AS id
FROM pvw_Workrecord b
WHERE diffdays >= 5


------------- 后备人才选拔 ------------
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570310'',''leftid^' + cast(a.Director AS nvarchar(15)) + 
N''',''后备人才选拔工作'')">请您完成后备人才选拔工作</a>' AS url, 
a.Director AS approver, 1 AS id
FROM pReserveTalentsDep a,pReserveTalents_Process b
WHERE a.Date=b.Date AND ISNULL(b.Submit,0)=1 AND ISNULL(b.Closed,0)=0
AND ISNULL(a.IsSubmit,0)=0


------------- 年度MD职级及薪酬 ------------
-- 部门MD职级及薪酬调整
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.520010'',''leftid^' + cast(a.DepID AS nvarchar(15)) + 
N''',''MD职级及薪酬调整'')">请您完成' + cast(datepart(yy, dateadd(yy,1,a.Date)) AS varchar(10)) + 
N'年度' + (select DepAbbr from oDepartment where DepID=a.DepID) + N'MD职级及薪酬调整</a>' AS url, 
a.Director AS approver, 1 AS id
FROM pYear_MDSalaryModifyDep a,pYear_MDSalaryModify_Process b
WHERE a.Date=b.Date AND a.IsDepSubmit is NULL
AND ISNULL(b.Submit,0)=1 AND ISNULL(b.Closed,0)=0 AND ISNULL(a.IsClosed,0)=0
-- 部门MD职级及薪酬HR调整反馈
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.520020'',''leftid^' + cast(a.DepID AS nvarchar(15)) + 
N''',''MD职级及薪酬调整确认'')">请您完成' + cast(datepart(yy, dateadd(yy,1,a.Date)) AS varchar(10)) + 
N'年度' + (select DepAbbr from oDepartment where DepID=a.DepID) + N'MD职级及薪酬调整确认</a>' AS url, 
a.Director AS approver, 1 AS id
FROM pYear_MDSalaryModifyDep a,pYear_MDSalaryModify_Process b
WHERE a.Date=b.Date AND ISNULL(a.IsDepSubmit,0)=1 AND ISNULL(a.IsHRSubmit,0)=1 AND ISNULL(a.IsDepReSubmit,0)=0
AND ISNULL(b.Submit,0)=1 AND ISNULL(b.Closed,0)=0 AND ISNULL(a.IsClosed,0)=0


------------- 年金分配 ------------
-- 薪酬类型非营业部;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.530010'',''leftid^' +'0-'+cast(a.SalaryPayID AS nvarchar(15)) + 
N''',''企业年金分配反馈'')">请您完成' + cast(datepart(yy, a.PensionMonth) AS varchar(10)) + 
N'年' + cast(datepart(mm, a.PensionMonth) AS varchar(10)) + N'月' + b.Title + N'员工年金分配</a>' AS url, 
a.PensionContact AS approver, 1 AS id
FROM pDepPensionPerMM a,oCD_SalaryPayType b
WHERE a.SalaryPayID=b.ID AND a.SalaryPayID<>6 AND ISNULL(IsSubmit,0)=0 AND ISNULL(IsClosed,0)=0 
and a.PensionContact is not NULL
-- 薪酬类型为营业部;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.530020'',''leftid^' + cast(b.DepID AS nvarchar(15)) +'-6'+
N''',''企业年金分配反馈'')">请您完成' + cast(datepart(yy, a.PensionMonth) AS varchar(10)) + 
N'年' + cast(datepart(mm, a.PensionMonth) AS varchar(10)) + N'月' + b.DepAbbr + N'员工年金分配</a>' AS url, 
a.PensionContact AS approver, 1 AS id
FROM pDepPensionPerMM a,odepartment b
WHERE ISNULL(a.DepID,a.SupDepID)=b.DepID AND a.SalaryPayID=6 AND ISNULL(IsSubmit,0)=0 AND ISNULL(IsClosed,0)=0 
and a.PensionContact is not NULL


------------- 年金参与员工分配 ------------
-- 总部、子公司;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.530110'',''leftid^' + cast(a.EID AS nvarchar(10)) +'-'+ cast(a.pPensionUpdateID AS varchar(4))+
N''',''企业年金分配参与员工'')">请您确认' + N'参加'+ cast(YEAR(b.PensionYearBegin) AS varchar(4))+'-'+cast(YEAR(b.PensionYearEnd) AS varchar(4)) 
+ N'年度企业年金分配</a>' AS url, 
a.EID AS approver, 1 AS id
FROM pPensionUpdatePerEmp_Register a,pPensionUpdate b,pVW_employee c
where ISNULL(a.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0 and a.pPensionUpdateID=b.ID
and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 and a.EID=c.EID and c.DepType in (1,4)
-- 营业部;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.530120'',''leftid^' + cast(ISNULL(a.DepID,a.SupDepID) AS nvarchar(15)) +'-'+ cast(a.pPensionUpdateID AS varchar(4))+
N''',''企业年金分配参与员工'')">请您确认' + (select DepAbbr from odepartment where DepID=ISNULL(a.DepID,a.SupDepID)) + N'参加'
+ cast(YEAR(b.PensionYearBegin) AS varchar(4))+'-'+cast(YEAR(b.PensionYearEnd) AS varchar(4)) + N'年度企业年金分配人员</a>' AS url, 
a.PensionContact AS approver, 1 AS id
FROM pPensionUpdatePerDep a,pPensionUpdate b
where ISNULL(a.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0 and a.pPensionUpdateID=b.ID
and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 and a.PensionContact is not NULL


--------------- 月度工资 ------------
---- 薪酬类型非营业部;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550010'',''leftid^' + cast(a.SalaryPayID AS nvarchar(15)) + 
N''',''月度工资分配反馈'')">请您完成' + cast(datepart(yy, a.Date) AS varchar(10)) + N'年' + 
cast(datepart(mm, a.Date) AS varchar(10)) + N'月' + b.Title + N'员工月度工资分配</a>' AS url, 
a.SalaryContact AS approver, 1 AS id
FROM pDepSalaryPerMonth a,oCD_SalaryPayType b,pSalaryPerMonth c
WHERE a.SalaryPayID=b.ID AND a.SalaryContact is not NULL AND DATEDIFF(MM,a.Date,c.Date)=0
AND ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0
AND ISNULL(c.Submit,0)=1 AND ISNULL(c.Closed,0)=0
AND a.SalaryPayID in (1,3,4,5,7,17)
---- 通讯费&过节费
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550050'',''leftid^' + cast(a.SalaryPayID AS nvarchar(15)) + 
N''',''月度工资分配反馈'')">请您完成' + cast(datepart(yy, a.Date) AS varchar(10)) + N'年' + 
cast(datepart(mm, a.Date) AS varchar(10)) + N'月' + b.Title + N'员工月度工资分配</a>' AS url, 
a.SalaryContact AS approver, 1 AS id
FROM pDepSalaryPerMonth a,oCD_SalaryPayType b,pSalaryPerMonth c
WHERE a.SalaryPayID=b.ID AND a.SalaryContact is not NULL AND DATEDIFF(MM,a.Date,c.Date)=0
AND ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0
AND ISNULL(c.Submit,0)=1 AND ISNULL(c.Closed,0)=0
AND a.SalaryPayID=20
---- 薪酬类型为营业部;
--UNION
--SELECT DISTINCT
--N'<a href="#" onclick="moveTo(''1.0.550020'',''leftid^' + cast(b.DepID AS nvarchar(15)) + 
--N''',''月度工资分配反馈'')">请您完成' + cast(datepart(yy, a.Date) AS varchar(10)) + N'年' + 
--cast(datepart(mm, a.Date) AS varchar(10)) + N'月' + b.DepAbbr + N'员工月度工资分配</a>' AS url, 
--a.SalaryContact AS approver, 1 AS id
--FROM pDepSalaryPerMonth a,odepartment b
--WHERE a.DepID=b.DepID AND a.SalaryPayID=6 AND ISNULL(IsSubmit,0)=0 AND a.SalaryContact is not NULL


------------- 月度工资统计 ------------
--UNION
--SELECT DISTINCT
--N'<a href="#" onclick="moveTo(''1.0.550310'',''leftid^' + cast(a.DepID AS nvarchar(5)) + 
--N''',''月度工资统计反馈'')">请您完成' + cast(datepart(yy, b.Date) AS varchar(10)) + N'年' + 
--cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + c.DepAbbr + N'员工工资统计</a>' AS url, 
--a.SalaryContact AS approver, 1 AS id
--FROM pSalaryPerMMSummDep a,pSalaryPerMMSumm_Process b,oDepartment c
--WHERE DATEDIFF(mm,a.Date,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
--and ISNULL(a.IsSubmit,0)=0 AND a.SalaryContact is NOT NULL AND a.DepID=c.DepID
-- 新统计功能
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550320'',''leftid^' + cast(a.DepID AS nvarchar(5)) + 
'-' + cast(a.ProcessID AS nvarchar(5)) +
N''',''月度工资统计反馈'')">请您完成' + cast(datepart(yy, b.Date) AS varchar(10)) + N'年' + 
cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + c.DepAbbr + N'员工工资统计(新)</a>' AS url, 
a.SalaryContact AS approver, 1 AS id
FROM pSalaryPerMMSummDep a,pSalaryPerMMSumm_Process b,oDepartment c
WHERE DATEDIFF(mm,a.Date,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and ISNULL(a.IsSubmit,0)=0 AND a.SalaryContact is NOT NULL AND a.DepID=c.DepID


------------- 业绩考核(月度) ------------
---- 本人考核
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.570410'',''目标责任考核'')">请您于3个工作日内对《目标任务协议书》中的业绩协议完成情况进行说明。</a>' AS url, 
a.ReportTo AS approver, 1 AS id
FROM pTrgtRspCntrDep a,pTrgtRspCntr_Process b
WHERE ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 and a.ProcessID=b.ID
and ISNULL(a.IsSubmit,0)=0 and ISNULL(a.SubmitTime,0)=0 and ISNULL(a.IsClosed,0)=0 and a.TRCLev=0
--and DATEDIFF(dd,GETDATE(),'2019-5-30 0:0:0')>0
---- 部门审核人考核
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.570415'',''目标责任考核'')">请您完成本月部门目标责任审核。</a>' AS url, 
a.ReportTo AS approver, 1 AS id
FROM pTrgtRspCntrDep a,pTrgtRspCntr_Process b
WHERE ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 and a.ProcessID=b.ID 
and ISNULL(a.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0 and a.TRCLev=1
and (select COUNT(n.ReportTo)-SUM(cast(ISNULL(n.IsSubmit,n.IsClosed) as int)) from pEMPTrgtRspCntrMM m,pTrgtRspCntrDep n
where m.EID=n.ReportTo and n.TRCLev=0 and m.ProcessID=n.ProcessID
and m.PT=a.ReportTo and m.PT is not NULL and m.ProcessID=b.ID)=0
---- 部门负责人考核
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.570420'',''目标责任考核'')">请您完成本月部门目标责任考核。</a>' AS url, 
a.ReportTo AS approver, 1 AS id
FROM pTrgtRspCntrDep a,pTrgtRspCntr_Process b
WHERE ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 and a.ProcessID=b.ID 
and ISNULL(a.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0 and a.TRCLev=2
and ((select COUNT(n.ReportTo)-SUM(cast(ISNULL(n.IsSubmit,n.IsClosed) as int)) from pEMPTrgtRspCntrMM m,pTrgtRspCntrDep n
where m.EID=n.ReportTo and n.TRCLev=0 and m.ProcessID=n.ProcessID
and m.RT=a.ReportTo and m.RT is NULL and m.ProcessID=b.ID)=0 or
(select COUNT(m.EID)-SUM(cast(m.SubmitPT as int)) from pEMPTrgtRspCntrMM m
where m.RT=a.ReportTo and m.PT is not NULL and m.ProcessID=b.ID)=0)
---- 部门负责人考核反馈
--UNION
--SELECT DISTINCT
--N'<a href="#" onclick="$x.top().LoadPortal(''1.0.570430'',''目标责任考核'')">请您完成本月部门目标责任考核反馈。</a>' AS url, 
--a.ReportTo AS approver, 1 AS id
--FROM pTrgtRspCntrDep a,pTrgtRspCntr_Process b
--WHERE ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 
--and a.ProcessID=b.ID and ISNULL(a.IsSubmit,0)=0 and a.TRCLev=3
--and (select COUNT(m.EID)-SUM(cast(m.SubmitHR as int)) from pEMPTrgtRspCntrMM m
--where m.RRT=a.ReportTo and m.ProcessID=b.ID)=0


------------- 五险一金统计 ------------
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.530220'',''leftid^' + cast(ISNULL(a.DepID2nd,a.DepID1st) AS nvarchar(5)) + 
N''',''五险一金工资扣款统计'')">请于' + cast(datepart(mm, (select min(term)+1 from lCalendar where DATEDIFF(mm,term,b.Date)=0 and xType=1)) AS varchar(2)) + N'月'
+ cast(datepart(dd, (select min(term) from lCalendar where DATEDIFF(mm,term,b.Date)=0 and xType=1)) AS varchar(2)) + N'日前递交' + c.DepAbbr
+ cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + N'工资五险一金扣款数据</a>' AS url, 
a.DepInsHFContact AS approver, 1 AS id
FROM pEMPInsuranceHousingFundDep a,pEMPInsuranceHousingFund_Process b,oDepartment c
WHERE DATEDIFF(mm,a.Month,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0 and ISNULL(a.DepID2nd,a.DepID1st)=C.DepID
AND a.DepInsHFContact is NOT NULL
AND DATEDIFF(DD,GETDATE(),(select min(term) from lCalendar where DATEDIFF(mm,term,b.Date)=0 and xType=1))>=0
--and a.DepInsHFContact in (4404)
---- 临时调整
--SELECT DISTINCT
--N'<a href="#" onclick="moveTo(''1.0.530220'',''leftid^' + cast(ISNULL(a.DepID2nd,a.DepID1st) AS nvarchar(5)) + 
--N''',''五险一金工资扣款统计'')">请于9月26日下班前递交' + c.DepAbbr
--+ cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + N'工资五险一金扣款数据</a>' AS url, 
--a.DepInsHFContact AS approver, 1 AS id
--FROM pEMPInsuranceHousingFundDep a,pEMPInsuranceHousingFund_Process b,oDepartment c
--WHERE DATEDIFF(mm,a.Month,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
--and ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0 and ISNULL(a.DepID2nd,a.DepID1st)=C.DepID
--AND a.DepInsHFContact is NOT NULL
--AND DATEDIFF(DD,GETDATE(),'2019-9-27 23:59:59')>=0


------------- 月度费用统计 ------------
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550400'',''leftid^' + cast(ISNULL(a.DepID2nd,a.DepID1st) AS nvarchar(5)) + 
N''',''月度费用统计'')">请您完成' + cast(datepart(yy, b.Month) AS varchar(10)) + N'年' + 
cast(datepart(mm, b.Month) AS varchar(10)) + N'月工资' + c.DepAbbr + N'直管人员费用统计</a>' AS url, 
a.DepSalaryContact AS approver, 1 AS id
FROM pMonthExpenseDep a,pMonthExpense_Process b,oDepartment c
WHERE DATEDIFF(mm,a.Month,b.Month)=0 AND ISNULL(a.DepID2nd,a.DepID1st)=c.DepID
AND ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 AND ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0
AND a.DepSalaryContact is not NULL


------------- 年度奖金 ------------
---- 总部
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550420'',''leftid^' + cast(a.AnnualBonusDepID AS nvarchar(5)) + 
'-' + cast(a.ProcessID AS nvarchar(5)) +
N''',''年度奖金统计反馈'')">请您完成' + c.DepAbbr + cast(datepart(yy, b.Year) AS varchar(10)) + N'年度' 
+ (select Title from oCD_AnnualBonusType where ID=a.AnnualBonusType) +N'分配</a>' AS url, 
a.Director AS approver, 1 AS id
FROM pYear_AnnualBonusDep a,pYear_AnnualBonus_Process b,oDepartment c
WHERE a.ProcessID=b.ID
and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0
AND a.AnnualBonusDepID=c.DepID AND c.DepID=780
---- 一级部门
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550410'',''leftid^' + cast(a.AnnualBonusDepID AS nvarchar(5)) + 
'-' + cast(a.ProcessID AS nvarchar(5)) +
N''',''年度奖金统计反馈'')">请您完成' + c.DepAbbr + cast(datepart(yy, b.Year) AS varchar(10)) + N'年度' 
+ (select Title from oCD_AnnualBonusType where ID=a.AnnualBonusType) +N'分配</a>' AS url, 
a.Director AS approver, 1 AS id
FROM pYear_AnnualBonusDep a,pYear_AnnualBonus_Process b,oDepartment c
WHERE a.ProcessID=b.ID
and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0 AND ISNULL(a.AnnualBonusDep1stTotal,0)<>0
AND a.AnnualBonusDepID=c.DepID AND c.DepGrade=1
---- 二级部门
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550410'',''leftid^' + cast(a.AnnualBonusDepID AS nvarchar(5)) + 
'-' + cast(a.ProcessID AS nvarchar(5)) +
N''',''年度奖金统计反馈'')">请您完成' + c.DepAbbr + cast(datepart(yy, b.Year) AS varchar(10)) + N'年度' 
+ (select Title from oCD_AnnualBonusType where ID=a.AnnualBonusType) +N'分配</a>' AS url, 
a.Director AS approver, 1 AS id
FROM pYear_AnnualBonusDep a,pYear_AnnualBonus_Process b,oDepartment c
WHERE a.ProcessID=b.ID
and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.IsSubmit=0 AND ISNULL(a.IsClosed,0)=0
AND a.AnnualBonusDepID=c.DepID AND c.DepGrade=2


------------- 年度评优 ------------
---- 部门负责人(含展业精英含投理顾)
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.510020'',''leftid^' + cast(a.AppraiseDepID AS nvarchar(5)) + 
'-' + cast(a.AppraiseEID AS nvarchar(5)) +
N''',''年度评优'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年度'+(select DepAbbr from odepartment where DepID=a.AppraiseDepID)+N'评优工作</a>' AS url, 
a.AppraiseEID AS approver, 1 AS id
FROM pYear_DepAppraise a,pYear_AppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
AND a.AppraiseDepID<>349
---- 公司领导
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.510040'',''leftid^' + cast(a.AppraiseDepID AS nvarchar(5)) + 
'-' + cast(a.AppraiseEID AS nvarchar(5)) +
N''',''年度评优'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年度评优工作</a>' AS url, 
a.AppraiseEID AS approver, 1 AS id
FROM pYear_DepAppraise a,pYear_AppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
AND a.AppraiseDepID=349


------------- 职能部门考核 ------------
---- 部门负责人(考评)
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570011'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门自评及互评考核工作</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.Status=1
---- 部门负责人(业务部门)
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570011'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门服务考核工作</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.Status=2
---- 合规纪检
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570020'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门合规纪检考核</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
-------- 法律合规部(737)、风险管理部(359)、审计部(358)、纪检监察室(792)
and a.Status=2 and a.FDAppraiseEID in (select Director from oDepartment where DepID in (737,358,359,792))
---- 投行质控内核考核
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570021'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年投行质控内核考核考核</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.Status in (11,12)
---- 办公室、战略企划部
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570030'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门年度重点考核</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
-------- 办公室(350)、战略企划部(702)
and a.Status=2 and a.FDAppraiseEID in (select Director from oDepartment where DepID in (350,702))
---- 分管领导
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570041'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门工作考核</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.Status=3
---- 党委书记
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570042'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门党建文化工作考核</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.Status=4 and a.FDAppraiseEID=5587
---- 总裁
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570043'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门工作考核</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.Status=5 and a.FDAppraiseEID=5014
---- 董事长
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570043'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门工作考核</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.Status=6 and a.FDAppraiseEID=1022


------------- 年度考核 ------------
-- 员工自评
-- skyWindow ID: 500010
UNION ALL
SELECT N'<a href="#" onclick="moveTo(''1.0.500010'',''年度考核--自评'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年年度考核自评</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Status=0 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
and a.pYear_ID=b.ID


-------- 员工互评 --------
-- 普通员工年度互评
-- 4-总部普通员工；33-一级分支机构普通员工；34-二级分支机构普通员工；11-子公司员工
-- skyWindow ID: 501000
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501000'',''年度考核-员工互评'')">请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + N'年年度考核员工互评</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachN a
left join pYear_Process c on a.pYear_ID=c.ID
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.Score_Type1 IN (4,33,34,11)


-------- 员工履职情况、胜任素质 --------
-- 1-总部部门负责人；2-总部部门副职；31-一级分支机构负责人；32-一级分支机构副职及二级分支机构经理室成员；10-子公司部门负责人
-- skyWindow ID: 501100
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.EachLType AS nvarchar(15)) +
N''',''年度考核-履职胜任测评'')" >请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + 
N'年'+d.sEachLType+N'履职胜任测评' + '</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachL a
left join pYear_Process c on a.pYear_ID=c.ID
inner join (select Score_EID,MIN(EachLType) as EachLType,Score_Type1,sEachLType from pVW_pYear_ScoreEachL where Score_EID is not NULL and sEachLType is not NULL group by Score_EID,Score_Type1,sEachLType) d on a.Score_EID=d.Score_EID and a.EachLType=d.EachLType
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.Score_Type1 in (1,2,31,32,10)


---- 评分
---- 普通员工 ----
-- skyWindow ID: 503010
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.503010'',''leftid^' + cast(a.Score_Type1 AS nvarchar(15)) 
+ '-' + cast(a.Score_Status AS nvarchar(15)) + N''',''年度考核评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年'+c.sType+N'年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a
left join pYear_Process b on a.pYear_ID=b.ID
inner join pVW_pYear_ScoreType c on a.Score_EID=c.Score_EID and a.Score_Status=c.Score_Status and a.Score_Type1=c.Score_Type1
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.Score_Status>=2 and a.Score_Status<>7 and A.Score_Type1 in (4,33,34,11)
---- 总部中层员工 ----
-- skyWindow ID: 503030
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.503030'',''leftid^' + cast(a.Score_Type1 AS nvarchar(15)) 
+ '-' + cast(a.Score_Status AS nvarchar(15)) + N''',''年度考核评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年'+c.sType+N'年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a
left join pYear_Process b on a.pYear_ID=b.ID
inner join pVW_pYear_ScoreType c on a.Score_EID=c.Score_EID and a.Score_Status=c.Score_Status and a.Score_Type1=c.Score_Type1
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.Score_Status>=2 and a.Score_Status<>7 and A.Score_Type1 in (1,2,36,10)
---- 分支机构合规、财务员工 ----
-- skyWindow ID: 503020
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.503020'',''leftid^' + cast(a.Score_Type1 AS nvarchar(15)) 
+ '-' + cast(a.Score_Status AS nvarchar(15)) + N''',''年度考核评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年'+c.sType+N'年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a
left join pYear_Process b on a.pYear_ID=b.ID
inner join pVW_pYear_ScoreType c on a.Score_EID=c.Score_EID and a.Score_Status=c.Score_Status and a.Score_Type1=c.Score_Type1
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.Score_Status>=2 and a.Score_Status<>7 and A.Score_Type1 in (14,17,19)
---- 一级分支机构负责人 ----
-- skyWindow ID: 503040
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.503040'',''leftid^' + cast(a.Score_Type1 AS nvarchar(15)) 
+ '-' + cast(a.Score_Status AS nvarchar(15)) + N''',''年度考核评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年'+c.sType+N'年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a
left join pYear_Process b on a.pYear_ID=b.ID
inner join pVW_pYear_ScoreType c on a.Score_EID=c.Score_EID and a.Score_Status=c.Score_Status and a.Score_Type1=c.Score_Type1
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.Score_Status>=2 and a.Score_Status<>7 and A.Score_Type1=31 and A.Score_Status=2
-- skyWindow ID: 503045
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.503045'',''leftid^' + cast(a.Score_Type1 AS nvarchar(15)) 
+ '-' + cast(a.Score_Status AS nvarchar(15)) + N''',''年度考核评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年'+c.sType+N'年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a
left join pYear_Process b on a.pYear_ID=b.ID
inner join pVW_pYear_ScoreType c on a.Score_EID=c.Score_EID and a.Score_Status=c.Score_Status and a.Score_Type1=c.Score_Type1
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.Score_Status>=2 and a.Score_Status<>7 and A.Score_Type1=31 and A.Score_Status=3
---- 一级分支机构副职及二级分支机构经理室成员 ----
-- skyWindow ID: 503050
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.503050'',''leftid^' + cast(a.Score_Type1 AS nvarchar(15)) 
+ '-' + cast(a.Score_Status AS nvarchar(15)) + N''',''年度考核评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年'+c.sType+N'年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a
left join pYear_Process b on a.pYear_ID=b.ID
inner join pVW_pYear_ScoreType c on a.Score_EID=c.Score_EID and a.Score_Status=c.Score_Status and a.Score_Type1=c.Score_Type1
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.Score_Status>=2 and a.Score_Status<>7 and A.Score_Type1=32

---- 兼职合规 ----
-- skyWindow ID: 503010
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.503010'',''leftid^' + cast(a.Score_Type2 AS nvarchar(15)) 
+ '-' + cast(a.Score_Status AS nvarchar(15)) + N''',''年度考核评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年'+c.sType+N'年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a
left join pYear_Process b on a.pYear_ID=b.ID
inner join pVW_pYear_ScoreType c on a.Score_EID=c.Score_EID and a.Score_Status=c.Score_Status
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.Score_Status=7

GO