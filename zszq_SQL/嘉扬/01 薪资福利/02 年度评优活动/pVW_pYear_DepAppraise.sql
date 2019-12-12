-- pVW_pYear_DepAppraise

-- 总部部门(不包含公司领导、投资银行(695)及下属部门、信息技术事业部下属部门(744,745)和财富管理事业部(811))
select distinct a.DepID,a.Director,(select name from eEmployee where EID=a.Director) as DirectorName
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.Director is not NULL
and a.DepType=1 and a.DepGrade=1 and ISNULL(a.AdminID,0)<>695 and a.DepID not in (349,695,744,745,811)

-- 公司领导(不含董事长、总裁、书记)(非部门负责人)
union
select distinct a.DepID,a.EID,a.Name
from eEmployee a
where a.DepID=349 AND a.EID not in (1022,5014,5587) AND a.Status not in (4,5)
and a.EID not in (select Director from oDepartment where ISNULL(isDisabled,0)=0 and Director is not NULL 
and DepType=1 and DepGrade=1 and ISNULL(AdminID,0)<>695 and DepID not in (349,695,744,745,811))
-- 排除刘文雷
and a.EID<>1294

-- 总部部门(投资银行：695 => (投资银行管理总部DepID:683))
union
select distinct a.DepID,(select Director from oDepartment where DepID=683),
(select name from eEmployee where EID=(select Director from oDepartment where DepID=683))
from oDepartment a
where a.DepID=695

-- 子公司
---- 浙商资本DepID:392;浙商投资DepID:830
union
select distinct a.DepID,a.Director,(select name from eEmployee where EID=a.Director)
from oDepartment a
where a.DepID in (392,830)
---- 浙商资管：393 => (运营管理总部DepID:795)
union
select distinct a.DepID,(select Director from oDepartment where DepID=795),
(select name from eEmployee where EID=(select Director from oDepartment where DepID=795))
from oDepartment a
where a.DepID=393

-- 一级分支机构
union
select distinct a.DepID,a.Director,(select name from eEmployee where EID=a.Director)
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.xOrder<>9999999999999 and a.Director is not NULL
and a.DepType in (2,3) and a.DepGrade=1