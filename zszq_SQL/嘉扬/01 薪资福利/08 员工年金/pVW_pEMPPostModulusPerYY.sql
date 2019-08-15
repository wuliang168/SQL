-- pVW_pEMPPostModulusPerYY

select a.PensionYear as PensionYear,g.EID as EID,g.BID as BID,f.badge as Badge,f.Name as Name,g.IsPension as IsPension,g.JoinDate as JoinDate,g.LeaDate as LeaDate,
g.Status as Status,g.MDIDYY as LastYearMDID,g.AdminIDYY as LastYearAdminID,
/* 入职日期大于或者退休日期小于年金分配日期 */
(case when YEAR(g.JoinDate)>YEAR(a.PensionYear) OR YEAR(ISNULL(g.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))<YEAR(a.PensionYear) 
then 0 
else (case when ISNULL(d.AdminModulus,0)>ISNULL(e.MDModulus,0) then ISNULL(d.AdminModulus,0) else ISNULL(e.MDModulus,0) end) end) as PostModulusPerYY,
(case 
/* 入职日期大于或者退休日期小于年金分配日期 */
when YEAR(g.JoinDate)>YEAR(a.PensionYear) OR YEAR(ISNULL(g.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))<YEAR(a.PensionYear)
then 0
/* 入职日期小于或者退休日期大于年金分配日期 */
when YEAR(g.JoinDate)<YEAR(a.PensionYear) AND YEAR(ISNULL(g.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))>YEAR(a.PensionYear) 
then 12
/* 入职日期小于并且退休日期等于年金分配日期 */
when YEAR(g.JoinDate)<YEAR(a.PensionYear) AND YEAR(ISNULL(g.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))=YEAR(a.PensionYear)
then 
(case when DAY(g.LeaDate)>(32-DAY(g.LeaDate+32-DAY(ISNULL(g.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))))/2 
then MONTH(g.LeaDate) else MONTH(g.LeaDate)-1 end)
/* 入职日期等于并且退休日期大于年金分配日期 */
when YEAR(g.JoinDate)=YEAR(a.PensionYear) AND YEAR(ISNULL(g.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))>YEAR(a.PensionYear)
then 
(case when DAY(g.JoinDate)>(32-DAY(g.JoinDate+32-DAY(g.JoinDate)))/2 then 12-MONTH(g.JoinDate) else 12-MONTH(g.JoinDate)+1 end)
/* 入职日期等于并且退休日期等于年金分配日期 */
when YEAR(g.JoinDate)=YEAR(a.PensionYear) AND YEAR(ISNULL(g.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.PensionYear, 120) + '12-31')))=YEAR(a.PensionYear)
then 
(case when DAY(g.JoinDate)>(32-DAY(g.JoinDate+32-DAY(g.JoinDate)))/2 and DAY(g.LeaDate)>(32-DAY(g.LeaDate+32-DAY(g.LeaDate)))/2
then MONTH(g.LeaDate)-MONTH(g.JoinDate)
when DAY(g.JoinDate)>(32-DAY(g.JoinDate+32-DAY(g.JoinDate)))/2 and DAY(g.LeaDate)<(32-DAY(g.LeaDate+32-DAY(g.LeaDate)))/2
then MONTH(g.LeaDate)-MONTH(g.JoinDate)-1
when DAY(g.JoinDate)<(32-DAY(g.JoinDate+32-DAY(g.JoinDate)))/2 and DAY(g.LeaDate)>(32-DAY(g.LeaDate+32-DAY(g.LeaDate)))/2
then MONTH(g.LeaDate)-MONTH(g.JoinDate)+1
else MONTH(g.LeaDate)-MONTH(g.JoinDate) end)
end) as PostMonthPerYY
from pPensionPerYY as a
inner join pPensionUpdatePerEmp as g on DATEDIFF(YY,a.PensionYear,g.PensionYear)=0 and ISNULL(g.IsSubmit,0)=1
inner join pVW_employee as f on ISNULL(g.EID,g.BID)=ISNULL(f.eid,f.BID)
left join oCD_AdminType as d on g.AdminIDYY=d.ID
left join oCD_MDType as e on g.MDIDYY=e.ID