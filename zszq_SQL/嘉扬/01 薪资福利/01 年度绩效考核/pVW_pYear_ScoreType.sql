-- pVW_pYear_ScoreType

-------- 字段说明 --------
-- sType：被考核类型
-- EID：被考核人员EID
-- Score_EID：考核人员EID
-- Score_DepID：考核人员部门
-- Weight1：员工考核内容1考核百分比
-- Weight2：员工考核内容2考核百分比
-- Weight3：员工考核内容3考核百分比
-- Modulus：员工考核内容考核权重
-- Score_Status：考核阶段
-- SCORE_TYPE1：考核角色
-- SCORE_TYPE2：兼职合规

-------- SCORE_TYPE1 被考核类型说明 --------
-- 1-总部部门负责人
-- 2-总部部门副职
-- 4-总部普通员工
-- 26-子公司班子成员
-- 10-子公司部门行政负责人
-- 11-子公司普通员工
-- 31-一级分支机构负责人
-- 32-二级分支机构副职及二级分支机构经理室成员
-- 33-一级分支机构普通员工
-- 34-二级分支机构普通员工
-- 14-分支机构合规专员
-- 17-分支机构区域财务经理
-- 19-综合会计

-------- SCORE_TYPE2 兼职合规说明 --------
-- 35-兼职合规管理

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreType]
AS

--------- 总部部门负责人 --------
-- 1-总部部门负责人
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：50%              履职情况胜任素质测评(公司班子成员30%、分管领导50%、360度评价20%(部门负责人互评10%、下属员工10%))
-- Score_Status=2：50%              战略企划部考核(部门年度工作计划)
-- Score_Status=99：%               最终年度考核
--
-- 总部部门负责人 自评 0% Score_Status-0
SELECT DISTINCT N'1-总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部部门负责人 履职情况胜任素质测评 50% Score_Status-1
---- 非法律合规部门
UNION
SELECT DISTINCT N'1-总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) and a.kpidepidyy<>737
--
-- 总部部门负责人 履职情况胜任素质测评 50% Score_Status-1
---- 法律合规部门
UNION
SELECT DISTINCT N'1-总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) and a.kpidepidyy=737
--
-- 总部部门负责人 战略企划部考核 50%*100% Score_Status-2
---- 战略企划部(702)
UNION
SELECT DISTINCT N'1-总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
2 AS Score_Status,N'2-战略企划部考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) AND c.DepID=702
--
-- 总部部门负责人 最终年度考核 % Score_Status-99
UNION
SELECT DISTINCT N'1-总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
99 AS Score_Status,N'99-最终年度考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)


--------- 总部部门副职 --------
-- 2-总部部门副职
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：50%              履职情况胜任素质测评(分管领导30%、部门负责人50%、360度评价20%(下属员工20%))
-- Score_Status=2：50%*50%          总部部门负责人考核(部门年度工作计划)
-- Score_Status=99：50%*50%         分管领导考核(部门年度工作计划)
--
-- 总部部门副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部部门副职 履职情况胜任素质测评 50% Score_Status-1
---- 非法律合规部门
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) AND a.kpidepidyy<>737
--
-- 总部部门副职 总部部门负责人考核 50%*50% Score_Status-2
---- 总部部门负责人(Director)非空，且总部部门负责人(Director)非分管领导
---- 非法律合规部门
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,50 AS Modulus,
2 AS Score_Status,N'2-总部部门负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND (c.Director is not NULL AND c.Director<>c.Director2) AND a.kpidepidyy<>737
--
-- 总部部门副职 分管领导考核 50%*50% Score_Status-99
---- 总部部门负责人(Director)为非空，或总部部门负责人(Director)非分管领导
---- 非法律合规部门
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,50 AS Modulus,
99 AS Score_Status,N'99-分管领导考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND (c.Director is not NULL AND c.Director<>c.Director2) AND a.kpidepidyy<>737
--
-- 总部部门副职 分管领导考核 50%*100% Score_Status-99
---- 总部部门负责人(Director)为空，或总部部门负责人(Director)为分管领导
---- 非法律合规部门
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
99 AS Score_Status,N'99-分管领导考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND (c.Director is NULL or c.Director=c.Director2) AND a.kpidepidyy<>737
--
-- 总部部门副职 履职情况胜任素质测评 50% Score_Status-1
---- 法律合规部门 合规总监(许向军：1033)考核 100%
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1033 AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) AND a.kpidepidyy=737
--
-- 总部部门副职 分管领导考核 50%*100% Score_Status-99
---- 法律合规部门 合规总监(许向军：1033)考核 100%
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1033 AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
99 AS Score_Status,N'99-分管领导考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) AND a.kpidepidyy=737


