select b.EID AS EID, dbo.eFN_getdepid1st(b.DepID) AS DepID, b.Name AS Name, a.term AS Term, b.LeaDate AS LeaDate,b.JoinDate AS JoinDate,
/* YCQ:上月应出勤天数 */
(case
/* 入职日期大于或者离职日期小于上个月 */
when datediff(mm,a.Term,b.JoinDate) > 0 OR datediff(mm,a.Term,ISNULL(b.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.Term, 120) + '12-31'))) < 0 
then 0
/* 入职日期小于并且离职日期大于上个月 */
when datediff(mm,a.Term,b.JoinDate) < 0 AND datediff(mm,a.Term,ISNULL(b.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.Term, 120) + '12-31'))) > 0 
then (select COUNT(datediff(mm,Term,GETDATE())) from lCalendar where xType in (1) and datediff(mm,Term,GETDATE()) = 1)
/* 入职日期小于并且离职日期等于上个月 */
when datediff(mm,a.Term,b.JoinDate) < 0 AND datediff(mm,a.Term,ISNULL(b.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.Term, 120) + '12-31'))) = 0 
then (select COUNT(datediff(dd,Term,GETDATE())) from lCalendar where xType in (1) and datediff(mm,Term,GETDATE()) = 1 and datediff(dd,Term,b.LeaDate) > -1)
/* 入职日期等于并且离职日期大于上个月 */
when datediff(mm,a.Term,b.JoinDate) = 0 AND datediff(mm,a.Term,ISNULL(b.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.Term, 120) + '12-31'))) > 0 
then (select COUNT(datediff(dd,Term,GETDATE())) from lCalendar where xType in (1) and datediff(mm,Term,GETDATE()) = 1 and datediff(dd,Term,b.JoinDate) < 1)
/* 入职日期等于并且离职日期等于上个月 */
when datediff(mm,a.Term,b.JoinDate) = 0 AND datediff(mm,a.Term,ISNULL(b.LeaDate,dateAdd(yy,1,CONVERT(char(5), a.Term, 120) + '12-31'))) = 0 
then (select COUNT(datediff(dd,Term,GETDATE())) from lCalendar where xType in (1) and datediff(mm,Term,GETDATE()) = 1 and datediff(dd,Term,b.LeaDate) > -1 and datediff(dd,Term,b.JoinDate) < 1)
END) AS YCQ,
/* NoDutyDayall:所有异常 */
(select COUNT(ISNULL(Initialized,1)) from BS_YC_DK where EID=b.EID and datediff(mm,Term,GETDATE()) = 1) AS NoDutyDayall,
/* NoDutyDay1:异常未递交 */
(select COUNT(ISNULL(Initialized,1)) from BS_YC_DK where EID=b.EID and datediff(mm,Term,GETDATE()) = 1 and ISNULL(Initialized,0)=0) AS NoDutyDay1,
/* NoDutyDay:异常未审核 */
(select COUNT(ISNULL(Submit,1)) from BS_YC_DK where EID=b.EID and datediff(mm,Term,GETDATE()) = 1 and ISNULL(Submit,0)=0) AS NoDutyDay,
/* DutyDay:异常已审核 */
(select COUNT(ISNULL(Submit,1)) from BS_YC_DK where EID=b.EID and datediff(mm,Term,GETDATE()) = 1 and ISNULL(Submit,0)=1) AS DutyDay,
/* SJCQ:上月实际出勤天数 */
NULL AS SJCQ,
/* SJCQ1:上月实际出勤天数(异常含已审核) */
NULL AS SJCQ1
from Lleave_Periods as a
left join aEmployee as b on b.Status in (1,2,3,4,5)
where datediff(mm,a.Term,GETDATE()) = 1