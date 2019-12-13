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

-------- sType 被考核类型说明 --------
-- 1-总部部门负责人
-- 2-总部部门副职
-- 4-总部普通员工
-- 26-子公司班子成员
-- 10-子公司部门行政负责人
-- 11-子公司普通员工
-- 30-子公司部门副职
-- 24-分公司负责人
-- 25-分公司副职
-- 29-分公司普通员工
-- 5-一级营业部负责人
-- 6-一级营业部副职
-- 12-一级营业部普通员工
-- 7-二级营业部经理室成员
-- 13-二级营业部普通员工
-- 14-营业部合规专员
-- 17-营业部区域财务经理
-- 19-综合会计

-------- SCORE_TYPE2 兼职合规说明 --------
-- 15-营业部合规联系人
-- 16-总部兼职合规专员

--------- 总部部门负责人 --------
-- 1-总部部门负责人
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：20%              胜任素质测评
-- Score_Status=2：50%              战略企划部考核(部门年度工作计划)
-- Score_Status=3：30%*30%          分管领导考核(履职情况)
-- Score_Status=4：30%*20%          其他副职领导(副总裁、财务总监)考核(履职情况)
-- Score_Status=9：30%*50%          主要领导(党委书记、公司总裁、公司董事长)考核(履职情况)
--
-- 总部部门负责人 自评 0% Score_Status-0
SELECT DISTINCT N'1-总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部部门负责人(非法律合规) 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'1-总部部门负责人(非法律合规)' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5) and d.DepID<>737
--
-- 总部部门负责人(法律合规) 胜任素质测评 0% Score_Status-1
UNION
SELECT DISTINCT N'1-总部部门负责人(法律合规)' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5) and d.DepID=737
--
-- 总部部门负责人 战略企划部考核 50%*100% Score_Status-2
---- 战略企划部(702)
UNION
SELECT DISTINCT N'1-总部部门负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
50 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
2 AS Score_Status,N'2-战略企划部考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
AND c.DepID=702
--
-- 总部部门负责人(非法律合规) 分管领导考核 30%*20% Score_Status-3
---- 分管领导(Director2)为非空，或者分管领导(Director2)非其他副职，或者分管领导(Director2)非主要领导
UNION
SELECT DISTINCT N'1-总部部门负责人(非法律合规)' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
NULL AS Weight1,30 AS Weight2,NULL AS Weight3,20 AS Modulus,
3 AS Score_Status,N'3-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5) and d.DepID<>737
AND a.kpidepidyy=c.DepID AND c.Director2 not in (1026,1027,6012,1033,1425,1028,5587,5014,1022) AND c.Director2 is not NULL
---- 分管领导(Director2)为其他副职领导
UNION
SELECT DISTINCT N'1-总部部门负责人(非法律合规)' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
NULL AS Weight1,30 AS Weight2,NULL AS Weight3,20 AS Modulus,
10 AS Score_Status,N'10-其他副职领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5) and d.DepID<>737
AND a.kpidepidyy=c.DepID AND c.Director2 in (1026,1027,6012,1033,1425,1028)
---- 分管领导(Director2)为主要领导
UNION
SELECT DISTINCT N'1-总部部门负责人(非法律合规)' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
NULL AS Weight1,30 AS Weight2,NULL AS Weight3,20 AS Modulus,
10 AS Score_Status,N'10-主要领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5) and d.DepID<>737
AND a.kpidepidyy=c.DepID AND c.Director2 in (5587,5014,1022)
--
-- 总部部门负责人(非法律合规) 其他副职领导(副总裁(赵伟江：1026、高玮：1027、程景东：6012、许向军：1033、张辉：1425)、财务总监(盛建龙：1028))考核 30%*20% Score_Status-4
UNION
SELECT DISTINCT N'1-总部部门负责人(非法律合规)' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,b.EID AS Score_EID,
NULL AS Weight1,30 AS Weight2,NULL AS Weight3,20 AS Modulus,
4 AS Score_Status,N'4-其他副职领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee b,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5) and d.DepID<>737
AND b.EID in (1026,1027,6012,1033,1425,1028)
--
-- 总部部门负责人(非法律合规) 主要领导(党委书记(李桦：5587)、公司总裁(王青山：5014)、公司董事长(吴承根：1022))考核 30%*60% Score_Status-9
UNION
SELECT DISTINCT N'1-总部部门负责人(非法律合规)' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,b.EID AS Score_EID,
NULL AS Weight1,30 AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'9-主要领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee b,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5) and d.DepID<>737
AND b.EID in (5587,5014,1022)
--
-- 总部部门负责人(法律合规) 合规总监(许向军：1033)考核 50%*100% Score_Status-9
UNION
SELECT DISTINCT N'1-总部部门负责人(法律合规)' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,b.EID AS Score_EID,
NULL AS Weight1,50 AS Weight2,NULL AS Weight3,100 AS Modulus,
9 AS Score_Status,N'9-主要领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee b,eEmployee d
WHERE a.perole = 1 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5) and d.DepID=737
AND b.EID=1033


