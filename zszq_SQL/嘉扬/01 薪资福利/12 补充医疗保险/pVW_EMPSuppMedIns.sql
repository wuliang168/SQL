-- pVW_EMPSuppMedIns

select a.EID as EID,(select Badge from eEmployee where EID=a.EID) as Badge,(select Name from eEmployee where EID=a.EID) as Name,
SMICertID,(select CompID from eEmployee where EID=a.EID) as CompID,(select dbo.eFN_getdepid1st(depid) from eEmployee where EID=a.EID) as DepID1,
(select dbo.eFN_getdepid2nd(depid) from eEmployee where EID=a.EID) as DepID2,(select jobid from eEmployee where EID=a.EID) as JobID,
(select EmpGrade from eEmployee where EID=a.EID) as EmpGrade,(select JoinDate from eStatus where EID=a.EID) as JoinDate,
(select LeaDate from eStatus where EID=a.EID) as LeaDate,(select LeaType from eStatus where EID=a.EID) as LeaType,SMINO,SMIType,IsConfirm,
(select Status from eEmployee where EID=a.EID) as Status,(select xorder from oJob where JobID=(select jobid from eEmployee where EID=a.EID)) as jobxorder
from pEMPSuppMedIns a