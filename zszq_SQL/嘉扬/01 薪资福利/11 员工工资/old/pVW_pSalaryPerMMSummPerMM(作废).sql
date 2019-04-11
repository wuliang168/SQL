-- pVW_pSalaryPerMMSummPerMM
---- xOrder 1,2,3
select Date,DepID,SalaryContact,EMPType,EMPNum,EMPSalary,EMPPerf,EMPWelfare,EMPPerfLY,EMPSUMMTotal,xOrder
from pSalaryPerMMSumm_register
where xOrder in (1,2,3)
---- xOrder 4
UNION
select Date,a.DepID,SalaryContact,EMPType,
(select SUM(EMPNum) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID) as EMPNum,
(select SUM(EMPSalary) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID) as EMPSalary,
(select SUM(EMPPerf) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID) as EMPPerf,
(select SUM(EMPWelfare) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID) as EMPWelfare,
(select SUM(EMPPerfLY) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID) as EMPPerfLY,
(select SUM(EMPSUMMTotal) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID) as EMPSUMMTotal,
xOrder
from pSalaryPerMMSumm_register a
where xOrder in (4)