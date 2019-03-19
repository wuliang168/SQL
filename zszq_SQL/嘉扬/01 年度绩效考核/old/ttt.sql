/* 异常考勤确认*/ SELECT N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600052'',''考勤确认'')">请您确认的异常考勤</a>' AS url, CASE WHEN dbo.eFN_getdepid1(b.DEPID) = b.DEPID THEN
                          (SELECT     isnull(Director, 4576)
                            FROM          odepartment c
                            WHERE      c.depid = b.DEPID) ELSE
                          (SELECT     isnull(Director, 4576)
                            FROM          odepartment c
                            WHERE      c.depid = dbo.eFN_getdepid1(b.DEPID)) END AS approver, 2 AS id
FROM         BS_YC_DK a, eemployee b
WHERE     a.EID = b.EID AND ISNULL(a.Initialized, 0) = 1 AND ISNULL(a.SUBMIT, 0) = 0 AND OUTID IS NULL
/* 异常考勤说明*/ UNION
SELECT     N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600051'',''异常考勤说明'')">请您说明未打卡原因或补充外出登记</a>' AS url, a.EID AS approver, 2 AS id
FROM         BS_YC_DK a
WHERE     ISNULL(a.Initialized, 0) = 0 AND ISNULL(a.SUBMIT, 0) = 0
/* 月工作计划与汇总*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600020'',''绩效首页'')">请您于本月8日前制定' + cast(month(a.period) AS varchar(10)) + N'月份工作计划</a>' AS url, b.EID AS approver, 3 AS id
FROM         PEMPPROCESS_MONTH a, eemployee b
WHERE     a.badge = b.Badge AND ISNULL(a.Initialized, 0) = 0 AND ISNULL(a.Closed, 0) = 0 AND a.monthID IN
                          (SELECT DISTINCT id
                            FROM          PPROCESS_MONTH
                            WHERE      begindate IS NOT NULL AND enddate IS NULL)
/* 月度工作日志空缺超过5天*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="$x.top().LoadPortal(''1.0.600067'',''绩效首页'')">您' + cast(datepart(mm, mm) AS varchar(10)) + N'月工作日志空缺超过5天，请补充。</a>' AS url, EID AS approver, 
                      7 AS id
FROM         pvw_Workrecord b
WHERE     datediff(mm, mm, getdate()) < 2 AND workday - tianxieday >= 5
/* skyWindow ID: 500100*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610003'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     SCORE_TYPE IN (1) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500200*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610005'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     SCORE_TYPE IN (2) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500100*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610003'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     SCORE_TYPE IN (10) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500300*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610006'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     SCORE_TYPE IN (24) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500200*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610005'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     SCORE_TYPE IN (25) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500300*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610006'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     SCORE_TYPE IN (5) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500200*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610005'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     SCORE_TYPE IN (6) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500200*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610005'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     SCORE_TYPE IN (7) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500500*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610001'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     SCORE_STATUS = 0 AND SCORE_TYPE IN (4, 11, 29, 12, 13) AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500400*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610004'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     a.SCORE_TYPE IN (14) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500400*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610004'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     a.SCORE_TYPE IN (17) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 500400*/ UNION
SELECT     N'<a href="#" onclick="moveTo(''1.0.610004'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) + N''',''年度考核--自评'')">请您完成年度考核自评</a>' AS url, EID AS approver, 1 AS id
FROM         pscore a
WHERE     a.SCORE_TYPE IN (19, 20) AND SCORE_STATUS = 0 AND isnull(SUBMIT, 0) = 0
/* skyWindow ID: 501000*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.501000'',''leftid^' + cast(a.SCORE_TYPE AS nvarchar(15)) 
                      + N''',''年度互评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成员工互评</a>' AS url, a.EID AS approver, 
                      1 AS id
FROM         pscore a
WHERE     EXISTS
                          (SELECT     1
                            FROM          pEmpProcess_Year_Mutual
                            WHERE      evalEID = a.EID AND ISNULL(SUBMIT, 0) = 0) AND a.SCORE_TYPE IN (4, 11, 29, 12, 13) AND SCORE_STATUS = 1 AND isnull(SUBMIT, 0) = 0 AND isnull(closed, 0) 
                      = 0