--------- 总部普通员工 --------
-- 4-总部普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=99：70%             总部部门负责人考核(工作业绩50%、工作态度20%、工作能力20%和合规风控性10%)
--
-- 总部普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'4-总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=4 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'4-总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=4 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部普通员工 总部部门负责人考核 70% Score_Status-99
UNION
SELECT DISTINCT N'4-总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,ISNULL(c.Director,c.Director2) AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
99 AS Score_Status,N'99-总部部门负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=4 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)


------ 一级分支机构负责人 ------
-- 31-一级分支机构负责人
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：25%              履职情况胜任素质测评(公司班子领导30%、分管领导50%、360度评价20%(一级分支机构互评10%、分支机构员工10%))
-- Score_Status=2：60%              网点运营管理总部考核(经营业绩指标)
-- Score_Status=3：15%              法律合规部考核(合规管理有效性)
-- Score_Status=99：%               最终年度考核
--
-- 一级分支机构负责人 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'31-一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构负责人 履职情况胜任素质测评 25% Score_Status-1
UNION
SELECT DISTINCT N'31-一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
25 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构负责人 网点运营管理总部(DepID:362)考核 60% Score_Status-2
UNION
SELECT DISTINCT N'31-一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=362) AS Score_EID,
60 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
2 AS Score_Status,N'2-网点运营管理总部考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构负责人 法律合规部(DepID:737)考核 15% Score_Status-3
UNION
SELECT DISTINCT N'24-一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=737) AS Score_EID,
15 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
3 AS Score_Status,N'3-法律合规部考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构负责人 最终年度考核 % Score_Status-99
UNION
SELECT DISTINCT N'31-一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
99 AS Score_Status,N'99-最终年度考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)


------ 一级分支机构副职及二级分支机构经理室成员 ------
-- 32-一级分支机构副职及二级分支机构经理室成员
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：40%              履职情况胜任素质测评(分管领导30%、一级分支机构负责人50%、360度评价20%(下属员工20%))
-- Score_Status=2：(50%+10%)*50%    分公司负责人考核(工作任务目标50%、合规管理有效性10%)
-- Score_Status=99：(50%+10%)*50%   分管领导考核(工作任务目标50%、合规管理有效性10%)
--
-- 一级分支机构副职及二级分支机构经理室成员 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'32-一级分支机构副职及二级分支机构经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=32 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构副职及二级分支机构经理室成员 履职情况胜任素质测评 40% Score_Status-1
UNION
SELECT DISTINCT N'32-一级分支机构副职及二级分支机构经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
40 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=32 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构副职及二级分支机构经理室成员 分公司负责人考核 (50%+10%)*50% Score_Status-2
UNION
SELECT DISTINCT N'32-一级分支机构副职及二级分支机构经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
50 AS Weight1,10 AS Weight2,NULL AS Weight3,50 AS Modulus,
2 AS Score_Status,N'2-一级分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=32 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is not NULL
--
-- 一级分支机构副职及二级分支机构经理室成员 分管领导(赵伟江：1026)考核 (50%+10%)*50% Score_Status-99
UNION
SELECT DISTINCT N'32-一级分支机构副职及二级分支机构经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1026 AS Score_EID,
50 AS Weight1,10 AS Weight2,NULL AS Weight3,50 AS Modulus,
99 AS Score_Status,N'99-分管领导考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=32 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is not NULL


