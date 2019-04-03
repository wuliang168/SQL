USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[bs_DK_Start]    Script Date: 01/03/2017 08:32:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[bs_DK_Start]          
@eid int,          
@RetVal int=0 output          
as          
begin          
           
 declare @ip varchar(50)          
           
 select @ip=SUBSTRING(LocalUser,19,LEN(localuser)) from skySecUserLog a,skySecUser b           
 where a.URID=b.ID and b.EID=@eid and CONVERT(VARCHAR(20),a.OPData)=N'v8bs' and a.OPText='login ok'         
 and a.ID=(select MAX(ID) from skySecUserLog where URID=b.ID and CONVERT(VARCHAR(20),a.OPData)=N'v8bs')          
     
 if LEN(@ip)=0    
 begin    
 select @ip=SUBSTRING(HostName,1,LEN(HostName)-1) from skySecUserLog a,skySecUser b           
 where a.URID=b.ID and b.EID=@eid and CONVERT(VARCHAR(20),a.OPData)=N'v8bs' and a.OPText='login ok'         
 and a.ID=(select MAX(ID) from skySecUserLog where URID=b.ID and CONVERT(VARCHAR(20),a.OPData)=N'v8bs')    
 end    
          

          
 ---重复IP          
/* if exists(select 1 from BS_DK_time where DATEDIFF(DAY,term,GETDATE())=0 and ip=@ip  and eid<>@eid           
 and DATEPART(HOUR,GETDATE()) between 0 and 13 and @ip<>'10.51.60.29' and @ip<>'10.51.60.28')          
 begin          
  set @RetVal=999009          
  return @RetVal           
 end    */      
           
           
 ---重复IP          
 /*if exists(select 1 from BS_DK_time where DATEDIFF(DAY,term,GETDATE())=0 and ip=@ip and eid<>@eid           
 and DATEPART(HOUR,GETDATE()) between 13 and 24 
 and @ip<>'10.51.60.29'        
 and @ip<>'10.51.60.28')       
 
 begin          
  set @RetVal=999010          
  return @RetVal           
 end           */
          
 ---存在早上的打卡记录          
 if exists(select 1 from BS_DK_time where eid=@eid           
 and datediff(day,getdate(),beginTime)=0           
 and DATEPART(HOUR,GETDATE()) between 0 and 13           
 )          
 begin          
  set @RetVal=999008          
  return @RetVal          
 end          
           
 ---下午已打卡          
 if exists(select 1 from BS_DK_time where eid=@eid           
 and datediff(day,getdate(),endTime)=0           
 and DATEPART(HOUR,GETDATE()) between 13 and 24 )          
 begin          
  set @RetVal=999011          
  return @RetVal            
 end       
           
           
 --insert into skyMSGAlarm(ID,Title)          
 --select 999011,N'您下午已打卡！'          
          
           
 ---新增打卡数据          
 if not exists(select 1 from BS_DK_time where DATEDIFF(DAY,term,GETDATE())=0           
  and eid=@eid )          
  and DATEPART(HOUR,GETDATE()) between 0 and 13          
 begin          
  insert into BS_DK_time(term,termType,eid,badge,name,ip,beginTime)          
  select convert(varchar(10),GETDATE(),120),a.xType,b.EID,b.Badge,b.Name,@ip,GETDATE()            
  from lCalendar a,eemployee b where DATEDIFF(DAY,Term,GETDATE())=0 and b.EID=@eid          
          
 end          
           
           
 update BS_DK_time set endTime=GETDATE() where DATEPART(HOUR,GETDATE()) between 13 and 24          
 and eid=@eid and DATEDIFF(DAY,term,GETDATE())=0          
           
            
 ---新增下班打卡数据          
 if not exists(select 1 from BS_DK_time where DATEDIFF(DAY,term,GETDATE())=0 and eid=@eid)          
 and DATEPART(HOUR,GETDATE()) between 13 and 24          
 begin          
  insert into BS_DK_time(term,termType,eid,badge,name,ip,endTime)          
  select convert(varchar(10),GETDATE(),120),a.xType,b.EID,b.Badge,b.Name,@ip,GETDATE()            
  from lCalendar a,eemployee b where DATEDIFF(DAY,Term,GETDATE())=0 and b.EID=@eid          
 end          
           
 set @RetVal=0          
 return @RetVal          
           
           
end