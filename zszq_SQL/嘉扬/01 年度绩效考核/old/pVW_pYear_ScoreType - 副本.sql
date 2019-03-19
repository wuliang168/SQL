-- pVW_pYear_ScoreType
-------- 字段说明 --------
-- sType：被考核类型
-- EID：被考核人员EID
-- Score_EID：考核人员EID
-- Score_DepID：考核人员部门
-- Weight1：员工阶段1考核百分比
-- Weight2：员工阶段2考核百分比
-- Weight3：员工阶段3考核百分比
-- Modulus：考核权重
-- Score_Status：考核阶段
-- SCORE_TYPE1：考核角色
-- SCORE_TYPE2：兼职合规

-------- sType 被考核类型说明 --------
-- 1-总部部门负责人
-- 2-总部部门副职
-- 10-子公司部门行政负责人
-- 24-分公司负责人
-- 25-分公司副职
-- 5-一级营业部负责人
-- 6-一级营业部副职
-- 7-二级营业部经理室成员
-- 4-总部普通员工
-- 11-子公司普通员工
-- 29-分公司普通员工
-- 12-一级营业部普通员工
-- 13-二级营业部普通员工
-- 14-营业部合规风控专员
-- 17-营业部区域财务经理
-- 19-综合会计（集中）
-- 20-综合会计（非集中）

-------- SCORE_TYPE2 兼职合规说明 --------
-- 15-营业部合规联系人
-- 16-总部兼职合规专员

--------- 总部部门负责人 --------
-- 1-总部部门负责人
-- 358-合规审计部,359-风险管理部,670-投行质量控制总部
-- Score_Status=0：自评完毕
-- Score_Status=1：胜任素质测评
-- Score_Status=2：分管领导考核(部门年度工作计划和履职情况)
-- Score_Status=9：公司总裁考核(部门年度工作计划和履职情况)
--
-- 总部部门负责人 自评 0% Score_Status-0
SELECT DISTINCT N'总部部门负责人' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (1) AND a.pstatus = 1
--
-- 总部部门负责人 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'总部部门负责人' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (1) AND a.pstatus = 1
--
-- 总部部门负责人 分管领导考核 (50%+30%)*40% Score_Status-2
UNION
SELECT DISTINCT N'总部部门负责人' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,40 AS Modulus,
2 AS Score_Status,N'分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (1) AND a.pstatus = 1 AND depid not in(358,359,670)
--
-- 合规审计部、风险管理部、投行质量控制总部负责人 合规风控总监考核 (50%+30%)*50% Score_Status-2
UNION
SELECT DISTINCT N'合规审计部、风险管理部、投行质量控制总部负责人' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,50 AS Modulus,
2 AS Score_Status,N'合规风控总监考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (1) AND a.pstatus = 1 AND depid in(358,359,670)
--
-- 总部部门负责人 公司总裁考核 (50%+30%)*60% Score_Status-9
UNION
SELECT DISTINCT N'总部部门负责人' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'公司总裁考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (1) AND a.pstatus = 1 AND depid not in(358,359,670)
--
-- 合规审计部、风险管理部、投行质量控制总部负责人 公司总裁考核 (50%+30%)*50% Score_Status-9
UNION
SELECT DISTINCT N'合规审计部、风险管理部、投行质量控制总部负责人' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,50 AS Modulus,
9 AS Score_Status,N'公司总裁考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (1) AND a.pstatus = 1 AND depid in(358,359,670)


--------- 总部部门副职 --------
-- 2-总部部门副职
-- Score_Status=0：自评完毕
-- Score_Status=1：胜任素质测评
-- Score_Status=2：总部部门负责人考核(部门年度工作计划和履职情况)
-- Score_Status=9：分管领导考核(部门年度工作计划和履职情况)
--
-- 总部部门副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (2) AND a.pstatus = 1
--
-- 总部部门副职 胜任素质测评 30% Score_Status-1
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (2) AND a.pstatus = 1
--
-- 总部部门副职 总部部门负责人考核 70%*40% Score_Status-2
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,40 AS Modulus,
2 AS Score_Status,N'总部部门负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (2) AND a.pstatus = 1
--
-- 总部部门副职 分管领导考核 70%*60% Score_Status-9
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (2) AND a.pstatus = 1


