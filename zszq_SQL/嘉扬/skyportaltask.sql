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
SELECT DISTINCT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600020'',''绩效首页'')">请您于本月20日前制定' + 
cast(month(a.period) AS varchar(10)) + N'月份工作计划</a>' AS url, 
ISNULL(b.EID, 5256) AS approver,3 AS id
FROM PEMPPROCESS_MONTH a, eemployee b
WHERE a.badge = b.Badge AND ISNULL(a.Initialized, 0) = 0 AND ISNULL(a.Closed, 0) = 0 
AND a.monthID=(select id from pProcess_month where DATEDIFF(mm,kpimonth,getdate())=0)
AND DATEPART(dd,GETDATE()) BETWEEN 1 AND 31

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
SELECT DISTINCT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600021'',''月度计划评分'')">请您于本月30日前考核下属上月度工作完成情况</a>' AS url, 
ISNULL(a.kpiReportTo, 5256) AS approver, 3 AS id
FROM pEmpProcess_Month a
WHERE ISNULL(a.Closed, 0)  = 0
AND A.MONTHID=(select id from pProcess_month where DATEDIFF(mm,kpimonth,getdate())=1)
AND DATEPART(dd,GETDATE()) BETWEEN 16 AND 31
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
WHERE datediff(m, mm, getdate()) < 2 AND workday - tianxieday >= 5


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
N'<a href="#" onclick="moveTo(''1.0.530010'',''leftid^' + cast(a.SalaryPayID AS nvarchar(15)) + 
N''',''年金计划分配反馈'')">请您完成' + cast(datepart(yy, a.PensionMonth) AS varchar(10)) + 
N'年' + cast(datepart(mm, a.PensionMonth) AS varchar(10)) + N'月' + b.Title + N'员工年金分配</a>' AS url, 
a.PensionContact AS approver, 1 AS id
FROM pDepPensionPerMM a,oCD_SalaryPayType b
WHERE a.SalaryPayID=b.ID AND a.SalaryPayID<>6 AND ISNULL(IsSubmit,0)=0 and a.PensionContact is not NULL
-- 薪酬类型为营业部;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.530020'',''leftid^' + cast(b.DepID AS nvarchar(15)) + 
N''',''年金计划分配反馈'')">请您完成' + cast(datepart(yy, a.PensionMonth) AS varchar(10)) + 
N'年' + cast(datepart(mm, a.PensionMonth) AS varchar(10)) + N'月' + b.DepAbbr + N'员工年金分配</a>' AS url, 
a.PensionContact AS approver, 1 AS id
FROM pDepPensionPerMM a,odepartment b
WHERE ISNULL(a.DepID,a.SupDepID)=b.DepID AND a.SalaryPayID=6 AND ISNULL(IsSubmit,0)=0 and a.PensionContact is not NULL


