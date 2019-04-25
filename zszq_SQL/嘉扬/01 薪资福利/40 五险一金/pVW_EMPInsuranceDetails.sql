-- pVW_EMPInsuranceDetails
-- 社保
SELECT a.EID as EID,a.Badge as Badge,a.Name,b.SalaryPayID as SalaryPayID,a.Status as Status,
a.CompID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,a.JobID as JobID,(select xOrder from oJob where JobID=a.JobID) as JobxOrder,
c.EMPInsuranceLoc as EMPInsuranceLoc,c.EMPInsuranceDepart as EMPInsuranceDepart,
---- 1-四舍五入进分;2-四舍五入进角;3-四舍五入进元;4-里进分;5-分进角;6-分角进元;7-取整到分;8-取整到角;9-取整到元
------ 养老保险(个人)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case
when d.CalcMethod=1 Then ROUND(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioEMP,2)
when d.CalcMethod=2 Then ROUND(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioEMP,1)
when d.CalcMethod=3 Then ROUND(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioEMP,0)
when d.CalcMethod=4 Then CEILING(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioEMP*100)/100
when d.CalcMethod=5 Then CEILING(FLOOR(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioEMP*100)/10)/10
when d.CalcMethod=6 Then CEILING(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioEMP)
when d.CalcMethod=7 Then FLOOR(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioEMP*100)/100
when d.CalcMethod=8 Then FLOOR(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioEMP*10)/10
when d.CalcMethod=9 Then FLOOR(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioEMP)
end )
end )
as EndowInsEMP,
------ 医疗保险(个人)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
when d.CalcMethod=1 Then ROUND(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioEMP,2)
when d.CalcMethod=2 Then ROUND(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioEMP,1)
when d.CalcMethod=3 Then ROUND(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioEMP,0)
when d.CalcMethod=4 Then CEILING(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioEMP*100)/100
when d.CalcMethod=5 Then CEILING(FLOOR(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioEMP*100)/10)/10
when d.CalcMethod=6 Then CEILING(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioEMP)
when d.CalcMethod=7 Then FLOOR(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioEMP*100)/100
when d.CalcMethod=8 Then FLOOR(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioEMP*10)/10
when d.CalcMethod=9 Then FLOOR(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioEMP)
end )
end )
------ 医疗补助金额(个人)
+ 
(Case
when ISNULL(d.MedicalPlusInsType,0)=0 and ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0
Then ISNULL(ISNULL(d.MedicalPlusInsEMP,ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalPlusInsRatioEMP),0)
else 0
end )
as MedicalInsEMP,
------ 失业保险(个人)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
when d.CalcMethod=1 Then ROUND(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioEMP,2)
when d.CalcMethod=2 Then ROUND(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioEMP,1)
when d.CalcMethod=3 Then ROUND(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioEMP,0)
when d.CalcMethod=4 Then CEILING(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioEMP*100)/100
when d.CalcMethod=5 Then CEILING(FLOOR(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioEMP*100)/10)/10
when d.CalcMethod=6 Then CEILING(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioEMP)
when d.CalcMethod=7 Then FLOOR(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioEMP*100)/100
when d.CalcMethod=8 Then FLOOR(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioEMP*10)/10
when d.CalcMethod=9 Then FLOOR(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioEMP)
end )
end )
as UnemployInsEMP,
------ 养老保险(企业)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
when d.CalcMethod=1 Then ROUND(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioGRP,2)
when d.CalcMethod=2 Then ROUND(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioGRP,1)
when d.CalcMethod=3 Then ROUND(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioGRP,0)
when d.CalcMethod=4 Then CEILING(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioGRP*100)/100
when d.CalcMethod=5 Then CEILING(FLOOR(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioGRP*100)/10)/10
when d.CalcMethod=6 Then CEILING(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioGRP)
when d.CalcMethod=7 Then FLOOR(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioGRP*100)/100
when d.CalcMethod=8 Then FLOOR(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioGRP*10)/10
when d.CalcMethod=9 Then FLOOR(ISNULL(c.EMPEndowBase,c.EMPInsuranceBase)*d.EndowInsRatioGRP)
end ) 
end )
as EndowInsGRP,
------ 医疗保险(企业)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
when d.CalcMethod=1 Then ROUND(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioGRP,2)
when d.CalcMethod=2 Then ROUND(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioGRP,1)
when d.CalcMethod=3 Then ROUND(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioGRP,0)
when d.CalcMethod=4 Then CEILING(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioGRP*100)/100
when d.CalcMethod=5 Then CEILING(FLOOR(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioGRP*100)/10)/10
when d.CalcMethod=6 Then CEILING(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioGRP)
when d.CalcMethod=7 Then FLOOR(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioGRP*100)/100
when d.CalcMethod=8 Then FLOOR(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioGRP*10)/10
when d.CalcMethod=9 Then FLOOR(ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalInsRatioGRP)
end ) 
end )
------ 医疗补助金额(公司)
+ 
(Case
when ISNULL(d.MedicalPlusInsType,0)=0 and ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0
Then ISNULL(ISNULL(d.MedicalPlusInsGRP,ISNULL(c.EMPMedicalBase,c.EMPInsuranceBase)*d.MedicalPlusInsRatioGRP),0)
else 0
end )
as MedicalInsGRP,
------ 失业保险(企业)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
when d.CalcMethod=1 Then ROUND(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioGRP,2)
when d.CalcMethod=2 Then ROUND(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioGRP,1)
when d.CalcMethod=3 Then ROUND(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioGRP,0)
when d.CalcMethod=4 Then CEILING(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioGRP*100)/100
when d.CalcMethod=5 Then CEILING(FLOOR(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioGRP*100)/10)/10
when d.CalcMethod=6 Then CEILING(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioGRP)
when d.CalcMethod=7 Then FLOOR(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioGRP*100)/100
when d.CalcMethod=8 Then FLOOR(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioGRP*10)/10
when d.CalcMethod=9 Then FLOOR(ISNULL(c.EMPUnemployBase,c.EMPInsuranceBase)*d.UnemployInsRatioGRP)
end ) 
end )
as UnemployInsGRP,
------ 生育保险(企业)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
when d.CalcMethod=1 Then ROUND(ISNULL(c.EMPMaternityBase,c.EMPInsuranceBase)*d.MaternityInsRatioGRP,2)
when d.CalcMethod=2 Then ROUND(ISNULL(c.EMPMaternityBase,c.EMPInsuranceBase)*d.MaternityInsRatioGRP,1)
when d.CalcMethod=3 Then ROUND(ISNULL(c.EMPMaternityBase,c.EMPInsuranceBase)*d.MaternityInsRatioGRP,0)
when d.CalcMethod=4 Then CEILING(ISNULL(c.EMPMaternityBase,c.EMPInsuranceBase)*d.MaternityInsRatioGRP*100)/100
when d.CalcMethod=5 Then CEILING(FLOOR(ISNULL(c.EMPMaternityBase,c.EMPInsuranceBase)*d.MaternityInsRatioGRP*100)/10)/10
when d.CalcMethod=6 Then CEILING(ISNULL(c.EMPMaternityBase,c.EMPInsuranceBase)*d.MaternityInsRatioGRP)
when d.CalcMethod=7 Then FLOOR(ISNULL(c.EMPMaternityBase,c.EMPInsuranceBase)*d.MaternityInsRatioGRP*100)/100
when d.CalcMethod=8 Then FLOOR(ISNULL(c.EMPMaternityBase,c.EMPInsuranceBase)*d.MaternityInsRatioGRP*10)/10
when d.CalcMethod=9 Then FLOOR(ISNULL(c.EMPMaternityBase,c.EMPInsuranceBase)*d.MaternityInsRatioGRP)
end ) 
end )
as MaternityInsGRP,
------ 工伤保险(企业)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
when d.CalcMethod=1 Then ROUND(ISNULL(c.EMPInjuryBase,c.EMPInsuranceBase)*d.InjuryInsRatioGRP,2)
when d.CalcMethod=2 Then ROUND(ISNULL(c.EMPInjuryBase,c.EMPInsuranceBase)*d.InjuryInsRatioGRP,1)
when d.CalcMethod=3 Then ROUND(ISNULL(c.EMPInjuryBase,c.EMPInsuranceBase)*d.InjuryInsRatioGRP,0)
when d.CalcMethod=4 Then CEILING(ISNULL(c.EMPInjuryBase,c.EMPInsuranceBase)*d.InjuryInsRatioGRP*100)/100
when d.CalcMethod=5 Then CEILING(FLOOR(ISNULL(c.EMPInjuryBase,c.EMPInsuranceBase)*d.InjuryInsRatioGRP*100)/10)/10
when d.CalcMethod=6 Then CEILING(ISNULL(c.EMPInjuryBase,c.EMPInsuranceBase)*d.InjuryInsRatioGRP)
when d.CalcMethod=7 Then FLOOR(ISNULL(c.EMPInjuryBase,c.EMPInsuranceBase)*d.InjuryInsRatioGRP*100)/100
when d.CalcMethod=8 Then FLOOR(ISNULL(c.EMPInjuryBase,c.EMPInsuranceBase)*d.InjuryInsRatioGRP*10)/10
when d.CalcMethod=9 Then FLOOR(ISNULL(c.EMPInjuryBase,c.EMPInsuranceBase)*d.InjuryInsRatioGRP)
end ) 
end )
as InjuryInsGRP
from eEmployee a
inner join pEmployeeEmolu b on a.EID=b.EID 
inner join pEMPInsurance c on a.EID=c.EID
left join oCD_InsuranceRatioLoc d on c.EMPInsuranceLoc=d.Place and ISNULL(d.IsDisabled,0)=0