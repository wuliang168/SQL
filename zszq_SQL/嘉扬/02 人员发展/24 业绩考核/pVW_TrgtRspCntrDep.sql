-- pVW_TrgtRspCntrDep

-- 部门负责人考核
---- 总部(不含投行)
select dbo.eFN_getcompid(a.DepID) as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(a.DepID)) as ReportTo,a.xOrder as DepxOrder
from oDepartment a
where ISNULL(dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID)),0)<>695
and dbo.eFN_getcompid(a.DepID)=11 and dbo.eFN_getdeptype(a.DepID)=1 and dbo.eFN_getdepgrade(a.DepID)=1
and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999

---- 总部(投行)
------ 投资银行管理总部：683
UNION
select dbo.eFN_getcompid(a.DepID) as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
dbo.eFN_getdepdirector(683) as ReportTo,a.xOrder as DepxOrder
from oDepartment a
where ISNULL(dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID)),0)=695 and dbo.eFN_getdepgrade(a.DepID)=1
and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999

---- 子公司
------ 资管
UNION
select dbo.eFN_getcompid(a.DepID) as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
dbo.eFN_getdepdirector(795) as ReportTo,a.xOrder as DepxOrder
from oDepartment a
where dbo.eFN_getcompid(a.DepID)=13 and dbo.eFN_getdepgrade(a.DepID)=1
and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999

UNION
---- 网点运营管理总部(DepID:362)
------ 分支机构
select dbo.eFN_getcompid(a.DepID) as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
dbo.eFN_getdepdirector(362) as ReportTo,a.xOrder as DepxOrder
from oDepartment a
where dbo.eFN_getcompid(a.DepID)=11 and dbo.eFN_getdeptype(a.DepID) in (2,3)
and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999