-- pVW_pSDMarketerPostModulusPerYY
select a.PensionYear as PensionYear,b.Identification as Identification,b.Name as Name,b.IsPension as IsPension,b.JoinDate as JoinDate,b.LeaveDate as LeaDate,
(case when YEAR(b.JoinDate)>YEAR(a.PensionYear) OR YEAR(ISNULL(b.LeaveDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))<YEAR(a.PensionYear) then NULL 
else 1 end) as PostModulusPerYY,
(case 
when YEAR(b.JoinDate)>YEAR(a.PensionYear) OR YEAR(ISNULL(b.LeaveDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))<YEAR(a.PensionYear)
then NULL
when YEAR(b.JoinDate)<YEAR(a.PensionYear) AND YEAR(ISNULL(b.LeaveDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))>YEAR(a.PensionYear) 
then 12
when YEAR(b.JoinDate)<YEAR(a.PensionYear) AND YEAR(ISNULL(b.LeaveDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))=YEAR(a.PensionYear)
then 
(case when DAY(b.LeaveDate)>=(32-DAY(b.JoinDate+32-DAY(ISNULL(b.LeaveDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))))/2 
then MONTH(b.LeaveDate) else MONTH(b.LeaveDate)-1 end)
when YEAR(b.JoinDate)=YEAR(a.PensionYear) AND YEAR(ISNULL(b.LeaveDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))>YEAR(a.PensionYear)
then 
(case when DAY(b.JoinDate)>(32-DAY(b.JoinDate+32-DAY(b.JoinDate)))/2 then 12-MONTH(b.JoinDate) else 12-MONTH(b.JoinDate)+1 end)
when YEAR(b.JoinDate)=YEAR(a.PensionYear) AND YEAR(ISNULL(b.LeaveDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))=YEAR(a.PensionYear)
then 
(case when DAY(b.JoinDate)>(32-DAY(b.JoinDate+32-DAY(b.JoinDate)))/2 and DAY(b.LeaveDate)>=(32-DAY(b.LeaveDate+32-DAY(b.LeaveDate)))/2
then MONTH(b.LeaveDate)-MONTH(b.JoinDate)
when DAY(b.JoinDate)>(32-DAY(b.JoinDate+32-DAY(b.JoinDate)))/2 and DAY(b.LeaveDate)<(32-DAY(b.LeaveDate+32-DAY(b.LeaveDate)))/2
then MONTH(b.LeaveDate)-MONTH(b.JoinDate)-1
when DAY(b.JoinDate)<(32-DAY(b.JoinDate+32-DAY(b.JoinDate)))/2 and DAY(b.LeaveDate)>=(32-DAY(b.LeaveDate+32-DAY(b.LeaveDate)))/2
then MONTH(b.LeaveDate)-MONTH(b.JoinDate)+1
else MONTH(b.LeaveDate)-MONTH(b.JoinDate) end) 
end) as PostMonthPerYY
from pPensionPerYY as a
left join pSalesDepartMarketerEmolu as b on ISNULL(b.IsPension,0)=1 and b.Status not in (4)
where ISNULL(a.Closed,0)=0