-- pVW_pYear_ScoreType_update

-------- 字段说明 --------
-- sType：被考核类型
-- EID：被考核人员EID
-- Score_EID：考核人员EID
-- Score_DepID：考核人员部门
-- Weight1：员工考核内容1考核百分比
-- Weight2：员工考核内容2考核百分比
-- Weight3：员工考核内容3考核百分比
-- Modulus：员工考核内容考核权重
-- ComplModulus：兼职员工考核内容考核权重
-- Score_Status：考核阶段
-- SCORE_TYPE1：考核角色
-- SCORE_TYPE2：兼职合规

-------- SCORE_TYPE1 被考核类型说明 --------
-- 1-总部部门负责人
-- 2-总部部门副职
-- 4-总部普通员工
-- 26-子公司班子成员
-- 10-子公司部门行政负责人
-- 30-子公司部门副职
-- 11-子公司普通员工
-- 31-一级分支机构负责人
-- 32-二级分支机构副职及二级分支机构经理室成员
-- 33-分支机构普通员工
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
ALTER VIEW [dbo].[pVW_pYear_ScoreType_update]
AS

--------- 总部部门负责人 --------
-- 1-总部部门负责人
-- Score_Status=0：0%               自评完毕
-- Score_Status=10：30%             履职情况胜任素质测评
-- Score_Status=20：70%             战略企划部考核(部门年度工作计划)
-- Score_Status=99：%               最终年度考核
--
-- 总部部门负责人 自评 0% Score_Status-0
SELECT DISTINCT N'总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部部门负责人 履职情况胜任素质测评 30% Score_Status-10
---- 非法律合规部门
UNION
SELECT DISTINCT N'总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) and a.kpidepidyy<>737
--
-- 总部部门负责人 履职情况胜任素质测评 30% Score_Status-10
---- 法律合规部门
UNION
SELECT DISTINCT N'总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) and a.kpidepidyy=737
--
-- 总部部门负责人 战略企划部考核 70% Score_Status-20
---- 战略企划部(702)
UNION
SELECT DISTINCT N'总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=702) AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,70 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
4 AS Score_Status,N'2-战略企划部考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部部门负责人 最终年度考核 % Score_Status-99
UNION
SELECT DISTINCT N'总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-最终年度考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=1 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)


--------- 总部部门副职 --------
-- 2-总部部门副职
-- Score_Status=0：0%               自评完毕
-- Score_Status=10：30%             履职情况胜任素质测评
-- Score_Status=20：70%             战略企划部考核(部门年度工作计划)
-- Score_Status=99：%               最终年度考核
--
-- 总部部门副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部部门副职 履职情况胜任素质测评 30% Score_Status-1
---- 非法律合规部门
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) AND a.kpidepidyy<>737
--
-- 总部部门副职 战略企划部考核 70% Score_Status-2
---- 非法律合规部门
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=702) AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,70 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
4 AS Score_Status,N'2-战略企划部考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy<>737
--
-- 总部部门副职 最终年度考核 % Score_Status-99
---- 非法律合规部门
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-最终年度考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy<>737
--
-- 总部部门副职 最终年度考核 70% Score_Status-99
---- 法律合规部门 合规总监(许向军：1033)考核 100%
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1033 AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-合规总监考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=2 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) AND a.kpidepidyy=737


--------- 总部普通员工 --------
-- 4-总部普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=10：30%             员工互评
-- Score_Status=99：70%             总部部门负责人考核
--
-- 总部普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=4 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部普通员工 员工互评 30% Score_Status-1
---- 不含法律合规部
UNION
SELECT DISTINCT N'总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=4 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) and a.kpidepidyy<>737
--
-- 总部普通员工 总部部门负责人考核 70% Score_Status-99
---- 不含法律合规部
UNION
SELECT DISTINCT N'总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select ISNULL(Director,Director2) from oDepartment where DepID=a.kpidepidyy) AS Score_EID,
60 AS Weight1,30 AS Weight2,10 AS Weight3,70 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-总部部门负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=4 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) and a.kpidepidyy<>737
--
-- 总部普通员工 总部部门负责人考核 100% Score_Status-99
---- 法律合规部 合规总监(许向军：1033)考核 100%
UNION
SELECT DISTINCT N'总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1033 AS Score_EID,
70 AS Weight1,30 AS Weight2,NULL AS Weight3,100 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-总部部门负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=4 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5) and a.kpidepidyy=737