--------- 总部部门副职 --------
-- 2-总部部门副职
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              胜任素质测评
-- Score_Status=2：(30%+40%)*50%    总部部门负责人考核(部门年度工作计划和履职情况)
-- Score_Status=9：(30%+40%)*50%    分管领导考核(部门年度工作计划和履职情况)
--
-- 总部部门副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 2 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部部门副职 胜任素质测评 30% Score_Status-1
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 2 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部部门副职 总部部门负责人考核 (30%+40%)*50% Score_Status-2
---- 总部部门负责人(Director)非空，且总部部门负责人(Director)非分管领导
UNION
SELECT DISTINCT N'2-总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,50 AS Modulus,
2 AS Score_Status,N'2-总部部门负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 2 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND (c.Director is not NULL AND c.Director<>c.Director2)
--
-- 总部部门副职 分管领导考核 (30%+40%)*50% Score_Status-9
---- 总部部门负责人(Director)为非空，或总部部门负责人(Director)非分管领导
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,50 AS Modulus,
9 AS Score_Status,N'9-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 2 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND (c.Director is not NULL AND c.Director<>c.Director2)
--
-- 总部部门副职 分管领导考核 (30%+40%)*100% Score_Status-9
---- 总部部门负责人(Director)为空，或总部部门负责人(Director)为分管领导
UNION
SELECT DISTINCT N'总部部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,100 AS Modulus,
9 AS Score_Status,N'9-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 2 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND (c.Director is NULL or c.Director=c.Director2)


--------- 总部普通员工 --------
-- 4-总部普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=9：70%              总部部门负责人考核(工作业绩50%、工作态度20%、工作能力20%和合规风控性10%)
--
-- 总部普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'4-总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 4 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'4-总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 4 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 总部普通员工 总部部门负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'4-总部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,ISNULL(c.Director,c.Director2) AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'9-总部部门负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 4 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)


------ 子公司合规总监 ------
-- 26-子公司班子成员
-- Score_Status=0：0%               自评完毕
-- Score_Status=2：母公司首席风险官考核(年度工作计划和履职情况)
-- Score_Status=3：子公司总经理考核(年度工作计划和履职情况)
-- Score_Status=9：子公司董事长考核(年度工作计划和履职情况)
--
---- 子公司合规总监 自评 0% Score_Status-0
--UNION
--SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
--NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
--0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.perole=26 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
---- 子公司合规总监 母公司首席风险官(高玮：1027)考核 (60%+40%)*50% Score_Status-2
--UNION
--SELECT DISTINCT N'子公司合规总监' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1027 AS Score_EID,
--60 AS Weight1,40 AS Weight2,NULL AS Weight3,50 AS Modulus,
--2 AS Score_Status,N'2-子公司首席风险官考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.perole=26 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--AND a.EID=5479
----
---- 子公司合规总监 子公司总经理(楼小平：1343)考核 (60%+40%)*20% Score_Status-3
--UNION
--SELECT DISTINCT N'子公司合规总监' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1343 AS Score_EID,
--60 AS Weight1,40 AS Weight2,NULL AS Weight3,20 AS Modulus,
--3 AS Score_Status,N'3-子公司总经理考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.perole=26 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--AND a.EID=5479
----
---- 子公司合规总监 子公司董事长(盛建龙：1028)考核 (60%+40%)*30% Score_Status-9
--UNION
--SELECT DISTINCT N'子公司合规总监' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
--60 AS Weight1,40 AS Weight2,NULL AS Weight3,30 AS Modulus,
--9 AS Score_Status,N'9-子公司董事长考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
--FROM pEmployee_register a,eEmployee d
--WHERE a.perole=26 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--AND a.EID=5479


