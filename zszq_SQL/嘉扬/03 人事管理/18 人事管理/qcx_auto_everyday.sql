USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[qcx_auto_everyday]  
   @RetVal int=0 Output
as  
begin   
   set nocount on 

   Begin TRANSACTION 
 
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
  
   -- 更新在职员工离岗日期
   update b
   set b.LeaDate=NULL
   from eEmployee a,eStatus b 
   where a.EID=b.EID and a.Status not in (4,5) and b.LeaDate is not NULL
   -- 异常流程
   If @@Error<>0
   Goto ErrM

   -- 递交
   COMMIT TRANSACTION

   -- 正常处理流程
   Set @Retval = 0
   Return @Retval

   -- 异常处理流程
   ErrM:
   ROLLBACK TRANSACTION
   Set @Retval = -1
   Return @Retval
  
end