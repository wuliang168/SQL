-- pVW_EMPInsHousingFundDetails
---- 浙江省直房改公积金+杭州市社会保障
SELECT a.EID as EID,a.Badge as Badge,a.Name,b.SalaryPayID as SalaryPayID,a.Status as Status,
a.CompID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,a.JobID as JobID,(select xOrder from oJob where JobID=a.JobID) as JobxOrder,
c.EMPInsuranceBase as EMPInsuranceBase,c.EMPInsuranceLoc as EMPInsuranceLoc,c.EMPInsuranceDepart as EMPInsuranceDepart,
d.EMPHousingFundBase as EMPHousingFundBase,d.EMPHousingFundLoc as EMPHousingFundLoc,d.EMPHousingFundDepart as EMPHousingFundDepart
from eEmployee a,pEmployeeEmolu b,pEMPInsurance c,pEMPHousingFund d
where a.EID=b.EID and a.EID=c.EID and a.EID=d.EID

---- 浙江省直房改公积金+杭州市社会保障
SELECT a.EID as EID,a.Badge as Badge,a.Name,b.SalaryPayID as SalaryPayID,a.Status as Status,
a.CompID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,a.JobID as JobID,(select xOrder from oJob where JobID=a.JobID) as JobxOrder,
c.EMPInsuranceBase as EMPInsuranceBase,c.EMPInsuranceLoc as EMPInsuranceLoc,c.EMPInsuranceDepart as EMPInsuranceDepart,
d.EMPHousingFundBase as EMPHousingFundBase,d.EMPHousingFundLoc as EMPHousingFundLoc,d.EMPHousingFundDepart as EMPHousingFundDepart
from eEmployee a,pEmployeeEmolu b,pEMPInsurance c,pEMPHousingFund d
where a.EID=b.EID and a.EID=c.EID and a.EID=d.EID