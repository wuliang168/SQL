-- pVW_ProjectBonusPerPJ

select a.ID as ID,a.ProjectBonusYear as ProjectBonusYear,a.DepID as DepID,
(case when ISNULL(a.ProjectBonusSSSub1YearN,0)>=ISNULL(a.ProjectBonusSSSub2YearN,0) and ISNULL(a.ProjectBonusSSSub1YearN,0)>=ISNULL(a.ProjectBonusSSSub3YearN,0) 
and ISNULL(a.ProjectBonusSSSub1YearN,0)>0 and ISNULL(a.ProjectBonusSSSub1YearN,0)>=ISNUMERIC(a.ProjectBonusTDISType)*3 then ISNULL(NULLIF(ISNULL(a.ProjectBonusSSSub1YearN,0)-1,0),-1)+2
when ISNULL(a.ProjectBonusSSSub2YearN,0)>=ISNULL(a.ProjectBonusSSSub1YearN,0) and ISNULL(a.ProjectBonusSSSub2YearN,0)>=ISNULL(a.ProjectBonusSSSub3YearN,0) 
and ISNULL(a.ProjectBonusSSSub2YearN,0)>0 and ISNULL(a.ProjectBonusSSSub2YearN,0)>=ISNUMERIC(a.ProjectBonusTDISType)*3 then ISNULL(NULLIF(ISNULL(a.ProjectBonusSSSub2YearN,0)-1,0),-1)+2
when ISNULL(a.ProjectBonusSSSub3YearN,0)>=ISNULL(a.ProjectBonusSSSub1YearN,0) and ISNULL(a.ProjectBonusSSSub3YearN,0)>=ISNULL(a.ProjectBonusSSSub3YearN,0) 
and ISNULL(a.ProjectBonusSSSub3YearN,0)>0 and ISNULL(a.ProjectBonusSSSub3YearN,0)>=ISNUMERIC(a.ProjectBonusTDISType)*3 then ISNULL(NULLIF(ISNULL(a.ProjectBonusSSSub3YearN,0)-1,0),-1)+2
when ISNULL(a.ProjectBonusSSYearN,0)>=ISNUMERIC(a.ProjectBonusTDISType)*3 then ISNULL(NULLIF(ISNULL(a.ProjectBonusSSYearN,0)-1,0),-1)+2
else ISNULL(NULLIF(ISNULL(a.ProjectBonusTDISType*3,1)-1,0),-1)+2 end) as ProjectBonusYearMAXN,
a.ProjectTitle as ProjectTitle,a.ProjectBonusType as ProjectBonusType,
a.ProjectBonusUTUpRatio as ProjectBonusUTUpRatio,a.ProjectBonusTDISType as ProjectBonusTDISType,
a.ProjectBonusSSYearN as ProjectBonusSSYearN,a.ProjectBonusSSSub1YearN as ProjectBonusSSSub1YearN,a.ProjectBonusSSSub2YearN as ProjectBonusSSSub2YearN,a.ProjectBonusSSSub3YearN as ProjectBonusSSSub3YearN,
---- 正常
--a.ProjectBonusNI as ProjectBonusNI,a.ProjectBonusOTNI as ProjectBonusOTNI,
--a.ProjectBonusCT as ProjectBonusCT,
--a.ProjectBonusUT as ProjectBonusUT,
--ROUND(a.ProjectBonusUT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)*10000 as ProjectBonusUTDIS1stYear,
--ROUND((a.ProjectBonusUT/10000-ROUND(a.ProjectBonusUT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)*10000 as ProjectBonusUTDIS2ndYear,
--a.ProjectBonusUT-ROUND(a.ProjectBonusUT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)*10000
---ROUND((a.ProjectBonusUT/10000-ROUND(a.ProjectBonusUT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)*10000 as ProjectBonusUTDIS3thYear,
--a.ProjectBonusCS as ProjectBonusCS,
--ROUND(a.ProjectBonusCS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)*10000 as ProjectBonusCSDIS1stYear,
--ROUND((a.ProjectBonusCS/10000-ROUND(a.ProjectBonusCS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)*10000 as ProjectBonusCSDIS2ndYear,
--a.ProjectBonusCS-ROUND(a.ProjectBonusCS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)*10000
---ROUND((a.ProjectBonusCS/10000-ROUND(a.ProjectBonusCS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)*10000 as ProjectBonusCSDIS3thYear,
--a.ProjectBonusDS as ProjectBonusDS,
--ROUND(a.ProjectBonusDS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)*10000 as ProjectBonusDSDIS1stYear,
--ROUND((a.ProjectBonusDS/10000-ROUND(a.ProjectBonusDS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)*10000 as ProjectBonusDSDIS2ndYear,
--a.ProjectBonusDS-ROUND(a.ProjectBonusDS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)*10000
---ROUND((a.ProjectBonusDS/10000-ROUND(a.ProjectBonusDS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)*10000 as ProjectBonusDSDIS3thYear,
--a.ProjectBonusSS as ProjectBonusSS,
--(case when a.ProjectBonusSSYearN=1 then ROUND(a.ProjectBonusSS/10000/a.ProjectBonusSSYearN,2)*10000 else 0 end) as ProjectBonusSSDIS1stYear,
--ROUND(a.ProjectBonusSS/10000/a.ProjectBonusSSYearN,2)*10000 as ProjectBonusSSAVGY,
--a.ProjectBonusOT as ProjectBonusOT,
--ROUND(a.ProjectBonusOT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)*10000 as ProjectBonusOTDIS1stYear,
--ROUND((a.ProjectBonusOT/10000-ROUND(a.ProjectBonusOT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)*10000 as ProjectBonusOTDIS2ndYear,
--a.ProjectBonusOT-ROUND(a.ProjectBonusOT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)*10000
---ROUND((a.ProjectBonusOT/10000-ROUND(a.ProjectBonusOT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)*10000 as ProjectBonusOTDIS3thYear,
--a.ProjectBonusSP as ProjectBonusSP,
---- 万元
a.ProjectBonusNI/10000 as ProjectBonusNI,a.ProjectBonusOTNI/10000 as ProjectBonusOTNI,
a.ProjectBonusCT/10000 as ProjectBonusCT,
a.ProjectBonusUT/10000 as ProjectBonusUT,
ROUND(a.ProjectBonusUT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2) as ProjectBonusUTDIS1stYear,
ROUND((a.ProjectBonusUT/10000-ROUND(a.ProjectBonusUT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2) as ProjectBonusUTDIS2ndYear,
a.ProjectBonusUT/10000-ROUND(a.ProjectBonusUT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
-ROUND((a.ProjectBonusUT/10000-ROUND(a.ProjectBonusUT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2) as ProjectBonusUTDIS3thYear,
a.ProjectBonusCS/10000 as ProjectBonusCS,
ROUND(a.ProjectBonusCS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2) as ProjectBonusCSDIS1stYear,
ROUND((a.ProjectBonusCS/10000-ROUND(a.ProjectBonusCS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2) as ProjectBonusCSDIS2ndYear,
a.ProjectBonusCS/10000-ROUND(a.ProjectBonusCS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
-ROUND((a.ProjectBonusCS/10000-ROUND(a.ProjectBonusCS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2) as ProjectBonusCSDIS3thYear,
a.ProjectBonusDS/10000 as ProjectBonusDS,
ROUND(a.ProjectBonusDS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2) as ProjectBonusDSDIS1stYear,
ROUND((a.ProjectBonusDS/10000-ROUND(a.ProjectBonusDS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2) as ProjectBonusDSDIS2ndYear,
a.ProjectBonusDS/10000-ROUND(a.ProjectBonusDS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
-ROUND((a.ProjectBonusDS/10000-ROUND(a.ProjectBonusDS/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2) as ProjectBonusDSDIS3thYear,
a.ProjectBonusSS/10000 as ProjectBonusSS,
(case when a.ProjectBonusSSYearN=1 then ROUND(a.ProjectBonusSS/10000/a.ProjectBonusSSYearN,2) else NULL end) as ProjectBonusSSDIS1stYear,
ROUND(a.ProjectBonusSS/10000/a.ProjectBonusSSYearN,2) as ProjectBonusSSAVGY,
a.ProjectBonusSSSub1/10000 as ProjectBonusSSSub1,
(case when a.ProjectBonusSSSub1YearN=1 then ROUND(a.ProjectBonusSSSub1/10000/a.ProjectBonusSSSub1YearN,2) else NULL end) as ProjectBonusSSSub1DIS1stYear,
ROUND(a.ProjectBonusSSSub1/10000/a.ProjectBonusSSSub1YearN,2) as ProjectBonusSSSub1AVGY,
a.ProjectBonusSSSub2/10000 as ProjectBonusSSSub2,
(case when a.ProjectBonusSSSub2YearN=1 then ROUND(a.ProjectBonusSSSub2/10000/a.ProjectBonusSSSub2YearN,2) else NULL end) as ProjectBonusSSSub2DIS1stYear,
ROUND(a.ProjectBonusSSSub2/10000/a.ProjectBonusSSSub2YearN,2) as ProjectBonusSSSub2AVGY,
a.ProjectBonusSSSub3/10000 as ProjectBonusSSSub3,
(case when a.ProjectBonusSSSub3YearN=1 then ROUND(a.ProjectBonusSSSub3/10000/a.ProjectBonusSSSub3YearN,2) else NULL end) as ProjectBonusSSSub3DIS1stYear,
ROUND(a.ProjectBonusSSSub3/10000/a.ProjectBonusSSSub3YearN,2) as ProjectBonusSSSub3AVGY,
a.ProjectBonusOT/10000 as ProjectBonusOT,
ROUND(a.ProjectBonusOT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2) as ProjectBonusOTDIS1stYear,
ROUND((a.ProjectBonusOT/10000-ROUND(a.ProjectBonusOT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2) as ProjectBonusOTDIS2ndYear,
a.ProjectBonusOT/10000-ROUND(a.ProjectBonusOT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
-ROUND((a.ProjectBonusOT/10000-ROUND(a.ProjectBonusOT/10000*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2) as ProjectBonusOTDIS3thYear,
a.ProjectBonusSP/10000 as ProjectBonusSP,a.Remark as Remark
from pProjectBonusPerPJ a