/* skyWindow ID: 501100*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.eachtype AS nvarchar(15)) 
                      + N''',''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')" >请您完成对' + CASE WHEN a.eachtype = 1
                       THEN N'总部部门负责人测评' /* 总部部门分管领导测评*/ WHEN a.eachtype = 2 THEN N'总部部门负责人互评' /* 总部部门负责人互评*/ WHEN a.eachtype = 3 THEN N'总部部门负责人测评' /* 总部部门内下属员工测评*/ END
                       + N'年度胜任素质测评</a>' AS url, a.scoreeid AS approver, 1 AS id
FROM         Pscore_each a, pscore b
WHERE     a.EID = b.EID AND a.SCORE_TYPE = 1 AND a.SCOREEID NOT IN (1022) /* 1022：吴承根*/ AND (isnull(a.SUBMIT, 0) = 0) AND (isnull(b.Closed, 0) = 0 AND b.SCORE_STATUS = 1)
/* skyWindow ID: 501100*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.eachtype AS nvarchar(15)) 
                      + N''',''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')" >请您完成对' + CASE WHEN a.eachtype = 5
                       THEN N'总部部门副职测评' /* 总部部门分管领导测评*/ WHEN a.eachtype = 6 THEN N'总部部门副职测评' /* 总部部门负责人测评*/ WHEN a.eachtype = 7 THEN N'总部部门副职测评' /* 总部部门内下属员工测评*/ END
                       + N'年度胜任素质测评</a>' AS url, a.scoreeid AS approver, 1 AS id
FROM         Pscore_each a, pscore b
WHERE     a.EID = b.EID AND a.SCORE_TYPE = 2 AND a.SCOREEID NOT IN (1022) /* 1022：吴承根*/ AND (ISNULL(a.SUBMIT, 0) = 0) AND (isnull(b.Closed, 0) = 0 AND b.SCORE_STATUS = 1)
/* skyWindow ID: 501100*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.501100'',''leftid^' + cast(a.eachtype AS nvarchar(15)) 
                      + N''',''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')" >请您完成对' + CASE WHEN a.eachtype = 11
                       THEN N'子公司部门负责人测评' /* 子公司总经理测评*/ WHEN a.eachtype = 12 THEN N'子公司部门负责人互评' /* 子公司部门负责人互评*/ WHEN a.eachtype = 13 THEN N'子公司部门负责人测评' /* 子公司部门内下属员工测评*/ END
                       + N'年度胜任素质测评</a>' AS url, a.scoreeid AS approver, 1 AS id
FROM         Pscore_each a, pscore b
WHERE     a.EID = b.EID AND a.SCORE_TYPE = 10 AND (ISNULL(a.SUBMIT, 0) = 0) AND (isnull(b.Closed, 0) = 0 AND b.SCORE_STATUS = 1)
/* skyWindow ID: 501200*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.501200'',''leftid^' + cast(a.eachtype AS nvarchar(15)) 
                      + N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成' + CASE WHEN a.eachtype = 21 THEN
                       N'分公司负责人测评' /* 分公司分管领导测评*/ WHEN a.eachtype = 22 THEN N'分公司负责人测评' /* 分公司人员测评*/ END + N'年度胜任素质测评</a>' AS url, a.scoreeid AS approver, 
                      1 AS id
FROM         Pscore_each a, pscore b
WHERE     a.EID = b.EID AND a.SCORE_TYPE = 24 AND (ISNULL(a.SUBMIT, 0) = 0) AND (isnull(b.Closed, 0) = 0 AND b.SCORE_STATUS = 1)
/* skyWindow ID: 501200*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.501200'',''leftid^' + cast(a.eachtype AS nvarchar(15)) 
                      + N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成' + CASE WHEN a.eachtype = 25 THEN
                       N'分公司副职测评' /* 分公司负责人测评*/ WHEN a.eachtype = 26 THEN N'分公司副职测评' /* 分公司人员测评*/ END + N'年度胜任素质测评</a>' AS url, a.scoreeid AS approver, 1 AS id