------ 子公司部门行政负责人 ------
-- 10-子公司部门行政负责人
-- Score_Status=0：自评完毕
-- Score_Status=1：胜任素质测评
-- Score_Status=2：子公司总经理考核(部门年度工作计划和履职情况)
-- Score_Status=9：公司总裁考核(部门年度工作计划和履职情况)
--
-- 子公司部门行政负责人 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'子公司部门行政负责人' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (10) AND a.pstatus = 1
--
-- 子公司部门行政负责人 胜任素质测评 20% Score_Status-2
UNION
SELECT DISTINCT N'子公司部门行政负责人' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (10) AND a.pstatus = 1
--
-- 子公司部门行政负责人 子公司总经理考核 80%*40% Score_Status-3
UNION
SELECT DISTINCT N'子公司部门行政负责人' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,40 AS Modulus,
2 AS Score_Status,N'子公司总经理考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (10) AND a.pstatus = 1
--
-- 子公司部门行政负责人 公司总裁考核 80%*60% Score_Status-9
UNION
SELECT DISTINCT N'子公司部门行政负责人' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'公司总裁考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (10) AND a.pstatus = 1


------ 分公司负责人 ------
-- 24-分公司负责人
-- Score_Status=0：自评完毕
-- Score_Status=1：胜任素质测评
-- Score_Status=2：网点运营管理总部考核(经营业绩指标)
-- Score_Status=3：合规审计部考核(合规风控管理有效性)
-- Score_Status=4：分管领导考核(履职情况)
-- Score_Status=9：公司总裁考核(履职情况)
--
-- 分公司负责人 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'分公司负责人' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (24) AND a.pstatus = 1
--
-- 分公司负责人 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'分公司负责人' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (24) AND a.pstatus = 1
--
-- 分公司负责人 网点运营管理总部考核 40% Score_Status-2
UNION
SELECT DISTINCT N'分公司负责人' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
40 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
2 AS Score_Status,N'网点运营管理总部考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (24) AND a.pstatus = 1
--
-- 分公司负责人 合规审计部考核 20% Score_Status-3
UNION
SELECT DISTINCT N'分公司负责人' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
3 AS Score_Status,N'合规审计部考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (24) AND a.pstatus = 1
--
-- 分公司负责人 分管领导考核 20%*40% Score_Status-4
UNION
SELECT DISTINCT N'分公司负责人' AS sType,a.EID AS EID,a.KPIEID3 AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,40 AS Modulus,
4 AS Score_Status,N'分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (24) AND a.pstatus = 1
--
-- 分公司负责人 公司总裁考核 20%*60% Score_Status-9
UNION
SELECT DISTINCT N'分公司负责人' AS sType,a.EID AS EID,a.KPIEID4 AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'公司总裁考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (24) AND a.pstatus = 1


------ 分公司副职 ------
-- 25-分公司副职
-- Score_Status=0：自评完毕
-- Score_Status=1：胜任素质测评
-- Score_Status=2：分公司负责人考核(工作任务目标、履职情况和合规管理有效性)
-- Score_Status=9：分管领导考核(工作任务目标、履职情况和合规管理有效性)
--
-- 分公司副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'分公司副职' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (25) AND a.pstatus = 1
--
-- 分公司副职 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'分公司副职' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (25) AND a.pstatus = 1
--
-- 分公司副职 分公司负责人考核 80%*40% Score_Status-2
UNION
SELECT DISTINCT N'分公司副职' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,40 AS Modulus,
2 AS Score_Status,N'分公司负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (25) AND a.pstatus = 1
--
-- 分公司副职 分管领导考核 80%*60% Score_Status-9
UNION
SELECT DISTINCT N'分公司副职' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,60 AS Modulus,
9 AS Score_Status,N'分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (25) AND a.pstatus = 1


