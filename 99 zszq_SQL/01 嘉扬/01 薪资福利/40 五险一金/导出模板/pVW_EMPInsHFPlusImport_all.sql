-- pVW_EMPInsHFPlusImport_all

select b.Month as Month,a.EID as EID,a.HRLID as HRLID,d.chn_name as Name,f.SalaryPayID as SalaryPayID,g.EMPInsuranceDepart as EMPInsuranceDepart,h.EMPHousingFundDepart as EMPHousingFundDepart,
(select IsSubmit from pEMPInsuranceHousingFundDep where g.EMPInsuranceDepart=ISNULL(DepID2nd,DepID1st) and MONTH=c.Month) as InsuranceIsSubmit,
(select IsSubmit from pEMPInsuranceHousingFundDep where h.EMPHousingFundDepart=ISNULL(DepID2nd,DepID1st) and MONTH=b.Month) as HousingFundIsSubmit,
c.EndowInsGRPPlus as SB_C8,c.EndowInsEMPPlus as SB_06,b.HousingFundGRPPlus as SB_C9,b.HousingFundEMPPlus as SB_07,c.UnemployInsEMPPlus as SB_09,
c.MedicalInsGRPPlus as SB_C10,c.UnemployInsGRPPlus as SB_C11,c.MedicalInsEMPPlus as SB_10,c.MaternityInsGRPPlus as SB_C12,c.InjuryInsGRPPlus as SB_C13
from eEmployee a
left join pEMPHousingFundPerMM_all b on a.EID=b.EID
left join pEMPInsurancePerMM_all c on a.EID=c.EID
left join OPENQUERY(HRLINK, 'SELECT emp_code,emp_id,chn_name FROM DBO.EMP_INFO_MASTER') d on d.emp_code=a.HRLID COLLATE Latin1_General_CI_AI
inner join pEmployeeEmolu f on a.EID=f.EID
inner join pEMPInsurance g on a.EID=g.EID
inner join pEMPHousingFund h on a.EID=h.EID
where a.status not in (4,5) and b.Month=c.Month