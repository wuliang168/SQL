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
FROM pVW_EMPReportToDaily a
WHERE EXISTS (select 1 from BS_YC_DK where EID=a.EID AND ISNULL(Initialized, 0) = 1 AND ISNULL(SUBMIT, 0) = 0 AND ISNULL(OUTID,0)=0)

-- 异常考勤说明
UNION
SELECT DISTINCT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600051'',''异常考勤说明'')">请您说明未打卡原因或补充外出登记</a>' AS url,
ISNULL(a.EID, 5256) AS approver,2 AS id
FROM BS_YC_DK a
WHERE ISNULL(a.Initialized, 0) = 0 AND ISNULL(a.SUBMIT, 0) = 0
---- 仅限今年和去年
AND datediff(yy,a.TERM,getdate())<2
-- AND (datediff(M,getdate(),a.TERM)=0 or datediff(M,getdate(),a.TERM)=-1)

-- 外出登记确认
UNION
SELECT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600201'',''外出考勤确认'')">请您确认的外出记录</a>' AS url, 
CASE WHEN dbo.eFN_getdepid1_XS(b.DEPID) = b.DEPID 
THEN (SELECT ISNULL(Director, 5256) FROM odepartment c WHERE c.depid = b.DEPID) 
ELSE (SELECT ISNULL(Director, 5256) FROM odepartment c WHERE c.depid = dbo.eFN_getdepid1_XS(b.DEPID))
END AS approver, 2 AS id
FROM aOut_register a, eemployee b
WHERE a.EID = b.EID AND ISNULL(a.Initialized, 0) = 1 AND ISNULL(a.SUBMIT, 0) = 0

