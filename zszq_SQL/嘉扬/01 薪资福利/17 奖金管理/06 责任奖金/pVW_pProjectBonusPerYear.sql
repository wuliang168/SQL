-- pVW_pProjectBonusPerYear

select a.ProjectBonusDISYear as ProjectBonusDISYear,a.DepID as DepID,a.ProjectTitleID as ProjectTitleID,
---- PBCTDISPY
ISNULL(a.ProjectBonusCTDISPerYear,0) as PBCTDISPY,
ISNULL(a.ProjectBonusCTDISPerYear,0)-(select SUM(ProjectBonusCTDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.ProjectTitleID=ProjectTitleID) as PBCTDISPYRST,
---- PBUTDISPY
ISNULL(a.ProjectBonusUTDISPerYear,0) as PBUTDISPY,
ISNULL(a.ProjectBonusUTDISPerYear,0)-(select SUM(ProjectBonusUTDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.ProjectTitleID=ProjectTitleID) as PBUTDISPYRST,
---- PBCSDISPY
ISNULL(a.ProjectBonusCSDISPerYear,0) as PBCSDISPY,
ISNULL(a.ProjectBonusCSDISPerYear,0)-(select SUM(ProjectBonusCSDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.ProjectTitleID=ProjectTitleID) as PBCSDISPYRST,
---- PBDSDISPY
ISNULL(a.ProjectBonusDSDISPerYear,0) as PBDSDISPY,
ISNULL(a.ProjectBonusDSDISPerYear,0)-(select SUM(ProjectBonusDSDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.ProjectTitleID=ProjectTitleID) as PBDSDISPYRST,
---- PBSSDISPY
ISNULL(a.ProjectBonusSSDISPerYear,0) as PBSSDISPY,
ISNULL(a.ProjectBonusSSDISPerYear,0)-(select SUM(ProjectBonusSSDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.ProjectTitleID=ProjectTitleID) as PBSSDISPYRST,
---- PBOTDISPY
ISNULL(a.ProjectBonusOTDISPerYear,0) as PBOTDISPY,
ISNULL(a.ProjectBonusOTDISPerYear,0)-(select SUM(ProjectBonusOTDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.ProjectTitleID=ProjectTitleID) as PBOTDISPYRST,
---- PBSPDISPY
ISNULL(a.ProjectBonusSPDISPerYear,0) as PBSPDISPY,
ISNULL(a.ProjectBonusSPDISPerYear,0)-(select SUM(ProjectBonusSPDISYear) from pProjectBonusPerEMP where a.ProjectBonusDISYear=ProjectBonusDISYear and a.ProjectTitleID=ProjectTitleID) as PBSPDISPYRST
from pProjectBonusPerYear a