-- pVW_EMPInsuranceHousingFundImport_all

select b.Month as Month,a.EID as EID,a.HRLID as HRLID,d.chn_name as Name,f.SalaryPayID as SalaryPayID,g.EMPInsuranceDepart as EMPInsuranceDepart,h.EMPHousingFundDepart as EMPHousingFundDepart,
(select IsSubmit from pEMPInsuranceHousingFundDep where g.EMPInsuranceDepart=ISNULL(DepID2nd,DepID1st) and Month=c.Month) as InsuranceIsSubmit,
(select IsSubmit from pEMPInsuranceHousingFundDep where h.EMPHousingFundDepart=ISNULL(DepID2nd,DepID1st) and Month=b.Month) as HousingFundIsSubmit,
d.gongjijinmax as gongjijinmax,c.EndowInsEMP as yanglaogeren,c.UnemployInsGRP as shiyegongsi,c.EndowInsGRP as yanglaogongsi,c.UnemployInsEMP as shiyegeren, 
c.InjuryInsGRP as gongshanggongsi,c.MaternityInsGRP as shengyugongsi,c.MedicalInsGRP as yiliaogongsi,c.MedicalInsEMP as yiliaogeren,
b.HousingFundGRP as gongjijingongsi,b.HousingFundEMP as gongjijingeren, 
d.dabing as dabing,d.yanglaoplace as yanglaoplace,d.gongjijinplace as gongjijinplace
from eEmployee a
left join pEMPHousingFundPerMM_all b on a.EID=b.EID
left join pEMPInsurancePerMM_all c on a.EID=c.EID
left join OPENQUERY(HRLINK, 'SELECT a.emp_code,a.chn_name,b.dabing,b.yanglaoplace,b.gongjijinplace,b.gongjijinmax FROM DBO.EMP_INFO_MASTER a,DBO.CU_SALARYPLACE b WHERE a.emp_id=b.emp_id') d on d.emp_code=a.HRLID COLLATE Latin1_General_CI_AI
inner join pEMPSalary f on a.EID=f.EID
inner join pEMPInsurance g on a.EID=g.EID
inner join pEMPHousingFund h on a.EID=h.EID
where a.status not in (4,5) and DATEDIFF(MM,b.Month,c.Month)=0