------ 子公司部门行政负责人 ------
-- 10-子公司部门行政负责人
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：20%              胜任素质测评
-- Score_Status=2：80%*50%          子公司合规总监考核(合规风控部)(部门年度工作计划和履职情况)
-- Score_Status=3：80%*20%          子公司总经理考核(合规风控部)(部门年度工作计划和履职情况)
-- Score_Status=9：80%*30%          子公司董事长考核(合规风控部)(部门年度工作计划和履职情况)
-- Score_Status=3：80%*40%          子公司总经理考核(部门年度工作计划和履职情况)
-- Score_Status=9：80%*60%          子公司董事长考核(部门年度工作计划和履职情况)
--
-- 子公司部门行政负责人 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 10 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司部门行政负责人 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 10 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司合规风控部行政负责人 子公司合规总监(方斌：5479)考核 (50%+30%)*50% Score_Status-2
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,5479 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,50 AS Modulus,
2 AS Score_Status,N'2-子公司合规总监考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 10 AND a.pstatus = 1 AND a.kpidepidyy=666 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司合规风控部行政负责人 子公司总经理(盛建龙：1028)考核 (50%+30%)*20% Score_Status-3
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,20 AS Modulus,
3 AS Score_Status,N'3-子公司总经理考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 10 AND a.pstatus = 1 AND a.kpidepidyy=666 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司合规风控部行政负责人 子公司董事长(盛建龙：1028)考核 (50%+30%)*30% Score_Status-9
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,30 AS Modulus,
9 AS Score_Status,N'9-子公司董事长考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 10 AND a.pstatus = 1 AND a.kpidepidyy=666 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司部门行政负责人 子公司总经理(盛建龙：1028)考核 (50%+30%)*40% Score_Status-3
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,40 AS Modulus,
3 AS Score_Status,N'3-子公司总经理考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 10 AND a.pstatus = 1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司部门行政负责人 子公司董事长(盛建龙：1028)考核 (50%+30%)*60% Score_Status-9
UNION
SELECT DISTINCT N'10-子公司部门行政负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
50 AS Weight1,30 AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'9-子公司董事长考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 10 AND a.pstatus = 1 AND a.kpidepidyy<>666 AND a.EID=d.EID and d.status not in (4,5)


------ 子公司部门副职 ------
-- 30-子公司部门副职
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              胜任素质测评
-- Score_Status=2：(30%+40%)*50%    子公司部门负责人考核(部门年度工作计划和履职情况)
-- Score_Status=9：(30%+40%)*50%    分管领导考核(部门年度工作计划和履职情况)
--
-- 子公司部门副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'30-子公司部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 30 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司部门副职 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'30-子公司部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 30 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司部门副职 子公司部门负责人考核 (30%+40%)*50% Score_Status-2
---- 子公司部门负责人(Director)非空，且子公司部门负责人(Director)非分管领导
UNION
SELECT DISTINCT N'30-子公司部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,50 AS Modulus,
2 AS Score_Status,N'2-子公司部门负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 30 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND (c.Director is not NULL AND c.Director<>c.Director2)
--
-- 子公司部门副职 子公司分管领导考核 (30%+40%)*50% Score_Status-9
---- 子公司部门负责人(Director)为非空，或子公司部门负责人(Director)非分管领导
UNION
SELECT DISTINCT N'30-子公司部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,50 AS Modulus,
9 AS Score_Status,N'9-子公司分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 30 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND (c.Director is not NULL AND c.Director<>c.Director2)
--
-- 子公司部门副职 子公司分管领导考核 (30%+40%)*100% Score_Status-9
---- 子公司部门负责人(Director)为空，或子公司部门负责人(Director)为分管领导
UNION
SELECT DISTINCT N'30-子公司部门副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director2 AS Score_EID,
30 AS Weight1,40 AS Weight2,NULL AS Weight3,100 AS Modulus,
9 AS Score_Status,N'9-子公司分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 30 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND (c.Director is NULL or c.Director=c.Director2)


