-- pVW_ProjectBonusPerYear

select a.ID as ID,a.ProjectBonusYear as ProjectBonusYear,a.DepID as DepID,
a.ProjectTitle as ProjectTitle,
---- 正常
--ISNULL(a.ProjectBonusCT,0)*10000+ISNULL(ProjectBonusUTDIS1stYear,0)*10000+ISNULL(ProjectBonusCSDIS1stYear,0)*10000+ISNULL(ProjectBonusDSDIS1stYear,0)*10000
--+ISNULL(ProjectBonusOTDIS1stYear,0)*10000+(case when a.ProjectBonusSSYearN=1 then ISNULL(ProjectBonusSSAVGY,0) else 0 end)*10000
--+ISNULL(a.ProjectBonusSP,0)*10000 as ProjectBonusDIS1stYear,
--ISNULL(ProjectBonusUTDIS2ndYear,0)*10000+ISNULL(ProjectBonusCSDIS2ndYear,0)*10000+ISNULL(ProjectBonusDSDIS2ndYear,0)*10000+ISNULL(ProjectBonusOTDIS2ndYear,0)*10000
--as ProjectBonusDIS2ndYear,
--ISNULL(ProjectBonusUTDIS3thYear,0)*10000+ISNULL(ProjectBonusCSDIS3thYear,0)*10000+ISNULL(ProjectBonusDSDIS3thYear,0)*10000+ISNULL(ProjectBonusOTDIS3thYear,0)*10000
--as ProjectBonusDIS3thYear,
--(case when a.ProjectBonusSSYearN>1 then ISNULL(ProjectBonusSSAVGY,0)*10000 else 0 end) as ProjectBonusSSAVGY,
---- 万元
ISNULL(a.ProjectBonusCT,0)+ISNULL(ProjectBonusUTDIS1stYear,0)+ISNULL(ProjectBonusCSDIS1stYear,0)+ISNULL(ProjectBonusDSDIS1stYear,0)+ISNULL(ProjectBonusOTDIS1stYear,0)
+(case when a.ProjectBonusSSYearN=1 then ISNULL(ProjectBonusSSAVGY,0) else 0 end)+ISNULL(a.ProjectBonusSP,0) as ProjectBonusDIS1stYear,
ISNULL(ProjectBonusUTDIS2ndYear,0)+ISNULL(ProjectBonusCSDIS2ndYear,0)+ISNULL(ProjectBonusDSDIS2ndYear,0)+ISNULL(ProjectBonusOTDIS2ndYear,0) as ProjectBonusDIS2ndYear,
ISNULL(ProjectBonusUTDIS3thYear,0)+ISNULL(ProjectBonusCSDIS3thYear,0)+ISNULL(ProjectBonusDSDIS3thYear,0)+ISNULL(ProjectBonusOTDIS3thYear,0) as ProjectBonusDIS3thYear,
(case when a.ProjectBonusSSYearN>1 then ISNULL(ProjectBonusSSAVGY,0) else 0 end) as ProjectBonusSSAVGY,
a.IsDistribution as IsDistribution
from pVW_ProjectBonusPerPJ a