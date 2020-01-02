USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[eSP_LeaveStart]    Script Date: 09/15/2017 11:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_LeaveStart]
--skydatarefresh eSP_LeaveStart
 @ID    int,
 @URID  int,
 @RetVal  int=0 Output
As
/*
-- Create By kayang
-- 离退管理的处理程序，根据type字段分别处理 1-离职|2- 退休
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
    Declare @type int,@EID int

    Select @type=type,@EID=EID from eleave_register where ID=@ID


    --数据还未确认
    If Exists(Select 1 From eleave_register  Where ID=@ID And Isnull(Initialized,0)=0)
    Begin
        Set @RetVal = 910020
        Return @RetVal
    End
              
 --合同自动解除，判断该员工是否存在合同管理登记表中              
 if Exists(Select 1 From eleave_register a  Where a.ID=@ID And isnull(a.isEndCon,0)=1)                        
 Begin              
  --记录合同解除历史              
              
  If exists (Select 1 from eContract_register Where EID=@EID)              
  Begin              
   Set @retval=920100              
   return @Retval
  End               
              
 end                    
                  
 ---离退的通用检查程序，重新检查防止数据确认之后长时间不处理，判断条件发生变化                       
 Exec esp_leavechecksub @ID,@retval output                        
              
 If @RetVal<>0                        
 Return @RetVal                        
              
                        
Begin TRANSACTION

    -- 年金
    ------ 后台转前台；离职类型为16：转为业务前台
    ------ 投理顾中未出现
    --IF Exists (select 1 from eleave_register a,eDetails b
    --where a.ID=@ID and a.leaveType in (5) and a.EID=b.EID and b.CertNo not in (select Identification from pSalesDepartMarketerEmolu))
    --Begin
    --    insert into pSalesDepartMarketerEmolu(Name,Gender,Identification,Status,CompID,SupDepID,DepID,JobID,AdminID,SalaryPerMM,SalaryPayID,
    --    IsPension,IsPensionConfirm,PensionTaxMinus,GrpPensionYearRest,EmpPensionYearRest,GrpPensionFrozen,EmpPensionFrozen,GrpPensionTotal,EmpPensionTotal,
    --    JoinDate,JoinGrpDate,LeaveDate,IsConfirm,Remark)
    --    select b.Name,b.Gender,b.CertNo,1,b.CompID,b.DepID1,b.DepID2,
    --    (select JobID from oJob where ISNULL(DepID1st,0)=ISNULL(b.DepID1,0) and ISNULL(DepID2nd,0)=ISNULL(b.DepID2,0) and JobAbbr=N'投理顾' and ISNULL(isDisabled,0)=0),
    --    30,NULL,6,b.IsPension,1,NULL,b.GrpPensionYearRest,b.EmpPensionYearRest,b.GrpPensionFrozen,b.EmpPensionFrozen,b.GrpPensionTotal,b.EmpPensionTotal,b.JoinDate,NULL,NULL,1,NULL
    --    from eleave_register a,PVW_PEMPEMOLU b
    --    where a.ID=@ID and a.EID=b.EID
    --    -- 异常流程
    --    If @@Error<>0
    --    Goto ErrM
    --End
    ------ 投理顾中出现
    --IF Exists (select 1 from eleave_register a,eDetails b
    --where a.ID=@ID and a.leaveType in (5) and a.EID=b.EID and b.CertNo in (select Identification from pSalesDepartMarketerEmolu))
    --Begin
    --    update c
    --    set c.Status=1,c.CompID=c.CompID,c.SupDepID=dbo.eFN_getdepid1st(b.DepID1),c.DepID=dbo.eFN_getdepid2nd(b.DepID2),
    --    c.JobID=(select JobID from oJob where ISNULL(DepID1st,0)=ISNULL(b.DepID1,0) and ISNULL(DepID2nd,0)=ISNULL(b.DepID2,0) and JobAbbr=N'投理顾' and ISNULL(isDisabled,0)=0),
    --    c.IsPension=b.IsPension,c.IsPensionConfirm=1,c.LeaveDate=NULL,c.IsConfirm=1,c.GrpPensionFrozen=b.GrpPensionFrozen,c.EmpPensionFrozen=b.EmpPensionFrozen
    --    from eleave_register a,PVW_PEMPEMOLU b,pSalesDepartMarketerEmolu c
    --    where a.ID=@ID and a.EID=b.EID and b.CertNo=c.Identification
    --    -- 异常流程
    --    If @@Error<>0
    --    Goto ErrM
    --End
    
              
 --离职              
 IF @type=1               
 Begin              
               
  ---更新员工状态为离职                  
  update a                  
   set a.status=4              
  from eemployee a,eleave_register b                  
  where a.eid=b.eid and b.id=@id and b.leavetype<>4                  
              
  If @@Error<>0                        
  Goto ErrM          
          
  ---更新员工状态为退休        
  update a                  
   set a.status=5              
  from eemployee a,eleave_register b                  
  where a.eid=b.eid and b.id=@id and b.leavetype=4                 
              
  If @@Error<>0                        
  Goto ErrM                   
              
  --更新人事状态表eStatus的离职相关字段                        
  Update a                        
  Set a.isleave=1,                  
   a.leadate=convert(varchar(10),b.leavedate,120),                  
   a.leatype=b.leavetype,                  
   a.leareason=b.leavereason,              
   a.isblacklist=b.isblacklist                  
  From eStatus a,eleave_Register b                        
  Where a.EID=b.EID and b.ID=@ID                        
              
  If @@Error<>0                        
  Goto ErrM                        
                       
  --同步解除合同，自动处理合同相关              
  if Exists(Select 1 From eleave_register a,estatus b                  
    Where a.ID=@ID And a.eid=b.eid And isnull(a.isEndCon,0)=1 and isnull(conCount,0)<>0)                        
  Begin              
              
   --记录合同解除历史              
              
   Delete From eContract_register where EID=@EID              
              
   Insert Into eContract_register(type,EID,Badge,Name,compid,DepID,jobid,conCount,contract,contype,conProperty,conNo,              
     conBeginDate,conTerm,conEndDate,effectDate,reason,RegBy,RegDate,Initialized,initializedby,              
     InitializedTime,Submit,submitby,SubmitTime,closed,closedby,closedTime,EZID)                      
   Select 5,b.EID,c.Badge,c.Name,c.compid,c.DepID,c.jobid,b.conCount,b.contract,b.contype,b.conProperty,b.conNo,              
     b.conBeginDate,b.conTerm,b.conEndDate,a.leaveDate,N'离职自动解除合同',@URID,getdate(),1,@URID,              
     getdate(),1,@URID,getdate(),1,@URID,getdate(),a.EZID                     
   From eleave_register a , estatus b ,eemployee c                
   Where a.ID=@ID  And a.EID=b.EID And b.EID=c.EID              
              
   If @@Error<>0                        
   Goto ErrM               
              
   Insert Into eContract_all(ID,type,EID,Badge,Name,compid,DepID,jobid,conCount,contract,contype,conProperty,conNo,              
     conBeginDate,conTerm,conEndDate,effectDate,reason,RegBy,RegDate,Initialized,initializedby,              
     InitializedTime,Submit,submitby,SubmitTime,closed,closedby,closedTime,EZID)                      
   Select ID,type,EID,Badge,Name,compid,DepID,jobid,conCount,contract,contype,conProperty,conNo,              
     conBeginDate,conTerm,conEndDate,effectDate,reason,RegBy,RegDate,Initialized,initializedby,              
     InitializedTime,Submit,submitby,SubmitTime,closed,closedby,closedTime,EZID                     
   From eContract_register                     
   Where EID=@EID              
              
   If @@Error<>0                        
   Goto ErrM               
              
   Delete from eContract_register Where EID=@EID              
              
   --更新人事状态表 estatus              
   update a                  
   set a.ConCount=null,                  
    a.Contract=null,                
    a.contype=null,                
    a.ConProperty=null,                 
    a.ConNo=null,                     
    a.ConBeginDate=null,                  
    a.ConTerm=null,                  
    a.ConEndDate=null                  
   from estatus a,eleave_register b                  
   where a.eid=b.eid and b.id=@id                  
                   
   If @@Error<>0                        
   Goto ErrM              
              
  end                  
 End              
              
 --退休              
 IF @type=2              
 Begin              
               
  ---更新员工状态为退休                
  update a                  
   set a.status=5              
  from eemployee a,eleave_register b                  
  where a.eid=b.eid and b.id=@id                  
              
  If @@Error<>0                        
  Goto ErrM 

  -- 更新发薪类型为退休
  update a
  set a.SalaryPayID=8
  from pEmployeeEmolu a,eleave_register b
  where a.eid=b.eid and b.id=@id
  -- 异常流程
  If @@Error<>0
  Goto ErrM
              
  --更新人事状态表eStatus的离职相关字段                        
  Update a                        
  Set a.isleave=1,                  
   a.leadate=convert(varchar(10),b.leavedate,120)                 
  From eStatus a,eleave_Register b                        
  Where a.EID=b.EID and b.ID=@ID                        
              
  If @@Error<>0                        
  Goto ErrM                        
                       
  --同步解除合同，自动处理合同相关              
              
  --记录合同解除历史              
              
  Delete From eContract_register where EID=@EID              
              
  Insert Into eContract_register(type,EID,Badge,Name,compid,DepID,jobid,conCount,contract,contype,conProperty,conNo,              
    conBeginDate,conTerm,conEndDate,effectDate,reason,RegBy,RegDate,Initialized,initializedby,              
    InitializedTime,Submit,submitby,SubmitTime,closed,closedby,closedTime,EZID)                      
  Select 5,b.EID,c.Badge,c.Name,c.compid,c.DepID,c.jobid,b.conCount,b.contract,b.contype,b.conProperty,b.conNo,              
    b.conBeginDate,b.conTerm,b.conEndDate,a.leaveDate,N'退休自动解除合同',@URID,getdate(),1,@URID,              
    getdate(),1,@URID,getdate(),1,@URID,getdate(),a.EZID                     
  From eleave_register a , estatus b ,eemployee c                       
  Where a.ID=@ID  And a.EID=b.EID And b.EID=c.EID              
              
  If @@Error<>0                        
  Goto ErrM               
              
  Insert Into eContract_all(ID,type,EID,Badge,Name,compid,DepID,jobid,conCount,contract,contype,conProperty,conNo,              
    conBeginDate,conTerm,conEndDate,effectDate,reason,RegBy,RegDate,Initialized,initializedby,              
    InitializedTime,Submit,submitby,SubmitTime,closed,closedby,closedTime,EZID)                      
  Select ID,type,EID,Badge,Name,compid,DepID,jobid,conCount,contract,contype,conProperty,conNo,              
    conBeginDate,conTerm,conEndDate,effectDate,reason,RegBy,RegDate,Initialized,initializedby,              
    InitializedTime,Submit,submitby,SubmitTime,closed,closedby,closedTime,EZID                     
  From eContract_register                     
  Where EID=@EID              
              
  If @@Error<>0                        
  Goto ErrM               
              
  Delete from eContract_register Where EID=@EID              
                  
  --更新人事状态表 estatus              
  update a                  
  set a.ConCount=null,                  
   a.Contract=null,                  
   a.contype=null,                
   a.ConProperty=null,                 
   a.ConNo=null,                     
   a.ConBeginDate=null,                  
   a.ConTerm=null,                  
   a.ConEndDate=null                  
  from estatus a,eleave_register b                  
  where a.eid=b.eid and b.id=@id                  
                  
  If @@Error<>0                        
  Goto ErrM              
                 
 End     
     
 --更新绩效中状态    
 update a     
 set a.Status=b.Status,a.pstatus=2    
 from pEmployee a,eemployee b    
 where a.EID=b.EID and b.EID=(select EID from eleave_register where id=@ID)    
     
  IF @@Error <> 0                                                                              
 Goto ErrM     
     
  update a     
 set a.Status=b.Status,a.pstatus=2    
 from PEMPLOYEE_CHANGE a,eemployee b    
 where a.EID=b.EID and b.EID=(select EID from eleave_register where id=@ID)    
     
  IF @@Error <> 0                                                                              
 Goto ErrM     
     
  update a     
 set a.Status=b.Status,a.pstatus=2    
 from PEMPLOYEE_REGISTER a,eemployee b    
 where a.EID=b.EID and b.EID=(select EID from eleave_register where id=@ID)    
     
  IF @@Error <> 0                                                                              
 Goto ErrM     
     
 --将绩效流程中数据结束    
 --KPI制定    
  update a     
 set a.Closed=1,a.ClosedTime=GETDATE(),a.pstatus=5  
 from PEMPPROCESS_KPI a    
 where a.badge=(select badge from eleave_register where id=@ID) and ISNULL(a.Closed,0)=0    
     
  IF @@Error <> 0                                                                              
 Goto ErrM      
     
 --KPI调整    
  update a     
 set a.kaiqi=0    
 from PEMPLOYEE_CHANGE_KPI a    
 where a.badge=(select badge from eleave_register where id=@ID) and ISNULL(a.Closed,0)=0    
     
  IF @@Error <> 0                                                                              
 Goto ErrM     
     
 --KPI月度流程    
  update a     
 set a.Closed=1,a.ClosedTime=GETDATE(),a.pstatus=5   
 from PEMPPROCESS_MONTH a    
 where a.badge=(select badge from eleave_register where id=@ID) and ISNULL(a.Closed,0)=0    
     
  IF @@Error <> 0                                                                              
 Goto ErrM      
     
 --KPI半年度流程    
  update a     
 set a.Closed=1,a.ClosedTime=GETDATE(),a.pstatus=5   
 from PEMPPROCESS_HALFYEAR a    
 where a.badge=(select badge from eleave_register where id=@ID) and ISNULL(a.Closed,0)=0    
     
  IF @@Error <> 0                                                                              
 Goto ErrM     
     
 --KPI本年度流程    
  update a     
 set a.Closed=1,a.ClosedTime=GETDATE(),a.pstatus=5    
 from pEmpProcess_Year a    
 where a.badge=(select badge from eleave_register where id=@ID) and ISNULL(a.Closed,0)=0    
     
  IF @@Error <> 0                                                                              
 Goto ErrM     
                  
              
 ---记录离职历史               
 insert into eleave_all(id,type,eid,badge,name,compid,depid,depid2,jobid,joindate,lastleavedate,ApplyDate,leavedate,leavetype,              
    leavereason,isEndCon,isPay,PayFee,IsExpenses,ExpenseFee,isBlackList,Iscompete,regBy,regdate,competeFee,              
    initialized,NewCompany,newcomptype,NewJob,initializedby,initializedtime,NewSalary,submit,submitby,submittime,closed,              
    closedby,closedtime,remark,Seqid,EZID,hrg)                  
 select  id,type,eid,badge,name,compid,depid,depid2,jobid,joindate,lastleavedate,ApplyDate,leavedate,leavetype,              
    leavereason,isEndCon,isPay,PayFee,IsExpenses,ExpenseFee,isBlackList,Iscompete,regBy,regdate,competeFee,              
    initialized,NewCompany,newcomptype,NewJob,initializedby,initializedtime,NewSalary,submit,submitby,submittime,1,              
    @URID,getdate(),remark,Seqid,EZID,hrg              
 from eleave_register                  
 where id=@id                          
 If @@Error<>0                        
 Goto ErrM               
                  
 ----记录人事事件表                  
 insert into eEvent(Type,effectdate,EID,CompID,DepID,JobID,status,ReportTo,wfreportto,EmpType,EmpGrade,              
    EmpCategory,EmpProperty,EmpGroup,EmpKind,WorkCity,Remark,EZID)                  
 select 6,a.leaveDate,b.EID,b.CompID,b.DepID,b.JobID,b.status,b.ReportTo,b.wfreportto,b.EmpType,b.EmpGrade,              
    b.EmpCategory,b.EmpProperty,b.EmpGroup,b.EmpKind,b.WorkCity,N'员工离退处理',b.EZID                 
 from eleave_register a , eemployee b                  
 where a.id=@id And a.EID=b.EID                 
                  
 If @@Error<>0                        
 Goto ErrM           
           
 --BS账号          
  update skysecuser set Disabled=1 where Badge=(select badge from eleave_register where id=@id )
  IF @@Error <> 0                                                                        
 GOTO ErrM 

           
                  
 -----删除登记表                  
 delete from eleave_register where id=@id                  
              
 If @@Error<>0                        
 Goto ErrM                   

    COMMIT TRANSACTION

    Set @Retval = 0
    Return @Retval

    ErrM:                          
    Set @Retval = -1
    ROLLBACK TRANSACTION
    Return @Retval
                        
End 