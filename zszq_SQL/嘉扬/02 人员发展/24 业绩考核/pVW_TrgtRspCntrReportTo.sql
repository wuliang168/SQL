-- pVW_TrgtRspCntrReportTo

-- 部门负责人考核
---- 总部
select CompID as CompID,dbo.eFN_getdepid1st(DepID) as DepID1st,dbo.eFN_getdepid2nd(DepID) as DepID2nd,Director as ReportTo,1 as TRCLev,xOrder as xOrder
from oDepartment
where CompID=11 and DepType=1 and DepGrade=1
and ISNULL(IsDisabled,0)=0 and xOrder<>9999999999999

UNION
---- 子公司
select CompID as CompID,dbo.eFN_getdepid1st(DepID) as DepID1st,dbo.eFN_getdepid2nd(DepID) as DepID2nd,Director as ReportTo,1 as TRCLev,xOrder as xOrder
from oDepartment
where CompID in (12,13) and DepType=4 and DepGrade=1
and ISNULL(IsDisabled,0)=0 and xOrder<>9999999999999

UNION
---- 分支机构
select CompID as CompID,dbo.eFN_getdepid1st(DepID) as DepID1st,dbo.eFN_getdepid2nd(DepID) as DepID2nd,Director as ReportTo,1 as TRCLev,xOrder as xOrder
from oDepartment
where CompID=11 and DepType in (2,3)
and ISNULL(IsDisabled,0)=0 and xOrder<>9999999999999

UNION
-- 网点运营管理总部(DepID:362) ()
select CompID as CompID,dbo.eFN_getdepid1st(DepID) as DepID1st,dbo.eFN_getdepid2nd(DepID) as DepID2nd,Director as ReportTo,2 as TRCLev,2 as xOrder
from oDepartment
where DepID=362

UNION
-- 人力资源考核(DepID:354) ()
select CompID as CompID,dbo.eFN_getdepid1st(DepID) as DepID1st,dbo.eFN_getdepid2nd(DepID) as DepID2nd,Director as ReportTo,3 as TRCLev,1 as xOrder
from oDepartment
where DepID=354