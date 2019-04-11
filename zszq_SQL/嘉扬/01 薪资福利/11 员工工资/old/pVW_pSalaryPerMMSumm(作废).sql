-- pVW_pSalaryPerMMSumm
select RANK() OVER(Order by DepxOrder) as No,*
from (select a.DepID,EMPType,Year(date) as Year,b.xOrder as DepxOrder,a.xOrder,EMPNum,EMPSalary,EMPPerf,EMPWelfare,EMPPerfLY,EMPSummTotal,
SubString('JanEMPNumFebEMPNumMarEMPNumAprEMPNumMayEMPNumJunEMPNumJulEMPNumAugEMPNumSepEMPNumOctEMPNumNovEMPNumDecEMPNum',Month(Date)*9-8,9) as EMPNummonths,
SubString('JanEMPSalaryFebEMPSalaryMarEMPSalaryAprEMPSalaryMayEMPSalaryJunEMPSalaryJulEMPSalaryAugEMPSalarySepEMPSalaryOctEMPSalaryNovEMPSalaryDecEMPSalary',Month(Date)*9-8,9) as EMPSalarymonths,
SubString('JanEMPPerfFebEMPPerfMarEMPPerfAprEMPPerfMayEMPPerfJunEMPPerfJulEMPPerfAugEMPPerfSepEMPPerfOctEMPPerfNovEMPPerfDecEMPPerf',Month(Date)*9-8,9) as EMPPerfmonths,
SubString('JanEMPWelfareFebEMPWelfareMarEMPWelfareAprEMPWelfareMayEMPWelfareJunEMPWelfareJulEMPWelfareAugEMPWelfareSepEMPWelfareOctEMPWelfareNovEMPWelfareDecEMPWelfare',Month(Date)*9-8,9) as EMPWelfaremonths,
SubString('JanEMPPerfLYFebEMPPerfLYMarEMPPerfLYAprEMPPerfLYMayEMPPerfLYJunEMPPerfLYJulEMPPerfLYAugEMPPerfLYSepEMPPerfLYOctEMPPerfLYNovEMPPerfLYDecEMPPerfLY',Month(Date)*9-8,9) as EMPPerfLYmonths,
SubString('JanEMPSummTotalFebEMPSummTotalMarEMPSummTotalAprEMPSummTotalMayEMPSummTotalJunEMPSummTotalJulEMPSummTotalAugEMPSummTotalSepEMPSummTotalOctEMPSummTotalNovEMPSummTotalDecEMPSummTotal',Month(Date)*9-8,9) as EMPSummTotalmonths
from pSalaryPerMMSumm_all a,oDepartment b where a.DepID=b.DepID) as ord
pivot(SUM(EMPNum) for EMPNummonths in ([JanEMPNum],[FebEMPNum],[MarEMPNum],[AprEMPNum],[MayEMPNum],[JunEMPNum],[JulEMPNum],[AugEMPNum],[SepEMPNum],[OctEMPNum],[NovEMPNum],[DecEMPNum])) as p1
pivot(SUM(EMPSalary) for EMPSalarymonths in ([JanEMPSalary],[FebEMPSalary],[MarEMPSalary],[AprEMPSalary],[MayEMPSalary],[JunEMPSalary],[JulEMPSalary],[AugEMPSalary],[SepEMPSalary],[OctEMPSalary],[NovEMPSalary],[DecEMPSalary])) as p2
pivot(SUM(EMPPerf) for EMPPerfmonths in ([JanEMPPerf],[FebEMPPerf],[MarEMPPerf],[AprEMPPerf],[MayEMPPerf],[JunEMPPerf],[JulEMPPerf],[AugEMPPerf],[SepEMPPerf],[OctEMPPerf],[NovEMPPerf],[DecEMPPerf])) as p3
pivot(SUM(EMPWelfare) for EMPWelfaremonths in ([JanEMPWelfare],[FebEMPWelfare],[MarEMPWelfare],[AprEMPWelfare],[MayEMPWelfare],[JunEMPWelfare],[JulEMPWelfare],[AugEMPWelfare],[SepEMPWelfare],[OctEMPWelfare],[NovEMPWelfare],[DecEMPWelfare])) as p4
pivot(SUM(EMPPerfLY) for EMPPerfLYmonths in ([JanEMPPerfLY],[FebEMPPerfLY],[MarEMPPerfLY],[AprEMPPerfLY],[MayEMPPerfLY],[JunEMPPerfLY],[JulEMPPerfLY],[AugEMPPerfLY],[SepEMPPerfLY],[OctEMPPerfLY],[NovEMPPerfLY],[DecEMPPerfLY])) as p5
pivot(SUM(EMPSummTotal) for EMPSummTotalmonths in ([JanEMPSummTotal],[FebEMPSummTotal],[MarEMPSummTotal],[AprEMPSummTotal],[MayEMPSummTotal],[JunEMPSummTotal],[JulEMPSummTotal],[AugEMPSummTotal],[SepEMPSummTotal],[OctEMPSummTotal],[NovEMPSummTotal],[DecEMPSummTotal])) as p6
