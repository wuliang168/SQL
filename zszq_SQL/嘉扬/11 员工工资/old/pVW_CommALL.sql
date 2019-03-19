select NULL as No,*,NULL as Remark
from (select eid as EID,Year(date) as Year,SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(Date)*3-2,3) as months,
(ISNULL(CommAllowance,0)+ISNULL(CommAllowancePlus,0)) as CommAllowanceTotal from pEmployeeComm_all) as ord
pivot(sum(CommAllowanceTotal) for months in ([Jan],[Feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[Sep],[Oct],[Nov],[Dec])) as p