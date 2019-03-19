USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[Psp_monthcollectQX]    Script Date: 11/20/2017 13:40:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_monthcollectQX]           
@id int,              
@URID int,                
@RetVal int=0 OutPut                 
as                
begin        
        
  --0106begin        
  declare @kpimonth smalldatetime        
  select @kpimonth=kpimonth from pProcess_month where id=(select monthID from pEmpProcess_Month where id=@id)          
  --0106end         
  --审核人已确认，不能取消！
  if exists (select 1 from pEmpProcess_Month where id=@id and ISNULL(Closed,0)=1)  
  begin  
 set @RetVal=1100045  
 return @retval  
  end        
               
  Begin TRANSACTION                
                  
  update a            
  set a.InitializedTime=null,a.Initialized=0            
  from pEmpProcess_Month a            
  where id=@id            
                  
  IF @@Error <> 0                                     
  Goto ErrM     
      
  update a            
  set a.InitializedTime=null,a.Initialized=0            
  from PMONTH_KPI a            
  where monthid=(select monthid from pEmpProcess_Month where id=@id)         
  and badge=(select badge from pEmpProcess_Month where id=@id)          
                  
  IF @@Error <> 0                                     
  Goto ErrM     
      
  update a            
  set a.InitializedTime=null,a.Initialized=0            
  from PMONTH_GS a            
  where monthid=(select monthid from pEmpProcess_Month where id=@id)         
  and badge=(select badge from pEmpProcess_Month where id=@id)          
                  
  IF @@Error <> 0                                     
  Goto ErrM          
            
  update a            
  set a.InitializedTime=null,a.Initialized=0            
  from PMONTH_PLAN a            
  where monthid=(select monthid from pEmpProcess_Month where id=@id)         
  and badge=(select badge from pEmpProcess_Month where id=@id)          
                  
  IF @@Error <> 0                                     
  Goto ErrM           
            
  update a            
  set a.InitializedTime=null,a.Initialized=0            
  from PMONTH_ASS a            
  where monthid=(select id from pProcess_month where DATEDIFF(MM,kpimonth,DATEADD(MM,-1,@kpimonth))=0 and ISNULL(submit,0)=1)--0106         
  and badge=(select badge from pEmpProcess_Month where id=@id)          
                  
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