-- pVW_LawFamilyInfo

select b.Badge as Badge,b.Name as Name,a.Fname as FName,a.relation as FRelation,a.gender as FGender,a.Birthday,a.Company as FCompany,
a.Job as FJob,a.status as FStatus,a.tel as FTel,a.CERTID as FCertID,a.isyj as FIsYJ,a.OversResidNo as FOversResIDNo
from ebg_family a,eEmployee b
where a.eid=b.EID
and b.Status not in (4,5) and dbo.eFN_getdepadmin(b.DepID)=695