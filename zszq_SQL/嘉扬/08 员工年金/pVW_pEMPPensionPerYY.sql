-- pVW_pEMPPensionPerYY
select a.PensionYear,a.Badge,a.Name,e.CertNo,a.IsPension,a.JoinDate,a.LeaDate,a.PostModulusPerYY,a.PostMonthPerYY,
a.PostModulusPerYY*a.PostMonthPerYY as PostModulusPerMM,
d.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/
((select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pEMPPostModulusPerYY where Year(PensionYear)=Year(d.PensionYear))+
(select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pSDMarketerPostModulusPerYY where Year(PensionYear)=Year(d.PensionYear))) as GrpPensionPerYY,
(case when b.Status not in (4,5) then d.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/
((select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pEMPPostModulusPerYY where Year(PensionYear)=Year(d.PensionYear))+
(select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pSDMarketerPostModulusPerYY where Year(PensionYear)=Year(d.PensionYear)))/4
else NULL END) as EmpPensionPerYY,
c.xorder as jobxorder
from pVW_pEMPPostModulusPerYY as a
inner join eemployee as b on a.Badge=b.Badge
inner join oJob as c on b.JobID=c.JobID
left join pPensionPerYY as d on DATEDIFF(yy,a.PensionYear,d.PensionYear)=0
inner join eDetails as e on b.EID=e.EID
where ISNULL(a.PostModulusPerYY,0) <> 0