--------- 一级分支机构普通员工 --------
-- 33-一级分支机构普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=99：70%             分公司负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 一级分支机构普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'33-一级分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=33 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'33-一级分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=33 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构普通员工 分公司负责人考核 70% Score_Status-99
UNION
SELECT DISTINCT N'33-一级分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
99 AS Score_Status,N'99-一级分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=33 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)


--------- 二级分支机构普通员工 --------
-- 34-二级分支机构普通员工
-- Score_Status=0：0%                   自评完毕
-- Score_Status=1：30%                  员工互评
-- Score_Status=2：70%*60%              二级分支机构负责人考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=99：70%*40%             一级分支机构负责人考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=99：70%*100%            一级分支机构兼职二级分支机构负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 二级营业部普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'34-二级分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=34 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 二级营业部普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'34-二级分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=34 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 二级营业部普通员工 二级分支机构负责人考核 70%*60% Score_Status-2
UNION
SELECT DISTINCT N'34-二级分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,60 AS Modulus,
2 AS Score_Status,N'2-二级分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=34 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director<>(select Director from oDepartment where DepID=dbo.eFN_getdepid1st(a.kpidepidyy))
--
-- 二级营业部普通员工 一级分支机构负责人考核 70%*40% Score_Status-99
UNION
SELECT DISTINCT N'34-二级分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,40 AS Modulus,
99 AS Score_Status,N'99-一级分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=34 AND a.pstatus=1 AND dbo.eFN_getdepid1st(a.kpidepidyy)=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director<>(select Director from oDepartment where DepID=a.kpidepidyy)
--
-- 二级营业部普通员工 一级分支机构兼职二级分支机构负责人考核 70%*100% Score_Status-99
UNION
SELECT DISTINCT N'34-二级分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
99 AS Score_Status,N'99-一级分支机构兼职二级分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=34 AND a.pstatus=1 AND dbo.eFN_getdepid1st(a.kpidepidyy)=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director=(select Director from oDepartment where DepID=a.kpidepidyy)


--------- 分支机构合规专员 --------
-- 14-分支机构合规专员
-- Score_Status=0：0%                           自评完毕
-- Score_Status=99：(60%+40%)*100%              合规总监考核(岗位工作完成情况和专业技术考核)
--
-- 分支机构合规专员 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'14-分支机构合规专员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=14 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分支机构合规专员 合规总监(许向军：1033)考核 (60%+40%)*100% Score_Status-99
UNION
SELECT DISTINCT N'14-分支机构合规专员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1033 AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,100 AS Modulus,
99 AS Score_Status,N'99-合规总监考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=14 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND (select Director from oDepartment where DepID=737)=1033


--------- 兼职合规管理 --------
-- 35-兼职合规管理
-- Score_Status=7：100%*51%               法律合规部负责人考核(兼合规管理)
--
-- 兼职合规管理 法律合规部负责人(DepID:737)考核 51% Score_Status-7
UNION
SELECT DISTINCT N'35-兼职合规管理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=737) AS Score_EID,
100 AS Weight1,NULL AS Weight2,NULL AS Weight3,51 AS Modulus,
7 AS Score_Status,N'7-法律合规部负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type2=35 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)


