-- pVW_EMPInsHousingFundBase

SELECT a.EID as EID,a.BID as BID,a.Badge as Badge,a.Name,b.SalaryPayID as SalaryPayID,a.Status as Status,a.CompID as CompID,
a.DepID1st as Dep1st,a.DepID2nd as Dep2nd,a.JobTitle as JobTitle,a.JobxOrder as JobxOrder,
c.EMPInsuranceBase as EMPInsuranceBase,c.EMPInsuranceLoc as EMPInsuranceLoc,c.InsRatioLocID as EMPInsRatioLocID,c.EMPInsuranceDepart as EMPInsuranceDepart,
d.EMPHousingFundBase as EMPHousingFundBase,d.EMPHousingFundLoc as EMPHousingFundLoc,d.HFRatioLocID as EMPHFRatioLocID,d.EMPHousingFundDepart as EMPHousingFundDepart
from pVW_Employee a
inner join pEMPSalary b on ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID)
inner join pEMPInsurance c on ISNULL(a.EID,a.BID)=ISNULL(c.EID,c.BID)
inner join pEMPHousingFund d on ISNULL(a.EID,a.BID)=ISNULL(d.EID,d.BID)