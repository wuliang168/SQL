------------- 年度评优 ------------
---- 部门负责人(含展业精英含投理顾)
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.510020'',''年度评优'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年度评优工作</a>' AS url, 
a.AppraiseEID AS approver, 1 AS id
FROM pYear_DepAppraise a,pYear_AppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
-- 不包含投资银行(695)、资管、资本、分公司、营业部、网点运营管理总部(362)
AND a.AppraiseEID not in (1023,1025,1026,1027,1028,1033,1089,1317)
---- 公司领导
UNION
SELECT DISTINCT
N'<a href="#" onclick="$x.top().LoadPortal(''1.0.510040'',''年度评优'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年度评优工作</a>' AS url, 
a.AppraiseEID AS approver, 1 AS id
FROM pYear_DepAppraise a,pYear_AppraiseProcess b,eEmployee c
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
-- 不包含公司一把手(董事长(1022)、总裁(5014)、书记(5587)、楼伟亮(1112)、何蔚玲(1063)、邓宏光(1032)、刘文雷(1294)、许运凯(4774))
AND a.AppraiseEID=c.EID AND c.DepID=349 AND a.AppraiseEID not in (1022,5014,5587,1112,1063,1032,1294,4774)


------------- 职能部门考核 ------------
---- 部门负责人(自评)
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570010'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门自评考核工作</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
---- 战略企划部(702)、计划财务部(355)、资产存管部(356)、人力资源部(354)、培训中心(360)、办公室(350)、董办(351)
---- 行政管理总部(352)、基建办(669)、党群部(353)、信息技术运保部(744)、信息技术开发部(745)
---- 法律合规部(737)、风险管理部(359)、审计部(358)
and a.Status=1 and a.FDAppraiseEID in (select Director from oDepartment where DepID in (702,355,356,354,360,350,351,352,669,353,744,745,737,359,358))
---- 部门负责人(业务部门)
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570035'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门考核工作</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
-------- 浙商证券研究所(361)、网点运营管理总部(362)、财富管理中心（事业部）(715)、投资银行(695)、投资银行质量控制总部(670)
-------- 证券投资部(380)、融资融券部(381)、衍生品经纪业务总部(382)、FICC事业部(383)、金融衍生品部(394)、经纪业务总部(738)、浙商资管(393->544)、浙商资本(392)
and a.Status=1 and a.FDAppraiseEID in (select Director from oDepartment where DepID in (361,362,715,695,670,380,381,382,383,394,738,544,392))
---- 合规
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570020'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门合规考核工作</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
-------- 法律合规部(737)、风险管理部(359)、审计部(358)
and a.Status=2 and a.FDAppraiseEID in (select Director from oDepartment where DepID in (737,358,359))
---- 财务
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570030'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门财务考核工作</a>' AS url, 
a.FDAppraiseEID AS approver, 1 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
-------- 计划财务部(355)
and a.Status=2 and a.FDAppraiseEID in (select Director from oDepartment where DepID=355)
---- 分管领导
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.570040'',''leftid^' + cast(a.Status AS nvarchar(2)) + N''',''职能部门考核'')">请您进行'
+ cast(YEAR(b.Date) AS varchar(4)) + N'年职能部门考核工作</a>' AS url, 
a.FDAppraiseEID AS approver, 2 AS id
FROM pYear_FDDepAppraise a,pYear_FDAppraiseProcess b
WHERE ISNULL(a.IsSubmit,0)=0 and a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
and a.Status=3 
AND (select COUNT(IsSubmit)-COUNT(ISNULL(IsSubmit,1)) from pYear_FDDepAppraise
where Status=1 and FDAppraiseEID in (select Director from pVW_pFDAppraise where Status=3 and FDAppraiseEID=a.FDAppraiseEID))=0
AND (select COUNT(IsSubmit)-COUNT(ISNULL(IsSubmit,1)) from pYear_FDDepAppraise
where Status=2 and FDAppraiseEID in (select Director from pVW_pFDAppraise where Status=3 and FDAppraiseEID=a.FDAppraiseEID))=0

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

-- 中层员工(分公司/一级营业部负责人) 自评
-- skyWindow ID: 500030
UNION ALL
SELECT N'<a href="#" onclick="moveTo(''1.0.500030'',''年度考核--自评'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年年度考核自评</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (24,5) AND a.Score_Status=0 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
and a.pYear_ID=b.ID

-- 普通员工 自评
-- skyWindow ID: 500010
UNION ALL
SELECT N'<a href="#" onclick="moveTo(''1.0.500010'',''年度考核--自评'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年年度考核自评</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (4,11,29,12,13,14,17,19,20) AND a.Score_Status=0 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
and a.pYear_ID=b.ID


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
-- 总部部门负责人 分管领导评分
-- skyWindow ID: 502110
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502110'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--分管领导评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部部门负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=1 AND a.Score_Status=2 
AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 总部部门负责人 总裁评分
-- skyWindow ID: 502120
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502120'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--总裁评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部部门负责人年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 3 AS id
FROM pYear_Score a, pYear_Process b
WHERE a.Score_Type1 IN (1) AND a.Score_Status=3
AND (select COUNT(Initialized)/COUNT(ISNULL(Initialized,1)) from pYear_Score 
where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)=1
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 总部部门负责人 董事长评分
-- skyWindow ID: 502125
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502125'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--董事长评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年总部部门负责人年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 3 AS id
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
ISNULL(a.Score_EID,5256) AS approver, 2 AS id
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
-- 子公司合规风控总监 首席风险官评分
-- skyWindow ID: 502150
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502150'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--首席风险官评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年子公司合规风控总监年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=26 AND a.Score_Status=2 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID 
AND a.EID=(select EID from eEmployee where JobID in (select JobID from oJob where JobAbbr like N'合规风控%' AND ISNULL(isDisabled,0)=0 AND xOrder<>999999999999999 AND CompID=13))
-- 子公司部门负责人 子公司总经理评分
-- skyWindow ID: 502155
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502155'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--子公司总经理评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年子公司部门负责人年度考核评分</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 1 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=10 AND a.Score_Status=3 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 子公司部门负责人 董事长评分
-- skyWindow ID: 502160
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502160'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--董事长评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年子公司部门负责人年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 4 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1=10 AND a.Score_Status=9
AND (select COUNT(Initialized)/COUNT(ISNULL(Initialized,1)) from pYear_Score 
where Score_Type1=a.Score_Type1 AND Score_Status=a.Score_Status AND Score_EID=a.Score_EID)=1
AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
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
ISNULL(a.Score_EID,5256) AS approver, 5 AS id
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (24,5) AND a.Score_Status=5 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.pYear_ID=b.ID
-- 分公司负责人/一级营业部负责人 董事长评分
-- skyWindow ID: 502240
UNION ALL
SELECT DISTINCT N'<a href="#" onclick="moveTo(''1.0.502245'',''leftid^' + cast(a.Score_Status AS nvarchar(15)) + 
N''',''年度考核--董事长评分'')">请您完成'
+ cast(datepart(yy, b.Date) AS varchar(4)) + N'年分公司/一级营业部负责人年度考核评分及排名</a>' AS url, 
ISNULL(a.Score_EID,5256) AS approver, 5 AS id
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