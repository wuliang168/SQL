-- pVW_pYearMDSalaryModifyDep

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYearMDSalaryModifyDep]
AS

---- 浙商证券(非分支机构，不含投资银行)
select a.DepID as SupDepID,a.DepID as DepID,a.Director as Director,a.xOrder as xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.CompID=11 and ISNULL(a.AdminID,0) not in (695,715) 
and a.DepType=1 and a.DepGrade=1 and ISNULL(a.ISOU,0)=0 and a.DepID<>349

---- 财富管理
UNION
select a.DepID as SupDepID,a.DepID as DepID,a.Director as Director,a.xOrder as xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.CompID=11 and ISNULL(a.DepID,0)=715 and a.DepType=1 and a.DepGrade=1

---- 投资银行
UNION
select a.DepID as SupDepID,a.DepID as DepID,1276 as Director,a.xOrder as xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.CompID=11 and ISNULL(a.DepID,0)=695 and a.DepType=1 and a.DepGrade=1

---- 浙商资管
UNION
select a.DepID as SupDepID,a.DepID as DepID,1245 as Director,a.xOrder as xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.CompID=13 and DepID=393

---- 浙商资本
UNION
select a.DepID as SupDepID,a.DepID as DepID,1906 as Director,a.xOrder as xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.CompID=12 and DepID=392

---- 分支机构
UNION
select a.DepID as SupDepID,a.DepID as DepID,a.Director as Director,a.xOrder as xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and a.CompID=11 and a.DepType in (2,3) and a.DepGrade=1

---- 区域财务(虚拟)
UNION
select a.AdminID as SupDepID,a.DepID as DepID,dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(a.DepID)) as Director,a.xOrder as xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and ISNULL(a.DepID,0)=733

---- 合规风控(虚拟)
UNION
select a.AdminID as SupDepID,a.DepID as DepID,dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(a.DepID)) as Director,a.xOrder as xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and ISNULL(a.DepID,0)=732

---- 分支机构经理(虚拟)
UNION
select a.AdminID as SupDepID,a.DepID as DepID,dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(a.DepID)) as Director,a.xOrder as xOrder
from oDepartment a
where ISNULL(a.isDisabled,0)=0 and ISNULL(a.DepID,0)=736

Go