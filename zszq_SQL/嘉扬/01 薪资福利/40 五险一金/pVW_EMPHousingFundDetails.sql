-- pVW_EMPHousingFundDetails
-- 公积金
SELECT a.EID as EID,a.Badge as Badge,a.Name,b.SalaryPayID as SalaryPayID,a.Status as Status,
a.CompID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,a.JobID as JobID,(select xOrder from oJob where JobID=a.JobID) as JobxOrder,
c.EMPHousingFundLoc as EMPHousingFundLoc,c.EMPHousingFundDepart as EMPHousingFundDepart,
---- 1-四舍五入进分;2-四舍五入进角;3-四舍五入进元;4-里进分;5-分进角;6-分角进元;7-取整到分;8-取整到角;9-取整到元
------ 公积金(个人)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
When d.CalcMethod=1 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioEMP,2)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0),2)
When d.CalcMethod=2 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioEMP,1)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0),1)
When d.CalcMethod=3 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioEMP,0)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0),0)
When d.CalcMethod=4 Then CEILING(c.EMPHousingFundBase*d.HousingFundRatioEMP*100)/100+CEILING(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0)*100)/100
When d.CalcMethod=5 Then CEILING(FLOOR(c.EMPHousingFundBase*d.HousingFundRatioEMP*100)/10)/10+CEILING(FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0)*100)/10)/10
When d.CalcMethod=6 Then CEILING(c.EMPHousingFundBase*d.HousingFundRatioEMP)+CEILING(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0))
When d.CalcMethod=7 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioEMP*100)/100+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0)*100)/100
When d.CalcMethod=8 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioEMP*10)/10+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0)*10)/10
When d.CalcMethod=9 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioEMP)+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0))
End ) 
End ) as HousingFundEMP,
------ 公积金(企业)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
When d.CalcMethod=1 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioGRP,2)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0),2)
When d.CalcMethod=2 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioGRP,1)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0),1)
When d.CalcMethod=3 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioGRP,0)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0),0)
When d.CalcMethod=4 Then CEILING(c.EMPHousingFundBase*d.HousingFundRatioGRP*100)/100+CEILING(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0)*100)/100
When d.CalcMethod=5 Then CEILING(FLOOR(c.EMPHousingFundBase*d.HousingFundRatioGRP*100)/10)/10+CEILING(FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0)*100)/10)/10
When d.CalcMethod=6 Then CEILING(c.EMPHousingFundBase*d.HousingFundRatioGRP)+CEILING(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0))
When d.CalcMethod=7 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioGRP*100)/100+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0)*100)/100
When d.CalcMethod=8 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioGRP*10)/10+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0)*10)/10
When d.CalcMethod=9 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioGRP)+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0))
End ) 
End ) as HousingFundGRP,
------ 公积金在当地，工资在杭州发放的存在公积金超额现象
-------- SalaryPayID为1,4,7表示总部、资管、资本；Place为1115,1117表示浙江省直公积金和杭州公积金
-------- 公积金超额(个人)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
When b.SalaryPayID in (1,4,7) and c.EMPHousingFundBase-(select HousingFundBaseUpLimit from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)<=0 Then NULL
when b.SalaryPayID in (1,4,7) and c.EMPHousingFundBase-(select HousingFundBaseUpLimit from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)>0 Then
(Case 
When d.CalcMethod=1 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioEMP,2)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0),2)-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioEMP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=2 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioEMP,1)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0),1)-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioEMP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=3 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioEMP,0)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0),0)-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioEMP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=4 Then CEILING(c.EMPHousingFundBase*d.HousingFundRatioEMP*100)/100+CEILING(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0)*100)/100-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioEMP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=5 Then CEILING(FLOOR(c.EMPHousingFundBase*d.HousingFundRatioEMP*100)/10)/10+CEILING(FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0)*100)/10)/10-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioEMP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=6 Then CEILING(c.EMPHousingFundBase*d.HousingFundRatioEMP)+CEILING(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0))-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioEMP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=7 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioEMP*100)/100+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0)*100)/100-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioEMP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=8 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioEMP*10)/10+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0)*10)/10-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioEMP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=9 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioEMP)+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusEMP,0))-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioEMP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
End )
End ) 
End ) as EMPHousingFundOverEMP,
-------- 公积金超额(公司)
(Case 
when ISNULL(c.IsPostRetirement,0)=1 or ISNULL(c.IsLeave,0)=1 or ISNULL(c.Isabandon,0)=1 then NULL
when ISNULL(c.IsPostRetirement,0)=0 and ISNULL(c.IsLeave,0)=0 and ISNULL(c.Isabandon,0)=0 then 
(Case 
When b.SalaryPayID in (1,4,7) and c.EMPHousingFundBase-(select HousingFundBaseUpLimit from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)<=0 Then NULL
when b.SalaryPayID in (1,4,7) and c.EMPHousingFundBase-(select HousingFundBaseUpLimit from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)>0 Then
(Case 
When d.CalcMethod=1 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioGRP,2)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0),2)-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioGRP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=2 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioGRP,1)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0),1)-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioGRP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=3 Then ROUND(c.EMPHousingFundBase*d.HousingFundRatioGRP,0)+ROUND(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0),0)-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioGRP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=4 Then CEILING(c.EMPHousingFundBase*d.HousingFundRatioGRP*100)/100+CEILING(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0)*100)/100-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioGRP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=5 Then CEILING(FLOOR(c.EMPHousingFundBase*d.HousingFundRatioGRP*100)/10)/10+CEILING(FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0)*100)/10)/10-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioGRP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=6 Then CEILING(c.EMPHousingFundBase*d.HousingFundRatioGRP)+CEILING(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0))-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioGRP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=7 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioGRP*100)/100+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0)*100)/100-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioGRP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=8 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioGRP*10)/10+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0)*10)/10-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioGRP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
When d.CalcMethod=9 Then FLOOR(c.EMPHousingFundBase*d.HousingFundRatioGRP)+FLOOR(c.EMPHousingFundBase*ISNULL(d.HousingFundRatioPlusGRP,0))-(select ROUND(HousingFundBaseUpLimit*HousingFundRatioGRP,0) from oCD_HousingFundRatioLoc where Place=1117 and ISNULL(IsDisabled,0)=0)
End )
End ) 
End ) as EMPHousingFundOverGRP
from eEmployee a
inner join pEmployeeEmolu b on a.EID=b.EID 
inner join pEMPHousingFund c on a.EID=c.EID
left join oCD_HousingFundRatioLoc d on c.EMPHousingFundLoc=d.Place and ISNULL(d.IsDisabled,0)=0