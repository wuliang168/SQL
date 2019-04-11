USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[Psp_monthGB]    Script Date: 03/06/2017 09:38:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_monthGB]                     
@id int,                        
@URID int,                        
@RetVal int=0 OutPut                         
as                        
begin            
            
   --该月已关闭，不用重复点击！                                   
 If Exists(Select 1 From pProcess_month                             
    Where ISNULL(Submit,0)=1 and isnull(id,0)=@id and enddate is not null                         
   )                                  
 Begin                                  
  Set @RetVal = 1100042                              
  Return @RetVal                                  
 End         
           
   --0106begin              
  --部门负责人直接完成              
  update a              
  set a.Closed=1,a.ClosedTime=GETDATE()              
  from pEmpProcess_Month a              
  where badge in (select badge from eemployee where EID in (select DIRECTOR from ODEPARTMENT where DIRECTOR is not null))              
                
  IF @@Error <> 0                                                       
  Goto ErrM               
  --0106end             
                    
                  
     --存在未完成员工不允许关闭！                                   
 If Exists(Select 1 From pEmpProcess_Month                             
    Where ISNULL(Closed,0)=0 and isnull(monthid,0)=@id                          
   )                                  
 Begin                                  
  Set @RetVal = 1000012                              
  Return @RetVal                                  
 End                                            
                       
  Begin TRANSACTION                     
                      
  update a                    
  set a.Submit=1,a.SubmitTime=GETDATE(),enddate=GETDATE(),eidclose=@URID                    
  from pProcess_month a                    
  where a.id=@id                    
                        
  IF @@Error <> 0                                             
  Goto ErrM           
   -- insert into PMONTH_ASS(monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,remark,badge,monthid)            
 -- select monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,remark,badge,monthid            
 -- from PMONTH_PLAN            
 -- where monthid=@id     
      
  --  IF @@Error <> 0                                             
 -- Goto ErrM                
  --绩效节点数生成 Add By Jimmy                        
  --declare @processid int                        
  --select @processid=pProcessID from pProcess_month where id=@id                       
                  
  --delete from SkyPAFormConfig where xyear=@processid and xtype=4                      
                        
  --  IF @@Error <> 0                                                     
  --  Goto ErrM                          
                            
  --insert into SkyPAFormConfig(xyear,PID,id,XID,xorder,title,xtype,URL,remark,Condition,beforeorafter)                        
  --select @processid,cast (c.EID as varchar),cast (@processid as varchar)+cast (EID as varchar)+cast (a.id as varchar),                        
  --case when xid <> 0 then cast (@processid as varchar)+cast (EID as varchar)+cast (XID as varchar) else 0 end,                        
  --a.xorder,a.title,a.xtype,a.URL,a.remark,'select {U_EID}',beforeorafter                        
  --from pAFormConfig a,pEmpProcess_Month b,pEmployee c,pAForm_Role d                        
  --where b.badge=c.Badge and a.xtype=4 and a.beforeorafter=2 and c.perole=d.Roleid and d.Formid=a.id                        
  --and d.isUsed=1 and b.monthID=@id                   
  --and cast (@processid as varchar)+cast (EID as varchar)+cast (a.id as varchar) not in (select id from SkyPAFormConfig)                  
                            
  COMMIT TRANSACTION                                             
  Set @RetVal=0                                                            
  Return @RetVal                               
                                
   ErrM:                                              
  ROLLBACK TRANSACTION                                                      
  If isnull(@RetVal,0)=0                                                           
  Set @RetVal=-1                                                         
  Return @RetVal                               
                                
end