--------- 子公司普通员工 --------
-- 11-子公司普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=9：70%              子公司部门行政负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 子公司普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'11-子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 11 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'11-子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 11 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 子公司普通员工 子公司负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'11-子公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,ISNULL(c.Director,c.Director2) AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'9-子公司负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 11 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)


------ 分公司负责人 ------
-- 24-分公司负责人
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：20%              胜任素质测评
-- Score_Status=2：40%              网点运营管理总部考核(经营业绩指标)
-- Score_Status=3：20%              法律合规部考核(合规管理有效性)
-- Score_Status=4：20%*30%          分管领导考核(履职情况)
-- Score_Status=5：20%*30%          公司总裁考核(履职情况)
-- Score_Status=9：20%*40%          公司董事长考核(履职情况)
--
-- 分公司负责人 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'24-分公司负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 24 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司负责人 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'24-分公司负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 24 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司负责人 网点运营管理总部(DepID:362)考核 40% Score_Status-2
UNION
SELECT DISTINCT N'24-分公司负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=362) AS Score_EID,
40 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
2 AS Score_Status,N'2-网点运营管理总部考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 24 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司负责人 法律合规部(DepID:737)考核 20% Score_Status-3
UNION
SELECT DISTINCT N'24-分公司负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=737) AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
3 AS Score_Status,N'3-法律合规部考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 24 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司负责人 分管领导(赵伟江：1026)考核 20%*30% Score_Status-4
UNION
SELECT DISTINCT N'24-分公司负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1026 AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,
4 AS Score_Status,N'4-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 24 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司负责人 公司总裁(王青山：5014)考核 20%*30% Score_Status-5
UNION
SELECT DISTINCT N'24-分公司负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,5014 AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,
5 AS Score_Status,N'5-公司总裁考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 24 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司负责人 公司董事长(吴承根：1022)考核 20%*40% Score_Status-9
UNION
SELECT DISTINCT N'24-分公司负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1022 AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,40 AS Modulus,
9 AS Score_Status,N'9-公司董事长考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 24 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)


------ 分公司副职 ------
-- 25-分公司副职
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：20%              胜任素质测评
-- Score_Status=2：80%*40%          分公司负责人考核(工作任务目标30%、履职情况40%和合规管理有效性10%)
-- Score_Status=9：80%*60%          分管领导考核(工作任务目标30%、履职情况40%和合规管理有效性10%)
--
-- 分公司副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'25-分公司副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 25 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司副职 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'25-分公司副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 25 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司副职 分公司负责人考核 (30%+40%+10%)*40% Score_Status-2
---- 分公司负责人(Director)非空
UNION
SELECT DISTINCT N'25-分公司副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,40 AS Modulus,
2 AS Score_Status,N'2-分公司负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 25 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is not NULL
--
-- 分公司副职 分管领导(赵伟江：1026)考核 (30%+40%+10%)*60% Score_Status-9
---- 分公司负责人(Director)非空
UNION
SELECT DISTINCT N'25-分公司副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1026 AS Score_EID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,60 AS Modulus,
9 AS Score_Status,N'9-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 25 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is not NULL
--
-- 分公司副职 分管领导(赵伟江：1026)考核 (30%+40%+10%)*100% Score_Status-9
---- 分公司负责人(Director)为空
UNION
SELECT DISTINCT N'25-分公司副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1026 AS Score_EID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,100 AS Modulus,
9 AS Score_Status,N'9-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 25 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is NULL


