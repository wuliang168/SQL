select a.PensionYear,a.Identification,a.Name,a.IsPension,a.JoinDate,a.LeaDate,a.PostModulusPerYY,a.PostMonthPerYY,
a.PostModulusPerYY*a.PostMonthPerYY as PostModulusPerMM,
b.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/
((select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pSDMarketerPostModulusPerYY where Year(PensionYear)=Year(b.PensionYear))+
(select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pEMPPostModulusPerYY where Year(PensionYear)=Year(b.PensionYear))) as GrpPensionPerYY,
b.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/
((select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pSDMarketerPostModulusPerYY where Year(PensionYear)=Year(b.PensionYear))+
(select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pEMPPostModulusPerYY where Year(PensionYear)=Year(b.PensionYear)))/4 as EmpPensionPerYY,
d.xorder as jobxorder
from pVW_pSDMarketerPostModulusPerYY as a
left join pPensionPerYY as b on Year(a.PensionYear)=Year(b.PensionYear)
inner join pSalesDepartMarketerEmolu as c on a.Identification=c.Identification
inner join oJob as d on c.JobID=d.JobID
where ISNULL(a.PostModulusPerYY,0) <> 0