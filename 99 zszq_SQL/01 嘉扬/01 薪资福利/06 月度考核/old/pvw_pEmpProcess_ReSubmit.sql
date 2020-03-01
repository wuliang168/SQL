-- pvw_pEmpProcess_ReSubmit

select (select EID from eEmployee where badge=a.badge) as EID,NULL as xid,name+'_'+CONVERT(VARCHAR(7),period,20) as Title,
kpiReportTo as KPIReportTo,monthID as MonthID
from pEmpProcess_Month a
where a.pstatus=4