-- pVW_TrgtRspCntrReportTo

-- 部门负责人考核
---- 总部(不含投行和研究所)
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
NULL as PreviewTo,dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(a.DepID)) as ReportTo,dbo.eFN_getdepid1st(a.DepID) as ReportToDepID
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID and ISNULL(dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID)),0)<>695
and ISNULL(dbo.eFN_getdepid1st(a.DepID),0)<>361 and a.CompID=11 and dbo.eFN_getdeptype(a.DepID)=1
and a.Name<>N'胡晶飚'

---- 总部(研究所)
------ 浙商证券研究所：361
UNION
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
2098 as PreviewTo,dbo.eFN_getdepdirector(361) as ReportTo,361 as ReportToDepID
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID and ISNULL(dbo.eFN_getdepid1st(a.DepID),0)=361

---- 总部(投行)
------ 投资银行管理总部：683
UNION
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
NULL as PreviewTo,dbo.eFN_getdepdirector(683) as ReportTo,695 as ReportToDepID
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID and ISNULL(dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID)),0)=695

---- 子公司
------ 资管
UNION
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
NULL as PreviewTo,dbo.eFN_getdepdirector(795) as ReportTo,393 as ReportToDepID
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID
and a.CompID=13

UNION
---- 网点运营管理总部(DepID:362)
------ 分支机构
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
1308 as PreviewTo,dbo.eFN_getdepdirector(362) as ReportTo,362 as ReportToDepID
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID and a.EmpGrade in (9,5)
and a.CompID=11 and dbo.eFN_getdeptype(a.DepID) in (2,3)

UNION
---- 网点运营管理总部(DepID:362)
------ 胡晶飚
select a.EID as EID,a.CompID as CompID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,
1308 as PreviewTo,dbo.eFN_getdepdirector(362) as ReportTo,362 as ReportToDepID
from eEmployee a,oDepartment b
where a.Status not in (4,5) and a.DepID=b.DepID and a.CompID=11
and a.Name=N'胡晶飚'