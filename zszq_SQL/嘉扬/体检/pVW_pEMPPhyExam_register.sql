-- pVW_pEMPPhyExam_register

select a.PEYear as PEYear,a.EID as EID,a.PEDate as PEDate,(select COUNT(EID) from pEMPPhyExam_register where PEDate=a.PEDate)as PESumm 
from pEMPPhyExam_register a