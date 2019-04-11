USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[Psp_monthcollectQRTJ]    Script Date: 11/20/2017 13:31:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_monthcollectQRTJ]                                
@id int,                                  
@URID int,                                    
@RetVal int=0 OutPut                                     
as                                    
begin                          
  --0106begin                          
  declare @kpimonth smalldatetime,                  
   @badge varchar(20), --Add By Jimmy                
   @monthid int                
                             
  select @kpimonth=kpimonth from pProcess_month where id=(select monthID from pEmpProcess_Month where id=@id)                
  select @monthid=monthID from pEmpProcess_Month where id=@id                   
  select @badge=badge from pEmpProcess_Month where id=@id                          
  --0106end                      
  --提交校验 Add By Jimmy 3-18                  
  --没有当月工作计划                  
  if not exists (select 1 from PMONTH_PLAN where badge=@badge and monthid=@monthid)                  
  begin                  
 set @RetVal=1100036                  
 return @retval                  
  end                    
   --数据已经提交！                                             
 If Exists(Select 1 From pEmpProcess_Month                                       
    Where id=@id And Isnull(Initialized,0)=1                                 
   )                                            
 Begin                                            
  Set @RetVal = 1100007                                        
  Return @RetVal                                            
 End    --没有月工作小结                  
  if exists (select 1 from PMONTH_ASS where BADGE=@badge and MONTHSCOOP is null                  
 and MONTHID=(select id from pProcess_month                   
  where DATEDIFF(MM,kpimonth,DATEADD(MM,-1,(select kpimonth from PVW_MONTHCOLLECT1                   
   where badge=@badge)))=0 and ISNULL(submit,0)=1))                  
  begin                  
 set @RetVal=1100037                  
 return @retval                  
  end   
   --月度计划内容为空
   if exists (select 1 from PMONTH_PLAN where BADGE=@badge and monthtitle is null                  
 and MONTHID=@monthid)                 
  begin                  
 set @RetVal=1100049                  
 return @retval                  
  end   
 
                    
  --没有KPI进度                  
 /* if exists (select 1 from PMONTH_KPI where BADGE=@badge and KPIRATE is null                  
 and MONTHID=@monthid)                  
  begin                  
 set @RetVal=1100038                  
 return @retval                  
  end         */                    
  Begin TRANSACTION                                    
                                      
  update a                                
  set a.InitializedTime=GETDATE(),a.Initialized=1,a.SubmitTime=GETDATE(),pstatus=3                          
  from pEmpProcess_Month a                                
  where id=@id                                
                                      
  IF @@Error <> 0                                                         
  Goto ErrM                      
                      
  update a                                
  set a.InitializedTime=GETDATE(),a.Initialized=1,a.SubmitTime=GETDATE()                               
  from PMONTH_KPI a                                
  where monthid=(select monthid from pEmpProcess_Month where id=@id) and                               
  badge=(select badge from pEmpProcess_Month where id=@id)                                
                                      
  IF @@Error <> 0                                                         
  Goto ErrM                     
                      
  update a                                
  set a.InitializedTime=GETDATE(),a.Initialized=1,a.SubmitTime=GETDATE()                               
  from PMONTH_GS a                                
  where monthid=(select monthid from pEmpProcess_Month where id=@id) and                               
  badge=(select badge from pEmpProcess_Month where id=@id)                               
                                      
  IF @@Error <> 0                                                         
  Goto ErrM                              
                                
  update a
  set a.InitializedTime=GETDATE(),a.Initialized=1                                
  from PMONTH_PLAN a                                
  where monthid=(select monthid from pEmpProcess_Month where id=@id) and                               
  badge=(select badge from pEmpProcess_Month where id=@id)                              
                                      
  IF @@Error <> 0                                                         
  Goto ErrM                            
                              
  update a                              
  set a.InitializedTime=GETDATE(),a.Initialized=1                              
  from PMONTH_ASS a                              
  where monthid=(select id from pProcess_month where DATEDIFF(MM,kpimonth,DATEADD(MM,-1,@kpimonth))=0 and ISNULL(submit,0)=1)--0106                           
  and badge=(select badge from pEmpProcess_Month where id=@id)                           
                               
  IF @@Error <> 0                                                       
  Goto ErrM         
          
  --add20140527chap.lee        
  if @badge in (select badge from PEMPLOYEE_REGISTER where isnull(PEROLE,0) in (1,5))        
  begin        
          
  update a                  
  set a.ClosedTime=GETDATE(),a.Closed=1,a.pingfendate=GETDATE(),a.pstatus=5                
  from pEmpProcess_Month a                  
  where id=@id                  
                        
  IF @@Error <> 0                                           
  Goto ErrM                
                  
           
          
  end        
  --end20140527   

  insert into PMONTH_ASS(monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,remark,badge,monthid)                
    select monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,remark,badge,monthid                
    from PMONTH_PLAN                
    where monthid=(select monthid from pEmpProcess_Month where id=@id) and                 
    badge=(select badge from pEmpProcess_Month where id=@id) 
         
                  
  IF @@Error <> 0                                           
  Goto ErrM                                 
                                      
  COMMIT TRANSACTION                                                         
  Set @RetVal=0                                                                        
  Return @RetVal                                
                                            
   ErrM:                                                          
  ROLLBACK TRANSACTION                             
  If isnull(@RetVal,0)=0                                                                       
  Set @RetVal=-1                                                                        
  Return @RetVal                                           
                                            
end 