-- Attence_LLMMDep

select distinct b.LLMonth as LLMonth,a.Dep1st as Dep1st,a.ReportToDaily as ReportToDaily
from PVW_EMPREPORTTODAILY a,ATTENCE_LLMONTHLY b
where a.EID in 
(select EID from ATTENCE_LLMONTHLY where Dep1st not in (349,392,393) and dbo.eFN_getdeptype(Dep1st) in (1,4) and WORKCITY=45 
and ISNULL(dbo.eFN_getdepadmin(Dep1st),0)<>695 and Dep1st not in (383,786,380) and COMPID=11 and (ABNORMWORKDAYS<>0 or LATEWORKDAYS<>0 or EARLYWORKDAYS<>0))