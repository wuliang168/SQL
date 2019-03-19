USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[eSP_AutoProbStart]    Script Date: 02/11/2019 14:43:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--转正自动任务    
ALTER proc [dbo].[eSP_AutoProbStart]    
@RetVal int=0 output    
as    
begin    
     
 ---用于存储当前满足自动转正的员工信息    
 create table #eStatus_Prob    
 (    
  id int identity(1,1),    
  eid int primary key,    
  joindate smalldatetime,    
  isProb bit,    
  ProbTerm int,    
  ProbEndDate smalldatetime,    
  ProbConfDate smalldatetime    
 )    
     
 Begin TRANSACTION           
     
   ---把符合自动转正的员工放入临时表    
   insert into #eStatus_Prob(eid,joindate,isProb,ProbTerm,ProbEndDate,ProbConfDate)    
   select a.eid,a.JoinDate,a.isProb,a.ProbTerm,a.ProbEndDate,a.ProbConfDate from eStatus a,eemployee b    
   where ISNULL(a.isProb,0)=1 and a.EID=b.EID
   and b.Status not in (4,5)    
   and DATEDIFF(DAY,GETDATE(),isnull(ProbEndDate,'2049-12-31'))<=-1    
      
   If @@Error<>0            
   Goto ErrM        
       
   ---更新临时表信息    
   update #eStatus_Prob set isProb=0,ProbConfDate=DATEADD(day,1,ProbEndDate)    
       
   If @@Error<>0            
   Goto ErrM     
    
   ---更新状态表     
   update a    
   set a.isProb=b.isProb,    
  a.ProbConfDate=b.ProbConfDate    
   from estatus a,#eStatus_Prob b     
   where a.eid=b.eid 
      
    
   If @@Error<>0            
   Goto ErrM     
      update a    
   set a.Status=1   
   from eemployee a,#eStatus_Prob b     
   where a.eid=b.eid 
     
   If @@Error<>0            
   Goto ErrM     
  
     
   ---插入人事事件表    
   Insert Into eevent(Type,effectdate,EID,CompID,DepID,JobID,status,ReportTo,wfreportto,EmpType,EmpGrade,EmpCategory,        
       EmpProperty,EmpGroup,EmpKind,WorkCity,Remark,EZID)          
   select 2,a.ProbConfDate,b.EID,b.CompID,b.DepID,b.JobID,b.status,b.ReportTo,b.wfreportto,b.EmpType,b.EmpGrade,b.EmpCategory,        
       b.EmpProperty,b.EmpGroup,b.EmpKind,b.WorkCity,N'人事试用转正（自动任务）',b.EZID        
   from #eStatus_Prob a,eemployee b          
   where a.eid=b.eid    
          
   If @@Error<>0            
   Goto ErrM     
       
       
   /*  
   **存入历史  
   **1.先在登记表中生成ID  
   **2.存入到历史表  
   */  
   ---先在登记表中生成ID，然后插入到历史表中  
   delete from eProb_register where type=2 and eid in(select eid from #eStatus_Prob)  
     
   insert into eProb_register(eid,type)  
   select eid,2 from #eStatus_Prob  
     
     
   --存入历史          
   Insert Into eProb_all(id,type,EZID,eid,badge,name,compid,depid,depid2,jobid,Status,joindate,isProb,Probterm,Probenddate,        
          effectdate,Result,regby,regdate,initialized,initializedby,initializedtime,        
       submit,submitby,submitTime,closed,closedby,closedTime,remark        
   )            
   Select c.id,2,b.EZID,b.EID,b.Badge,b.Name,b.CompID,b.DepID,dbo.efn_getdepid(b.DepID),b.JobID,b.Status,    
   a.joindate,a.isProb,a.ProbTerm,a.ProbEndDate,a.ProbConfDate,1,1,GETDATE(),1,1,GETDATE(),        
       1,1,GETDATE(),1,1,GETDATE(),N'人事试用转正（自动任务）'        
   From #eStatus_Prob a,eemployee b,eProb_register c where a.eid=b.EID  and a.eid=c.eid and c.type=2    
       
   If @@Error<>0            
   Goto ErrM            
    
 COMMIT TRANSACTION          
           
 Set @Retval = 0             
 Return @Retval              
              
ErrM:              
Set @Retval = -1              
ROLLBACK TRANSACTION              
Return @Retval      
    
end    
    
    

