select NULL as No,*,NULL as Remark
from (select eid as EID,Year(date) as Year,SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(Date)*3-2,3) as months,TrafficAllowance from pEmployeeTraffic_all) as ord
pivot(sum(TrafficAllowance) for months in ([Jan],[Feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[Sep],[Oct],[Nov],[Dec])) as p