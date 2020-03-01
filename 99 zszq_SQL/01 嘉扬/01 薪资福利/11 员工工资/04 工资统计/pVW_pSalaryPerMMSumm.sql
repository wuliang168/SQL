-- pVW_pSalaryPerMMSumm

select a.Date as Date,a.PerMMSummType as PerMMSummType,a.EMPType as EMPType,SUM(a.EMPNum) as EMPNumSumm,SUM(a.EMPSalary) as EMPSalarySumm,
SUM(a.EMPPerf) as EMPPerfSumm,SUM(a.EMPWelfare) as EMPWelfareSumm,SUM(a.EMPSummTotal) as EMPSummTotalSumm,a.xOrder as xOrder
from pSalaryPerMMSumm_register a
where a.PerMMSummType=1
group by a.Date,a.PerMMSummType,a.EMPType,a.xOrder

UNION ALL
select b.Date as Date,b.PerMMSummType as PerMMSummType,b.EMPType as EMPType,SUM(b.EMPNum) as EMPNumSumm,SUM(b.EMPSalary) as EMPSalarySumm,
SUM(b.EMPPerf) as EMPPerfSumm,SUM(b.EMPWelfare) as EMPWelfareSumm,SUM(b.EMPSummTotal) as EMPSummTotalSumm,b.xOrder as xOrder
from pSalaryPerMMSumm_all b,pSalaryPerMMSumm_register a
where b.PerMMSummType=2 and DATEDIFF(MM,a.Date,b.Date)=0 and a.DepID=b.DepID
group by b.Date,b.PerMMSummType,b.EMPType,b.xOrder