--------- 分支机构区域财务经理 --------
-- 17-分支机构区域财务经理
-- Score_Status=0：0%                   自评完毕
-- Score_Status=2：(60%+40%)*30%        分支机构负责人考核(岗位工作完成情况60%和专业技术考核40%)
-- Score_Status=3：(60%+40%)*30%        计划财务部负责人考核(岗位工作完成情况60%和专业技术考核40%)
-- Score_Status=99：(60%+40%)*40%       财务总监考核(岗位工作完成情况60%和专业技术考核40%)
--
-- 分支机构区域财务经理 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'17-分支机构区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=17 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
-- 
-- 分支机构区域财务经理 分支机构负责人考核 (60%+40%)*30% Score_Status-2
UNION
SELECT DISTINCT N'17-分支机构区域财务经理' AS sType,c.CWEID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,30 AS Modulus,
2 AS Score_Status,N'2-分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=17 AND a.pstatus=1 AND c.CWEID=a.EID AND c.DepType in (2,3) AND a.EID=d.EID and d.status not in (4,5)
--
-- 分支机构区域财务经理 财务部负责人(DepID:355)考核 (60%+40%)*30% Score_Status-3
---- 财务部负责人(DepID:355)
UNION
SELECT DISTINCT N'17-分支机构区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=355) AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,30 AS Modulus,
3 AS Score_Status,N'3-财务部负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=17 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND (select Director from oDepartment where DepID=355)<>1028
--
-- 分支机构区域财务经理 财务总监(盛建龙：1028)考核 (60%+40%)*40% Score_Status-99
UNION
SELECT DISTINCT N'17-分支机构区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,40 AS Modulus,
99 AS Score_Status,N'99-财务总监考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=17 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)


--------- 综合会计 --------
-- 19-综合会计
-- Score_Status=0：0%                   自评完毕
-- Score_Status=2：(60%+40%)*20%        分支机构负责人考核(岗位工作完成情况60%和专业技术考核40%)
-- Score_Status=3：(60%+40%)*40%        区域财务经理考核(岗位工作完成情况60%和专业技术考核40%)
-- Score_Status=99：(60%+40%)*40%       计划财务部负责人考核(岗位工作完成情况60%和专业技术考核40%)
--
-- 综合会计 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'19-综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
-- 
-- 综合会计 分支机构负责人考核 (60%+40%)*20% Score_Status-2
UNION
SELECT DISTINCT N'17-分支机构区域财务经理' AS sType,c.CWEID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,20 AS Modulus,
2 AS Score_Status,N'2-分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND c.CWEID=a.EID AND c.DepType in (2,3) AND a.EID=d.EID and d.status not in (4,5)
--
-- 综合会计 分支机构区域财务经理考核 (60%+40%)*40% Score_Status-3
---- 分支机构区域财务经理(CWEID)为非空
UNION
SELECT DISTINCT N'19-综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.CWEID AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,40 AS Modulus,
3 AS Score_Status,N'3-分支机构区域财务经理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND c.CWEID is not NULL AND a.EID=d.EID and d.status not in (4,5)
--
-- 综合会计 计划财务部负责人(DepID:355)考核 (60%+40%)*40% Score_Status-99
---- 分支机构区域财务经理(CWEID)为非空
UNION
SELECT DISTINCT N'19-综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=355) AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,40 AS Modulus,
99 AS Score_Status,N'99-计划财务部负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND c.CWEID is not NULL AND a.EID=d.EID and d.status not in (4,5)
--
-- 综合会计 计划财务部负责人(DepID:355)考核 (60%+40%)*80% Score_Status-99
---- 分支机构区域财务经理(CWEID)为空
UNION
SELECT DISTINCT N'19-综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=355) AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,80 AS Modulus,
99 AS Score_Status,N'99-计划财务部负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND c.CWEID is NULL AND a.EID=d.EID and d.status not in (4,5)


------ 子公司合规总监 ------
-- 26-子公司班子成员
-- Score_Status=0：0%               自评完毕
-- Score_Status=2：母公司首席风险官考核(年度工作计划和履职情况)
-- Score_Status=3：子公司总经理考核(年度工作计划和履职情况)
-- Score_Status=99：子公司董事长考核(年度工作计划和履职情况)
--
---- 子公司合规总监 自评 0% Score_Status-0
--UNION
--SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
--NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
--0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=26 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
---- 子公司合规总监 母公司首席风险官(高玮：1027)考核 (60%+40%)*50% Score_Status-2
--UNION
--SELECT DISTINCT N'子公司合规总监' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1027 AS Score_EID,
--60 AS Weight1,40 AS Weight2,NULL AS Weight3,50 AS Modulus,
--2 AS Score_Status,N'2-子公司首席风险官考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=26 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--AND a.EID=5479
----
---- 子公司合规总监 子公司总经理(楼小平：1343)考核 (60%+40%)*20% Score_Status-3
--UNION
--SELECT DISTINCT N'子公司合规总监' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1343 AS Score_EID,
--60 AS Weight1,40 AS Weight2,NULL AS Weight3,20 AS Modulus,
--3 AS Score_Status,N'3-子公司总经理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=26 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--AND a.EID=5479
----
---- 子公司合规总监 子公司董事长(盛建龙：1028)考核 (60%+40%)*30% Score_Status-99
--UNION
--SELECT DISTINCT N'子公司合规总监' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
--60 AS Weight1,40 AS Weight2,NULL AS Weight3,30 AS Modulus,
--99 AS Score_Status,N'99-子公司董事长考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=26 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--AND a.EID=5479