FROM         Pscore_each a, pscore b
WHERE     a.EID = b.EID AND a.SCORE_TYPE = 25 AND (ISNULL(a.SUBMIT, 0) = 0) AND (isnull(b.Closed, 0) = 0 AND b.SCORE_STATUS = 1)
/* skyWindow ID: 501200*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.501200'',''leftid^' + cast(a.eachtype AS nvarchar(15)) 
                      + N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成' + CASE WHEN a.eachtype = 31 THEN
                       N'一级营业部负责人测评' /* 一级营业部分管领导测评*/ WHEN a.eachtype = 32 THEN N'一级营业部负责人测评' /* 一级营业部人员测评*/ END + N'年度胜任素质测评</a>' AS url, 
                      a.scoreeid AS approver, 1 AS id
FROM         Pscore_each a, pscore b
WHERE     a.EID = b.EID AND a.SCORE_TYPE = 5 AND (ISNULL(a.SUBMIT, 0) = 0) AND (isnull(b.Closed, 0) = 0 AND b.SCORE_STATUS = 1)
/* skyWindow ID: 501200*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.501200'',''leftid^' + cast(a.eachtype AS nvarchar(15)) 
                      + N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成' + CASE WHEN a.eachtype = 35 THEN
                       N'一级营业部副职测评' /* 一级营业部负责人测评*/ WHEN a.eachtype = 36 THEN N'一级营业部副职测评' /* 一级营业部人员测评*/ END + N'年度胜任素质测评</a>' AS url, a.scoreeid AS approver, 
                      1 AS id
FROM         Pscore_each a, pscore b
WHERE     a.EID = b.EID AND a.SCORE_TYPE = 6 AND (ISNULL(a.SUBMIT, 0) = 0) AND (isnull(b.Closed, 0) = 0 AND b.SCORE_STATUS = 1)
/* skyWindow ID: 501200*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.501200'',''leftid^' + cast(a.eachtype AS nvarchar(15)) 
                      + N''', ''胜任素质360度测评（评分不能超过表头标识上限，点击表头分数字段可进行排序，快捷输入：tab键横向移动单元格，回车键纵向移动单元格)'')">请您完成' + CASE WHEN a.eachtype = 41 THEN
                       N'二级营业部经理室成员测评' /* 一级营业部负责人测评*/ WHEN a.eachtype = 42 THEN N'二级营业部经理室成员测评' /* 二级营业部人员测评*/ END + N'年度胜任素质测评</a>' AS url, 
                      a.scoreeid AS approver, 1 AS id
FROM         Pscore_each a, pscore b
WHERE     a.EID = b.EID AND a.SCORE_TYPE = 7 AND (ISNULL(a.SUBMIT, 0) = 0) AND (isnull(b.Closed, 0) = 0 AND b.SCORE_STATUS = 1)
/* skyWindow ID: 502110*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502110'',''leftid^' + cast(12 AS nvarchar(15)) + N''',''年度考核--分管领导评分'')">请您完成对总部部门负责人的年度考核评分</a>' AS url, 
                      b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (1) AND b.SCORE_EID NOT IN (1022) /* 1022：吴承根*/ AND (a.SCORE_STATUS = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502130*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502130'',''leftid^' + cast(22 AS nvarchar(15)) + N''',''年度考核--总部部门负责人评分'')">请您完成对总部部门副职的年度评分</a>' AS url, 
                      b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (2) AND (a.SCORE_STATUS = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 0)
