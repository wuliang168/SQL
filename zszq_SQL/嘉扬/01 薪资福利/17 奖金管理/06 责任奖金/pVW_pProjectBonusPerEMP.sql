-- pVW_pProjectBonusPerEMP

select a.EID as EID,SUM(a.ProjectBonusCTDISYear) as PBCTDISYear,SUM(a.ProjectBonusUTDISYear) as PBUTDISYear,SUM(a.ProjectBonusCSDISYear) as PBCSDISYear,
SUM(a.ProjectBonusDSDISYear) as PBDSDISYear,SUM(a.ProjectBonusSSDISYear) as PBSSDISYear,SUM(a.ProjectBonusOTDISYear) as PBOTDISYear,SUM(a.ProjectBonusSPDISYear) as PBSPDISYear
from pProjectBonusPerEMP a
where ISNULL(a.IsDIST,0)=0
group by a.EID