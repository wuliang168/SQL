-- oVW_OrgTree

SELECT '0' AS ID, '0' AS xid, '0' AS xCOL, N'行政组织架构' AS title, 17 AS IMGID, 0 AS Form, NULL AS EZID, 0 AS type, 0 AS hrg
UNION ALL
/*
    有效公司
*/ 
SELECT 'c' + cast(ID AS varchar(10)) AS ID, '0' AS xid, '0' AS xCOL, a.title, 1154 AS IMGID, 1 AS Form, 100 AS EZID, 1 AS type, 0 AS hrg
FROM oCD_DepType a
WHERE isnull(isdisabled, 0) = 0
/*
    有效部门
*/ 
UNION ALL
SELECT cast(depid AS varchar(10)) AS ID, cast(adminid AS varchar(10)) AS xid, 'c' + cast(DepType AS varchar(10)) AS xCOL, 
a.title, 1164 AS IMGID, 1 AS Form, a.EZID, 2 AS type, DepEmp AS hrg
FROM oDepartment a
WHERE isnull(isdisabled, 0) = 0