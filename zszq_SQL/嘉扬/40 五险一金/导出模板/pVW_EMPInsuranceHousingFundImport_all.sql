-- pVW_EMPInsuranceHousingFundImport_all
select b.Month as Month,a.EID as EID,a.HRLID as HRLID,d.chn_name as Name,f.SalaryPayID as SalaryPayID,g.EMPInsuranceDepart as EMPInsuranceDepart,h.EMPHousingFundDepart as EMPHousingFundDepart,
(select IsSubmit from pEMPInsuranceHousingFundDep where g.EMPInsuranceDepart=ISNULL(DepID2nd,DepID1st) and Month=c.Month) as InsuranceIsSubmit,
(select IsSubmit from pEMPInsuranceHousingFundDep where h.EMPHousingFundDepart=ISNULL(DepID2nd,DepID1st) and Month=b.Month) as HousingFundIsSubmit,
e.gongjijinmax as gongjijinmax,c.EndowInsEMP as yanglaogeren,c.UnemployInsGRP as shiyegongsi,c.EndowInsGRP as yanglaogongsi,c.UnemployInsEMP as shiyegeren, 
c.InjuryInsGRP as gongshanggongsi,c.MaternityInsGRP as shengyugongsi,c.MedicalInsGRP as yiliaogongsi,c.MedicalInsEMP as yiliaogeren,
b.HousingFundGRP as gongjijingongsi,b.HousingFundEMP as gongjijingeren, 
e.dabing as dabing,e.yanglaoplace as yanglaoplace,e.gongjijinplace as gongjijinplace
from eEmployee a
left join pEMPHousingFundPerMM_all b on a.EID=b.EID
left join pEMPInsurancePerMM_all c on a.EID=c.EID and b.Month=c.Month
left join OPENQUERY(HRLINK, 'SELECT emp_code,emp_id,chn_name FROM DBO.EMP_INFO_MASTER') d on d.emp_code=a.HRLID COLLATE Latin1_General_CI_AI
left join OPENQUERY(HRLINK, 'SELECT emp_id,dabing,yanglaoplace,gongjijinplace,gongjijinmax FROM DBO.CU_SALARYPLACE') e on d.emp_id=e.emp_id COLLATE Latin1_General_CI_AI
inner join pEmployeeEmolu f on a.EID=f.EID
inner join pEMPInsurance g on a.EID=g.EID
inner join pEMPHousingFund h on a.EID=h.EID
where a.status not in (4,5)