-- pVW_pEMPPostModulusPerYY
select a.PensionYear as PensionYear,f.badge as Badge,f.Name as Name,b.IsPension as IsPension,c.JoinDate as JoinDate,c.LeaDate as LeaDate,
b.LastYearMDID as LastYearMDID,b.LastYearAdminID as LastYearAdminID,
/* 入职日期大于或者退休日期小于年金分配日期 */
(case when YEAR(c.JoinDate)>YEAR(a.PensionYear) OR YEAR(ISNULL(c.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))<YEAR(a.PensionYear) 
then NULL 
else (case when ISNULL(d.AdminModulus,0)>ISNULL(e.MDModulus,0) then ISNULL(d.AdminModulus,0) else ISNULL(e.MDModulus,0) end) end) as PostModulusPerYY,
(case 
/* 入职日期大于或者退休日期小于年金分配日期 */
when YEAR(c.JoinDate)>YEAR(a.PensionYear) OR YEAR(ISNULL(c.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))<YEAR(a.PensionYear)
then NULL
/* 入职日期小于或者退休日期大于年金分配日期 */
when YEAR(c.JoinDate)<YEAR(a.PensionYear) AND YEAR(ISNULL(c.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))>YEAR(a.PensionYear) 
then 12
/* 入职日期小于并且退休日期等于年金分配日期 */
when YEAR(c.JoinDate)<YEAR(a.PensionYear) AND YEAR(ISNULL(c.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))=YEAR(a.PensionYear)
then 
(case when DAY(c.LeaDate)>(32-DAY(c.LeaDate+32-DAY(ISNULL(c.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))))/2 
then MONTH(c.LeaDate) else MONTH(c.LeaDate)-1 end)
/* 入职日期等于并且退休日期大于年金分配日期 */
when YEAR(c.JoinDate)=YEAR(a.PensionYear) AND YEAR(ISNULL(c.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))>YEAR(a.PensionYear)
then 
(case when DAY(c.JoinDate)>(32-DAY(c.JoinDate+32-DAY(c.JoinDate)))/2 then 12-MONTH(c.JoinDate) else 12-MONTH(c.JoinDate)+1 end)
/* 入职日期等于并且退休日期等于年金分配日期 */
when YEAR(c.JoinDate)=YEAR(a.PensionYear) AND YEAR(ISNULL(c.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))=YEAR(a.PensionYear)
then 
(case when DAY(c.JoinDate)>(32-DAY(c.JoinDate+32-DAY(c.JoinDate)))/2 and DAY(c.LeaDate)>(32-DAY(c.LeaDate+32-DAY(c.LeaDate)))/2
then MONTH(c.LeaDate)-MONTH(c.JoinDate)
when DAY(c.JoinDate)>(32-DAY(c.JoinDate+32-DAY(c.JoinDate)))/2 and DAY(c.LeaDate)<(32-DAY(c.LeaDate+32-DAY(c.LeaDate)))/2
then MONTH(c.LeaDate)-MONTH(c.JoinDate)-1
when DAY(c.JoinDate)<(32-DAY(c.JoinDate+32-DAY(c.JoinDate)))/2 and DAY(c.LeaDate)>(32-DAY(c.LeaDate+32-DAY(c.LeaDate)))/2
then MONTH(c.LeaDate)-MONTH(c.JoinDate)+1
else MONTH(c.LeaDate)-MONTH(c.JoinDate) end)
end) as PostMonthPerYY
from pPensionPerYY as a
left join pEmployeeEmolu as b on ISNULL(b.IsPension,0)=1
left join eStatus as c on c.EID=b.EID 
left join oCD_AdminType as d on b.LastYearAdminID=d.ID
left join oCD_MDType as e on b.LastYearMDID=e.ID
inner join eemployee as f on b.eid=f.eid and f.status not in (4)
left join oJob as g on f.JobID=g.JobID
where ISNULL(a.Closed,0)=0 and ISNULL(a.Submit,0)=1