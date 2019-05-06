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
a.ProjectTitle as ProjectTitle,a.ProjectBonusType as ProjectBonusType,a.ProjectBonusAcc as ProjectBonusAcc,
a.ProjectBonusUTUpRatio as ProjectBonusUTUpRatio,a.ProjectBonusTDISType as ProjectBonusTDISType,
a.ProjectBonusSSYearN as ProjectBonusSSYearN,a.ProjectBonusSSSub1YearN as ProjectBonusSSSub1YearN,a.ProjectBonusSSSub2YearN as ProjectBonusSSSub2YearN,a.ProjectBonusSSSub3YearN as ProjectBonusSSSub3YearN,
---- 基于分配精度
------ 项目净收入
a.ProjectBonusNI as ProjectBonusNI,
------ 其他奖金净收入
a.ProjectBonusOTNI as ProjectBonusOTNI,
------ 承揽奖金
a.ProjectBonusCT as ProjectBonusCT,
------ 责任承做奖
a.ProjectBonusUT as ProjectBonusUT,
ROUND(ROUND(a.ProjectBonusUT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusUTDIS1stYear,
ROUND(ROUND((a.ProjectBonusUT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)-ROUND(a.ProjectBonusUT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusUTDIS2ndYear,
a.ProjectBonusUT-ROUND(ROUND(a.ProjectBonusUT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2)-ROUND(ROUND((a.ProjectBonusUT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)-ROUND(a.ProjectBonusUT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusUTDIS3thYear,
------ 综合支持奖
a.ProjectBonusCS as ProjectBonusCS,
ROUND(ROUND(a.ProjectBonusCS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusCSDIS1stYear,
ROUND(ROUND((a.ProjectBonusCS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)-ROUND(a.ProjectBonusCS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusCSDIS2ndYear,
a.ProjectBonusCS-ROUND(ROUND(a.ProjectBonusCS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2)-ROUND(ROUND((a.ProjectBonusCS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)-ROUND(a.ProjectBonusCS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusCSDIS3thYear,
------ 发行支持奖
a.ProjectBonusDS as ProjectBonusDS,
ROUND(ROUND(a.ProjectBonusDS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusDSDIS1stYear,
ROUND(ROUND((a.ProjectBonusDS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)-ROUND(a.ProjectBonusDS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusDSDIS2ndYear,
a.ProjectBonusDS-ROUND(ROUND(a.ProjectBonusDS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2)-ROUND(ROUND((a.ProjectBonusDS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)-ROUND(a.ProjectBonusDS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusDSDIS3thYear,
------ 综合及后督奖
a.ProjectBonusSS as ProjectBonusSS,
ROUND((case when a.ProjectBonusSSYearN=1 then ROUND(a.ProjectBonusSS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)/a.ProjectBonusSSYearN,2) else NULL end)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusSSDIS1stYear,
ROUND(ROUND(a.ProjectBonusSS/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)/a.ProjectBonusSSYearN,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusSSAVGY,
a.ProjectBonusSSSub1 as ProjectBonusSSSub1,
ROUND((case when a.ProjectBonusSSSub1YearN=1 then ROUND(a.ProjectBonusSSSub1/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)/a.ProjectBonusSSSub1YearN,2) else NULL end)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusSSSub1DIS1stYear,
ROUND(ROUND(a.ProjectBonusSSSub1/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)/a.ProjectBonusSSSub1YearN,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusSSSub1AVGY,
a.ProjectBonusSSSub2 as ProjectBonusSSSub2,
ROUND((case when a.ProjectBonusSSSub2YearN=1 then ROUND(a.ProjectBonusSSSub2/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)/a.ProjectBonusSSSub2YearN,2) else NULL end)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusSSSub2DIS1stYear,
ROUND(ROUND(a.ProjectBonusSSSub2/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)/a.ProjectBonusSSSub2YearN,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusSSSub2AVGY,
a.ProjectBonusSSSub3 as ProjectBonusSSSub3,
ROUND((case when a.ProjectBonusSSSub3YearN=1 then ROUND(a.ProjectBonusSSSub3/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)/a.ProjectBonusSSSub3YearN,2) else NULL end)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusSSSub3DIS1stYear,
ROUND(ROUND(a.ProjectBonusSSSub3/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)/a.ProjectBonusSSSub3YearN,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusSSSub3AVGY,
------ 其他包销/分销/通道奖
a.ProjectBonusOT as ProjectBonusOT,
ROUND(ROUND(a.ProjectBonusOT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusOTDIS1stYear,
ROUND(ROUND((a.ProjectBonusOT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)-ROUND(a.ProjectBonusOT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusOTDIS2ndYear,
a.ProjectBonusOT-ROUND(ROUND(a.ProjectBonusOT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2)-ROUND(ROUND((a.ProjectBonusOT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)-ROUND(a.ProjectBonusOT/(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc)*(case when a.ProjectBonusTDISType=0 then 0.5 when a.ProjectBonusTDISType=1 then 0.75 else 1 end),2))*0.7,2)
*(select PBAcc from oCD_ProjectBonusAcc where ID=a.ProjectBonusAcc),2) as ProjectBonusOTDIS3thYear,
------ 特殊贡献奖
a.ProjectBonusSP as ProjectBonusSP,
a.Remark as Remark
from pProjectBonusPerPJ a