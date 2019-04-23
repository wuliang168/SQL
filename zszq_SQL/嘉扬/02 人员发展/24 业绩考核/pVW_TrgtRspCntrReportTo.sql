-- pVW_TrgtRspCntrReportTo

-- 部门负责人考核
---- 总部(不含投行)
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,NULL as DepID2nd,
dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(a.DepID)) as ReportTo
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID and ISNULL(dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID)),0)<>695
and a.CompID=11 and dbo.eFN_getdeptype(a.DepID)=1

---- 总部(投行)
------ 投资银行管理总部：683
UNION
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,NULL as DepID2nd,
dbo.eFN_getdepdirector(683) as ReportTo
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID and ISNULL(dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID)),0)=695

---- 子公司
------ 资管
UNION
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,NULL as DepID2nd,
dbo.eFN_getdepdirector(795) as ReportTo
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID
and a.CompID=13

UNION
---- 网点运营管理总部(DepID:362)
------ 分支机构
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
dbo.eFN_getdepdirector(362) as ReportTo
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID and a.EmpGrade in (9,5)
and a.CompID=11 and dbo.eFN_getdeptype(a.DepID) in (2,3)