-- 月工作计划与汇总(旧)
UNION
SELECT DISTINCT 
N'<a href="#" onclick="moveTo(''1.0.600020'',''leftid^' + cast(a.MonthID AS nvarchar(15)) + 
N''',''绩效首页'')">请您于本月15日前制定' + cast(month(a.period) AS varchar(10)) + N'月份工作计划</a>' AS url, 
ISNULL(b.EID, 5256) AS approver,3 AS id
FROM PEMPPROCESS_MONTH a, eemployee b
WHERE a.badge = b.Badge AND ISNULL(a.Initialized, 0) = 0 AND ISNULL(a.Closed, 0) = 0 
AND a.monthID=(select id from pProcess_month where DATEDIFF(mm,kpimonth,getdate())=0)


-- 月工作计划与汇总_上月(旧)
UNION
SELECT DISTINCT 
N'<a href="#" onclick="moveTo(''1.0.600020'',''leftid^' + cast(a.MonthID AS nvarchar(15)) + 
N''',''绩效首页'')">请您先修改' + cast(month(a.period) AS varchar(10)) + N'月份工作计划，再'
+ cast(month(DATEADD(mm,1,a.period)) AS varchar(10)) + N'对月份工作计划进行评分</a>' AS url, 
ISNULL(b.EID, 5256) AS approver,2 AS id
FROM PEMPPROCESS_MONTH a, eemployee b
WHERE a.badge = b.Badge AND ISNULL(a.Initialized, 0) = 0 AND ISNULL(a.Closed, 0) = 1 AND a.pStatus=2

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
FROM pvw_pEmpProcess_Month a
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
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550310'',''leftid^' + cast(a.DepID AS nvarchar(5)) + 
N''',''月度工资统计反馈'')">请您完成' + cast(datepart(yy, b.Date) AS varchar(10)) + N'年' + 
cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + c.DepAbbr + N'员工工资统计</a>' AS url, 
a.SalaryContact AS approver, 1 AS id
FROM pSalaryPerMMSummDep a,pSalaryPerMMSumm_Process b,oDepartment c
WHERE DATEDIFF(mm,a.Date,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and ISNULL(a.IsSubmit,0)=0 AND a.SalaryContact is NOT NULL AND a.DepID=c.DepID
-- 新统计功能
--UNION
--SELECT DISTINCT
--N'<a href="#" onclick="moveTo(''1.0.550320'',''leftid^' + cast(a.DepID AS nvarchar(5)) + 
--'-' + cast(a.ProcessID AS nvarchar(5)) +
--N''',''月度工资统计反馈'')">请您完成' + cast(datepart(yy, b.Date) AS varchar(10)) + N'年' + 
--cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + c.DepAbbr + N'员工工资统计(新)</a>' AS url, 
--a.SalaryContact AS approver, 1 AS id
--FROM pSalaryPerMMSummDep a,pSalaryPerMMSumm_Process b,oDepartment c
--WHERE DATEDIFF(mm,a.Date,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
--and ISNULL(a.IsSubmit,0)=0 AND a.SalaryContact is NOT NULL AND a.DepID=c.DepID


------------- 业绩考核(月度) ------------
---- 本人考核
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.570410'',''目标责任考核'')">请您于3个工作日内对《目标任务协议书》中的业绩协议完成情况进行说明。</a>' AS url, 
a.ReportTo AS approver, 1 AS id
FROM pTrgtRspCntrDep a,pTrgtRspCntr_Process b
WHERE ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 
and ISNULL(a.IsSubmit,0)=0 and ISNULL(a.SubmitTime,0)=0 and ISNULL(a.IsClosed,0)=0 and a.TRCLev=0
--and DATEDIFF(dd,GETDATE(),'2019-5-30 0:0:0')>0
---- 部门审核人考核
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.570415'',''目标责任考核'')">请您完成本月部门目标责任审核。</a>' AS url, 
a.ReportTo AS approver, 1 AS id
FROM pTrgtRspCntrDep a,pTrgtRspCntr_Process b
WHERE ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 
and Datediff(mm,b.TRCMonth,a.TRCMonth)=0 and ISNULL(a.IsSubmit,0)=0 and a.TRCLev=1
and (select COUNT(m.EID)-COUNT(m.SubmitSelf) from pEMPTrgtRspCntrMM m,pVW_TrgtRspCntrReportTo n
where m.EID=n.EID and n.PreviewTo=a.ReportTo and n.PreviewTo is not NULL)=0
---- 部门负责人考核
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.570420'',''目标责任考核'')">请您完成本月部门目标责任考核。</a>' AS url, 
a.ReportTo AS approver, 1 AS id
FROM pTrgtRspCntrDep a,pTrgtRspCntr_Process b
WHERE ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 
and Datediff(mm,b.TRCMonth,a.TRCMonth)=0 and ISNULL(a.IsSubmit,0)=0 and a.TRCLev=2
and ((select COUNT(m.EID)-SUM(cast(m.SubmitSelf as int)) from pEMPTrgtRspCntrMM m,pVW_TrgtRspCntrReportTo n
where m.EID=n.EID and n.ReportTo=a.ReportTo and n.PreviewTo is NULL)=0 or
(select COUNT(m.EID)-SUM(cast(m.SubmitPT as int)) from pEMPTrgtRspCntrMM m,pVW_TrgtRspCntrReportTo n
where m.EID=n.EID and n.ReportTo=a.ReportTo and n.PreviewTo is not NULL)=0)
---- 部门负责人考核反馈
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.570430'',''目标责任考核'')">请您完成本月部门目标责任考核反馈。</a>' AS url, 
a.ReportTo AS approver, 1 AS id
FROM pTrgtRspCntrDep a,pTrgtRspCntr_Process b
WHERE ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 
and Datediff(mm,b.TRCMonth,a.TRCMonth)=0 and ISNULL(a.IsSubmit,0)=0 and a.TRCLev=3
and (select COUNT(m.EID)-COUNT(m.SubmitHR) from pEMPTrgtRspCntrMM m,pVW_TrgtRspCntrReportTo n
where m.EID=n.EID and n.ReportTo=a.ReportTo)=0


