-- pVW_MonthExpenseEMPPerMM

select a.Month as Month,a.EID as EID,(select Badge from eEmployee where EID=a.EID) as Badge,(select Name from eEmployee where EID=a.EID) as Name,
(select CompID from eEmployee where EID=a.EID) as CompID,(select dbo.eFN_getdepid1st(DepID) from eEmployee where EID=a.EID) as DepID1st,
(select dbo.eFN_getdepid2nd(DepID) from eEmployee where EID=a.EID) as DepID2nd,(select JobID from eEmployee where EID=a.EID) as JobID,
SUM(MonthExpense) as MonthExpenseTotal
from pMonthExpensePerMM a
group by a.Month,a.EID