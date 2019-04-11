USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[eSP_ChangeOrgStart]    Script Date: 05/23/2018 08:58:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_ChangeOrgStart]  --eSP_ChangeOrgStart 2301,1                  
--skydatarefresh eSP_ChangeOrgStart                      
 @ID    int,                      
 @URID  int,                                  
 @RetVal  int=0 Output                                    
As                     
/*                     
-- Create By kayang                     
-- 调动管理的处理程序                    
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取                    
*/                    
Begin           
          
Declare @badge varchar(20)                                
                                  
 --数据还未确认!                                 
 If Exists(Select 1 From echangeorg_register                             
    Where ID=@ID And Isnull(Initialized,0)=0)                                  
 Begin                                  
  Set @RetVal = 910020                                  
  Return @RetVal                                  
 End                                  
                    
 ---人事调动的通用检查程序，处理程序重新检查，防止确认数据长时间不处理引起判断条件发生变化                                
 Exec eSP_changeorgchecksub @ID,@retval output                    
                                 
                           
 if @RetVal<>0                                  
 return @RetVal                                  
                                  
 Begin TRANSACTION                                 
                                
 --更新人事基本信息表eemployee                                  
 Update a                                  
 Set a.compid=b.new_compid,                            
  a.depid=b.new_depid,                            
  a.jobid=b.new_jobid,                            
  a.reportto=b.new_reportto ,                    
  a.wfreportto=b.new_wfreportto,              
  a.EmpGrade=b.new_EMPGRADE,              
  a.WorkCity=b.new_workcity                    
 From eemployee a,echangeorg_Register b                                  
 Where a.EID=b.EID and b.ID=@ID                                  
                   
                              
 If @@Error<>0                                  
 Goto ErrM        
         
 --更新人事状态        
 update a        
 set a.HRG=(select depemp from odepartment where depid=dbo.eFN_getdepid_XS(a.depid))        
 from eemployee a       
 where a.EID=(select EID from echangeorg_Register where ID=@ID)       
         
  IF @@Error <> 0                             
 Goto ErrM                      
                    
 ----更换岗位，更新新岗位开始日期                    
 update a                    
 set a.jobbegindate=convert(varchar(10),b.effectdate,120)                    
 from estatus a, echangeorg_Register b                    
 where a.eid=b.eid and b.jobid<>b.new_jobid and b.id=@id                              
                        
 If @@Error<>0                                  
 Goto ErrM                     
 ----更新兼任信息            
 update a            
 set a.ischange=0            
 from ePartOrg a,eChangeOrg_Register b            
 where a.EID=b.EID and b.ID=@ID and ISNULL(a.ischange,0)=1            
                         
 If @@Error<>0                                  
 Goto ErrM           
           
  /* 6.1                      
 插入干部管理                     
 create lizp                      
 */                
 --if exists(select 1 from eChangeOrg_Register where ID=@ID and new_JobID in (select JobID from oJob where isnull(JobType,0)=4))                
 --begin          
           
 --select @badge=badge from eChangeOrg_Register where ID=@ID               
 -- --职务上会                
 --insert into HPOSITIONW_REGIST(badge,name,compid,depid,depid2,jobid,status,joindate,rebby,rebdate)                
 --select badge,name,compid,dbo.eFN_getdepid(DepID),dbo.eFN_getdepid2(DepID),jobid,status,joindate,@URID,GETDATE()                
 --from eemployee a,eStatus b,eDetails c                      
 --where a.Badge=@badge and a.Status in (1,2,3) and a.EID=b.EID and a.EID=c.EID                
                 
 --  IF @@Error <> 0                        
 --GOTO ErrM                 
 ----高管资格                
 -- insert into EHIGHMANAGER_REGIST(badge,name,compid,depid,depid2,jobid,status,joindate,rebby,DEP_TITLE,DEP2_TITLE,JOB_TITLE)                
 --select badge,name,compid,dbo.eFN_getdepid(DepID),dbo.eFN_getdepid2(DepID),jobid,status,joindate,@URID                
 --,(select title from odepartment where DepID=dbo.eFN_getdepid(a.DepID))                
 --,(select title from odepartment where DepID=dbo.eFN_getdepid2(a.DepID))                
 --,(select title from ojob where JobID=a.JobID)                
 --from eemployee a,eStatus b,eDetails c                      
 --where a.Badge=@badge and a.Status in (1,2,3) and a.EID=b.EID and a.EID=c.EID                
                 
 --  IF @@Error <> 0                                                                              
 --GOTO ErrM                 
                 
 --end              

   ----员工调动，考核关系需重新设置
   update a
   set a.Initialized=0,a.InitializedTime=GETDATE(),a.KPIDEPID=b.new_depid
   from PEMPLOYEE_REGISTER a, echangeorg_Register b
   where a.eid=b.eid and b.id=@id
   -- 异常流程
   If @@Error<>0
   Goto ErrM

 ---插入历史表                            
 insert into eChangeOrg_All(ID,Type,EZID,EID,Badge,Name,CompID,DepID,JobID,Status,JoinDate,ReportTo,WfReportTo,New_CompID,                    
   New_DepID,New_JobID,New_ReportTo,New_WfReportTo,EffectDate,orgchangetype,RegBy,orgchangeReason,RegDate,Initialized,               
   EMPGRADE,new_EMPGRADE,new_workcity,depid2,                   
   InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,closed,closedBy,closedTime,Remark,SeqID      
   ,depid_title,depid2_title,new_depid_title,new_depid2_title)                            
 select  ID,Type,EZID,EID,Badge,Name,CompID,DepID,JobID,Status,JoinDate,ReportTo,WfReportTo,New_CompID,                    
   New_DepID,New_JobID,New_ReportTo,New_WfReportTo,EffectDate,orgchangetype,RegBy,orgchangeReason,RegDate,Initialized,               
   EMPGRADE,new_EMPGRADE,new_workcity,depid2,                        
   InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,1,@URID,getdate(),Remark,SeqID      
   ,(select title from odepartment where depid=a.depid) depid_title      
   ,(select title from odepartment where depid=a.depid2) depid2_title      
   ,(select title from odepartment where depid=dbo.eFN_getdepid(a.new_depid)) new_depid_title      
   ,(select title from odepartment where depid=dbo.eFN_getdepid2(a.new_depid)) new_depid2_title                   
 from echangeorg_register a                           
 where id=@id                            
                                 
 If @@Error<>0                                  
 Goto ErrM                              
                            
 -----记入事件表 ecd_eventtype                        
 insert into eEvent(Type,effectdate,EID,CompID,DepID,JobID,status,ReportTo,wfreportto,EmpType,EmpGrade,EmpCategory,EmpProperty,                    
    EmpGroup,EmpKind,WorkCity,Remark,EZID)                            
 select 4,a.effectdate,b.EID,b.CompID,b.DepID,b.JobID,b.status,b.ReportTo,b.wfreportto,b.EmpType,b.EmpGrade,b.EmpCategory,b.EmpProperty,                    
    b.EmpGroup,b.EmpKind,b.WorkCity,N'人事组织调动',b.EZID                            
 from echangeorg_register a ,eemployee b                    
 where a.id=@id and a.eid=b.eid                            
                            
 If @@Error<>0                                  
 Goto ErrM
 
	-- 薪酬调整
    ------ 新员工添加至薪酬调整表
    --Insert Into pChangeMDSalaryPerMM_register(EID,MDID,SalaryPerMM,WorkCityRatio,SalaryPerMMCity,SalaryPayID,SponsorAllowance,CheckUpSalary)
    --select a.EID,a.MDID,a.SalaryPerMM,(CASE when d.DepType in (2,3) then c.Ratio else 1 end),
    --ROUND(a.SalaryPerMM*(CASE when d.DepType in (2,3) then c.Ratio else 1 end),-2),a.SalaryPayID,a.SponsorAllowance,a.CheckUpSalary
    --From pEmployeeEmolu a,eemployee b,eCD_City c,odepartment d
    --Where a.EID=(select EID from ECHANGEORG_REGISTER where ID=@ID) and a.EID=b.EID and b.WorkCity=c.ID and b.DepID=d.DepID
    --and a.EID not in (select EID from pChangeMDSalaryPerMM_register)
    ---- 异常流程
    --If @@Error<>0
    --Goto ErrM                         
                    
                            
 -----删除登记表                            
 delete from echangeorg_register where id=@id                            
                    
 If @@Error<>0                 
 Goto ErrM                             
                            
 COMMIT TRANSACTION                      
                    
 Set @Retval = 0                                   
 Return @Retval                                    
                                    
ErrM:                     
ROLLBACK TRANSACTION                                    
Set @Retval = -1                    
Return @Retval                              
                                  
End 