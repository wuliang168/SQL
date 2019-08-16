-- @aveNum表示年金分配月份数，@PensEID表示非营业部年金分配人EID
declare @aveNum int,@PensEID int
set @aveNum=4
set @PensEID=(select EID from eemployee where Name=N'陈欣欣')

-- 更新非营业部年金企业年金分配数
IF Exists(select 1 from pEmpPensionPerMM_register a
where ISNULL(a.GrpPensionPerMM,0)=0 and a.GrpPensionMonthRest >= a.GrpPensionMonthTotal/@aveNum and a.PensionContact=@PensEID)
	BEGIN
		Update a
		set a.GrpPensionPerMM=a.GrpPensionMonthTotal/@aveNum 
		from pEmpPensionPerMM_register a
		where a.PensionContact=@PensEID
	END
ELSE
	BEGIN
		Update a
		set a.GrpPensionPerMM=GrpPensionMonthRest 
		from pEmpPensionPerMM_register a
		where a.PensionContact=@PensEID
	END

-- 更新非营业部年金企业分配剩余数
Update a
set a.GrpPensionMonthRest=a.GrpPensionMonthRest-a.GrpPensionPerMM
from pEmpPensionPerMM_register a
where a.PensionContact=@PensEID

-- 更新非营业部年金个人抵税部分年金分配数
IF Exists(select 1 from pEmpPensionPerMM_register a,pEmployeeEmolu b
where ISNULL(a.EmpPensionPerMMBTax,0)=0 and a.EID=b.EID and b.PensionTaxMinus >= a.GrpPensionMonthRest/@aveNum/4 and a.PensionContact=@PensEID)
	BEGIN
		Update a
		set a.EmpPensionPerMMBTax=a.GrpPensionMonthRest/@aveNum/4
		from pEmpPensionPerMM_register a,pEmployeeEmolu b
		where a.EID=b.EID and a.PensionContact=@PensEID
	END
ELSE
	BEGIN
		Update a
		set a.EmpPensionPerMMBTax=b.PensionTaxMinus
		from pEmpPensionPerMM_register a,pEmployeeEmolu b
		where a.EID=b.EID and a.PensionContact=@PensEID
	END

-- 更新非营业部年金个人非抵税部分年金分配数
Update a
set a.EmpPensionPerMMATax=a.GrpPensionPerMM/@aveNum-a.EmpPensionPerMMBTax
from pEmpPensionPerMM_register a
where a.PensionContact=@PensEID

-- 更新个人薪酬年金部分内容
--Update b
--set b.GrpPensionTotal=ISNULL(b.GrpPensionTotal,0)+a.GrpPensionPerMM,b.GrpPensionYearRest=b.GrpPensionYearRest-a.GrpPensionPerMM,
--b.EmpPensionTotal=ISNULL(b.EmpPensionTotal,0)+a.EmpPensionPerMMATax+a.EmpPensionPerMMBTax
--from pEmpPensionPerMM_register a,pEmployeeEmolu b
--where a.EID=b.EID and a.PensionContact=@PensEID