------------- 五险一金统计 ------------
UNION
--SELECT DISTINCT
--N'<a href="#" onclick="moveTo(''1.0.530220'',''leftid^' + cast(ISNULL(a.DepID2nd,a.DepID1st) AS nvarchar(5)) + 
--N''',''五险一金工资扣款统计'')">请于' + cast(datepart(mm, (select min(term)+1 from lCalendar where DATEDIFF(mm,term,b.Date)=0 and xType=1)) AS varchar(2)) + N'月'
--+ cast(datepart(dd, (select min(term) from lCalendar where DATEDIFF(mm,term,b.Date)=0 and xType=1)) AS varchar(2)) + N'日前递交' + c.DepAbbr
--+ cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + N'工资五险一金扣款数据</a>' AS url, 
--a.DepInsHFContact AS approver, 1 AS id
--FROM pEMPInsuranceHousingFundDep a,pEMPInsuranceHousingFund_Process b,oDepartment c
--WHERE DATEDIFF(mm,a.Month,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
--and ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0 and ISNULL(a.DepID2nd,a.DepID1st)=C.DepID
--AND a.DepInsHFContact is NOT NULL
--AND DATEDIFF(DD,GETDATE(),(select min(term) from lCalendar where DATEDIFF(mm,term,b.Date)=0 and xType=1))>=0
---- 临时调整
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.530220'',''leftid^' + cast(ISNULL(a.DepID2nd,a.DepID1st) AS nvarchar(5)) + 
N''',''五险一金工资扣款统计'')">请于9月26日下班前递交' + c.DepAbbr
+ cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + N'工资五险一金扣款数据</a>' AS url, 
a.DepInsHFContact AS approver, 1 AS id
FROM pEMPInsuranceHousingFundDep a,pEMPInsuranceHousingFund_Process b,oDepartment c
WHERE DATEDIFF(mm,a.Month,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0 and ISNULL(a.DepID2nd,a.DepID1st)=C.DepID
AND a.DepInsHFContact is NOT NULL
AND DATEDIFF(DD,GETDATE(),'2019-9-27 23:59:59')>=0


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
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.510020'',''年度评优'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年度评优工作</a>' AS url, 
a.AppraiseEID AS approver, 1 AS id
FROM pYear_DepAppraise a,pYear_AppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
------ 不包含总裁级别(赵伟江(1026)、高玮(1027)、盛建龙(1028)、张晖(1317))
AND a.AppraiseEID not in (1026,1027,1028,1317)
---- 公司领导
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.510040'',''年度评优'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年度评优工作</a>' AS url, 
a.AppraiseEID AS approver, 1 AS id
FROM pYear_DepAppraise a,pYear_AppraiseProcess b,eEmployee c
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
-- 不包含公司一把手(许向军(1033)、何蔚玲(1063)、邓宏光(1032)、刘文雷(1294)、许运凯(4774))
AND a.AppraiseEID=c.EID AND c.DepID=349 AND a.AppraiseEID in (1026,1027,1028,1317)


------------- 职能部门考核 ------------
---- 部门负责人(考评)
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570011'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门自评及互评考核工作</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
---- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
---- 行政管理总部(352)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
---- 法律合规部(737)、风险管理部(359)、审计部(358)
and a.Status=1 and a.FDAppraiseEID in (select Director from oDepartment where DepID in (702,355,356,354,360,350,351,352,353,744,745,737,359,358))
---- 部门负责人(业务部门)
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570035'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门考核工作</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
-------- 浙商证券研究所(361)、网点运营管理总部(362)、财富管理中心（事业部）(715)、投资银行(695->683)、投资银行质量控制总部(670)、投资银行内核办公室(786)
-------- 证券投资部(380)、融资融券部(381)、衍生品经纪业务总部(382)、FICC事业部(383)、金融衍生品部(394)、经纪业务总部(738)、托管业务部(789)
-------- 浙商资管(393->544)、浙商资本(392)
and a.Status=1 and a.FDAppraiseEID in (select Director from oDepartment where DepID in (361,362,715,683,670,786,380,381,382,383,394,738,789,544,392))
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
--------- 全体员工自评 ---------
-- 中层员工(非分公司/一级营业部负责人) 自评
-- skyWindow ID: 500020
UNION ALL
SELECT N'<a href="#" onclick="moveTo(''1.0.500020'',''年度考核--自评'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年年度考核自评</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (1,2,10,25,6,7,26) AND a.Score_Status=0 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
and a.pYear_ID=b.ID
AND a.Score_EID=(select EID from eEmployee where name=N'徐进')

-- 中层员工(分公司/一级营业部负责人) 自评
-- skyWindow ID: 500030
UNION ALL
SELECT N'<a href="#" onclick="moveTo(''1.0.500030'',''年度考核--自评'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年年度考核自评</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (24,5) AND a.Score_Status=0 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
and a.pYear_ID=b.ID
AND a.EID=(select EID from eEmployee where name=N'徐进')

-- 普通员工 自评
-- skyWindow ID: 500010
UNION ALL
SELECT N'<a href="#" onclick="moveTo(''1.0.500010'',''年度考核--自评'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年年度考核自评</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (4,11,29,12,13,14,17,19,20) AND a.Score_Status=0 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
and a.pYear_ID=b.ID
AND DATEDIFF(dd,'2019-1-15 0:0:0',GETDATE())<0


-------- 员工互评 --------
-- 普通员工年度互评
-- 4-总部普通员工；29-分公司普通员工；12-一级营业部普通员工；13-二级营业部普通员工；11-子公司员工
-- skyWindow ID: 501000
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501000'',
''年度互评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + N'年员工互评</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachN a,pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND b.Score_Type1 IN (4,11,29,12,13) AND ISNULL(a.Score_EID,5256)=b.EID
AND b.Score_Status=1 AND ISNULL(b.Initialized,0)=1
AND a.pYear_ID=c.ID


-------- 员工胜任素质 --------
-- 总部部门负责人胜任素质 测评
-- skyWindow ID: 501100
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.EachLType AS nvarchar(15)) + 
N''',''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')" >请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + 
CASE 
WHEN a.EachLType = 1 THEN N'年总部部门负责人胜任素质测评' -- 总部部门分管领导测评
WHEN a.EachLType = 2 THEN N'年总部部门负责人胜任素质互评' -- 总部部门负责人互评
WHEN a.EachLType = 3 THEN N'年总部部门负责人胜任素质测评' -- 总部部门内下属员工测评
END + '</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachL a, pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.EID=b.EID AND b.Score_Type1=1 AND ISNULL(b.Initialized,0)=1
AND b.pYear_ID=c.ID

-- 总部部门副职胜任素质 测评
-- skyWindow ID: 501100
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.EachLType AS nvarchar(15)) + 
N''',''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')" >请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + 
CASE 
WHEN a.EachLType = 5 THEN N'年总部部门副职胜任素质测评' -- 总部部门分管领导测评
WHEN a.EachLType = 6 THEN N'年总部部门副职胜任素质测评' -- 总部部门负责人测评
WHEN a.EachLType = 7 THEN N'年总部部门副职胜任素质测评' -- 总部部门内下属员工测评
END + '</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachL a, pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.EID=b.EID AND b.Score_Type1=2 AND ISNULL(b.Initialized,0)=1
AND b.pYear_ID=c.ID

