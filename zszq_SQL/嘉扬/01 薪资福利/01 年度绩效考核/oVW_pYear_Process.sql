-- oVW_pYear_Process
/* 标题 */
SELECT 0 AS ID, '0' AS xid, '0' AS xCOL, N'年度工作考核' AS title, 17 AS IMGID, 0 AS Form, 0 AS type, 0 AS xorder
/* 考核年度 */
UNION ALL
SELECT ID AS ID, '0' AS xid, '0' AS xCOL,convert(varchar(4),Year(a.Date)) as title , 1154 AS IMGID, 1 AS Form, 1 AS type, 0 AS xorder
FROM pYear_Process a
/* 考核员工类型 */
UNION ALL
SELECT DISTINCT (case when a.ID in (24,5) then 245 when a.ID in (25,6,7) then 2567 when a.ID in (29,12,13) then 291213 else a.ID end) AS ID, 
NULL AS xid,b.ID AS xCOL, 
(case when a.ID in (24,5) then N'分公司|一级营业部负责人' when a.ID in (25,6,7) then N'分公司副职|一级营业部副职|二级营业部经理室成员' 
when a.ID in (29,12,13) then N'分公司|营业部普通员工' else a.title end), 
1164 AS IMGID, 1 AS Form, 2 AS type, 
(case when a.ID in (24,5) then 30 when a.ID in (25,6,7) then 31 when a.ID in (29,12,13) then 32 else a.xorder end) AS xorder
FROM pCD_PeRole a,pYear_Process b
where a.ID in (1,2,4,5,6,7,10,11,12,13,14,17,19,24,25,29)