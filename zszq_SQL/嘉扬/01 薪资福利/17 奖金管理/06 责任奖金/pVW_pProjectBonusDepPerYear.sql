-- pVW_pProjectBonusDepPerYear

select a.ProjectBonusDISYear as ProjectBonusDISYear,a.DepID as DepID,
ISNULL(a.PBCTDISTTPY,0) as PBCTDISTTPY,ISNULL(a.PBCTDISTTPY,0)-(select SUM(ProjectBonusCTDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.DepID=ProjectBonusDepID) as PBCTDISTTPYRST,
ISNULL(a.PBUTDISTTPY,0) as PBUTDISTTPY,ISNULL(a.PBUTDISTTPY,0)-(select SUM(ProjectBonusUTDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.DepID=ProjectBonusDepID) as PBUTDISTTPYRST,
ISNULL(a.PBCSDISTTPY,0) as PBCSDISTTPY,ISNULL(a.PBCSDISTTPY,0)-(select SUM(ProjectBonusCSDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.DepID=ProjectBonusDepID) as PBCSDISTTPYRST,
ISNULL(a.PBDSDISTTPY,0) as PBDSDISTTPY,ISNULL(a.PBDSDISTTPY,0)-(select SUM(ProjectBonusDSDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.DepID=ProjectBonusDepID) as PBDSDISTTPYRST,
ISNULL(a.PBSSDISTTPY,0) as PBSSDISTTPY,ISNULL(a.PBSSDISTTPY,0)-(select SUM(ProjectBonusSSDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.DepID=ProjectBonusDepID) as PBSSDISTTPYRST,
ISNULL(a.PBOTDISTTPY,0) as PBOTDISTTPY,ISNULL(a.PBOTDISTTPY,0)-(select SUM(ProjectBonusOTDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.DepID=ProjectBonusDepID) as PBOTDISTTPYRST,
ISNULL(a.PBSPDISTTPY,0) as PBSPDISTTPY,ISNULL(a.PBSPDISTTPY,0)-(select SUM(ProjectBonusSPDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.DepID=ProjectBonusDepID) as PBSPDISTTPYRST
from pProjectBonusDepPerYear a