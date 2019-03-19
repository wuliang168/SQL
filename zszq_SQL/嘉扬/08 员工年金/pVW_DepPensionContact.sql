-- pVW_DepPensionContact
---- 薪酬类型非营业部;
select NULL as SupDepID,NULL as DepID,1 as Status,a.ID as SalaryPayID,a.PensionContact as PensionContact
from oCD_SalaryPayType a
where a.ID in (1,4,7)

---- 退休;
---- status:5表示退休;
UNION
select NULL,NULL,5,a.ID,a.PensionContact
from oCD_SalaryPayType a
where a.ID in (8)

---- 在职或退休;薪酬类型为营业部;
---- status:1表示在职; SalaryPayID: 6表示薪酬类型为营业部
UNION
select dbo.eFN_getdepid1st(a.DepID),dbo.eFN_getdepid2nd(a.DepID),1,6,a.DepPensionContact
from odepartment a
where ISNULL(a.isDisabled,0)=0 and a.DepType in (2,3)