------ 一级分支机构负责人 ------
-- 31-一级分支机构负责人
-- Score_Status=0：0%               自评完毕
-- Score_Status=10：25%             履职情况胜任素质测评
-- Score_Status=20：60%             网点运营管理总部考核(经营业绩指标)
-- Score_Status=30：15%             法律合规部考核(合规管理有效性)
-- Score_Status=99：%               最终年度考核
--
-- 一级分支机构负责人 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构负责人 履职情况胜任素质测评 25% Score_Status-1
UNION
SELECT DISTINCT N'一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,25 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构负责人 网点运营管理总部(DepID:362)考核 60% Score_Status-2
UNION
SELECT DISTINCT N'一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=362) AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,60 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
4 AS Score_Status,N'2-网点运营管理总部考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构负责人 法律合规部(DepID:737)考核 15% Score_Status-3
UNION
SELECT DISTINCT N'一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=737) AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,15 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
3 AS Score_Status,N'3-法律合规部考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构负责人 最终年度考核 % Score_Status-99
UNION
SELECT DISTINCT N'一级分支机构负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-最终年度考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=31 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)


------ 一级分支机构副职及二级分支机构经理室成员 ------
-- 32-一级分支机构副职及二级分支机构经理室成员
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：40%              履职情况胜任素质测评
-- Score_Status=20：60%             网点运营管理总部考核(经营业绩指标)
-- Score_Status=30：15%             法律合规部考核(合规管理有效性)
-- Score_Status=99：%               最终年度考核
--
-- 一级分支机构副职及二级分支机构经理室成员 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'一级分支机构副职及二级分支机构经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=32 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构副职及二级分支机构经理室成员 履职情况胜任素质测评 40% Score_Status-1
UNION
SELECT DISTINCT N'一级分支机构副职及二级分支机构经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,25 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-履职情况胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=32 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构副职及二级分支机构经理室成员 网点运营管理总部(DepID:362)考核 60% Score_Status-2
UNION
SELECT DISTINCT N'一级分支机构副职及二级分支机构经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=362) AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,60 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
4 AS Score_Status,N'2-网点运营管理总部考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=32 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构副职及二级分支机构经理室成员 法律合规部(DepID:737)考核 15% Score_Status-3
UNION
SELECT DISTINCT N'一级分支机构副职及二级分支机构经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=737) AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,15 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
3 AS Score_Status,N'3-法律合规部考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=32 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级分支机构副职及二级分支机构经理室成员 最终年度考核 % Score_Status-99
UNION
SELECT DISTINCT N'一级分支机构副职及二级分支机构经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-最终年度考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=32 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)


--------- 分支机构普通员工 --------
-- 33-分支机构普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=2：70%*60%          二级分支机构负责人考核
-- Score_Status=99：70%*40%         一级分支机构负责人考核
-- Score_Status=99：70%             一级分支机构负责人考核
--
-- 分支机构普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=33 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分支机构普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=33 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分支机构普通员工 二级分支机构负责人考核 70%*60% Score_Status-2
UNION
SELECT DISTINCT N'分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
60 AS Weight1,30 AS Weight2,10 AS Weight3,70*0.60 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
2 AS Score_Status,N'2-二级分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=33 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
and c.DepGrade=2 and c.Director<>c.Director2
--
-- 分支机构普通员工
---- 一级分支机构普通员工 一级分支机构负责人考核 70% Score_Status-99
UNION
SELECT DISTINCT N'分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
60 AS Weight1,30 AS Weight2,10 AS Weight3,70 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-一级分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=33 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5) 
and (c.DepGrade=1 or (c.DepGrade=2 and c.Director=c.Director2))
---- 二级分支机构普通员工 一级分支机构负责人考核 70%*40% Score_Status-99
UNION
SELECT DISTINCT N'分支机构普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
60 AS Weight1,30 AS Weight2,10 AS Weight3,70*0.40 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-一级分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=33 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5) 
and c.DepGrade=2 and c.Director<>c.Director2


--------- 分支机构合规专员 --------
-- 14-分支机构合规专员
-- Score_Status=0：                     自评完毕
-- Score_Status=99：                    合规总监考核
--
-- 分支机构合规专员 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'分支机构合规专员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=14 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分支机构合规专员 合规总监(许向军：1033)考核 Score_Status-99
UNION
SELECT DISTINCT N'分支机构合规专员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1033 AS Score_EID,
70 AS Weight1,30 AS Weight2,NULL AS Weight3,100 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-合规总监考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=14 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)