------ 一级营业部负责人 ------
-- 5-一级营业部负责人
-- Score_Status=0：自评完毕
-- Score_Status=1：胜任素质测评
-- Score_Status=2：合规审计部考核(合规风控管理有效性)
-- Score_Status=3：网点运营管理总部考核(经营业绩指标)
-- Score_Status=4：分管领导考核(履职情况)
-- Score_Status=9：公司总裁考核(履职情况)
--
-- 一级营业部负责人 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'一级营业部负责人' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (5) AND a.pstatus = 1
--
-- 一级营业部负责人 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'一级营业部负责人' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (5) AND a.pstatus = 1
--
-- 一级营业部负责人 网点运营管理总部考核 40% Score_Status-2
UNION
SELECT DISTINCT N'一级营业部负责人' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
40 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
2 AS Score_Status,N'网点运营管理总部考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (5) AND a.pstatus = 1
--
-- 一级营业部负责人 合规审计部考核 20% Score_Status-3
UNION
SELECT DISTINCT N'一级营业部负责人' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
3 AS Score_Status,N'合规审计部考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (5) AND a.pstatus = 1
--
-- 一级营业部负责人 分管领导考核 20%*40% Score_Status-4
UNION
SELECT DISTINCT N'一级营业部负责人' AS sType,a.EID AS EID,a.KPIEID3 AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,40 AS Modulus,
4 AS Score_Status,N'分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (5) AND a.pstatus = 1
--
-- 一级营业部负责人 公司总裁考核 20%*60% Score_Status-9
UNION
SELECT DISTINCT N'一级营业部负责人' AS sType,a.EID AS EID,a.KPIEID4 AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'公司总裁考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (5) AND a.pstatus = 1


------ 一级营业部副职 ------
-- 6-一级营业部副职
-- Score_Status=0：自评完毕
-- Score_Status=1：胜任素质测评
-- Score_Status=2：一级营业部负责人考核(工作任务目标、履职情况和合规管理有效性)
-- Score_Status=9：分管领导考核(工作任务目标、履职情况和合规管理有效性)
--
-- 一级营业部副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'一级营业部副职' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (6) AND a.pstatus = 1
--
-- 一级营业部副职 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'一级营业部副职' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (6) AND a.pstatus = 1
--
-- 一级营业部副职 一级营业部负责人考核 80%*40% Score_Status-2
UNION
SELECT DISTINCT N'一级营业部副职' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,40 AS Modulus,
2 AS Score_Status,N'一级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (6) AND a.pstatus = 1
--
-- 一级营业部副职 分管领导考核 80%*60% Score_Status-9
UNION
SELECT DISTINCT N'一级营业部副职' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,60 AS Modulus,
9 AS Score_Status,N'分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (6) AND a.pstatus = 1


------ 二级营业部经理室成员 ------
-- 7-二级营业部经理室成员
-- Score_Status=0：自评完毕
-- Score_Status=1：胜任素质测评
-- Score_Status=2：一级营业部负责人考核(工作任务目标、履职情况和合规管理有效性)
-- Score_Status=9：分管领导考核(工作任务目标、履职情况和合规管理有效性)
--
-- 二级营业部经理室成员 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'二级营业部经理室成员' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (7) AND a.pstatus = 1
--
-- 二级营业部经理室成员 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'二级营业部经理室成员' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (7) AND a.pstatus = 1
--
-- 二级营业部经理室成员 一级营业部负责人考核 80%*40% Score_Status-2
UNION
SELECT DISTINCT N'二级营业部经理室成员' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,40 AS Modulus,
2 AS Score_Status,N'一级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (7) AND a.pstatus = 1
--
-- 二级营业部经理室成员 分管领导考核 80%*60% Score_Status-9
UNION
SELECT DISTINCT N'二级营业部经理室成员' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,60 AS Modulus,
9 AS Score_Status,N'分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (7) AND a.pstatus = 1


--------- 总部普通员工 --------
-- 4-总部普通员工
-- Score_Status=0：自评完毕
-- Score_Status=1：员工互评
-- Score_Status=9：总部部门负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 总部普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'总部普通员工' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (4) AND a.pstatus = 1
--
-- 总部普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'总部普通员工' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (4) AND a.pstatus = 1
--
-- 总部普通员工 总部部门负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'总部普通员工' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'总部部门负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (4) AND a.pstatus = 1


--------- 子公司普通员工 --------
-- 11-子公司普通员工
-- Score_Status=0：自评完毕
-- Score_Status=1：员工互评
-- Score_Status=9：子公司部门行政负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 子公司普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'子公司普通员工' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (11) AND a.pstatus = 1
--
-- 子公司普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'子公司普通员工' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (11) AND a.pstatus = 1
--
-- 子公司普通员工 子公司负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'子公司普通员工' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'子公司负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (11) AND a.pstatus = 1


