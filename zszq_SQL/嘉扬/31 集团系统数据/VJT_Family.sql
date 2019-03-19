-- VJT_Family
select a.EID as EID,(select Name from eEmployee where EID=a.EID) as Name,(select CertNo from eDetails where EID=a.EID) as CertNo,
Fname as FName,(select Title from eCD_Relation where ID=a.relation) as FRelation,a.tel as FTel,a.address as FAddress,
a.Birthday as FBirthday,a.Company as FCompany,a.CERTID as FCertID,(case when b.EID is NULL then 0 else 1 end) as FEmg
from ebg_family a
left join eBG_Emergency b on a.eid=b.EID and a.Fname=b.EmergencyName
where (select status from eEmployee where eid=a.EID) not in (4,5)