--------- 分支机构区域财务经理 --------
-- 17-分支机构区域财务经理
-- Score_Status=0：                     自评完毕
-- Score_Status=20：                    分支机构负责人考核
-- Score_Status=30：                    计划财务部负责人考核
-- Score_Status=99：                    财务总监考核
--
-- 分支机构区域财务经理 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'分支机构区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=17 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
-- 
-- 分支机构区域财务经理 分支机构负责人考核 Score_Status-20
UNION
SELECT DISTINCT N'分支机构区域财务经理' AS sType,c.CWEID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
70 AS Weight1,30 AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
2 AS Score_Status,N'2-分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=17 AND a.pstatus=1 AND c.CWEID=a.EID AND c.DepType in (2,3) AND a.EID=d.EID and d.status not in (4,5)
--
-- 分支机构区域财务经理 财务部负责人(DepID:355)考核 Score_Status-30
---- 财务部负责人(DepID:355)
UNION
SELECT DISTINCT N'分支机构区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=355) AS Score_EID,
70 AS Weight1,30 AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
3 AS Score_Status,N'3-财务部负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=17 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND (select Director from oDepartment where DepID=355)<>1028
--
-- 分支机构区域财务经理 财务总监(盛建龙：1028)考核 Score_Status-99
UNION
SELECT DISTINCT N'分支机构区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
70 AS Weight1,30 AS Weight2,NULL AS Weight3,40 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-财务总监考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=17 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)


--------- 综合会计 --------
-- 19-综合会计
-- Score_Status=0：                     自评完毕
-- Score_Status=20：                    分支机构负责人考核
-- Score_Status=30：                    区域财务经理考核
-- Score_Status=99：                    计划财务部负责人考核
--
-- 综合会计 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
-- 
-- 综合会计 分支机构负责人考核 Score_Status-20
UNION
SELECT DISTINCT N'综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
70 AS Weight1,30 AS Weight2,NULL AS Weight3,20 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
2 AS Score_Status,N'2-分支机构负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND c.Director is not NULL AND a.EID=d.EID and d.status not in (4,5)
--
-- 综合会计 分支机构区域财务经理考核 Score_Status-30
---- 分支机构区域财务经理(CWEID)为非空
UNION
SELECT DISTINCT N'综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.CWEID AS Score_EID,
70 AS Weight1,30 AS Weight2,NULL AS Weight3,40 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
3 AS Score_Status,N'3-分支机构区域财务经理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND c.CWEID is not NULL AND a.EID=d.EID and d.status not in (4,5)
--
-- 综合会计 计划财务部负责人(DepID:355)考核 Score_Status-99
---- 分支机构区域财务经理(CWEID)为非空
UNION
SELECT DISTINCT N'综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=355) AS Score_EID,
70 AS Weight1,30 AS Weight2,NULL AS Weight3,40 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-计划财务部负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND c.CWEID is not NULL AND a.EID=d.EID and d.status not in (4,5)
--
-- 综合会计 计划财务部负责人(DepID:355)考核 Score_Status-99
---- 分支机构区域财务经理(CWEID)为空
UNION
SELECT DISTINCT N'综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=355) AS Score_EID,
70 AS Weight1,30 AS Weight2,NULL AS Weight3,80 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-计划财务部负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=19 AND a.pstatus=1 AND a.kpidepidyy=c.DepID AND c.CWEID is NULL AND a.EID=d.EID and d.status not in (4,5)


------ 子公司部门行政负责人 ------
-- 10-子公司部门行政负责人
-- Score_Status=0：0%                       自评完毕
-- Score_Status=1：20%                      胜任素质测评
-- Score_Status=2：(50%+30%)*20%            子公司总经理助理考核(部门年度工作计划和履职情况)
-- Score_Status=3：(50%+30%)*30%            子公司常务副总经理考核(部门年度工作计划和履职情况)
-- Score_Status=99：(50%+30%)*50%           子公司董事长考核(部门年度工作计划和履职情况)
-- Score_Status=3：(50%+30%)*30%            子公司常务副总经理考核(部门年度工作计划和履职情况)
-- Score_Status=99：(50%+30%)*70%           子公司董事长考核(部门年度工作计划和履职情况)
-- Score_Status=99：(50%+30%)*70%           合规总监考核(部门年度工作计划和履职情况)
--
-- 子公司部门行政负责人 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND c.CompID=13
--
-- 子公司部门行政负责人 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,20 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND c.CompID=13
--
-- 子公司合规风控部行政负责人 履职情况胜任素质测评 0% Score_Status-1
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,0 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy=666 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND c.CompID=13
--
-- 子公司部门行政负责人 子公司总经理助理考核 (50%+30%)*20% Score_Status-2
---- 子公司总经理助理协助分管子公司部门
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,20 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
2 AS Score_Status,N'2-子公司总经理助理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND ISNULL(c.Director2,1028) not in (1028,1343) AND c.CompID=13
--
-- 子公司部门行政负责人 子公司常务副总经理(楼小平：1343)考核 (50%+30%)*30% Score_Status-3
---- 子公司总经理助理协助分管子公司部门
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1343 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
3 AS Score_Status,N'3-子公司常务副总经理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND ISNULL(c.Director2,1028) not in (1028,1343) AND c.CompID=13
-- 子公司部门行政负责人 子公司总经理(盛建龙：1028)考核 (50%+30%)*50% Score_Status-99
---- 子公司总经理助理协助分管子公司部门
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,50 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-子公司总经理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND ISNULL(c.Director2,1028) not in (1028,1343) AND c.CompID=13
--
-- 子公司部门行政负责人 子公司常务副总经理(楼小平：1343)考核 (50%+30%)*30% Score_Status-3
---- 非子公司总经理助理分管子公司部门
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1343 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
3 AS Score_Status,N'3-子公司常务副总经理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND ISNULL(c.Director2,1028) in (1028,1343) AND c.CompID=13
-- 子公司部门行政负责人 子公司总经理(盛建龙：1028)考核 (50%+30%)*70% Score_Status-99
---- 非子公司总经理助理分管子公司部门
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,70 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-子公司总经理考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND ISNULL(c.Director2,1028) in (1028,1343) AND c.CompID=13
--
-- 子公司合规风控部行政负责人 子公司合规总监(方斌：5479)考核 (50%+50%)*100% Score_Status-2
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,5479 AS Score_EID,
50 AS Weight1,50 AS Weight2,NULL AS Weight3,100 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'2-子公司合规总监考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=10 AND a.pstatus=1 AND a.kpidepidyy=666 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND c.CompID=13


