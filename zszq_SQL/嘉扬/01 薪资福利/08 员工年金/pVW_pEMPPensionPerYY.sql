-- pVW_pEMPPensionPerYY

select a.PensionYear,a.EID as EID,a.BID as BID,a.Badge,a.Name,b.Identification as CertNo,a.IsPension,a.JoinDate,a.LeaDate,a.PostModulusPerYY,a.PostMonthPerYY,
a.PostModulusPerYY*a.PostMonthPerYY as PostModulusPerMM,d.PensionYearTotal,
ROUND(d.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/e.ModulusTotalYY,2) as GrpPensionPerYY,
(case when DATEDIFF(YY,ISNULL(a.LeaDate,dateAdd(yy,1,CONVERT(char(5),a.PensionYear, 120) + '12-31')),a.PensionYear)<0 and a.Status<>5 
then ROUND(d.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/e.ModulusTotalYY/4,2) else NULL END) as EmpPensionPerYY,
B.JobxOrder as jobxorder
from pVW_pEMPPostModulusPerYY as a
inner join pVW_Employee as b on ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID)
inner join pPensionPerYY as d on DATEDIFF(yy,a.PensionYear,d.PensionYear)=0
inner join (select PensionYear,SUM(PostModulusPerYY*PostMonthPerYY) as ModulusTotalYY from pVW_pEMPPostModulusPerYY where ISNULL(IsPension,0)=1 group by PensionYear) as e on DATEDIFF(yy,a.PensionYear,e.PensionYear)=0
where ISNULL(a.IsPension,0)=1