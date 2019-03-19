-- pVW_EMPInsuranceHousingFundImport
select a.EID as EID,a.HRLID as HRLID,d.chn_name as Name,f.SalaryPayID as SalaryPayID,g.EMPInsuranceDepart as EMPInsuranceDepart,h.EMPHousingFundDepart as EMPHousingFundDepart,
(select IsSubmit from pEMPInsuranceHousingFundDep where ISNULL(IsClosed,0)=0 and g.EMPInsuranceDepart=ISNULL(DepID2nd,DepID1st)) as InsuranceIsSubmit,
(select IsSubmit from pEMPInsuranceHousingFundDep where ISNULL(IsClosed,0)=0 and h.EMPHousingFundDepart=ISNULL(DepID2nd,DepID1st)) as HousingFundIsSubmit,
e.gongjijinmax as gongjijinmax,c.EndowInsEMP as yanglaogeren,c.UnemployInsGRP as shiyegongsi,c.EndowInsGRP as yanglaogongsi,c.UnemployInsEMP as shiyegeren, 
c.InjuryInsGRP as gongshanggongsi,c.MaternityInsGRP as shengyugongsi,c.MedicalInsGRP as yiliaogongsi,c.MedicalInsEMP as yiliaogeren,
b.HousingFundGRP as gongjijingongsi,b.HousingFundEMP as gongjijingeren, 
e.dabing as dabing,e.yanglaoplace as yanglaoplace,e.gongjijinplace as gongjijinplace
from eEmployee a
left join pEMPHousingFundPerMM b on a.EID=b.EID
left join pEMPInsurancePerMM c on a.EID=c.EID
left join OPENQUERY(HRLINK, 'SELECT emp_code,emp_id,chn_name FROM DBO.EMP_INFO_MASTER') d on d.emp_code=a.HRLID COLLATE Latin1_General_CI_AI
left join OPENQUERY(HRLINK, 'SELECT emp_id,dabing,yanglaoplace,gongjijinplace,gongjijinmax FROM DBO.CU_SALARYPLACE') e on d.emp_id=e.emp_id COLLATE Latin1_General_CI_AI
inner join pEmployeeEmolu f on a.EID=f.EID
inner join pEMPInsurance g on a.EID=g.EID
inner join pEMPHousingFund h on a.EID=h.EID
where a.status not in (4,5)