-- 子公司部门负责人胜任素质 测评
-- skyWindow ID: 501100
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.EachLType AS nvarchar(15)) + 
N''',''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')" >请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + 
CASE 
WHEN a.EachLType = 11 THEN N'年子公司部门负责人胜任素质测评' -- 子公司总经理测评
WHEN a.EachLType = 12 THEN N'年子公司部门负责人胜任素质互评' -- 子公司部门负责人互评
WHEN a.EachLType = 13 THEN N'年子公司部门负责人胜任素质测评' -- 子公司部门内下属员工测评
END + '</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachL a, pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.EID=b.EID AND b.Score_Type1=10 AND ISNULL(b.Initialized,0)=1
AND b.pYear_ID=c.ID

-- 分公司负责人胜任素质 测评
-- skyWindow ID: 501100
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.EachLType AS nvarchar(15)) + 
N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + 
CASE 
WHEN a.EachLType = 21 THEN N'年分公司负责人胜任素质测评' -- 分公司分管领导测评
WHEN a.EachLType = 22 THEN N'年分公司负责人胜任素质测评' -- 分公司人员测评
END + '</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachL a, pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.EID=b.EID AND b.Score_Type1=24 AND ISNULL(b.Initialized,0)=1
AND b.pYear_ID=c.ID

-- 分公司副职胜任素质 测评
-- skyWindow ID: 501100
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.EachLType AS nvarchar(15)) + 
N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + 
CASE 
WHEN a.EachLType = 25 THEN N'年分公司副职胜任素质测评' -- 分公司负责人测评
WHEN a.EachLType = 26 THEN N'年分公司副职胜任素质测评' -- 分公司人员测评
END + '</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachL a, pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.EID=b.EID AND b.Score_Type1=25 AND ISNULL(b.Initialized,0)=1
AND b.pYear_ID=c.ID

-- 一级营业部负责人胜任素质 测评
-- skyWindow ID: 501100
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.EachLType AS nvarchar(15)) + 
N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + 
CASE 
WHEN a.EachLType = 31 THEN N'年一级营业部负责人胜任素质测评' -- 一级营业部分管领导测评
WHEN a.EachLType = 32 THEN N'年一级营业部负责人胜任素质测评' -- 一级营业部人员测评
END + '</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachL a, pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.EID=b.EID AND b.Score_Type1=5 AND ISNULL(b.Initialized,0)=1
AND b.pYear_ID=c.ID

-- 一级营业部副职胜任素质 测评
-- skyWindow ID: 501100
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.EachLType AS nvarchar(15)) + 
N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + 
CASE 
WHEN a.EachLType = 35 THEN N'年一级营业部副职胜任素质测评' -- 一级营业部负责人测评
WHEN a.EachLType = 36 THEN N'年一级营业部副职胜任素质测评' -- 一级营业部人员测评
END + '</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachL a, pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.EID=b.EID AND b.Score_Type1=6 AND ISNULL(b.Initialized,0)=1
AND b.pYear_ID=c.ID

-- 二级营业部经理室成员胜任素质 测评
-- skyWindow ID: 501100
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.EachLType AS nvarchar(15)) + 
N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成'
+ cast(datepart(yy, c.Date) AS varchar(4)) + 
CASE 
WHEN a.EachLType = 41 THEN N'年二级营业部经理室成员胜任素质测评' -- 一级营业部负责人测评
WHEN a.EachLType = 42 THEN N'年二级营业部经理室成员胜任素质测评' -- 二级营业部人员测评
END + '</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_ScoreEachL a, pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.EID=b.EID AND b.Score_Type1=7 AND ISNULL(b.Initialized,0)=1
AND b.pYear_ID=c.ID


---- 评分
---- 总部部门负责人 ----
-- 总部部门负责人 战略企划部评分
-- skyWindow ID: 502110
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502110'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--战略企划部评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部部门负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=1 AND a.Score_Status=2 
AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 总部部门负责人 分管领导评分
-- skyWindow ID: 502115
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502115'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--分管领导评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部部门负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=1 AND a.Score_Status=3
AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 总部部门负责人 其他副职领导评分
-- skyWindow ID: 502120
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502120'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--其他副职领导评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部部门负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=1 AND a.Score_Status=4
AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 总部部门负责人 主要领导评分
-- skyWindow ID: 502125
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502125'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--主要领导评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部部门负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a, pYear_Process b
WHERE a.Score_Type1=1 AND a.Score_Status=9
AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 总部部门副职 ----
-- 总部部门副职 总部部门负责人评分
-- skyWindow ID: 502130
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502130'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--总部部门负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部部门副职年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=2 AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 总部部门副职 分管领导评分
-- skyWindow ID: 502140
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502140'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--分管领导评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部部门副职年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
from pYear_Score as a,pYear_Process b
WHERE a.Score_Type1=2 AND a.Score_Status=9
AND (select COUNT(Initialized)/COUNT(ISNULL(Initialized,1)) from pYear_Score 
where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)=1
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 子公司部门负责人 ----
-- 子公司合规风控部行政负责人 子公司合规风控总监评分
-- skyWindow ID: 502150
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502150'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--子公司合规风控总监评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年子公司合规风控部行政负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=10 AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID AND a.Score_DepID in (666)
---- 子公司合规风控总监 首席风险官评分
---- skyWindow ID: 502150
--UNION ALL
--SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502150'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
--N''',''年度考核--首席风险官评分'')">请您完成'
--+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年子公司合规风控总监年度考核评分</a>' AS url, 
--ISNULL(a.Score_EID,5256) AS approver, 1 AS id
--FROM pYear_Score a,pYear_Process b
--WHERE a.Score_Type1=26 AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
--AND a.pYear_ID=b.ID 
--AND a.EID=(select EID from eEmployee where JobID in (select JobID from oJob where JobAbbr like N'合规风控%' AND ISNULL(isDisabled,0)=0 AND xOrder<>999999999999999 AND CompID=13))
-- 子公司部门负责人 子公司总经理评分
-- skyWindow ID: 502155
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502155'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--子公司总经理评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年子公司部门负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=10 AND a.Score_Status=3 
AND (select COUNT(Initialized)/COUNT(ISNULL(Initialized,1)) from pYear_Score 
where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)=1
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 子公司部门负责人 子公司董事长评分
-- skyWindow ID: 502160
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502160'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--子公司董事长评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年子公司部门负责人年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=10 AND a.Score_Status=9
AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 分公司负责人/一级营业部负责人 ----
-- 分公司负责人/一级营业部负责人 网点运营管理总部评分
-- skyWindow ID: 502210
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502210'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--网点运营管理总部评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年分公司负责人/一级营业部负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (24,5) AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 分公司负责人/一级营业部负责人 合规审计部评分
-- skyWindow ID: 502220
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502220'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--合规审计部评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年分公司负责人/一级营业部负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (24,5) AND a.Score_Status=3 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 分公司负责人/一级营业部负责人 分管领导评分
-- skyWindow ID: 502230
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502230'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--分管领导评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年分公司负责人/一级营业部负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (24,5) AND a.Score_Status=4 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 分公司负责人/一级营业部负责人 总裁评分
-- skyWindow ID: 502240
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502240'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--总裁评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年分公司/一级营业部负责人年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (24,5) AND a.Score_Status=5 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 分公司负责人/一级营业部负责人 董事长评分
-- skyWindow ID: 502240
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502245'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--董事长评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年分公司/一级营业部负责人年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (24,5) AND a.Score_Status=9 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 分公司副职/一级营业部副职/二级营业部经理室 ----
-- 分公司副职/一级营业部副职/二级营业部经理室 分公司/一级营业部负责人评分
-- skyWindow ID: 502250
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502250'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--分公司负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年分公司副职/一级营业部副职/二级营业部经理室年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (25,6,7) AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 分公司副职/一级营业部副职/二级营业部经理室 分管领导评分
-- skyWindow ID: 502260
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502260'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--分管领导评分'')">请您确定'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年分公司副职/一级营业部副职/二级营业部经理室年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
from pYear_Score as a,pYear_Process b
where a.Score_Type1 IN (25,6,7) AND a.Score_Status=9
AND (select COUNT(Initialized)/COUNT(ISNULL(Initialized,1)) from pYear_Score 
where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)=1
AND (select COUNT(Submit)-COUNT(ISNULL(Initialized,1)) from pYear_Score 
where EID in (select EID from pYear_Score where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)
AND Score_Type2=15 AND Score_Status=7)=0
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 总部普通员工 ----
-- 总部普通员工 总部部门负责人评分
-- skyWindow ID: 502310
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502310'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--总部部门负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部普通员工年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
from pYear_Score as a,pYear_Process b
where a.Score_Type1=4 AND a.Score_Status=9 AND ISNULL(a.Initialized,0)=1
AND (select COUNT(Submit)-COUNT(ISNULL(Initialized,1)) from pYear_Score 
where EID in (select EID from pYear_Score where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)
AND Score_Type2=16 AND Score_Status=7)=0
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 子公司普通员工 ----
-- 子公司普通员工 子公司部门负责人评分
-- skyWindow ID: 502320
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502320'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--子公司部门负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年子公司普通员工年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type1=11 AND a.Score_Status=9 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 分公司/一级营业部及二级营业部普通员工 ----
-- 分公司/一级营业部及二级营业部普通员工 分公司负责人评分
-- skyWindow ID: 502330
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502330'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--分公司/一级营业部负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年分公司/一级营业部及二级营业部普通员工年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
from pYear_Score as a,pYear_Process b
where a.Score_Type1 IN (29,12,13) AND a.Score_Status=9
AND (select COUNT(Initialized)/COUNT(ISNULL(Initialized,1)) from pYear_Score 
where Score_Status=a.Score_Status AND Score_EID=a.Score_EID)=1
AND (select COUNT(Submit)-COUNT(ISNULL(Initialized,1)) from pYear_Score 
where EID in (select EID from pYear_Score where Score_Status=a.Score_Status AND Score_EID=a.Score_EID)
AND Score_Type2=15 AND Score_Status=7)=0
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
---- 二级营业部普通员工 ----
-- 二级营业部普通员工 二级营业部负责人评分
-- skyWindow ID: 502350
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502350'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--二级营业部负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年二级营业部普通员工年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type1=13 AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 区域财务经理 ----
-- 区域财务经理 营业部负责人考核评分
-- skyWindow ID: 502410
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502410'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--营业部负责人考核评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年区域财务经理年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type1=17 AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 区域财务经理 计划财务部负责人评分
-- skyWindow ID: 502420
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502420'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--计划财务部负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年区域财务经理年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type1=17 AND a.Score_Status=3
AND (select COUNT(Initialized)/COUNT(ISNULL(Initialized,1)) from pYear_Score 
where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)=1
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 区域财务经理 财务总监评分
-- skyWindow ID: 502430
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502430'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--财务总监评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年区域财务经理年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type1=17 AND a.Score_Status=9 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND (select COUNT(Submit)-COUNT(ISNULL(Initialized,1)) from pYear_Score 
where EID in (select EID from pYear_Score where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)
AND Score_Type2=15 AND Score_Status=7)=0
AND a.pYear_ID=b.ID

