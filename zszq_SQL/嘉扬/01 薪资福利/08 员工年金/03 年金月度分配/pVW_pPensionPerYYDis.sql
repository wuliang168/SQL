-- pVW_pPensionPerYYDis

select a.PensionYear,a.EID,a.BID,a.EmpPensionPerYYRST_old,a.EmpPensionPerYYDisAccu,a.EmpPensionPerYYDisAccu_diff,
a.EmpPensionPerYYDisAccu_diff
-ISNULL((select EmpPensionPerYYDisAccu_diff from pVW_pPensionPerYYDisDiff where DATEDIFF(YY,PensionYear,a.PensionYear)=1 and EID=a.EID),0) as EmpPensionPerYYRST_new,
EmpPensionPerMM
from pVW_pPensionPerYYDisDiff a