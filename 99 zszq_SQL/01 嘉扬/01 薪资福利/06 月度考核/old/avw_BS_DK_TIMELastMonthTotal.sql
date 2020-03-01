select a.EID AS EID, a.DepID AS DepID, a.Name AS Name, a.term AS Term, a.LeaDate AS LeaDate,a.JoinDate AS JoinDate,
/* YCQ:上月应出勤天数 */
a.YCQ AS YCQ,
/* NoDutyDayall:所有异常 */
a.NoDutyDayall AS NoDutyDayall,
/* NoDutyDay:异常未递交 */
a.NoDutyDay1 AS NoDutyDay1,
/* NoDutyDay:异常未审核 */
a.NoDutyDay AS NoDutyDay,
/* DutyDay:异常已审核 */
a.DutyDay AS DutyDay,
/* SJCQ:上月实际出勤天数 */
a.YCQ-a.NoDutyDayall/2.0 AS SJCQ,
/* SJCQ1:上月实际出勤天数(异常含已审核) */
a.YCQ-a.NoDutyDayall/2.0+a.DutyDay/2.0 AS SJCQ1
from avw_BS_DK_TIMELastMonth as a