--------- 分公司普通员工 --------
-- 29-分公司普通员工
-- Score_Status=0：自评完毕
-- Score_Status=1：员工互评
-- Score_Status=9：分公司负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 分公司普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'分公司普通员工' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (29) AND a.pstatus = 1
--
-- 分公司普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'分公司普通员工' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (29) AND a.pstatus = 1
--
-- 分公司普通员工 分公司负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'分公司普通员工' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'分公司负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (29) AND a.pstatus = 1


--------- 一级营业部普通员工 --------
-- 12-一级营业部普通员工
-- Score_Status=0：自评完毕
-- Score_Status=1：员工互评
-- Score_Status=9：一级营业部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 一级营业部普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'一级营业部普通员工' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (12) AND a.pstatus = 1
--
-- 一级营业部普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'一级营业部普通员工' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (12) AND a.pstatus = 1
--
-- 一级营业部普通员工 一级营业部负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'一级营业部普通员工' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'一级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (12) AND a.pstatus = 1


--------- 二级营业部普通员工 --------
-- 13-二级营业部普通员工
-- Score_Status=0：自评完毕
-- Score_Status=1：员工互评
-- Score_Status=2：二级营业部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=9：一级营业部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=9：一级营业部兼职二级营业部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 二级营业部普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'二级营业部普通员工' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (13) AND a.pstatus = 1
--
-- 二级营业部普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'二级营业部普通员工' AS sType,a.EID AS EID,NULL AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (13) AND a.pstatus = 1
--
-- 二级营业部普通员工 二级营业部负责人考核 30% Score_Status-2
UNION
SELECT DISTINCT N'二级营业部普通员工' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,
2 AS Score_Status,N'二级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (13) AND a.KPIEID1 IS NOT NULL AND a.KPIEID2 IS NOT NULL AND a.pstatus = 1
--
-- 二级营业部普通员工 分公司/一级营业部负责人考核 40% Score_Status-9
UNION
SELECT DISTINCT N'二级营业部普通员工' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,40 AS Modulus,
9 AS Score_Status,N'分公司/一级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (13) AND a.KPIEID1 IS NOT NULL AND a.KPIEID2 IS NOT NULL AND a.pstatus = 1
--
-- 二级营业部普通员工 分公司/一级营业部兼职二级营业部负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'二级营业部普通员工' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,70 AS Modulus,
9 AS Score_Status,N'分公司/一级营业部兼职二级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (13) AND a.KPIEID1 IS NOT NULL AND a.KPIEID2 IS NULL AND a.pstatus = 1


--------- 营业部合规风控专员 --------
-- 14-营业部合规风控专员
-- Score_Status=0：自评完毕
-- Score_Status=1：营业部负责人考核(岗位工作完成情况和专业技术考核)
-- Score_Status=2：合规审计部负责人考核(岗位工作完成情况和专业技术考核)
-- Score_Status=9：合规风控总监考核(岗位工作完成情况和专业技术考核)
--
-- 营业部合规风控专员 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'营业部合规风控专员' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole in (14) AND a.pstatus = 1 
--
-- 营业部合规风控专员 营业部负责人考核 20% Score_Status-1
UNION
SELECT DISTINCT N'营业部合规风控专员' AS sType,b.HGEID AS EID,b.Director AS Score_EID,a.kpidepid AS Score_DepID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,20 AS Modulus,
1 AS Score_Status,N'营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment b
WHERE a.perole in (14) AND b.HGEID = a.EID AND a.pstatus = 1
--
-- 营业部合规风控专员 合规审计部负责人考核 30% Score_Status-2
UNION
SELECT DISTINCT N'营业部合规风控专员' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,30 AS Modulus,
2 AS Score_Status,N'合规审计部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole in (14) AND a.pstatus = 1 
--
-- 营业部合规风控专员 合规风控总监考核 50% Score_Status-9
UNION
SELECT DISTINCT N'营业部合规风控专员' AS sType,a.EID AS EID,a.KPIEID3 AS Score_EID,a.kpidepid AS Score_DepID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,50 AS Modulus,
9 AS Score_Status,N'合规风控总监考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole in (14) AND a.pstatus = 1


--------- 营业部合规联系人 --------
-- 15-营业部合规联系人
-- Score_Status=7：合规审计部负责人考核(所兼合规风控工作)
--
-- 营业部合规联系人 合规审计部负责人考核 30% Score_Status-7
UNION
SELECT DISTINCT N'营业部合规联系人' AS sType,a.EID AS EID,a.KPIEID5 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
7 AS Score_Status,N'合规审计部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.pegroup in (15) AND a.pstatus = 1


