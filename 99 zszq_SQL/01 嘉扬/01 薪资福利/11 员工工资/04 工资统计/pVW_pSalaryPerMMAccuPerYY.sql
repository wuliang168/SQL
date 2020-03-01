-- pVW_pSalaryPerMMAccuPerYY

select YEAR(a.Date) as Date,a.DepID,a.PerMMSummType as PerMMSummType,a.EMPType as EMPType,a.xOrder as xOrder,
convert(int,ISNULL(SUM(a.EMPNum),0)+ISNULL(SUM(b.EMPNum),0)) as EMPNumSumm,ISNULL(SUM(a.EMPSalary),0)+ISNULL(SUM(b.EMPSalary),0) as EMPSalarySumm,
ISNULL(SUM(a.EMPPerf),0)+ISNULL(SUM(b.EMPPerf),0) as EMPPerfSumm,ISNULL(SUM(a.EMPWelfare),0)+ISNULL(SUM(b.EMPWelfare),0) as EMPWelfareSumm,
ISNULL(SUM(a.EMPSummTotal),0)+ISNULL(SUM(b.EMPSummTotal),0) as EMPSummTotalSumm
from pSalaryPerMMSumm_all a
left join pSalaryPerMMSumm_register b on DATEDIFF(YY,a.Date,b.Date)=0 and a.DepID=b.DepID and a.PerMMSummType=b.PerMMSummType and a.EMPType=b.EMPType
where a.PerMMSummType=1
group by YEAR(a.Date),a.DepID,a.PerMMSummType,a.EMPType,a.xOrder