--------- 分公司普通员工 --------
-- 29-分公司普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=9：70%              分公司负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 分公司普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'29-分公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 29 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'29-分公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 29 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 分公司普通员工 分公司负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'29-分公司普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'9-分公司负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 29 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)


------ 一级营业部负责人 ------
-- 5-一级营业部负责人
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：20%              胜任素质测评
-- Score_Status=2：40%              网点运营管理总部考核(经营业绩指标)
-- Score_Status=3：20%              法律合规部考核(合规管理有效性)
-- Score_Status=4：20%*30%          分管领导考核(履职情况)
-- Score_Status=5：20%*30%          公司总裁考核(履职情况)
-- Score_Status=9：20%*40%          公司董事长考核(履职情况)
--
-- 一级营业部负责人 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'5-一级营业部负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 5 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部负责人 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'5-一级营业部负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 5 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部负责人 网点运营管理总部(DepID:362)考核 40% Score_Status-2
UNION
SELECT DISTINCT N'5-一级营业部负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=362) AS Score_EID,
40 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
2 AS Score_Status,N'2-网点运营管理总部考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 5 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部负责人 法律合规部(DepID:737)考核 20% Score_Status-3
UNION
SELECT DISTINCT N'5-一级营业部负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=737) AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
3 AS Score_Status,N'3-法律合规部考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 5 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部负责人 分管领导(赵伟江：1026)考核 20%*30% Score_Status-4
UNION
SELECT DISTINCT N'5-一级营业部负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1026 AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,
4 AS Score_Status,N'4-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 5 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部负责人 公司总裁(王青山：5014)考核 20%*30% Score_Status-5
UNION
SELECT DISTINCT N'5-一级营业部负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,5014 AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,30 AS Modulus,
5 AS Score_Status,N'5-公司总裁考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 5 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部负责人 公司董事长(吴承根：1022)考核 20%*40% Score_Status-9
UNION
SELECT DISTINCT N'5-一级营业部负责人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1022 AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,40 AS Modulus,
9 AS Score_Status,N'9-公司董事长考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 5 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)


------ 一级营业部副职 ------
-- 6-一级营业部副职
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：20%              胜任素质测评
-- Score_Status=2：80%*40%          一级营业部负责人考核(工作任务目标30%、履职情况40%和合规管理有效性10%)
-- Score_Status=9：80%*60%          分管领导考核(工作任务目标30%、履职情况40%和合规管理有效性10%)
--
-- 一级营业部副职 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'6-一级营业部副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 6 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部副职 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'6-一级营业部副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 6 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部副职 一级营业部负责人考核 (30%+40%+10%)*40% Score_Status-2
---- 一级营业部负责人(Director)非空
UNION
SELECT DISTINCT N'6-一级营业部副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,40 AS Modulus,
2 AS Score_Status,N'2-一级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 6 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is not NULL
--
-- 一级营业部副职 分管领导(赵伟江：1026)考核 (30%+40%+10%)*60% Score_Status-9
---- 一级营业部负责人(Director)非空
UNION
SELECT DISTINCT N'6-一级营业部副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1026 AS Score_EID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,60 AS Modulus,
9 AS Score_Status,N'9-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 6 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is not NULL
--
-- 一级营业部副职 分管领导(赵伟江：1026)考核 (30%+40%+10%)*100% Score_Status-9
---- 一级营业部负责人(Director)为空
UNION
SELECT DISTINCT N'6-一级营业部副职' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1026 AS Score_EID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,100 AS Modulus,
9 AS Score_Status,N'9-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 6 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is NULL


