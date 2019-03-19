-- pVW_DepSalaryContact
---- 非营业部
select dbo.eFN_getdepid1st(a.DepID),dbo.eFN_getdepid2nd(a.DepID),a.DepSalaryContact
from oDepartment a
where a.DepType in (1,4) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999

---- 营业部
UNION
select dbo.eFN_getdepid1st(a.DepID),dbo.eFN_getdepid2nd(a.DepID),a.DepSalaryContact
from oDepartment a
where a.DepType in (2,3) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999