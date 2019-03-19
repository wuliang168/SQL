-- pVW_EmpOAAnnualLeave
select distinct a.OAID,a.EID,a.Name,a.ApprDep as DepAppr,a.OAType,a.OATitle,a.OAContent,a.LeaveType,a.LeaveYear,a.LeaveDays,a.LeaveBeginDate,a.LeaveEndDate,
a.AnnualLeaAdjust
from pEmpOALeave a
where a.LeaveType in (7) and a.Name=a.ApprDirector