------------- 年金参与员工分配 ------------
-- 营业部;
--UNION
--SELECT DISTINCT
--N'<a href="#" onclick="moveTo(''1.0.530120'',''leftid^' + cast(ISNULL(a.DepID,a.SupDepID) AS nvarchar(15)) +
--N''',''企业年金分配参与员工'')">请您确认' + (select DepAbbr from odepartment where DepID=ISNULL(a.DepID,a.SupDepID)) + N'参加'
--+ cast(YEAR(a.PensionYear) AS varchar(4)) + N'年度年金分配人员</a>' AS url, 
--a.PensionContact AS approver, 1 AS id
--FROM pPensionUpdatePerDep a,pPensionUpdate b
--where ISNULL(a.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0
--and YEAR(a.PensionYear)=YEAR(b.PensionYear) and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0


------------- 月度工资 ------------
-- 薪酬类型非营业部;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550010'',''leftid^' + cast(a.SalaryPayID AS nvarchar(15)) + 
N''',''月度工资分配反馈'')">请您完成' + cast(datepart(yy, a.Date) AS varchar(10)) + N'年' + 
cast(datepart(mm, a.Date) AS varchar(10)) + N'月' + b.Title + N'员工月度工资分配</a>' AS url, 
a.SalaryContact AS approver, 1 AS id
FROM pDepSalaryPerMonth a,oCD_SalaryPayType b
WHERE a.SalaryPayID=b.ID AND a.SalaryPayID not in (6,8) AND ISNULL(IsSubmit,0)=0 AND a.SalaryContact is not NULL
-- 薪酬类型为营业部;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550020'',''leftid^' + cast(b.DepID AS nvarchar(15)) + 
N''',''月度工资分配反馈'')">请您完成' + cast(datepart(yy, a.Date) AS varchar(10)) + N'年' + 
cast(datepart(mm, a.Date) AS varchar(10)) + N'月' + b.DepAbbr + N'员工月度工资分配</a>' AS url, 
a.SalaryContact AS approver, 1 AS id
FROM pDepSalaryPerMonth a,odepartment b
WHERE a.DepID=b.DepID AND a.SalaryPayID=6 AND ISNULL(IsSubmit,0)=0 AND a.SalaryContact is not NULL


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


------------- 费用统计 ------------
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550510'',''leftid^' + cast(ISNULL(a.DepID2nd,a.DepID1st) AS nvarchar(5)) + 
N''',''营销费用统计反馈'')">请您完成2016年12月-2017年11月营销费用发放统计</a>' AS url, 
a.SalaryContact AS approver, 1 AS id
FROM pExpensesSummDep a,pExpensesSumm_Process b
WHERE DATEDIFF(mm,a.Date,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0 
AND a.SalaryContact is NOT NULL AND a.ExpensesSUMMTotal is NOT NULL


------------- 五险一金统计 ------------
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.530220'',''leftid^' + cast(ISNULL(a.DepID2nd,a.DepID1st) AS nvarchar(5)) + 
N''',''五险一金工资扣款统计'')">请于' + cast(datepart(mm, (select min(term)+1 from lCalendar where DATEDIFF(mm,term,b.Date)=0 and xType=1)) AS varchar(2)) + N'月'
+ cast(datepart(dd, (select min(term)+1 from lCalendar where DATEDIFF(mm,term,b.Date)=0 and xType=1)) AS varchar(2)) + N'日前递交' + c.DepAbbr
+ cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + N'工资五险一金扣款数据</a>' AS url, 
a.DepInsHFContact AS approver, 1 AS id
FROM pEMPInsuranceHousingFundDep a,pEMPInsuranceHousingFund_Process b,oDepartment c
WHERE DATEDIFF(mm,a.Month,b.Date)=0 and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0 and ISNULL(a.DepID2nd,a.DepID1st)=C.DepID
AND a.DepInsHFContact is NOT NULL
AND DATEDIFF(DD,GETDATE(),(select min(term)+1 from lCalendar where DATEDIFF(mm,term,b.Date)=0 and xType=1))>=0


------------- 月度奖金 ------------
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550400'',''leftid^' + cast(ISNULL(a.DepID2nd,a.DepID1st) AS nvarchar(5)) + 
N''',''月度奖金统计'')">请您完成' + cast(datepart(yy, b.Date) AS varchar(10)) + N'年' + 
cast(datepart(mm, b.Date) AS varchar(10)) + N'月' + c.DepAbbr + N'直管人员奖金统计</a>' AS url, 
a.DepSalaryContact AS approver, 1 AS id
FROM pEMPMonthBonusDep a,pEMPMonthBonus_Process b,oDepartment c
WHERE DATEDIFF(mm,a.Date,b.Date)=0 AND ISNULL(a.DepID2nd,a.DepID1st)=c.DepID
AND ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 AND ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0
AND a.DepSalaryContact is not NULL


------------- 年度奖金 ------------
---- 一级部门
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550410'',''leftid^' + cast(a.AnnualBonusDepID AS nvarchar(5)) + 
N''',''上半年绩效奖金统计反馈'')">请您完成' + c.DepAbbr + cast(datepart(yy, b.Year) AS varchar(10)) + N'年度' 
+ N'上半年绩效奖金分配</a>' AS url, 
a.Director AS approver, 1 AS id
FROM pYear_AnnualBonusDep a,pYear_AnnualBonus_Process b,oDepartment c
WHERE DATEDIFF(mm,a.Year,b.Year)=0 and DATEDIFF(mm,a.Date,b.Date)=0 
and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0 AND ISNULL(a.AnnualBonusDepTotal,0)<>0
AND a.AnnualBonusDepID=c.DepID AND c.DepGrade=1
---- 二级部门
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550410'',''leftid^' + cast(a.AnnualBonusDepID AS nvarchar(5)) + 
N''',''上半年绩效奖金统计反馈'')">请您完成' + c.DepAbbr + cast(datepart(yy, b.Year) AS varchar(10)) + N'年度' 
+ N'上半年绩效奖金奖金分配</a>' AS url, 
a.Director AS approver, 1 AS id
FROM pYear_AnnualBonusDep a,pYear_AnnualBonus_Process b,oDepartment c
WHERE DATEDIFF(mm,a.Year,b.Year)=0 and DATEDIFF(mm,a.Date,b.Date)=0 
and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.IsSubmit=0 AND ISNULL(a.IsClosed,0)=0
AND a.AnnualBonusDepID=c.DepID AND c.DepGrade=2