-- ZSZQ.U_F_ZSZQ_QJBJ
-- 本级部门一般员工
select (select EID from eEmployee where Name=XM2 and status not in (4,5) and dbo.eFN_getdepid1st(DepID)=(select DepID from oDepartment where DepAbbr=REPLACE(BM2,N'证券营业部','') and ISNULL(isDisabled,0)=0)) as EID,
XM2 as Name,BM2 as DepAbbr,QJZL as LeaveType,KSSJ as LeaveDateFrom,JSSJ as LeaveDateTo,QJTS,BJJSJJTSY as Remark
from openquery(OA,'select XM2,BM2,QJZL,KSSJ,JSSJ,QJTS,BJJSJJTSY from ZSZQ.U_F_ZSZQ_QJBJ')
where DATEDIFF(YY,GETDATE(),(case when CHARINDEX(N'年',KSSJ)<>0 then CAST(replace(replace(replace(KSSJ,N'年','-'),N'月','-'),N'日','') as smalldatetime) else CAST(KSSJ as smalldatetime) end))<=1

-- ZSZQ.U_F_ZSZQ_QJYYB
-- 营业部一般员工
UNION
select (select EID from eEmployee where Name=XM2 and status not in (4,5) and DepID=(select DepID from oDepartment where DepAbbr=REPLACE(BM2,N'证券营业部','') and ISNULL(isDisabled,0)=0)) as EID,
XM2 as Name,BM2 as DepAbbr,QJZL as LeaveType,KSSJ as LeaveDateFrom,JSSJ as LeaveDateTo,QJTS,BJJSJJTSY as Remark
from openquery(OA,'select XM2,BM2,QJZL,KSSJ,JSSJ,QJTS,BJJSJJTSY from ZSZQ.U_F_ZSZQ_QJYYB')
where DATEDIFF(YY,GETDATE(),(case when CHARINDEX(N'年',KSSJ)<>0 then CAST(replace(replace(replace(KSSJ,N'年','-'),N'月','-'),N'日','') as smalldatetime) else CAST(KSSJ as smalldatetime) end))<=1

-- ZSZQ.U_F_ZSZQ_QJYYBCW
-- 营业部财务(电脑)员工
UNION
select (select EID from eEmployee where Name=XM2 and status not in (4,5) and DepID=(select DepID from oDepartment where DepAbbr=REPLACE(BM2,N'证券营业部','') and ISNULL(isDisabled,0)=0)) as EID,
XM2 as Name,BM2 as DepAbbr,QJZL as LeaveType,KSSJ as LeaveDateFrom,JSSJ as LeaveDateTo,QJTS,BJJSJJTSY as Remark
from openquery(OA,'select XM2,BM2,QJZL,KSSJ,JSSJ,QJTS,BJJSJJTSY from ZSZQ.U_F_ZSZQ_QJYYBCW')
where DATEDIFF(YY,GETDATE(),(case when CHARINDEX(N'年',KSSJ)<>0 then CAST(replace(replace(replace(KSSJ,N'年','-'),N'月','-'),N'日','') as smalldatetime) else CAST(KSSJ as smalldatetime) end))<=1

-- ZSZQ.U_F_ZSZQ_QJYYBHG
-- 营业部合规专员
UNION
select (select EID from eEmployee where Name=XM2 and status not in (4,5) and DepID=(select DepID from oDepartment where DepAbbr=REPLACE(BM2,N'证券营业部','') and ISNULL(isDisabled,0)=0)) as EID,
XM2 as Name,BM2 as DepAbbr,QJZL as LeaveType,KSSJ as LeaveDateFrom,JSSJ as LeaveDateTo,QJTS,BJJSJJTSY as Remark
from openquery(OA,'select XM2,BM2,QJZL,KSSJ,JSSJ,QJTS,BJJSJJTSY from ZSZQ.U_F_ZSZQ_QJYYBHG')
where DATEDIFF(YY,GETDATE(),(case when CHARINDEX(N'年',KSSJ)<>0 then CAST(replace(replace(replace(KSSJ,N'年','-'),N'月','-'),N'日','') as smalldatetime) else CAST(KSSJ as smalldatetime) end))<=1

-- ZSZQ.U_F_ZSZQ_QJYYBZJL
-- 营业部总经理室
UNION
select (select EID from eEmployee where Name=XM2 and status not in (4,5) and DepID=(select DepID from oDepartment where DepAbbr=REPLACE(BM2,N'证券营业部','') and ISNULL(isDisabled,0)=0)) as EID,
XM2 as Name,BM2 as DepAbbr,QJZL as LeaveType,KSSJ as LeaveDateFrom,JSSJ as LeaveDateTo,QJTS,BJJSJJTSY as Remark
from openquery(OA,'select XM2,BM2,QJZL,KSSJ,JSSJ,QJTS,BJJSJJTSY from ZSZQ.U_F_ZSZQ_QJYYBZJL')
where DATEDIFF(YY,GETDATE(),(case when CHARINDEX(N'年',KSSJ)<>0 then CAST(replace(replace(replace(KSSJ,N'年','-'),N'月','-'),N'日','') as smalldatetime) else CAST(KSSJ as smalldatetime) end))<=1

-- ZSZQ.U_F_ZSZQ_QJZC
-- 本级部门中层管理人员
UNION
select (select EID from eEmployee where Name=XM2 and status not in (4,5) and DepID=(select DepID from oDepartment where DepAbbr=REPLACE(BM2,N'证券营业部','') and ISNULL(isDisabled,0)=0)) as EID,
XM2 as Name,BM2 as DepAbbr,QJZL as LeaveType,KSSJ as LeaveDateFrom,JSSJ as LeaveDateTo,QJTS,BJJSJJTSY as Remark
from openquery(OA,'select XM2,BM2,QJZL,KSSJ,JSSJ,QJTS,BJJSJJTSY from ZSZQ.U_F_ZSZQ_QJZC')
where DATEDIFF(YY,GETDATE(),(case when CHARINDEX(N'年',KSSJ)<>0 then CAST(replace(replace(replace(KSSJ,N'年','-'),N'月','-'),N'日','') as smalldatetime) else CAST(KSSJ as smalldatetime) end))<=1

