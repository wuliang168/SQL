-- pVW_pYear_AppraiseTeam
select a.xOrder as xOrder,a.CompID as CompID,(select CompAbbr from oCompany where CompID=a.CompID) as CompAbbr,a.DepID as DepID,
a.AdminID as AdminID,(select DepAbbr from oDepartment where DepID=a.AdminID) as AdminAbbr,a.DepAbbr as DepAbbr,a.DepType as DepType,
a.DepGrade as DepGrade,a.ISOU as ISOU,a.EffectDate as EffectDate
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.xOrder <> 9999999999999 and DepID<>349