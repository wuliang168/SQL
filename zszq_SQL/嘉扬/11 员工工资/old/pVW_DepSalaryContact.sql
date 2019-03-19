-- pVW_DepSalaryContact
---- 薪酬类型非营业部;
select NULL as SupDepID,NULL as DepID,1 as Status,a.ID as SalaryPayID,a.SalaryContact as SalaryContact
from oCD_SalaryPayType a
where a.ID not in (1,4,7,8,18)

---- 在职或退休;薪酬类型为营业部;
---- status:1表示在职; SalaryPayID: 6表示薪酬类型为营业部
UNION
select dbo.eFN_getdepid1st(a.DepID),dbo.eFN_getdepid2nd(a.DepID),1,6,a.DepSalaryContact
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.DepType in (2,3)