------ 二级营业部经理室成员 ------
-- 7-二级营业部经理室成员
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：20%              胜任素质测评
-- Score_Status=2：80%*40%          一级营业部负责人考核(工作任务目标30%、履职情况40%和合规管理有效性10%)
-- Score_Status=9：80%*60%          分管领导考核(工作任务目标30%、履职情况40%和合规管理有效性10%)
--
-- 二级营业部经理室成员 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'7-二级营业部经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 7 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 二级营业部经理室成员 胜任素质测评 20% Score_Status-1
UNION
SELECT DISTINCT N'7-二级营业部经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
20 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-胜任素质测评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 7 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 二级营业部经理室成员 一级营业部负责人考核 (30%+40%+10%)*40% Score_Status-2
---- 一级营业部负责人(Director)非空
UNION
SELECT DISTINCT N'7-二级营业部经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,40 AS Modulus,
2 AS Score_Status,N'2-一级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 7 AND a.pstatus = 1 AND dbo.eFN_getdepid1st(a.kpidepidyy)=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is not NULL
--
-- 二级营业部经理室成员 分管领导(赵伟江：1026)考核 (30%+40%+10%)*60% Score_Status-9
---- 一级营业部负责人(Director)非空
UNION
SELECT DISTINCT N'7-二级营业部经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1026 AS Score_EID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,60 AS Modulus,
9 AS Score_Status,N'9-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 7 AND a.pstatus = 1 AND dbo.eFN_getdepid1st(a.kpidepidyy)=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is not NULL
--
-- 二级营业部经理室成员 分管领导(赵伟江：1026)考核 (30%+40%+10%)*100% Score_Status-9
---- 一级营业部负责人(Director)为空
UNION
SELECT DISTINCT N'7-二级营业部经理室成员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1026 AS Score_EID,
30 AS Weight1,40 AS Weight2,10 AS Weight3,100 AS Modulus,
9 AS Score_Status,N'9-分管领导考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 7 AND a.pstatus = 1 AND dbo.eFN_getdepid1st(a.kpidepidyy)=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director is NULL


--------- 一级营业部普通员工 --------
-- 12-一级营业部普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=9：70%              一级营业部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 一级营业部普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'12-一级营业部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 12 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'12-一级营业部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 12 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 一级营业部普通员工 一级营业部负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'12-一级营业部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'9-一级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 12 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)


--------- 二级营业部普通员工 --------
-- 13-二级营业部普通员工
-- Score_Status=0：0%               自评完毕
-- Score_Status=1：30%              员工互评
-- Score_Status=2：30%              二级营业部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=9：40%              一级营业部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=9：70%              一级营业部兼职二级营业部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 二级营业部普通员工 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'13-二级营业部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 13 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 二级营业部普通员工 员工互评 30% Score_Status-1
UNION
SELECT DISTINCT N'13-二级营业部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,NULL AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
1 AS Score_Status,N'1-员工互评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 13 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 二级营业部普通员工 二级营业部负责人考核 30% Score_Status-2
UNION
SELECT DISTINCT N'13-二级营业部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
2 AS Score_Status,N'2-二级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 13 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director<>(select Director from oDepartment where DepID=dbo.eFN_getdepid1st(a.kpidepidyy))
--
-- 二级营业部普通员工 分公司/一级营业部负责人考核 40% Score_Status-9
UNION
SELECT DISTINCT N'13-二级营业部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
40 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'9-分公司/一级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 13 AND a.pstatus = 1 AND dbo.eFN_getdepid1st(a.kpidepidyy)=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director<>(select Director from oDepartment where DepID=a.kpidepidyy)
--
-- 二级营业部普通员工 分公司/一级营业部兼职二级营业部负责人考核 70% Score_Status-9
UNION
SELECT DISTINCT N'13-二级营业部普通员工' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
70 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
9 AS Score_Status,N'9-分公司/一级营业部兼职二级营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 13 AND a.pstatus = 1 AND dbo.eFN_getdepid1st(a.kpidepidyy)=c.DepID AND a.EID=d.EID and d.status not in (4,5)
AND c.Director=(select Director from oDepartment where DepID=a.kpidepidyy)


