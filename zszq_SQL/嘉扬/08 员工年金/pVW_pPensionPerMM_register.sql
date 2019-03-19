-- pVW_pPensionPerMM_register
-- 非投理顾员工
select a.PensionYear as PensionYear,a.Badge as Badge,a.Name as Name,b.CompID as CompID,dbo.eFN_getdepid1st(b.DepID) as DepID1,
dbo.eFN_getdepid2nd(b.DepID) as DepID2,dbo.eFN_getdepid3th(b.DepID) as DepID3,b.JobID as JobID,b.Status as Status,e.CertNo as CertNo,
a.IsPension as IsPension,(case when f.SalaryPayID in (2,10,11,12,13,14,15,16) then 17 else f.SalaryPayID end) as SalaryPayID,a.JoinDate as JoinDate,a.LeaDate as LeaDate,
a.LastYearMDID as LastYearMDID,(select MDModulus from oCD_MDType where ID=a.LastYearMDID) as LastYearMDModulus,
a.LastYearAdminID as LastYearAdminID,(select AdminModulus from oCD_AdminType where ID=a.LastYearAdminID) as LastYearAdminModulus,
a.PostModulusPerYY as PostModulusPerYY,a.PostMonthPerYY as PostMonthPerYY,a.PostModulusPerYY*a.PostMonthPerYY as PostModulusPerMM,
d.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/
((select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pEMPPostModulusPerYY where Year(PensionYear)=Year(d.PensionYear))+
(select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pSDMarketerPostModulusPerYY where Year(PensionYear)=Year(d.PensionYear))) as GrpPensionPerYY,
(case when b.Status not in (4,5) then d.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/
((select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pEMPPostModulusPerYY where Year(PensionYear)=Year(d.PensionYear))+
(select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pSDMarketerPostModulusPerYY where Year(PensionYear)=Year(d.PensionYear)))/4
else NULL end) as EmpPensionPerYY,
c.xorder as jobxorder
from pVW_pEMPPostModulusPerYY as a
inner join eemployee as b on a.Badge=b.Badge
inner join oJob as c on b.JobID=c.JobID
left join pPensionPerYY as d on DATEDIFF(yy,a.PensionYear,d.PensionYear)=0
inner join eDetails as e on b.EID=e.EID
inner join pEmployeeEmolu as f on b.EID=f.EID
where ISNULL(a.PostModulusPerYY,0) <> 0

-- 投理顾员工
UNION
select a.PensionYear as PensionYear,NULL as Badge,a.Name as Name,c.CompID as CompID,c.SupDepID as DepID1,c.DepID as DepID2,
NULL as DepID3,c.JobID as JobID,c.Status as Status,a.Identification as CertNo,a.IsPension as IsPension,c.SalaryPayID as SalaryPayID,
a.JoinDate as JoinDate,a.LeaDate as LeaDate,NULL as LastYearMDID,NULL as LastYearMDModulus,
c.AdminID as LastYearAdminID,(select AdminModulus from oCD_AdminType where ID=c.AdminID) as LastYearAdminModulus,
a.PostModulusPerYY as PostModulusPerYY,a.PostMonthPerYY as PostMonthPerYY,a.PostModulusPerYY*a.PostMonthPerYY as PostModulusPerMM,
b.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/
((select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pSDMarketerPostModulusPerYY where Year(PensionYear)=Year(b.PensionYear))+
(select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pEMPPostModulusPerYY where Year(PensionYear)=Year(b.PensionYear))) as GrpPensionPerYY,
(case when c.Status not in (4,5) then b.PensionYearTotal*a.PostModulusPerYY*a.PostMonthPerYY/
((select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pSDMarketerPostModulusPerYY where Year(PensionYear)=Year(b.PensionYear))+
(select SUM(PostModulusPerYY*PostMonthPerYY) from pVW_pEMPPostModulusPerYY where Year(PensionYear)=Year(b.PensionYear)))/4
else NULL end) as EmpPensionPerYY,
d.xorder as jobxorder
from pVW_pSDMarketerPostModulusPerYY as a
left join pPensionPerYY as b on Year(a.PensionYear)=Year(b.PensionYear)
inner join pSalesDepartMarketerEmolu as c on a.Identification=c.Identification
inner join oJob as d on c.JobID=d.JobID
where ISNULL(a.PostModulusPerYY,0) <> 0