--------- 总部兼职合规专员 --------
-- 16-总部兼职合规专员
-- Score_Status=7：合规审计部负责人考核(所兼合规风控工作)
--
-- 总部兼职合规专员 合规审计部负责人考核 30% Score_Status-7
UNION
SELECT DISTINCT N'总部兼职合规专员' AS sType,a.EID AS EID,a.KPIEID5 AS Score_EID,a.kpidepid AS Score_DepID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
7 AS Score_Status,N'合规审计部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.pegroup in (16) AND a.pstatus = 1


--------- 区域财务经理 --------
-- 17-营业部区域财务经理
-- Score_Status=0：自评完毕
-- Score_Status=1：营业部负责人考核(岗位工作完成情况和专业技术考核)
-- Score_Status=2：计划财务部负责人考核(岗位工作完成情况和专业技术考核)
-- Score_Status=9：财务总监考核(岗位工作完成情况和专业技术考核)
--
-- 营业部区域财务经理 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'营业部区域财务经理' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole in (17) AND a.pstatus = 1
-- 
-- 营业部区域财务经理 营业部负责人考核 20% Score_Status-1
UNION
SELECT DISTINCT N'营业部区域财务经理' AS sType,b.CWEID AS EID,b.Director AS Score_EID,a.kpidepid AS Score_DepID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,20 AS Modulus,
1 AS Score_Status,N'营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment b
WHERE a.perole in (17) AND b.CWEID = a.EID AND a.pstatus = 1
--
-- 营业部区域财务经理 财务部负责人考核 30% Score_Status-2
UNION
SELECT DISTINCT N'营业部区域财务经理' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,30 AS Modulus,
2 AS Score_Status,N'财务部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole in (17) AND a.pstatus = 1
--
-- 营业部区域财务经理 财务总监考核 50% Score_Status-9
UNION
SELECT DISTINCT N'营业部区域财务经理' AS sType,a.EID AS EID,a.KPIEID3 AS Score_EID,a.kpidepid AS Score_DepID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,50 AS Modulus,
9 AS Score_Status,N'财务总监考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole in (17) AND a.pstatus = 1


--------- 综合会计（集中） --------
-- 19-综合会计（集中）
-- Score_Status=0：自评完毕
-- Score_Status=1：区域财务经理考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=9：计划财务部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 综合会计（集中） 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'综合会计（集中）' AS sType,a.EID AS EID,a.EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole in(19) AND a.pstatus = 1
--
-- 综合会计（集中） 区域财务经理考核 40% Score_Status-1
UNION
SELECT DISTINCT N'综合会计（集中）' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
100 AS Weight1,NULL AS Weight2,NULL AS Weight3,40 AS Modulus,
1 AS Score_Status,N'区域财务经理考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (19) AND a.pstatus = 1
--
-- 综合会计（集中） 计划财务部负责人考核 60% Score_Status-9
UNION
SELECT DISTINCT N'综合会计（集中）' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
100 AS Weight1,NULL AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'计划财务部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (19) AND a.pstatus = 1


------ 综合会计（非集中） ------
-- 20-综合会计（非集中）
-- Score_Status=0：自评完毕
-- Score_Status=1：区域财务经理考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=2：营业部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=9：考核分数汇总
--
-- 综合会计（非集中） 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'综合会计（非集中）' AS sType,a.EID AS EID,EID AS Score_EID,a.kpidepid AS Score_DepID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (20) AND a.pstatus = 1
--
-- 综合会计（非集中） 区域财务经理考核 40% Score_Status-1
UNION
SELECT DISTINCT N'综合会计（非集中）' AS sType,a.EID AS EID,a.KPIEID1 AS Score_EID,a.kpidepid AS Score_DepID,
100 AS Weight1,NULL AS Weight2,NULL AS Weight3,40 AS Modulus,
1 AS Score_Status,N'区域财务经理考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (20) AND a.pstatus = 1
--
-- 综合会计（非集中） 营业部负责人考核 60% Score_Status-9
UNION
SELECT DISTINCT N'综合会计（非集中）' AS sType,a.EID AS EID,a.KPIEID2 AS Score_EID,a.kpidepid AS Score_DepID,
100 AS Weight1,NULL AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a
WHERE a.perole IN (20) AND a.pstatus = 1