--------- 营业部合规专员 --------
-- 14-营业部合规专员
-- Score_Status=0：0%               自评完毕
-- Score_Status=2：0%               营业部负责人考核(岗位工作完成情况和专业技术考核)(作废)
-- Score_Status=3：100%             法律合规部负责人考核(岗位工作完成情况和专业技术考核)
-- Score_Status=9：0%               合规总监考核(岗位工作完成情况和专业技术考核)
--
-- 营业部合规专员 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'14-营业部合规专员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 14 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 营业部合规专员 营业部负责人考核 (60%+40%)*20% Score_Status-2
--UNION
--SELECT DISTINCT N'营业部合规专员' AS sType,c.HGEID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
--60 AS Weight1,40 AS Weight2,NULL AS Weight3,20 AS Modulus,
--2 AS Score_Status,N'营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
--FROM pEmployee_register a,oDepartment c,eEmployee d
--WHERE a.perole = 14 AND a.pstatus = 1 AND c.HGEID = a.EID AND a.EID=d.EID and d.status not in (4,5)
--
-- 营业部合规专员 法律合规部负责人(DepID:737)考核 (60%+40%)*40% Score_Status-3
---- 法律合规部负责人(DepID:737)非合规总监
UNION
SELECT DISTINCT N'14-营业部合规专员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=737) AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,40 AS Modulus,
3 AS Score_Status,N'3-法律合规部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 14 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
AND (select Director from oDepartment where DepID=737)<>1033
--
-- 营业部合规专员 合规总监(许向军：1033)考核 (60%+40%)*60% Score_Status-9
---- 法律合规部负责人(DepID:737)非合规总监
UNION
SELECT DISTINCT N'14-营业部合规专员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1033 AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'9-合规总监考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 14 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 营业部合规专员 合规总监(许向军：1033)考核 (60%+40%)*100% Score_Status-9
---- 法律合规部负责人(DepID:737)为合规总监
UNION
SELECT DISTINCT N'14-营业部合规专员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1033 AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,100 AS Modulus,
9 AS Score_Status,N'9-合规总监考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 14 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
AND (select Director from oDepartment where DepID=737)=1033


--------- 营业部合规联系人 --------
-- 15-营业部合规联系人
-- Score_Status=7：51%               法律合规部负责人考核(兼合规工作)
--
-- 营业部合规联系人 法律合规部负责人(DepID:737)考核 30% Score_Status-7
UNION
SELECT DISTINCT N'15-营业部合规联系人' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=737) AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
7 AS Score_Status,N'7-法律合规部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.pegroup = 15 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)


--------- 总部兼职合规专员 --------
-- 16-总部兼职合规专员
-- Score_Status=7：51%               法律合规部负责人考核(兼合规工作)
--
-- 总部兼职合规专员 法律合规部负责人(DepID:737)考核 30% Score_Status-7
UNION
SELECT DISTINCT N'16-总部兼职合规专员' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=737) AS Score_EID,
30 AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
7 AS Score_Status,N'7-法律合规部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.pegroup = 16 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)


