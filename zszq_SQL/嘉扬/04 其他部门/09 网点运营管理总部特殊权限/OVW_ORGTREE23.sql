SELECT '0' AS ID, '0' AS xid, '0' AS xCOL, N'行政组织架构' AS title, 17 AS IMGID, 0 AS Form, NULL AS EZID, 0 AS type, 0 AS hrg, 0 AS xorder

UNION ALL
/* 有效公司 */ 
SELECT 'c' + cast(ID AS varchar(10)) AS ID, '0' AS xid, '0' AS xCOL, a.title, 1154 AS IMGID, 1 AS Form, 100 AS EZID, 1 AS type, 0 AS hrg, 0 AS xorder
FROM oCD_DepType a
WHERE isnull(a.isdisabled, 0) = 0 AND a.ID in (2,3)

UNION ALL
/* 有效部门 */ 
SELECT cast(depid AS varchar(10)) AS ID, cast(adminid AS varchar(10)) AS xid, 'c' + cast(DepType AS varchar(10)) AS xCOL, a.title, 1164 AS IMGID, 1 AS Form, a.EZID, 2 AS type, 
DepEmp AS hrg, xorder AS xorder
FROM oDepartment a
WHERE isnull(a.isdisabled, 0) = 0 AND a.DepType in (2,3) AND ISNULL(a.DEPGRADE_XS, 0) = 1