-- pVW_EMPOfFamily

select a.EID as OEID,(select CertNo from eDetails where EID=a.EID) as OCertNo,(select Mobile from eDetails where EID=a.EID) as OMobile,
(select Name from eEmployee where EID=a.EID) as OName,
b.EID as FEID,(select Name from eEmployee where EID=b.EID) as FNAME,(select CertNo from eDetails where EID=b.EID) as FCERTID,
(select Mobile from eDetails where EID=b.EID) as FMobile,
(select relation from ebg_family where CERTID=(select CertNo from eDetails where EID=b.EID)) as FRelation,
(select CompID from eEmployee where EID=b.EID) as FCompID,(select dbo.eFN_getdepid1st(DepID) from eEmployee where EID=b.EID) as FDep1st,
(select dbo.eFN_getdepid2nd(DepID) from eEmployee where EID=b.EID) as FDep2nd,(select JobID from eEmployee where EID=b.EID) as FJobID,
(select xOrder from oJob where JobID=(select JobID from eEmployee where EID=a.EID)) as JobXorder
from ebg_family a,eDetails b
where a.EID<>b.EID
and (select Status from eEmployee where EID=a.EID) not in (4,5) and (select Status from eEmployee where EID=b.EID) not in (4,5)
and a.CERTID=b.CertNo