--------- 区域财务经理 --------
-- 17-营业部区域财务经理
-- Score_Status=0：0%               自评完毕
-- Score_Status=2：100%*20%         营业部负责人考核(岗位工作完成情况60%和专业技术考核40%)
-- Score_Status=3：100%*30%         计划财务部负责人考核(岗位工作完成情况60%和专业技术考核40%)
-- Score_Status=9：100%*50%         财务总监考核(岗位工作完成情况60%和专业技术考核40%)
--
-- 营业部区域财务经理 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'17-营业部区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 17 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
-- 
-- 营业部区域财务经理 营业部负责人考核 (60%+40%)*20% Score_Status-2
UNION
SELECT DISTINCT N'17-营业部区域财务经理' AS sType,c.CWEID AS EID,a.kpidepidyy AS Score_DepID,c.Director AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,20 AS Modulus,
2 AS Score_Status,N'2-营业部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 17 AND a.pstatus = 1 AND c.CWEID = a.EID AND c.DepType in (2,3) AND a.EID=d.EID and d.status not in (4,5)
--
-- 营业部区域财务经理 财务部负责人(DepID:355)考核 (60%+40%)*30% Score_Status-3
---- 财务部负责人(DepID:355)非财务总监
UNION
SELECT DISTINCT N'17-营业部区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=355) AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,30 AS Modulus,
3 AS Score_Status,N'3-财务部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 17 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
AND (select Director from oDepartment where DepID=355)<>1028
--
-- 营业部区域财务经理 财务总监(盛建龙：1028)考核 (60%+40%)*50% Score_Status-9
---- 财务部负责人(DepID:355)非财务总监
UNION
SELECT DISTINCT N'17-营业部区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,50 AS Modulus,
9 AS Score_Status,N'9-财务总监考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 17 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
AND (select Director from oDepartment where DepID=355)<>1028
--
-- 营业部区域财务经理 财务总监(盛建龙：1028)考核 (60%+40%)*80% Score_Status-9
---- 财务部负责人(DepID:355)为财务总监
UNION
SELECT DISTINCT N'17-营业部区域财务经理' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,1028 AS Score_EID,
60 AS Weight1,40 AS Weight2,NULL AS Weight3,80 AS Modulus,
9 AS Score_Status,N'9-财务总监考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 17 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
AND (select Director from oDepartment where DepID=355)=1028


--------- 综合会计 --------
-- 19-综合会计
-- Score_Status=0：0%               自评完毕
-- Score_Status=2：100%*40%         区域财务经理考核(工作业绩、工作态度、工作能力和合规风控性)
-- Score_Status=9：100%*60%         计划财务部负责人考核(工作业绩、工作态度、工作能力和合规风控性)
--
-- 综合会计 自评 0% Score_Status-0
UNION
SELECT DISTINCT N'19-综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,a.EID AS Score_EID,
NULL AS Weight1,NULL AS Weight2,NULL AS Weight3,NULL AS Modulus,
0 AS Score_Status,N'0-自评' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,eEmployee d
WHERE a.perole = 19 AND a.pstatus = 1 AND a.EID=d.EID and d.status not in (4,5)
--
-- 综合会计 区域财务经理考核 100%*40% Score_Status-2
---- 部门区域财务经理(CWEID)非空
UNION
SELECT DISTINCT N'19-综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,c.CWEID AS Score_EID,
100 AS Weight1,NULL AS Weight2,NULL AS Weight3,40 AS Modulus,
2 AS Score_Status,N'2-区域财务经理考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 19 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND c.CWEID is not NULL AND a.EID=d.EID and d.status not in (4,5)
--
-- 综合会计 计划财务部负责人(DepID:355)考核 100%*60% Score_Status-9
---- 部门区域财务经理(CWEID)为非空
UNION
SELECT DISTINCT N'19-综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=355) AS Score_EID,
100 AS Weight1,NULL AS Weight2,NULL AS Weight3,60 AS Modulus,
9 AS Score_Status,N'9-计划财务部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 19 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND c.CWEID is not NULL AND a.EID=d.EID and d.status not in (4,5)
--
-- 综合会计 计划财务部负责人(DepID:355)考核 100%*100% Score_Status-9
---- 部门区域财务经理(CWEID)为空
UNION
SELECT DISTINCT N'19-综合会计' AS sType,a.EID AS EID,a.kpidepidyy AS Score_DepID,(select Director from oDepartment where DepID=355) AS Score_EID,
100 AS Weight1,NULL AS Weight2,NULL AS Weight3,100 AS Modulus,
9 AS Score_Status,N'9-计划财务部负责人考核' AS Score_StatusTitle,a.perole AS Score_Type1,a.pegroup AS Score_Type2
FROM pEmployee_register a,oDepartment c,eEmployee d
WHERE a.perole = 19 AND a.pstatus = 1 AND a.kpidepidyy=c.DepID AND c.CWEID is NULL AND a.EID=d.EID and d.status not in (4,5)