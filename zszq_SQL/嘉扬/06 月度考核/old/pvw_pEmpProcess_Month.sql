-- pvw_pEmpProcess_Month
---- 总部
------ 非负责人
SELECT b.EID, NULL AS xid, a.name AS title, 
ISNULL(ISNULL(dbo.eFN_getdepdirector(b.DepID), dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(b.DepID))),dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID))) AS KPIReportTo, 
a.monthID AS MonthID
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.eEmployee AS b ON a.badge = b.Badge and (select DepType from oDepartment where DepID=b.DepID)=1
and b.EID<>dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID)) and b.EID<>ISNULL((select Director from oDepartment where DepID=b.DepID),0)
and b.EID<>ISNULL((select Director from oDepartment where DepID=dbo.eFN_getdepid1st(b.DepID)),0)
INNER JOIN PEMPLOYEE_REGISTER as c on b.EID=c.EID and c.pstatus in (1)
WHERE ISNULL(a.Closed, 0) = 0
------ 二级部门负责人
UNION
SELECT b.EID, NULL AS xid, a.name AS title, 
ISNULL(dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(b.DepID)),dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID))) AS KPIReportTo, 
a.monthID AS MonthID
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.eEmployee AS b ON a.badge = b.Badge and (select DepType from oDepartment where DepID=b.DepID)=1
and b.EID=ISNULL((select Director from oDepartment where DepID=b.DepID),0) and dbo.eFN_getdepid1st(b.DepID)<>b.DepID
INNER JOIN PEMPLOYEE_REGISTER as c on b.EID=c.EID and c.pstatus in (1)
WHERE ISNULL(a.Closed, 0) = 0
------ 一级部门负责人
UNION
SELECT b.EID, NULL AS xid, a.name AS title, 
dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID)) AS KPIReportTo, 
a.monthID AS MonthID
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.eEmployee AS b ON a.badge = b.Badge and (select DepType from oDepartment where DepID=b.DepID)=1
and b.EID=ISNULL((select Director from oDepartment where DepID=b.DepID),0) and dbo.eFN_getdepid1st(b.DepID)=b.DepID
INNER JOIN PEMPLOYEE_REGISTER as c on b.EID=c.EID and c.pstatus in (1)
WHERE ISNULL(a.Closed, 0) = 0

---- 子公司
------ 非负责人
UNION
SELECT b.EID, NULL AS xid, a.name AS title, 
ISNULL(dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(b.DepID)), dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID))) AS KPIReportTo, a.monthID AS MonthID
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.eEmployee AS b ON a.badge = b.Badge and (select DepType from oDepartment where DepID=b.DepID)=4
and b.EID<>dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID)) and b.EID<>(select Director from oDepartment where DepID=dbo.eFN_getdepid1st(b.DepID))
INNER JOIN PEMPLOYEE_REGISTER as c on b.EID=c.EID and c.pstatus in (1)
WHERE ISNULL(a.Closed, 0) = 0
------ 一级部门负责人
UNION
SELECT b.EID, NULL AS xid, a.name AS title, 
dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID)) AS KPIReportTo, a.monthID AS MonthID
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.eEmployee AS b ON a.badge = b.Badge and (select DepType from oDepartment where DepID=b.DepID)=4
and b.EID<>dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID)) and b.EID=(select Director from oDepartment where DepID=dbo.eFN_getdepid1st(b.DepID))
INNER JOIN PEMPLOYEE_REGISTER as c on b.EID=c.EID and c.pstatus in (1)
WHERE ISNULL(a.Closed, 0) = 0
------ 资管部门分管领导
UNION
SELECT b.EID, NULL AS xid, a.name AS title, 
dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(393)) AS KPIReportTo, a.monthID AS MonthID
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.eEmployee AS b ON a.badge = b.Badge and (select DepType from oDepartment where DepID=b.DepID)=4 and b.CompID=13
and b.EID=dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID))
INNER JOIN PEMPLOYEE_REGISTER as c on b.EID=c.EID and c.pstatus in (1)
WHERE ISNULL(a.Closed, 0) = 0

---- 营业部
------ 非负责人
UNION
SELECT b.EID, NULL AS xid, a.name AS title, 
ISNULL(dbo.eFN_getdepdirector(b.DepID), dbo.eFN_getdepdirector2(b.DepID)) AS KPIReportTo, a.monthID AS MonthID
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.eEmployee AS b ON a.badge = b.Badge and (select DepType from oDepartment where DepID=b.DepID) in (2,3)
and b.EID<>(select Director from oDepartment where DepID=b.DepID) and b.EID<>(select Director from oDepartment where DepID=dbo.eFN_getdepid1st(b.DepID))
INNER JOIN PEMPLOYEE_REGISTER as c on b.EID=c.EID and c.pstatus in (1)
WHERE ISNULL(a.Closed, 0) = 0
------ 二级营业部负责人
UNION
SELECT b.EID, NULL AS xid, a.name AS title, 
dbo.eFN_getdepdirector2(b.DepID) AS KPIReportTo, a.monthID AS MonthID
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.eEmployee AS b ON a.badge = b.Badge and (select DepType from oDepartment where DepID=b.DepID) in (2,3)
and b.EID=(select Director from oDepartment where DepID=b.DepID) and b.EID<>(select Director from oDepartment where DepID=dbo.eFN_getdepid1st(b.DepID))
INNER JOIN PEMPLOYEE_REGISTER as c on b.EID=c.EID and c.pstatus in (1)
WHERE ISNULL(a.Closed, 0) = 0
------ 一级营业部负责人
UNION
SELECT b.EID, NULL AS xid, a.name AS title, 
dbo.eFN_getdepdirector2(b.DepID) AS KPIReportTo, a.monthID AS MonthID
FROM dbo.pEmpProcess_Month AS a 
INNER JOIN dbo.eEmployee AS b ON a.badge = b.Badge and (select DepType from oDepartment where DepID=b.DepID) in (2,3)
and b.EID=(select Director from oDepartment where DepID=b.DepID) and b.EID=(select Director from oDepartment where DepID=dbo.eFN_getdepid1st(b.DepID))
INNER JOIN PEMPLOYEE_REGISTER as c on b.EID=c.EID and c.pstatus in (1)
WHERE ISNULL(a.Closed, 0) = 0