-------- 子公司部门行政负责人 ------
---- 10-子公司部门行政负责人
---- Score_Status=0：0%               自评完毕
---- Score_Status=1：20%              履职情况胜任素质测评
---- Score_Status=2：80%*50%          子公司合规总监考核(合规风控部)(部门年度工作计划和履职情况)
---- Score_Status=3：80%*20%          子公司总经理考核(合规风控部)(部门年度工作计划和履职情况)
---- Score_Status=99：80%*30%         子公司董事长考核(合规风控部)(部门年度工作计划和履职情况)
---- Score_Status=3：80%*40%          子公司总经理考核(部门年度工作计划和履职情况)
---- Score_Status=99：80%*60%         子公司董事长考核(部门年度工作计划和履职情况)
----
---- 子公司部门行政负责人 自评 0% Score_Status-0
--UNION
--SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
--NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
--0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
----
---- 子公司部门行政负责人 履职情况胜任素质测评 20% Score_Status-1
--UNION
--SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
--20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
--1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
----
---- 子公司合规风控部行政负责人 子公司合规总监(方斌：5479)考核 (50%+30%)*50% Score_Status-2
--UNION
--SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,5479 AS Score_EID,
--50 AS Weight1,30 AS Weight2,NULL AS Weight3,50 AS Modulus,
--2 AS Score_Status,N'2-子公司合规总监考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy=666 AND a.EID=d.EID and d.status not in (4,5)
----
---- 子公司合规风控部行政负责人 子公司总经理(盛建龙：1028)考核 (50%+30%)*20% Score_Status-3
--UNION
--SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
--50 AS Weight1,30 AS Weight2,NULL AS Weight3,20 AS Modulus,
--3 AS Score_Status,N'3-子公司总经理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy=666 AND a.EID=d.EID and d.status not in (4,5)
----
---- 子公司合规风控部行政负责人 子公司董事长(盛建龙：1028)考核 (50%+30%)*30% Score_Status-99
--UNION
--SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
--50 AS Weight1,30 AS Weight2,NULL AS Weight3,30 AS Modulus,
--99 AS Score_Status,N'99-子公司董事长考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy=666 AND a.EID=d.EID and d.status not in (4,5)
----
---- 子公司部门行政负责人 子公司总经理(盛建龙：1028)考核 (50%+30%)*40% Score_Status-3
--UNION
--SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
--50 AS Weight1,30 AS Weight2,NULL AS Weight3,40 AS Modulus,
--3 AS Score_Status,N'3-子公司总经理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)
----
---- 子公司部门行政负责人 子公司董事长(盛建龙：1028)考核 (50%+30%)*60% Score_Status-99
--UNION
--SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
--50 AS Weight1,30 AS Weight2,NULL AS Weight3,60 AS Modulus,
--99 AS Score_Status,N'99-子公司董事长考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)


--------- 子公司普通员工 --------
-- 11-子公司普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=99：70%             子公司部门行政负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 子公司普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'11-子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=11 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'11-子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=11 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司普通员工 子公司负责人考核 70% Score_Status-99
UNION
SELECT DISTINCT N'11-子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,ISNULL(c.Director,c.Director2) AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
99 AS Score_Status,N'99-子公司负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=11 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)

GO