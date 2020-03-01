-- pVW_pPensionPerMM

select a.EID as EID,a.BID as BID,SUM(a.EmpPensionPerYYRST) as EmpPensionPerYYRST
from pPensionUpdatePerEmp a,pPensionPerYY b
where DATEDIFF(YY,a.PensionYear,b.PensionYear)=0 AND ISNULL(a.IsPension,0)=1 AND ISNULL(a.IsConfirm,0)=1
group by a.EID,a.BID