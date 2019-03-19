-- pVW_pSalaryPerMMSummPerYY
---- pSalaryPerMMSumm_register
select Year,DENSE_RANK() OVER(partition by Year Order by DepxOrder) as No,DepID,EMPType,xOrder,
[JanEMPNum],[JanEMPSalary],[JanEMPPerf],[JanEMPWelfare],[JanEMPPerfLY],[JanEMPSummTotal],
[FebEMPNum],[FebEMPSalary],[FebEMPPerf],[FebEMPWelfare],[FebEMPPerfLY],[FebEMPSummTotal],
[MarEMPNum],[MarEMPSalary],[MarEMPPerf],[MarEMPWelfare],[MarEMPPerfLY],[MarEMPSummTotal],
[AprEMPNum],[AprEMPSalary],[AprEMPPerf],[AprEMPWelfare],[AprEMPPerfLY],[AprEMPSummTotal],
[MayEMPNum],[MayEMPSalary],[MayEMPPerf],[MayEMPWelfare],[MayEMPPerfLY],[MayEMPSummTotal],
[JunEMPNum],[JunEMPSalary],[JunEMPPerf],[JunEMPWelfare],[JunEMPPerfLY],[JunEMPSummTotal],
[JulEMPNum],[JulEMPSalary],[JulEMPPerf],[JulEMPWelfare],[JulEMPPerfLY],[JulEMPSummTotal],
[AugEMPNum],[AugEMPSalary],[AugEMPPerf],[AugEMPWelfare],[AugEMPPerfLY],[AugEMPSummTotal],
[SepEMPNum],[SepEMPSalary],[SepEMPPerf],[SepEMPWelfare],[SepEMPPerfLY],[SepEMPSummTotal],
[OctEMPNum],[OctEMPSalary],[OctEMPPerf],[OctEMPWelfare],[OctEMPPerfLY],[OctEMPSummTotal],
[NovEMPNum],[NovEMPSalary],[NovEMPPerf],[NovEMPWelfare],[NovEMPPerfLY],[NovEMPSummTotal],
[DecEMPNum],[DecEMPSalary],[DecEMPPerf],[DecEMPWelfare],[DecEMPPerfLY],[DecEMPSummTotal],
(ISNULL([JanEMPNum],0)+ISNULL([FebEMPNum],0)+ISNULL([MarEMPNum],0)+ISNULL([AprEMPNum],0)+ISNULL([MayEMPNum],0)+ISNULL([JunEMPNum],0)
+ISNULL([JulEMPNum],0)+ISNULL([AugEMPNum],0)+ISNULL([SepEMPNum],0)+ISNULL([OctEMPNum],0)+ISNULL([NovEMPNum],0)+ISNULL([DecEMPNum],0)) as YearEMPNum,
(ISNULL([JanEMPSalary],0)+ISNULL([FebEMPSalary],0)+ISNULL([MarEMPSalary],0)+ISNULL([AprEMPSalary],0)+ISNULL([MayEMPSalary],0)+ISNULL([JunEMPSalary],0)
+ISNULL([JulEMPSalary],0)+ISNULL([AugEMPSalary],0)+ISNULL([SepEMPSalary],0)+ISNULL([OctEMPSalary],0)+ISNULL([NovEMPSalary],0)+ISNULL([DecEMPSalary],0)) as YearEMPSalary,
(ISNULL([JanEMPPerf],0)+ISNULL([FebEMPPerf],0)+ISNULL([MarEMPPerf],0)+ISNULL([AprEMPPerf],0)+ISNULL([MayEMPPerf],0)+ISNULL([JunEMPPerf],0)
+ISNULL([JulEMPPerf],0)+ISNULL([AugEMPPerf],0)+ISNULL([SepEMPPerf],0)+ISNULL([OctEMPPerf],0)+ISNULL([NovEMPPerf],0)+ISNULL([DecEMPPerf],0)) as YearEMPPerf,
(ISNULL([JanEMPWelfare],0)+ISNULL([FebEMPWelfare],0)+ISNULL([MarEMPWelfare],0)+ISNULL([AprEMPWelfare],0)+ISNULL([MayEMPWelfare],0)+ISNULL([JunEMPWelfare],0)
+ISNULL([JulEMPWelfare],0)+ISNULL([AugEMPWelfare],0)+ISNULL([SepEMPWelfare],0)+ISNULL([OctEMPWelfare],0)+ISNULL([NovEMPWelfare],0)+ISNULL([DecEMPWelfare],0)) as YearEMPWelfare,
(ISNULL([JanEMPPerfLY],0)+ISNULL([FebEMPPerfLY],0)+ISNULL([MarEMPPerfLY],0)+ISNULL([AprEMPPerfLY],0)+ISNULL([MayEMPPerfLY],0)+ISNULL([JunEMPPerfLY],0)
+ISNULL([JulEMPPerfLY],0)+ISNULL([AugEMPPerfLY],0)+ISNULL([SepEMPPerfLY],0)+ISNULL([OctEMPPerfLY],0)+ISNULL([NovEMPPerfLY],0)+ISNULL([DecEMPPerfLY],0)) as YearEMPPerfLY,
(ISNULL([JanEMPSummTotal],0)+ISNULL([FebEMPSummTotal],0)+ISNULL([MarEMPSummTotal],0)+ISNULL([AprEMPSummTotal],0)+ISNULL([MayEMPSummTotal],0)+ISNULL([JunEMPSummTotal],0)
+ISNULL([JulEMPSummTotal],0)+ISNULL([AugEMPSummTotal],0)+ISNULL([SepEMPSummTotal],0)+ISNULL([OctEMPSummTotal],0)+ISNULL([NovEMPSummTotal],0)+ISNULL([DecEMPSummTotal],0)) as YearEMPSummTotal
from
(select DepID,EMPType,Year,DepxOrder,xOrder,SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month*3-2,3)+c 'c',v
from
(select a.DepID,EMPType,Year(date) as Year,MONTH(date) as Month,b.xOrder as DepxOrder,a.xOrder,
sum(EMPNum) 'EMPNum',sum(EMPSalary) 'EMPSalary',sum(EMPPerf) 'EMPPerf',sum(EMPWelfare) 'EMPWelfare',sum(EMPPerfLY) 'EMPPerfLY',sum(EMPSummTotal) 'EMPSummTotal'
from pSalaryPerMMSumm_register a,oDepartment b where a.DepID=b.DepID
group by a.DepID,EMPType,Year(date),MONTH(date),b.xOrder,a.xOrder) a
unpivot(v for c in([EMPNum],[EMPSalary],[EMPPerf],[EMPWelfare],[EMPPerfLY],[EMPSummTotal])) u) b
pivot(max(v) for c in(
[JanEMPNum],[JanEMPSalary],[JanEMPPerf],[JanEMPWelfare],[JanEMPPerfLY],[JanEMPSummTotal],
[FebEMPNum],[FebEMPSalary],[FebEMPPerf],[FebEMPWelfare],[FebEMPPerfLY],[FebEMPSummTotal],
[MarEMPNum],[MarEMPSalary],[MarEMPPerf],[MarEMPWelfare],[MarEMPPerfLY],[MarEMPSummTotal],
[AprEMPNum],[AprEMPSalary],[AprEMPPerf],[AprEMPWelfare],[AprEMPPerfLY],[AprEMPSummTotal],
[MayEMPNum],[MayEMPSalary],[MayEMPPerf],[MayEMPWelfare],[MayEMPPerfLY],[MayEMPSummTotal],
[JunEMPNum],[JunEMPSalary],[JunEMPPerf],[JunEMPWelfare],[JunEMPPerfLY],[JunEMPSummTotal],
[JulEMPNum],[JulEMPSalary],[JulEMPPerf],[JulEMPWelfare],[JulEMPPerfLY],[JulEMPSummTotal],
[AugEMPNum],[AugEMPSalary],[AugEMPPerf],[AugEMPWelfare],[AugEMPPerfLY],[AugEMPSummTotal],
[SepEMPNum],[SepEMPSalary],[SepEMPPerf],[SepEMPWelfare],[SepEMPPerfLY],[SepEMPSummTotal],
[OctEMPNum],[OctEMPSalary],[OctEMPPerf],[OctEMPWelfare],[OctEMPPerfLY],[OctEMPSummTotal],
[NovEMPNum],[NovEMPSalary],[NovEMPPerf],[NovEMPWelfare],[NovEMPPerfLY],[NovEMPSummTotal],
[DecEMPNum],[DecEMPSalary],[DecEMPPerf],[DecEMPWelfare],[DecEMPPerfLY],[DecEMPSummTotal])) p

