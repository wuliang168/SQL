-- pVW_pSalaryPerMMNXSumm

select a.Date as Date,a.DepID,a.PerMMSummType as PerMMSummType,SUM(a.EMPNum) as EMPNumSumm,SUM(a.EMPSalary) as EMPSalarySumm,
SUM(a.EMPPerf) as EMPPerfSumm,SUM(a.EMPWelfare) as EMPWelfareSumm,SUM(a.EMPSummTotal) as EMPSummTotalSumm
from pSalaryPerMMSumm_register a
where a.PerMMSummType=2
group by a.Date,a.DepID,a.PerMMSummType