------ 子公司部门副职 ------
-- 30-子公司部门副职
-- Score_Status=0：0%                       自评完毕
-- Score_Status=1：30%                      胜任素质测评
-- Score_Status=2：(30%+40%)*30%            子公司部门负责人考核(部门年度工作计划和履职情况)
-- Score_Status=99：(30%+40%)*70%            子公司分管领导考核(部门年度工作计划和履职情况)
--
-- 子公司部门副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'30-子公司部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=30 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND c.CompID=13
--
-- 子公司部门副职 履职情况胜任素质测评 30% Score_Status-1
UNION
SELECT DISTINCT N'30-子公司部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=30 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND c.CompID=13
--
-- 子公司部门副职 子公司部门负责人考核 (30%+40%)*30%  Score_Status-2
UNION
SELECT DISTINCT N'30-子公司部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
2 AS Score_Status,N'2-子公司部门负责人' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=30 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND c.CompID=13
--
-- 子公司部门副职 子公司分管领导考核 (30%+40%)*70% Score_Status-99
UNION
SELECT DISTINCT N'30-子公司部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,70 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-子公司分管领导' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=30 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND c.CompID=13


--------- 子公司普通员工 --------
-- 11-子公司普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=99：70%             子公司部门行政负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 子公司普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=11 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID
--
-- 子公司普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=11 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND a.kpidepidyy not in (666,542)
--
-- 子公司普通员工 子公司负责人考核 70% Score_Status-99
UNION
SELECT DISTINCT N'子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,ISNULL(c.Director,c.Director2) AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,70 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-子公司负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=11 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND a.kpidepidyy not in (666,542)
--
-- 子公司普通员工 子公司负责人考核 100% Score_Status-99
---- 合规部门
UNION
SELECT DISTINCT N'子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
50 AS Weight1,50 AS Weight2,NULL AS Weight3,100 AS Modulus,(case when a.Score_Type2=35 then 49 else NULL end) as ComplModulus,
99 AS Score_Status,N'99-子公司负责人考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.Score_Type1=11 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND a.kpidepidyy=c.DepID AND a.kpidepidyy in (666,542)

--------- 兼职合规管理 --------
-- 35-兼职合规管理
-- Score_Status=7：100%*51%               法律合规部负责人考核(兼合规管理)
--
-- 兼职合规管理 合规总监考核 51% Score_Status-7
---- 总部+分支机构      合规总监(许向军：1033)
UNION
SELECT DISTINCT N'兼职合规管理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1033 AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,51 as ComplModulus,
7 AS Score_Status,N'7-合规总监考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type2=35 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND (select CompID from oDepartment where DepID=a.kpidepidyy)=11
---- 资管               合规总监(方斌：5479)
UNION
SELECT DISTINCT N'兼职合规管理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,5479 AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,51 as ComplModulus,
7 AS Score_Status,N'7-合规总监考核' AS Score_StatusTitle,a.Score_Type1 AS Score_Type1,a.Score_Type2 AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.Score_Type2=35 AND a.pstatus=1 AND a.EID=d.EID and d.status not in (4,5)
AND (select CompID from oDepartment where DepID=a.kpidepidyy)=13

GO