-- 总部部门副职 分管领导评分
-- skyWindow ID: 502140
UNION
SELECT DISTINCT 
N'<a href="#" onclick="moveTo(''1.0.502140'',''leftid^' + cast(23 AS nvarchar(15)) + 
N''',''年度考核--分管领导评分'')">请您确定总部部门副职的年度排名</a>' AS url, 
a.SCORE_EID AS approver, 3 AS id
from pscore as a,pscore as b,pscore as c 
where isnull(a.SUBMIT,0)=0 AND a.eid=b.eid and a.eid=c.eid 
and a.SCORE_EID not in (1022) -- 1022：吴承根
AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 1) AND a.weight=60
AND ((a.SCORE_STATUS=3 AND a.SCORE_TYPE IN (2) AND isnull(a.compliance,0)=0)
OR (a.SCORE_STATUS=3 AND a.SCORE_TYPE IN (2) and (c.SCORE_STATUS=7 AND isnull(a.compliance,0)=16 AND ISNULL(c.submit,0)=1)))
/* skyWindow ID: 502150*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502150'',''leftid^' + cast(102 AS nvarchar(15)) + N''',''年度考核--子公司总经理评分'')">请您完成对子公司部门负责人的年度评分</a>' AS url, 
                      b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (10) AND (a.SCORE_STATUS = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502210*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502210'',''leftid^' + cast(2452 AS nvarchar(15)) + N''',''年度考核--网点运营管理总部评分'')">请您完成对分公司负责人/一级营业部负责人的年度评分</a>' AS url, 
                      b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (24, 5) AND (a.SCORE_STATUS = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502220*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502220'',''leftid^' + cast(2453 AS nvarchar(15)) + N''',''年度考核--合规审计部评分'')">请您完成对分公司负责人/一级营业部负责人的年度评分</a>' AS url, 
                      b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (24, 5) AND (a.SCORE_STATUS = 1) AND (b.SCORE_STATUS = 3 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502230*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502230'',''leftid^' + cast(2454 AS nvarchar(15)) + N''',''年度考核--分管领导评分'')">请您完成对分公司负责人/一级营业部负责人的年度评分</a>' AS url, 
                      b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (24, 5) AND (a.SCORE_STATUS = 1) AND (b.SCORE_STATUS = 4 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502250*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502250'',''leftid^' + cast(25672 AS nvarchar(15)) 
                      + N''',''年度考核--分公司负责人评分'')">请您完成对分公司副职/一级营业部副职/二级营业部经理室的年度评分</a>' AS url, b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (25, 6, 7) AND (a.SCORE_STATUS = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502260*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502260'',''leftid^' + cast(25673 AS nvarchar(15)) 
                      + N''',''年度考核--分管领导评分'')">请您确定分公司副职/一级营业部副职/二级营业部经理室的年度排名</a>' AS url, a.SCORE_EID AS approver, 1 AS id
FROM         pscore AS a, pscore AS b, pscore AS c
WHERE     isnull(a.SUBMIT, 0) = 0 AND a.eid = c.eid /*AND a.eid=b.eid AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 1)*/ AND ((a.SCORE_STATUS = 3 AND a.SCORE_TYPE IN (25, 6, 7) AND 
                      isnull(a.compliance, 0) = 0) OR
                      (a.SCORE_STATUS = 3 AND a.SCORE_TYPE IN (25, 6, 7) AND (c.SCORE_STATUS = 7 AND isnull(a.compliance, 0) = 15 AND ISNULL(c.submit, 0) = 1)))