---- pSalaryPerMMSumm_all
UNION ALL
select Year,DENSE_RANK() OVER(partition by Year Order by DepxOrder) as No,DepID,EMPType,xOrder,
[JanEMPNum],[JanEMPSalary],[JanEMPPerf],[JanEMPWelfare],[JanEMPPerfLY],[JanEMPSummTotal],
[FebEMPNum],[FebEMPSalary],[FebEMPPerf],[FebEMPWelfare],[FebEMPPerfLY],[FebEMPSummTotal],
[MarEMPNum],[MarEMPSalary],[MarEMPPerf],[MarEMPWelfare],[MarEMPPerfLY],[MarEMPSummTotal],
[AprEMPNum],[AprEMPSalary],[AprEMPPerf],[AprEMPWelfare],[AprEMPPerfLY],[AprEMPSummTotal],
[MayEMPNum],[MayEMPSalary],[MayEMPPerf],[MayEMPWelfare],[MayEMPPerfLY],[MayEMPSummTotal],
[JunEMPNum],[JunEMPSalary],[JunEMPPerf],[JunEMPWelfare],[JunEMPPerfLY],[JunEMPSummTotal],
[JulEMPNum],[JulEMPSalary],[JulEMPPerf],[JulEMPWelfare],[JulEMPPerfLY],[JulEMPSummTotal],
[AugEMPNum],[AugEMPSalary],[AugEMPPerf],[AugEMPWelfare],[AugEMPPerfLY],[AugEMPSummTotal],
[SepEMPNum],[SepEMPSalary],[SepEMPPerf],[SepEMPWelfare],[SepEMPPerfLY],[SepEMPSummTotal],
[OctEMPNum],[OctEMPSalary],[OctEMPPerf],[OctEMPWelfare],[OctEMPPerfLY],[OctEMPSummTotal],
[NovEMPNum],[NovEMPSalary],[NovEMPPerf],[NovEMPWelfare],[NovEMPPerfLY],[NovEMPSummTotal],
[DecEMPNum],[DecEMPSalary],[DecEMPPerf],[DecEMPWelfare],[DecEMPPerfLY],[DecEMPSummTotal],
(ISNULL([JanEMPNum],0)+ISNULL([FebEMPNum],0)+ISNULL([MarEMPNum],0)+ISNULL([AprEMPNum],0)+ISNULL([MayEMPNum],0)+ISNULL([JunEMPNum],0)
+ISNULL([JulEMPNum],0)+ISNULL([AugEMPNum],0)+ISNULL([SepEMPNum],0)+ISNULL([OctEMPNum],0)+ISNULL([NovEMPNum],0)+ISNULL([DecEMPNum],0)) as YearEMPNum,
(ISNULL([JanEMPSalary],0)+ISNULL([FebEMPSalary],0)+ISNULL([MarEMPSalary],0)+ISNULL([AprEMPSalary],0)+ISNULL([MayEMPSalary],0)+ISNULL([JunEMPSalary],0)
+ISNULL([JulEMPSalary],0)+ISNULL([AugEMPSalary],0)+ISNULL([SepEMPSalary],0)+ISNULL([OctEMPSalary],0)+ISNULL([NovEMPSalary],0)+ISNULL([DecEMPSalary],0)) as YearEMPSalary,
(ISNULL([JanEMPPerf],0)+ISNULL([FebEMPPerf],0)+ISNULL([MarEMPPerf],0)+ISNULL([AprEMPPerf],0)+ISNULL([MayEMPPerf],0)+ISNULL([JunEMPPerf],0)
+ISNULL([JulEMPPerf],0)+ISNULL([AugEMPPerf],0)+ISNULL([SepEMPPerf],0)+ISNULL([OctEMPPerf],0)+ISNULL([NovEMPPerf],0)+ISNULL([DecEMPPerf],0)) as YearEMPPerf,
(ISNULL([JanEMPWelfare],0)+ISNULL([FebEMPWelfare],0)+ISNULL([MarEMPWelfare],0)+ISNULL([AprEMPWelfare],0)+ISNULL([MayEMPWelfare],0)+ISNULL([JunEMPWelfare],0)
+ISNULL([JulEMPWelfare],0)+ISNULL([AugEMPWelfare],0)+ISNULL([SepEMPWelfare],0)+ISNULL([OctEMPWelfare],0)+ISNULL([NovEMPWelfare],0)+ISNULL([DecEMPWelfare],0)) as YearEMPWelfare,
(ISNULL([JanEMPPerfLY],0)+ISNULL([FebEMPPerfLY],0)+ISNULL([MarEMPPerfLY],0)+ISNULL([AprEMPPerfLY],0)+ISNULL([MayEMPPerfLY],0)+ISNULL([JunEMPPerfLY],0)
+ISNULL([JulEMPPerfLY],0)+ISNULL([AugEMPPerfLY],0)+ISNULL([SepEMPPerfLY],0)+ISNULL([OctEMPPerfLY],0)+ISNULL([NovEMPPerfLY],0)+ISNULL([DecEMPPerfLY],0)) as YearEMPPerfLY,
(ISNULL([JanEMPSummTotal],0)+ISNULL([FebEMPSummTotal],0)+ISNULL([MarEMPSummTotal],0)+ISNULL([AprEMPSummTotal],0)+ISNULL([MayEMPSummTotal],0)+ISNULL([JunEMPSummTotal],0)
+ISNULL([JulEMPSummTotal],0)+ISNULL([AugEMPSummTotal],0)+ISNULL([SepEMPSummTotal],0)+ISNULL([OctEMPSummTotal],0)+ISNULL([NovEMPSummTotal],0)+ISNULL([DecEMPSummTotal],0)) as YearEMPSummTotal
from
(select DepID,EMPType,Year,DepxOrder,xOrder,SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month*3-2,3)+c 'c',v
from
(select a.DepID,EMPType,Year(date) as Year,MONTH(date) as Month,b.xOrder as DepxOrder,a.xOrder,
sum(EMPNum) 'EMPNum',sum(EMPSalary) 'EMPSalary',sum(EMPPerf) 'EMPPerf',sum(EMPWelfare) 'EMPWelfare',sum(EMPPerfLY) 'EMPPerfLY',sum(EMPSummTotal) 'EMPSummTotal'
from pSalaryPerMMSumm_all a,oDepartment b where a.DepID=b.DepID
group by a.DepID,EMPType,Year(date),MONTH(date),b.xOrder,a.xOrder) a
unpivot(v for c in([EMPNum],[EMPSalary],[EMPPerf],[EMPWelfare],[EMPPerfLY],[EMPSummTotal])) u) b
pivot(max(v) for c in([JanEMPNum],[JanEMPSalary],[JanEMPPerf],[JanEMPWelfare],[JanEMPPerfLY],[JanEMPSummTotal],
[FebEMPNum],[FebEMPSalary],[FebEMPPerf],[FebEMPWelfare],[FebEMPPerfLY],[FebEMPSummTotal],
[MarEMPNum],[MarEMPSalary],[MarEMPPerf],[MarEMPWelfare],[MarEMPPerfLY],[MarEMPSummTotal],
[AprEMPNum],[AprEMPSalary],[AprEMPPerf],[AprEMPWelfare],[AprEMPPerfLY],[AprEMPSummTotal],
[MayEMPNum],[MayEMPSalary],[MayEMPPerf],[MayEMPWelfare],[MayEMPPerfLY],[MayEMPSummTotal],
[JunEMPNum],[JunEMPSalary],[JunEMPPerf],[JunEMPWelfare],[JunEMPPerfLY],[JunEMPSummTotal],
[JulEMPNum],[JulEMPSalary],[JulEMPPerf],[JulEMPWelfare],[JulEMPPerfLY],[JulEMPSummTotal],
[AugEMPNum],[AugEMPSalary],[AugEMPPerf],[AugEMPWelfare],[AugEMPPerfLY],[AugEMPSummTotal],
[SepEMPNum],[SepEMPSalary],[SepEMPPerf],[SepEMPWelfare],[SepEMPPerfLY],[SepEMPSummTotal],
[OctEMPNum],[OctEMPSalary],[OctEMPPerf],[OctEMPWelfare],[OctEMPPerfLY],[OctEMPSummTotal],
[NovEMPNum],[NovEMPSalary],[NovEMPPerf],[NovEMPWelfare],[NovEMPPerfLY],[NovEMPSummTotal],
[DecEMPNum],[DecEMPSalary],[DecEMPPerf],[DecEMPWelfare],[DecEMPPerfLY],[DecEMPSummTotal])) p