-- pVW_ReserveTalentsDep
---- 浙商证券(非分支机构，不含投资银行)
select a.DepID,a.Title,a.Director,a.xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.xOrder<>9999999999999
and a.CompID=11 and ISNULL(a.AdminID,0) not in (695,715) and a.DepType=1 and a.DepGrade=1 and ISNULL(a.ISOU,0)=0
and a.DepID<>349

---- 财富管理
UNION
select a.DepID,a.Title,a.Director,a.xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.xOrder<>9999999999999
and a.CompID=11 and ISNULL(a.DepID,0)=715 and a.DepType=1 and a.DepGrade=1

---- 投资银行
UNION
select a.DepID,a.Title,a.Director,a.xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.xOrder<>9999999999999
and a.CompID=11 and ISNULL(a.DepID,0)=695 and a.DepType=1 and a.DepGrade=1

---- 浙商资管
UNION
select a.DepID,a.Title,1245,a.xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.xOrder<>9999999999999
and a.CompID=13 and DepID=393

---- 分支机构
UNION
select a.DepID,a.Title,a.Director,a.xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.xOrder<>9999999999999
and a.CompID=11 and a.DepType in (2,3) and a.DepGrade=1