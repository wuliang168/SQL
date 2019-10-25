-- pVW_EMPInsuranceDetails

-- 社保
SELECT a.EID as EID,a.BID as BID,c.Badge as Badge,c.Name,b.SalaryPayID as SalaryPayID,c.Status as Status,
c.CompID,c.DepID1st as Dep1st,c.DepID2nd as Dep2nd,c.JobTitle as JobTitle,c.JobxOrder as JobxOrder,
a.EMPInsuranceLoc as EMPInsuranceLoc,a.InsRatioLocID as EMPInsRatioLocID,a.EMPInsuranceDepart as EMPInsuranceDepart,
---- 1-四舍五入进分;2-四舍五入进角;3-四舍五入进元;4-里进分;5-分进角;6-分角进元;7-取整到分;8-取整到角;9-取整到元
------ 养老保险(个人)
(Case 
when ISNULL(a.IsPostRetirement,0)=1 or ISNULL(a.IsLeave,0)=1 or ISNULL(a.Isabandon,0)=1 then NULL
when ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0 then 
(Case
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=1 Then ROUND(ISNULL(ISNULL(a.EMPEndowBaseEmp,a.EMPEndowBase),a.EMPInsuranceBase)*d.EndowInsRatioEMP,2)
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=2 Then ROUND(ISNULL(ISNULL(a.EMPEndowBaseEmp,a.EMPEndowBase),a.EMPInsuranceBase)*d.EndowInsRatioEMP,1)
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=3 Then ROUND(ISNULL(ISNULL(a.EMPEndowBaseEmp,a.EMPEndowBase),a.EMPInsuranceBase)*d.EndowInsRatioEMP,0)
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=4 Then CEILING(ISNULL(ISNULL(a.EMPEndowBaseEmp,a.EMPEndowBase),a.EMPInsuranceBase)*d.EndowInsRatioEMP*100)/100
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=5 Then CEILING(FLOOR(ISNULL(ISNULL(a.EMPEndowBaseEmp,a.EMPEndowBase),a.EMPInsuranceBase)*d.EndowInsRatioEMP*100)/10)/10
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=6 Then CEILING(ISNULL(ISNULL(a.EMPEndowBaseEmp,a.EMPEndowBase),a.EMPInsuranceBase)*d.EndowInsRatioEMP)
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=7 Then FLOOR(ISNULL(ISNULL(a.EMPEndowBaseEmp,a.EMPEndowBase),a.EMPInsuranceBase)*d.EndowInsRatioEMP*100)/100
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=8 Then FLOOR(ISNULL(ISNULL(a.EMPEndowBaseEmp,a.EMPEndowBase),a.EMPInsuranceBase)*d.EndowInsRatioEMP*10)/10
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=9 Then FLOOR(ISNULL(ISNULL(a.EMPEndowBaseEmp,a.EMPEndowBase),a.EMPInsuranceBase)*d.EndowInsRatioEMP)
end )
end )
as EndowInsEMP,
------ 医疗保险(个人)
(Case 
when ISNULL(a.IsPostRetirement,0)=1 or ISNULL(a.IsLeave,0)=1 or ISNULL(a.Isabandon,0)=1 then NULL
when ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0 then 
(Case 
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=1 Then ROUND(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioEMP,2)
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=2 Then ROUND(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioEMP,1)
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=3 Then ROUND(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioEMP,0)
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=4 Then CEILING(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioEMP*100)/100
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=5 Then CEILING(FLOOR(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioEMP*100)/10)/10
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=6 Then CEILING(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioEMP)
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=7 Then FLOOR(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioEMP*100)/100
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=8 Then FLOOR(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioEMP*10)/10
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=9 Then FLOOR(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioEMP)
end )
end )
------ 医疗补助金额(个人)
+ 
(Case
when ISNULL(d.MedicalPlusInsType,0)=0 and ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0
Then ISNULL(ISNULL(d.MedicalPlusInsEMP,ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalPlusInsRatioEMP),0)
else 0
end )
as MedicalInsEMP,
------ 失业保险(个人)
(Case 
when ISNULL(a.IsPostRetirement,0)=1 or ISNULL(a.IsLeave,0)=1 or ISNULL(a.Isabandon,0)=1 then NULL
when ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0 then 
(Case 
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=1 Then ROUND(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioEMP,2)
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=2 Then ROUND(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioEMP,1)
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=3 Then ROUND(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioEMP,0)
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=4 Then CEILING(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioEMP*100)/100
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=5 Then CEILING(FLOOR(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioEMP*100)/10)/10
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=6 Then CEILING(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioEMP)
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=7 Then FLOOR(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioEMP*100)/100
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=8 Then FLOOR(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioEMP*10)/10
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=9 Then FLOOR(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioEMP)
end )
end )
as UnemployInsEMP,
------ 养老保险(企业)
(Case 
when ISNULL(a.IsPostRetirement,0)=1 or ISNULL(a.IsLeave,0)=1 or ISNULL(a.Isabandon,0)=1 then NULL
when ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0 then 
(Case 
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=1 Then ROUND(ISNULL(a.EMPEndowBase,a.EMPInsuranceBase)*d.EndowInsRatioGRP,2)
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=2 Then ROUND(ISNULL(a.EMPEndowBase,a.EMPInsuranceBase)*d.EndowInsRatioGRP,1)
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=3 Then ROUND(ISNULL(a.EMPEndowBase,a.EMPInsuranceBase)*d.EndowInsRatioGRP,0)
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=4 Then CEILING(ISNULL(a.EMPEndowBase,a.EMPInsuranceBase)*d.EndowInsRatioGRP*100)/100
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=5 Then CEILING(FLOOR(ISNULL(a.EMPEndowBase,a.EMPInsuranceBase)*d.EndowInsRatioGRP*100)/10)/10
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=6 Then CEILING(ISNULL(a.EMPEndowBase,a.EMPInsuranceBase)*d.EndowInsRatioGRP)
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=7 Then FLOOR(ISNULL(a.EMPEndowBase,a.EMPInsuranceBase)*d.EndowInsRatioGRP*100)/100
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=8 Then FLOOR(ISNULL(a.EMPEndowBase,a.EMPInsuranceBase)*d.EndowInsRatioGRP*10)/10
when ISNULL(d.EndowInsCalcMethod,d.CalcMethod)=9 Then FLOOR(ISNULL(a.EMPEndowBase,a.EMPInsuranceBase)*d.EndowInsRatioGRP)
end ) 
end )
as EndowInsGRP,
------ 医疗保险(企业)
(Case 
when ISNULL(a.IsPostRetirement,0)=1 or ISNULL(a.IsLeave,0)=1 or ISNULL(a.Isabandon,0)=1 then NULL
when ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0 then 
(Case 
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=1 Then ROUND(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioGRP,2)
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=2 Then ROUND(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioGRP,1)
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=3 Then ROUND(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioGRP,0)
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=4 Then CEILING(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioGRP*100)/100
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=5 Then CEILING(FLOOR(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioGRP*100)/10)/10
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=6 Then CEILING(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioGRP)
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=7 Then FLOOR(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioGRP*100)/100
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=8 Then FLOOR(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioGRP*10)/10
when ISNULL(d.MedicalInsCalcMethod,d.CalcMethod)=9 Then FLOOR(ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalInsRatioGRP)
end ) 
end )
------ 医疗补助金额(公司)
+ 
(Case
when ISNULL(d.MedicalPlusInsType,0)=0 and ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0
Then ISNULL(ISNULL(d.MedicalPlusInsGRP,ISNULL(a.EMPMedicalBase,a.EMPInsuranceBase)*d.MedicalPlusInsRatioGRP),0)
else 0
end )
as MedicalInsGRP,
------ 失业保险(企业)
(Case 
when ISNULL(a.IsPostRetirement,0)=1 or ISNULL(a.IsLeave,0)=1 or ISNULL(a.Isabandon,0)=1 then NULL
when ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0 then 
(Case 
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=1 Then ROUND(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioGRP,2)
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=2 Then ROUND(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioGRP,1)
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=3 Then ROUND(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioGRP,0)
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=4 Then CEILING(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioGRP*100)/100
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=5 Then CEILING(FLOOR(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioGRP*100)/10)/10
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=6 Then CEILING(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioGRP)
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=7 Then FLOOR(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioGRP*100)/100
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=8 Then FLOOR(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioGRP*10)/10
when ISNULL(d.UnemployInsCalcMethod,d.CalcMethod)=9 Then FLOOR(ISNULL(a.EMPUnemployBase,a.EMPInsuranceBase)*d.UnemployInsRatioGRP)
end ) 
end )
as UnemployInsGRP,
------ 生育保险(企业)
(Case 
when ISNULL(a.IsPostRetirement,0)=1 or ISNULL(a.IsLeave,0)=1 or ISNULL(a.Isabandon,0)=1 then NULL
when ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0 then 
(Case 
when ISNULL(d.MaternityInsCalcMethod,d.CalcMethod)=1 Then ROUND(ISNULL(a.EMPMaternityBase,a.EMPInsuranceBase)*d.MaternityInsRatioGRP,2)
when ISNULL(d.MaternityInsCalcMethod,d.CalcMethod)=2 Then ROUND(ISNULL(a.EMPMaternityBase,a.EMPInsuranceBase)*d.MaternityInsRatioGRP,1)
when ISNULL(d.MaternityInsCalcMethod,d.CalcMethod)=3 Then ROUND(ISNULL(a.EMPMaternityBase,a.EMPInsuranceBase)*d.MaternityInsRatioGRP,0)
when ISNULL(d.MaternityInsCalcMethod,d.CalcMethod)=4 Then CEILING(ISNULL(a.EMPMaternityBase,a.EMPInsuranceBase)*d.MaternityInsRatioGRP*100)/100
when ISNULL(d.MaternityInsCalcMethod,d.CalcMethod)=5 Then CEILING(FLOOR(ISNULL(a.EMPMaternityBase,a.EMPInsuranceBase)*d.MaternityInsRatioGRP*100)/10)/10
when ISNULL(d.MaternityInsCalcMethod,d.CalcMethod)=6 Then CEILING(ISNULL(a.EMPMaternityBase,a.EMPInsuranceBase)*d.MaternityInsRatioGRP)
when ISNULL(d.MaternityInsCalcMethod,d.CalcMethod)=7 Then FLOOR(ISNULL(a.EMPMaternityBase,a.EMPInsuranceBase)*d.MaternityInsRatioGRP*100)/100
when ISNULL(d.MaternityInsCalcMethod,d.CalcMethod)=8 Then FLOOR(ISNULL(a.EMPMaternityBase,a.EMPInsuranceBase)*d.MaternityInsRatioGRP*10)/10
when ISNULL(d.MaternityInsCalcMethod,d.CalcMethod)=9 Then FLOOR(ISNULL(a.EMPMaternityBase,a.EMPInsuranceBase)*d.MaternityInsRatioGRP)
end ) 
end )
as MaternityInsGRP,
------ 工伤保险(企业)
(Case 
when ISNULL(a.IsPostRetirement,0)=1 or ISNULL(a.IsLeave,0)=1 or ISNULL(a.Isabandon,0)=1 then NULL
when ISNULL(a.IsPostRetirement,0)=0 and ISNULL(a.IsLeave,0)=0 and ISNULL(a.Isabandon,0)=0 then 
(Case 
when ISNULL(d.InjuryInsCalcMethod,d.CalcMethod)=1 Then ROUND(ISNULL(a.EMPInjuryBase,a.EMPInsuranceBase)*d.InjuryInsRatioGRP,2)
when ISNULL(d.InjuryInsCalcMethod,d.CalcMethod)=2 Then ROUND(ISNULL(a.EMPInjuryBase,a.EMPInsuranceBase)*d.InjuryInsRatioGRP,1)
when ISNULL(d.InjuryInsCalcMethod,d.CalcMethod)=3 Then ROUND(ISNULL(a.EMPInjuryBase,a.EMPInsuranceBase)*d.InjuryInsRatioGRP,0)
when ISNULL(d.InjuryInsCalcMethod,d.CalcMethod)=4 Then CEILING(ISNULL(a.EMPInjuryBase,a.EMPInsuranceBase)*d.InjuryInsRatioGRP*100)/100
when ISNULL(d.InjuryInsCalcMethod,d.CalcMethod)=5 Then CEILING(FLOOR(ISNULL(a.EMPInjuryBase,a.EMPInsuranceBase)*d.InjuryInsRatioGRP*100)/10)/10
when ISNULL(d.InjuryInsCalcMethod,d.CalcMethod)=6 Then CEILING(ISNULL(a.EMPInjuryBase,a.EMPInsuranceBase)*d.InjuryInsRatioGRP)
when ISNULL(d.InjuryInsCalcMethod,d.CalcMethod)=7 Then FLOOR(ISNULL(a.EMPInjuryBase,a.EMPInsuranceBase)*d.InjuryInsRatioGRP*100)/100
when ISNULL(d.InjuryInsCalcMethod,d.CalcMethod)=8 Then FLOOR(ISNULL(a.EMPInjuryBase,a.EMPInsuranceBase)*d.InjuryInsRatioGRP*10)/10
when ISNULL(d.InjuryInsCalcMethod,d.CalcMethod)=9 Then FLOOR(ISNULL(a.EMPInjuryBase,a.EMPInsuranceBase)*d.InjuryInsRatioGRP)
end ) 
end )
as InjuryInsGRP
from pEMPInsurance a
left join pEMPSalary b on ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID)
left join pVW_Employee c on ISNULL(a.EID,a.BID)=ISNULL(c.EID,c.BID)
left join oCD_InsuranceRatioLoc d on a.InsRatioLocID=d.ID and ISNULL(d.IsDisabled,0)=0