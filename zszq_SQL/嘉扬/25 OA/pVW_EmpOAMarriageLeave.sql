-- pVW_EmpOAMarriageLeave
select distinct a.OAID,a.EID,a.Name,a.ApprDep as DepAppr,a.OAType,a.OATitle,a.LeaveType,a.LeaveYear,a.LeaveDays,a.LeaveBeginDate,a.LeaveEndDate
from pEmpOALeave a
where a.LeaveType in (3) and a.Name=a.ApprDirector