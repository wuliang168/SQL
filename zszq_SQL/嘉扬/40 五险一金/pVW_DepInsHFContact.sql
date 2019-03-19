-- pVW_DepInsHFContact
---- 总部
select a.DepID as DepID1st,NULL as DepID2nd,a.DepInsHFContact as DepInsHFContact,a.xOrder as DepxOrder
from oDepartment a
where a.DepID in (780,392,393,682)

---- 营业部
UNION
select dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(a.DepID) as DepID2nd,a.DepInsHFContact as DepInsHFContact,a.xOrder as DepxOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.DepType in (2,3)