/* skyWindow ID: 502310*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502310'',''leftid^' + cast(42 AS nvarchar(15)) + N''',''年度考核--总部部门负责人评分'')">请您于1月3日前完成对总部普通员工的年度考核评分及排名</a>' AS url, 
                      a.SCORE_EID AS approver, 1 AS id
FROM         pscore AS a, pscore AS b, pscore AS c
WHERE     isnull(a.SUBMIT, 0) = 0 AND a.eid = b.eid AND a.eid = c.eid AND (b.SCORE_STATUS = 1 AND ISNULL(b.Closed, 0) = 1) AND ((a.SCORE_STATUS = 2 AND a.SCORE_TYPE IN (4) AND 
                      isnull(a.compliance, 0) = 0) OR
                      (a.SCORE_STATUS = 2 AND a.SCORE_TYPE IN (4) AND (c.SCORE_STATUS = 7 AND isnull(a.compliance, 0) = 16 AND ISNULL(c.submit, 0) = 1)))
/* skyWindow ID: 502320*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502320'',''leftid^' + cast(112 AS nvarchar(15)) 
                      + N''',''年度考核--子公司部门负责人评分'')">请您于1月3日前完成对子公司普通员工的年度考核评分及排名</a>' AS url, b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (11) AND (a.SCORE_STATUS = 1 AND ISNULL(a.Closed, 0) = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502330*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502330'',''leftid^' + cast(2912132 AS nvarchar(15)) 
                      + N''',''年度考核--分公司/一级营业部负责人评分'')">请您于1月3日前完成对分公司/一级营业部及二级营业部普通员工的年度考核评分及排名</a>' AS url, a.SCORE_EID AS approver, 1 AS id
FROM         pscore AS a, pscore AS b, pscore AS c, pscore AS d
WHERE     isnull(a.SUBMIT, 0) = 0 AND a.EID = b.EID AND a.EID = c.EID AND a.EID = d .EID AND (b.SCORE_STATUS = 1 AND ISNULL(b.Closed, 0) = 1) AND ((a.SCORE_STATUS = 2 AND a.SCORE_TYPE IN (29, 
                      12, 13) AND a.WEIGHT = 70 AND isnull(a.SUBMIT, 0) = 0 AND isnull(a.compliance, 0) = 0) OR
                      (a.SCORE_STATUS = 2 AND a.SCORE_TYPE IN (29, 12, 13) AND a.WEIGHT = 70 AND isnull(a.SUBMIT, 0) = 0 AND (d .SCORE_STATUS = 7 AND isnull(a.compliance, 0) = 15 AND ISNULL(d .submit, 0) 
                      = 1)) OR
                      (a.SCORE_STATUS = 3 AND a.SCORE_TYPE = 13 AND a.WEIGHT = 40 AND isnull(a.SUBMIT, 0) = 0 AND (isnull(a.compliance, 0) = 0) AND (c.SCORE_STATUS = 2 AND ISNULL(c.submit, 0) = 1)) OR
                      (a.SCORE_STATUS = 3 AND a.SCORE_TYPE = 13 AND a.WEIGHT = 40 AND isnull(a.SUBMIT, 0) = 0 AND (d .SCORE_STATUS = 7 AND isnull(a.compliance, 0) = 15 AND ISNULL(d .submit, 0) = 1) AND 
                      (c.SCORE_STATUS = 2 AND ISNULL(c.submit, 0) = 1)))
/* skyWindow ID: 502350*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502350'',''leftid^' + cast(132 AS nvarchar(15)) 
                      + N''',''年度考核--二级营业部负责人评分'')">请您于1月3日前完成对二级营业部普通员工的年度考核评分</a>' AS url, b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (13) AND b.weight = 30 AND (a.SCORE_STATUS = 1 AND ISNULL(a.Closed, 0) = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502410*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502410'',''leftid^' + cast(171 AS nvarchar(15)) + N''',''年度考核--营业部负责人考核评分'')">请您于1月3日前完成对区域财务经理的年度考核评分</a>' AS url, 
                      a.SCORE_EID AS approver, 1 AS id
FROM         pscore a
WHERE     a.SCORE_TYPE IN (17) AND (a.SCORE_STATUS = 1 AND ISNULL(a.SUBMIT, 0) = 0)
/* skyWindow ID: 502420*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502420'',''leftid^' + cast(172 AS nvarchar(15)) + N''',''年度考核--计划财务部负责人评分'')">请您于1月3日前完成对区域财务经理的年度考核评分</a>' AS url, 
                      a.SCORE_EID AS approver, 1 AS id
FROM         pscore a
WHERE     a.SCORE_TYPE IN (17) AND (a.SCORE_STATUS = 2 AND ISNULL(a.SUBMIT, 0) = 0)
/* skyWindow ID: 502430*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502430'',''leftid^' + cast(173 AS nvarchar(15)) + N''',''年度考核--财务总监评分'')">请您完成对区域财务经理的年度考核评分及排名</a>' AS url, 
                      c.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b, pscore c
WHERE     a.EID = b.EID AND c.EID = a.EID AND c.SCORE_TYPE IN (17) AND (a.SCORE_STATUS = 1 AND ISNULL(a.SUBMIT, 0) = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 1) AND 
                      (c.SCORE_STATUS = 3 AND ISNULL(c.SUBMIT, 0) = 0)
/* skyWindow ID: 502450*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502450'',''leftid^' + cast(191 AS nvarchar(15)) + N''',''年度考核--区域财务经理评分'')">请您于1月3日前完成对综合会计（集中）的年度考核评分</a>' AS url, 
                      a.SCORE_EID AS approver, 1 AS id
FROM         pscore a
WHERE     a.SCORE_TYPE IN (19) AND (a.SCORE_STATUS = 1 AND ISNULL(a.SUBMIT, 0) = 0)
/* skyWindow ID: 502460*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502460'',''leftid^' + cast(192 AS nvarchar(15)) 
                      + N''',''年度考核--计划财务部负责人评分'')">请您于1月3日前完成对综合会计（集中）的年度考核评分及排名</a>' AS url, b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (19) AND (a.SCORE_STATUS = 1 AND ISNULL(a.SUBMIT, 0) = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502450*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502450'',''leftid^' + cast(201 AS nvarchar(15)) + N''',''年度考核--区域财务经理评分'')">请您于1月3日前完成对综合会计（非集中）的年度考核评分</a>' AS url, 
                      a.SCORE_EID AS approver, 1 AS id
FROM         pscore a
WHERE     a.SCORE_TYPE IN (20) AND (a.SCORE_STATUS = 1 AND ISNULL(a.SUBMIT, 0) = 0)
/* skyWindow ID: 502470*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502470'',''leftid^' + cast(202 AS nvarchar(15)) 
                      + N''',''年度考核--分公司/营业部负责人评分'')">请您于1月3日前完成对综合会计（非集中）的年度考核评分及排名</a>' AS url, b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.SCORE_TYPE IN (20) AND (a.SCORE_STATUS = 1 AND ISNULL(a.SUBMIT, 0) = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502510*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502510'',''leftid^' + cast(141 AS nvarchar(15)) 
                      + N''',''年度考核--分公司/营业部负责人评分'')">请您于1月3日前完成对营业部合规风控专员的年度考核评分</a>' AS url, a.SCORE_EID AS approver, 1 AS id
FROM         pscore a
WHERE     a.SCORE_TYPE IN (14) AND (a.SCORE_STATUS = 1 AND ISNULL(a.SUBMIT, 0) = 0)
/* skyWindow ID: 502520*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502520'',''leftid^' + cast(142 AS nvarchar(15)) 
                      + N''',''年度考核--合规审计部负责人评分'')">请您于1月3日前完成对营业部合规风控专员的年度考核评分</a>' AS url, a.SCORE_EID AS approver, 1 AS id
FROM         pscore a
WHERE     a.SCORE_TYPE IN (14) AND (a.SCORE_STATUS = 2 AND ISNULL(a.SUBMIT, 0) = 0)
/* skyWindow ID: 502530*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502530'',''leftid^' + cast(143 AS nvarchar(15)) + N''',''年度考核--合规风控总监考核'')">请您完成对营业部合规风控专员的年度考核评分及排名</a>' AS url, 
                      c.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b, pscore c
WHERE     a.EID = b.EID AND c.EID = a.EID AND c.SCORE_TYPE IN (14) AND (a.SCORE_STATUS = 1 AND ISNULL(a.SUBMIT, 0) = 1) AND (b.SCORE_STATUS = 2 AND ISNULL(b.SUBMIT, 0) = 1) AND 
                      (c.SCORE_STATUS = 3 AND ISNULL(c.SUBMIT, 0) = 0)
/* skyWindow ID: 502550*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502550'',''leftid^' + cast(157 AS nvarchar(15)) + N''',''年度考核--合规审计部负责人评分'')">请您于1月3日前完成对营业部合规联络人的年度考核评分</a>' AS url, 
                      b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.compliance = 15 AND (a.SCORE_STATUS = 1 AND ISNULL(a.Closed, 0) = 1) AND (b.SCORE_STATUS = 7 AND ISNULL(b.SUBMIT, 0) = 0)
/* skyWindow ID: 502560*/ UNION
SELECT DISTINCT 
                      N'<a href="#" onclick="moveTo(''1.0.502560'',''leftid^' + cast(167 AS nvarchar(15)) + N''',''年度考核--合规审计部负责人评分'')">请您于1月3日前完成对总部兼职合规专员的年度考核评分</a>' AS url, 
                      b.SCORE_EID AS approver, 1 AS id
FROM         pscore a, pscore b
WHERE     a.EID = b.EID AND b.compliance = 16 AND (a.SCORE_STATUS = 1 AND ISNULL(a.Closed, 0) = 1) AND (b.SCORE_STATUS = 7 AND ISNULL(b.SUBMIT, 0) = 0)