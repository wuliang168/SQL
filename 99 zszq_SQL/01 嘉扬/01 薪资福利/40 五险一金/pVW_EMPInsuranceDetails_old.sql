-- pVW_EMPInsuranceDetails
-- 社保
SELECT a.EID as EID,a.Badge as Badge,a.Name,b.SalaryPayID as SalaryPayID,a.Status as Status,
a.CompID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,a.JobID as JobID,(select xOrder from oJob where JobID=a.JobID) as JobxOrder,
c.EMPInsuranceLoc as EMPInsuranceLoc,c.EMPInsuranceDepart as EMPInsuranceDepart,
---- 1-四舍五入进分;2-四舍五入进角;3-四舍五入进元;4-里进分;5-分进角;6-分角进元;7-取整到分;8-取整到角;9-取整到元
------ 养老保险(个人)
(Case 
when d.CalcMethod=1 Then ROUND(c.EMPInsuranceBase*d.EndowInsRatioEMP,2)
when d.CalcMethod=2 Then ROUND(c.EMPInsuranceBase*d.EndowInsRatioEMP,1)
when d.CalcMethod=3 Then ROUND(c.EMPInsuranceBase*d.EndowInsRatioEMP,0)
when d.CalcMethod=4 Then CEILING(c.EMPInsuranceBase*d.EndowInsRatioEMP*100)/100
when d.CalcMethod=5 Then CEILING(c.EMPInsuranceBase*d.EndowInsRatioEMP*10)/10
when d.CalcMethod=6 Then CEILING(c.EMPInsuranceBase*d.EndowInsRatioEMP)
when d.CalcMethod=7 Then FLOOR(c.EMPInsuranceBase*d.EndowInsRatioEMP*100)/100
when d.CalcMethod=8 Then FLOOR(c.EMPInsuranceBase*d.EndowInsRatioEMP*10)/10
when d.CalcMethod=9 Then FLOOR(c.EMPInsuranceBase*d.EndowInsRatioEMP)
-------- 广州社保(养老保险基数为社保基数):
end ) as EndowInsEMP,
------ 医疗保险(个人)
(Case 
when d.CalcMethod=1 and c.EMPInsuranceLoc not in (686,1160) Then ROUND(c.EMPInsuranceBase*d.MedicalInsRatioEMP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc not in (686,1160) Then ROUND(c.EMPInsuranceBase*d.MedicalInsRatioEMP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc not in (686,1160) Then ROUND(c.EMPInsuranceBase*d.MedicalInsRatioEMP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc not in (686,1160) Then CEILING(c.EMPInsuranceBase*d.MedicalInsRatioEMP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc not in (686,1160) Then CEILING(c.EMPInsuranceBase*d.MedicalInsRatioEMP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc not in (686,1160) Then CEILING(c.EMPInsuranceBase*d.MedicalInsRatioEMP)
when d.CalcMethod=7 and c.EMPInsuranceLoc not in (686,1160) Then FLOOR(c.EMPInsuranceBase*d.MedicalInsRatioEMP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc not in (686,1160) Then FLOOR(c.EMPInsuranceBase*d.MedicalInsRatioEMP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc not in (686,1160) Then FLOOR(c.EMPInsuranceBase*d.MedicalInsRatioEMP)
-------- 长春社保(医疗保险基数为医保基数):686；嘉兴社保(医疗保险基数为医保基数):1160
when d.CalcMethod=1 and c.EMPInsuranceLoc in (686,1160) Then ROUND(c.EMPMedicalBase*d.MedicalInsRatioEMP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc in (686,1160) Then ROUND(c.EMPMedicalBase*d.MedicalInsRatioEMP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc in (686,1160) Then ROUND(c.EMPMedicalBase*d.MedicalInsRatioEMP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc in (686,1160) Then CEILING(c.EMPMedicalBase*d.MedicalInsRatioEMP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc in (686,1160) Then CEILING(c.EMPMedicalBase*d.MedicalInsRatioEMP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc in (686,1160) Then CEILING(c.EMPMedicalBase*d.MedicalInsRatioEMP)
when d.CalcMethod=7 and c.EMPInsuranceLoc in (686,1160) Then FLOOR(c.EMPMedicalBase*d.MedicalInsRatioEMP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc in (686,1160) Then FLOOR(c.EMPMedicalBase*d.MedicalInsRatioEMP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc in (686,1160) Then FLOOR(c.EMPMedicalBase*d.MedicalInsRatioEMP)
end ) 
------ 医疗补助金额(个人)
+ 
(Case
when ISNULL(d.MedicalPlusInsType,0)=0 Then ISNULL(ISNULL(d.MedicalPlusInsEMP,c.EMPInsuranceBase*d.MedicalPlusInsRatioEMP),0)
else 0
end )
as MedicalInsEMP,
------ 失业保险(个人)
(Case 
when d.CalcMethod=1 and c.EMPInsuranceLoc not in (2344) Then ROUND(c.EMPInsuranceBase*d.UnemployInsRatioEMP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc not in (2344) Then ROUND(c.EMPInsuranceBase*d.UnemployInsRatioEMP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc not in (2344) Then ROUND(c.EMPInsuranceBase*d.UnemployInsRatioEMP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc not in (2344) Then CEILING(c.EMPInsuranceBase*d.UnemployInsRatioEMP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc not in (2344) Then CEILING(c.EMPInsuranceBase*d.UnemployInsRatioEMP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc not in (2344) Then CEILING(c.EMPInsuranceBase*d.UnemployInsRatioEMP)
when d.CalcMethod=7 and c.EMPInsuranceLoc not in (2344) Then FLOOR(c.EMPInsuranceBase*d.UnemployInsRatioEMP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc not in (2344) Then FLOOR(c.EMPInsuranceBase*d.UnemployInsRatioEMP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc not in (2344) Then FLOOR(c.EMPInsuranceBase*d.UnemployInsRatioEMP)
-------- 深圳社保(失业保险基数为最低工资):2344
when d.CalcMethod=1 and c.EMPInsuranceLoc=2344 Then ROUND(d.SalaryLimitLoc*d.UnemployInsRatioEMP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc=2344 Then ROUND(d.SalaryLimitLoc*d.UnemployInsRatioEMP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc=2344 Then ROUND(d.SalaryLimitLoc*d.UnemployInsRatioEMP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc=2344 Then CEILING(d.SalaryLimitLoc*d.UnemployInsRatioEMP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc=2344 Then CEILING(d.SalaryLimitLoc*d.UnemployInsRatioEMP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc=2344 Then CEILING(d.SalaryLimitLoc*d.UnemployInsRatioEMP)
when d.CalcMethod=7 and c.EMPInsuranceLoc=2344 Then FLOOR(d.SalaryLimitLoc*d.UnemployInsRatioEMP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc=2344 Then FLOOR(d.SalaryLimitLoc*d.UnemployInsRatioEMP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc=2344 Then FLOOR(d.SalaryLimitLoc*d.UnemployInsRatioEMP)
end )
as UnemployInsEMP,
------ 养老保险(企业)
(Case 
when d.CalcMethod=1 Then ROUND(c.EMPInsuranceBase*d.EndowInsRatioGRP,2)
when d.CalcMethod=2 Then ROUND(c.EMPInsuranceBase*d.EndowInsRatioGRP,1)
when d.CalcMethod=3 Then ROUND(c.EMPInsuranceBase*d.EndowInsRatioGRP,0)
when d.CalcMethod=4 Then CEILING(c.EMPInsuranceBase*d.EndowInsRatioGRP*100)/100
when d.CalcMethod=5 Then CEILING(c.EMPInsuranceBase*d.EndowInsRatioGRP*10)/10
when d.CalcMethod=6 Then CEILING(c.EMPInsuranceBase*d.EndowInsRatioGRP)
when d.CalcMethod=7 Then FLOOR(c.EMPInsuranceBase*d.EndowInsRatioGRP*100)/100
when d.CalcMethod=8 Then FLOOR(c.EMPInsuranceBase*d.EndowInsRatioGRP*10)/10
when d.CalcMethod=9 Then FLOOR(c.EMPInsuranceBase*d.EndowInsRatioGRP)
end ) as EndowInsGRP,
------ 医疗保险(企业)
(Case 
when d.CalcMethod=1 and c.EMPInsuranceLoc not in (686,1160) Then ROUND(c.EMPInsuranceBase*d.MedicalInsRatioGRP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc not in (686,1160) Then ROUND(c.EMPInsuranceBase*d.MedicalInsRatioGRP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc not in (686,1160) Then ROUND(c.EMPInsuranceBase*d.MedicalInsRatioGRP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc not in (686,1160) Then CEILING(c.EMPInsuranceBase*d.MedicalInsRatioGRP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc not in (686,1160) Then CEILING(c.EMPInsuranceBase*d.MedicalInsRatioGRP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc not in (686,1160) Then CEILING(c.EMPInsuranceBase*d.MedicalInsRatioGRP)
when d.CalcMethod=7 and c.EMPInsuranceLoc not in (686,1160) Then FLOOR(c.EMPInsuranceBase*d.MedicalInsRatioGRP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc not in (686,1160) Then FLOOR(c.EMPInsuranceBase*d.MedicalInsRatioGRP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc not in (686,1160) Then FLOOR(c.EMPInsuranceBase*d.MedicalInsRatioGRP)
-------- 长春社保(医疗保险基数为医保基数):686;嘉兴社保(医疗保险基数为医保基数):1160
when d.CalcMethod=1 and c.EMPInsuranceLoc in (686,1160) Then ROUND(c.EMPMedicalBase*d.MedicalInsRatioGRP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc in (686,1160) Then ROUND(c.EMPMedicalBase*d.MedicalInsRatioGRP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc in (686,1160) Then ROUND(c.EMPMedicalBase*d.MedicalInsRatioGRP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc in (686,1160) Then CEILING(c.EMPMedicalBase*d.MedicalInsRatioGRP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc in (686,1160) Then CEILING(c.EMPMedicalBase*d.MedicalInsRatioGRP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc in (686,1160) Then CEILING(c.EMPMedicalBase*d.MedicalInsRatioGRP)
when d.CalcMethod=7 and c.EMPInsuranceLoc in (686,1160) Then FLOOR(c.EMPMedicalBase*d.MedicalInsRatioGRP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc in (686,1160) Then FLOOR(c.EMPMedicalBase*d.MedicalInsRatioGRP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc in (686,1160) Then FLOOR(c.EMPMedicalBase*d.MedicalInsRatioGRP)
end ) 
------ 医疗补助金额(公司)
+ 
(Case
when ISNULL(d.MedicalPlusInsType,0)=0 Then ISNULL(ISNULL(d.MedicalPlusInsGRP,c.EMPInsuranceBase*d.MedicalPlusInsRatioGRP),0)
else 0
end )
as MedicalInsGRP,
------ 失业保险(企业)
(Case 
when d.CalcMethod=1 and c.EMPInsuranceLoc not in (2344) Then ROUND(c.EMPInsuranceBase*d.UnemployInsRatioGRP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc not in (2344) Then ROUND(c.EMPInsuranceBase*d.UnemployInsRatioGRP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc not in (2344) Then ROUND(c.EMPInsuranceBase*d.UnemployInsRatioGRP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc not in (2344) Then CEILING(c.EMPInsuranceBase*d.UnemployInsRatioGRP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc not in (2344) Then CEILING(c.EMPInsuranceBase*d.UnemployInsRatioGRP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc not in (2344) Then CEILING(c.EMPInsuranceBase*d.UnemployInsRatioGRP)
when d.CalcMethod=7 and c.EMPInsuranceLoc not in (2344) Then FLOOR(c.EMPInsuranceBase*d.UnemployInsRatioGRP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc not in (2344) Then FLOOR(c.EMPInsuranceBase*d.UnemployInsRatioGRP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc not in (2344) Then FLOOR(c.EMPInsuranceBase*d.UnemployInsRatioGRP)
-------- 深圳社保(失业保险基数为最低工资):2344
when d.CalcMethod=1 and c.EMPInsuranceLoc=2344 Then ROUND(d.SalaryLimitLoc*d.UnemployInsRatioGRP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc=2344 Then ROUND(d.SalaryLimitLoc*d.UnemployInsRatioGRP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc=2344 Then ROUND(d.SalaryLimitLoc*d.UnemployInsRatioGRP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc=2344 Then CEILING(d.SalaryLimitLoc*d.UnemployInsRatioGRP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc=2344 Then CEILING(d.SalaryLimitLoc*d.UnemployInsRatioGRP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc=2344 Then CEILING(d.SalaryLimitLoc*d.UnemployInsRatioGRP)
when d.CalcMethod=7 and c.EMPInsuranceLoc=2344 Then FLOOR(d.SalaryLimitLoc*d.UnemployInsRatioGRP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc=2344 Then FLOOR(d.SalaryLimitLoc*d.UnemployInsRatioGRP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc=2344 Then FLOOR(d.SalaryLimitLoc*d.UnemployInsRatioGRP)
end ) as UnemployInsGRP,
------ 生育保险(企业)
(Case 
when d.CalcMethod=1 and c.EMPInsuranceLoc not in (686) Then ROUND(c.EMPInsuranceBase*d.MaternityInsRatioGRP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc not in (686) Then ROUND(c.EMPInsuranceBase*d.MaternityInsRatioGRP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc not in (686) Then ROUND(c.EMPInsuranceBase*d.MaternityInsRatioGRP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc not in (686) Then CEILING(c.EMPInsuranceBase*d.MaternityInsRatioGRP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc not in (686) Then CEILING(c.EMPInsuranceBase*d.MaternityInsRatioGRP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc not in (686) Then CEILING(c.EMPInsuranceBase*d.MaternityInsRatioGRP)
when d.CalcMethod=7 and c.EMPInsuranceLoc not in (686) Then FLOOR(c.EMPInsuranceBase*d.MaternityInsRatioGRP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc not in (686) Then FLOOR(c.EMPInsuranceBase*d.MaternityInsRatioGRP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc not in (686) Then FLOOR(c.EMPInsuranceBase*d.MaternityInsRatioGRP)
-------- 长春社保(医疗保险基数为医保基数):686
when d.CalcMethod=1 and c.EMPInsuranceLoc=686 Then ROUND(c.EMPMedicalBase*d.MaternityInsRatioGRP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc=686 Then ROUND(c.EMPMedicalBase*d.MaternityInsRatioGRP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc=686 Then ROUND(c.EMPMedicalBase*d.MaternityInsRatioGRP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc=686 Then CEILING(c.EMPMedicalBase*d.MaternityInsRatioGRP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc=686 Then CEILING(c.EMPMedicalBase*d.MaternityInsRatioGRP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc=686 Then CEILING(c.EMPMedicalBase*d.MaternityInsRatioGRP)
when d.CalcMethod=7 and c.EMPInsuranceLoc=686 Then FLOOR(c.EMPMedicalBase*d.MaternityInsRatioGRP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc=686 Then FLOOR(c.EMPMedicalBase*d.MaternityInsRatioGRP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc=686 Then FLOOR(c.EMPMedicalBase*d.MaternityInsRatioGRP)
end ) as MaternityInsGRP,
------ 工伤保险(企业)
(Case 
when d.CalcMethod=1 and c.EMPInsuranceLoc not in (686) Then ROUND(c.EMPInsuranceBase*d.InjuryInsRatioGRP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc not in (686) Then ROUND(c.EMPInsuranceBase*d.InjuryInsRatioGRP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc not in (686) Then ROUND(c.EMPInsuranceBase*d.InjuryInsRatioGRP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc not in (686) Then CEILING(c.EMPInsuranceBase*d.InjuryInsRatioGRP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc not in (686) Then CEILING(c.EMPInsuranceBase*d.InjuryInsRatioGRP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc not in (686) Then CEILING(c.EMPInsuranceBase*d.InjuryInsRatioGRP)
when d.CalcMethod=7 and c.EMPInsuranceLoc not in (686) Then FLOOR(c.EMPInsuranceBase*d.InjuryInsRatioGRP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc not in (686) Then FLOOR(c.EMPInsuranceBase*d.InjuryInsRatioGRP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc not in (686) Then FLOOR(c.EMPInsuranceBase*d.InjuryInsRatioGRP)
-------- 长春社保(医疗保险基数为医保基数):686
when d.CalcMethod=1 and c.EMPInsuranceLoc=686 Then ROUND(c.EMPMedicalBase*d.InjuryInsRatioGRP,2)
when d.CalcMethod=2 and c.EMPInsuranceLoc=686 Then ROUND(c.EMPMedicalBase*d.InjuryInsRatioGRP,1)
when d.CalcMethod=3 and c.EMPInsuranceLoc=686 Then ROUND(c.EMPMedicalBase*d.InjuryInsRatioGRP,0)
when d.CalcMethod=4 and c.EMPInsuranceLoc=686 Then CEILING(c.EMPMedicalBase*d.InjuryInsRatioGRP*100)/100
when d.CalcMethod=5 and c.EMPInsuranceLoc=686 Then CEILING(c.EMPMedicalBase*d.InjuryInsRatioGRP*10)/10
when d.CalcMethod=6 and c.EMPInsuranceLoc=686 Then CEILING(c.EMPMedicalBase*d.InjuryInsRatioGRP)
when d.CalcMethod=7 and c.EMPInsuranceLoc=686 Then FLOOR(c.EMPMedicalBase*d.InjuryInsRatioGRP*100)/100
when d.CalcMethod=8 and c.EMPInsuranceLoc=686 Then FLOOR(c.EMPMedicalBase*d.InjuryInsRatioGRP*10)/10
when d.CalcMethod=9 and c.EMPInsuranceLoc=686 Then FLOOR(c.EMPMedicalBase*d.InjuryInsRatioGRP)
end ) as InjuryInsGRP
from eEmployee a
inner join pEmployeeEmolu b on a.EID=b.EID 
inner join pEMPInsurance c on a.EID=c.EID
left join oCD_InsuranceRatioLoc d on c.EMPInsuranceLoc=d.Place and ISNULL(d.IsDisabled,0)=0