---- 综合会计 ----
-- 综合会计 区域财务经理评分
-- skyWindow ID: 502450
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502450'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--区域财务经理评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年综合会计年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type1=19 AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 综合会计计划财务部负责人评分
-- skyWindow ID: 502460
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502460'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--计划财务部负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年综合会计年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type1=19 AND a.Score_Status=9
AND (select COUNT(Initialized)/COUNT(ISNULL(Initialized,1)) from pYear_Score 
where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)=1
AND (select COUNT(Submit)-COUNT(ISNULL(Initialized,1)) from pYear_Score 
where EID in (select EID from pYear_Score where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)
AND Score_Type2=15 AND Score_Status=7)=0
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 营业部合规专员 ----
-- 营业部合规专员 分公司/营业部负责人评分
-- skyWindow ID: 502510
--UNION ALL
--SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502510'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
--N''',''年度考核--分公司/营业部负责人评分'')">请您完成'
--+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年营业部合规专员年度考核评分</a>' AS url, 
--ISNULL(a.Score_EID,5256) AS approver, 1 AS id
--FROM pYear_Score a,pYear_Process b
--where a.Score_Type1=14 AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
--AND a.pYear_ID=b.ID
-- 营业部合规专员 合规审计部负责人评分
-- skyWindow ID: 502520
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502520'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--法律合规部负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年营业部合规专员年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type1=14 AND a.Score_Status=3
AND (select COUNT(Initialized)/COUNT(ISNULL(Initialized,1)) from pYear_Score 
where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)=1
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 营业部合规专员 合规风控总监评分
-- skyWindow ID: 502530
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502530'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--合规风控总监考核'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年营业部合规专员年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type1=14 AND a.Score_Status=9 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID

---- 营业部合规联系人 ----
-- 营业部合规联系人 合规审计部负责人评分
-- skyWindow ID: 502550
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502550'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--合规审计部负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年营业部合规联络人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type2=15 AND a.Score_Status=7 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
---- 总部兼职合规专员 ----
-- 总部兼职合规专员 合规审计部负责人评分
-- skyWindow ID: 502560
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502560'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--合规审计部负责人评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部兼职合规专员年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
where a.Score_Type2=16 AND a.Score_Status=7 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID