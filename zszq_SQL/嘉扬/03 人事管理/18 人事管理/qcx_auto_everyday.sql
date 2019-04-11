USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[qcx_auto_everyday]    Script Date: 02/11/2019 14:42:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[qcx_auto_everyday]  
as  
begin   
set nocount on  
 
 --更新带领导的人员花名册
delete from T_zs_employe_single  
  
insert into T_zs_employe_single  
select   
 case when belong=N'总部' then 1  
    when belong=N'营业部' then 2  
    when belong=N'分公司' then 3  
    when belong=N'子公司' then 4  
 end as belongorder,  
 case when depname=N'公司领导' then 1  
  when depname=N'人力资源部' then 2  
  else 200  
 end as deporder,  
 *   
from (  
  select 归属 belong,一级部门 depname,  
   count(*) countNum,  
   sum(case when 性别=N'男' then 1 else 0 end) man,  
   sum(case when 性别=N'女' then 1 else 0 end) woman,  
   dbo.fuc_getNmaeForDep(一级部门) listname  
  from zs_employee   
  where 员工状态 in(N'在职',N'试用')  
  group by 归属,一级部门  
 ) a  
  
  
  --更新不带领导的人员花名册
  delete from T_zs_employe_single_nohead  
  
insert into T_zs_employe_single_nohead  
select   
 case when belong=N'总部' then 1  
    when belong=N'营业部' then 2  
    when belong=N'分公司' then 3  
    when belong=N'子公司' then 4  
 end as belongorder,  
 case when depname=N'公司领导' then 1  
  when depname=N'人力资源部' then 2  
  else 200  
 end as deporder,  
 *   
from (  
  select 归属 belong,一级部门 depname,  
   count(*) countNum,  
   sum(case when 性别=N'男' then 1 else 0 end) man,  
   sum(case when 性别=N'女' then 1 else 0 end) woman,  
   dbo.fuc_getNmaeForDep_nohead(一级部门) listname  
  from zs_employee   
  where 员工状态 in(N'在职',N'试用')  
  group by 归属,一级部门  
 ) a  
  
  
  
end