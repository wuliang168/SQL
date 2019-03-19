USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Hpositionw_regist_CL]
@id int,
@urid int,
@RetVal Int =0 OUTPUT

As
/*                                                                                                                                
-- Create By wuliang E004205          
*/               
begin
--限制！
 --If Exists(Select 1 From Hpositionw_regist
 --Where ID=@ID And name is null )
 --Begin
 -- Set @RetVal = 910020
 -- Return @RetVal
 --End

 Begin TRANSACTION


 declare @eid int

 select @eid=eid
 from eemployee a,Hpositionw_regist b
 where a.Badge=b.badge and b.id=@id and isnull(b.directortype,N'')=N'第一负责人'

 update a
 set a.DepID=b.Adepid,a.JobID=b.Ajob
 from eemployee a,Hpositionw_regist b
 where a.Badge=b.badge and b.id=@id

    IF @@Error <> 0                                                                                                                                                     
 GOTO ErrM

 update a
 set a.director=(select eid from eemployee where badge=b.badge)
 from odepartment a,Hpositionw_regist b
 where a.DepID=b.Adepid and b.id=@id and isnull(b.directortype,N'')=N'第一负责人'

 IF @@Error <> 0
 GOTO ErrM

  update a
 set a.director1=(select eid from eemployee where badge=b.badge)
 from odepartment a,Hpositionw_regist b
 where a.DepID=b.Adepid and b.id=@id and isnull(b.directortype,N'')=N'第二负责人'

 IF @@Error <> 0
 GOTO ErrM

 insert into Hpositionw_all
 select *
 from Hpositionw_regist
 where id=@id

   IF @@Error <> 0
 GOTO ErrM

 --给BS权限
 if ISNULL(@eid,0)<>0  
 begin  
  delete skysecrolemember where URID=(select ID from skysecuser                                   
 where EID=@eid) and RUID not in (1000,1008,1009,1010,1011,1012,1013,1016)  
  
 IF @@Error <> 0                                                        
 Goto ErrM                                     
                                   
  delete skySecRoleMemberMaker where URID=(select ID from skysecuser                                   
 where EID=@eid) and RUID not in (1000,1008,1009,1010,1011,1012,1013,1016)     
     
 IF @@Error <> 0                                                        
   Goto ErrM   
    
  insert into dbo.skySecRoleMemberMaker(ruid,urid,hrid,xOrder)                                                                                  
   select 1017,id,1,null   
   from dbo.skysecuser a  
   where a.EID=@eid  
   and not exists (select 1 from skySecRoleMemberMaker where ruid=1017 and urid=a.id)  
     
   IF @@Error <> 0                                                        
      Goto ErrM  
        
      insert into dbo.skysecrolemember(id,ruid,urid,hrid,xOrder)                                                                                  
   select id,ruid,urid,hrid,xOrder                                                          
   from dbo.skySecRoleMemberMaker                                                                                   
   where id not in (select id from dbo.skysecrolemember)    
       
   IF @@Error <> 0                                                        
   Goto ErrM   
     
   ---提交生效        
  Update skySecUser Set Submit=1,SubmitTime=getdate() Where ID in (select ID from skySecUser where EID=@eid)       
          
                   
  Set @RetVal=111222                  
  Insert skySecRoleMember_All(ADID,xTime,HRID,RUID,URID,FCID,xOrder,Remark)                  
  Select 1,getdate(),HRID,RUID,URID,FCID,xOrder,Remark            
    From skySecRoleMember                  
    Where URID in (select ID from skySecUser where EID=@eid)                  
  If @@error<>0 Goto ErrM                  
                    
  Set @RetVal=111223                  
  Delete From skySecRoleMemberAgent Where RMID In (Select ID From skySecRoleMember Where URID in (select ID from skySecUser where EID=@eid))            
  Delete From skySecRoleMember Where URID in (select ID from skySecUser where EID=@eid)                  
  If @@error<>0 Goto ErrM                  
                   
  Set @RetVal=111224                  
  Insert skySecRoleMember(ID,HRID,RUID,URID,FCID,xOrder,Remark)              
  Select ID,HRID,RUID,URID,FCID,xOrder,Remark            
   From skySecRoleMemberMaker                  
    Where URID in (select ID from skySecUser where EID=@eid)                  
  If @@error<>0 Goto ErrM                  
             
  Insert skySecRoleMemberAgent(RMID,ZoneKey,ZoneID)              
  Select RMID,ZoneKey,ZoneID            
   From skySecRoleMemberAgentMaker                  
    Where RMID In (Select ID  From skySecRoleMemberMaker Where URID in (select ID from skySecUser where EID=@eid))            
  If @@error<>0 Goto ErrM                  
                 
  --用于给用户赋予对象列权限           
  Delete from skySecUserDataPermission Where URID in (select ID from skySecUser where EID=@eid);          
  Insert Into skySecUserDataPermission(URID,HRID,ObjName,ColName,DenyOpen,DenyUpdate,DenyAddNew,DenyDelete,Remark)          
   Select URID,HRID,ObjName,ColName,DenyOpen,DenyUpdate,DenyAddNew,DenyDelete,Remark           
    From skySecUserDataPermissionMaker Where URID in (select ID from skySecUser where EID=@eid);          
  --          
           
 Update skySecUser Set Submit=0,SubmitTime=getdate() Where ID in (select ID from skySecUser where EID=@eid)  
    
 end   
       
 delete from Hpositionw_regist where id=@id       
       
 IF @@Error <> 0                                                                                                                                                     
 GOTO ErrM            
              
COMMIT TRANSACTION                                                                                                      
 Set @Retval = 0                   
 Return @Retval                                                    
                                                                                                                
 ErrM:                                                           
 ROLLBACK TRANSACTION                                                                                                                     
 Set @Retval = -1                                                                                                                  
Return @Retval                                           
                                                  
End