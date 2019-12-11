USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[eSP_StaffStart]    Script Date: 03/30/2017 15:05:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure  [dbo].[eSP_StaffStart]
--skydatarefresh eSP_StaffStart 45,0
 @ID  Int,
 @URID int,
 @RetVal Int =0 OUTPUT
As
/*
-- Create By kayang
-- 员工入职处理程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
alter by Jimmy
*/
Declare @badge varchar(20),
        @EID int,
        @depid int

Begin
 --数据还未确认！
 If Exists(Select 1 From estaff_Register
 Where ID=@ID And Isnull(Initialized,0)=0 )
 Begin
  Set @RetVal = 910020
  Return @RetVal
 End

 ----请先分配员工工号!                                                                                                  
 --IF Exists(Select 1 From eStaff_register
 --Where ID=@ID and Badge Is Null)
 --Begin
 -- Set @Retval=920038
 -- Return @Retval
 --End

  --入职日期不是操作当天，无法入职处理，请联系总部综合人事庄武君处理，0571-87903100!
    --if Exists(Select 1 from eStaff_Register Where ID=@ID And datediff(D,Joindate,GETDATE())<>0
    --   and (@URID not in (2108,1,2196,5660))
    --     )
    --Begin
    --     Set @RetVal=920097
    --     Return @RetVal
    --End

 -- 入职信息检查,防止入职信息确认通过之后长时间不处理，校验条件发生变化
 Exec eSP_StaffCheckSub @ID,@RetVal output

 If @RetVal <> 0
 Return @RetVal

 Begin TRANSACTION
 --分配工号
 if exists(select 1 from eStaff_Register where ID=@ID and Type=1)
 begin
 exec eSP_StaffBadge @id,@RetVal
 end
 /* 1
 将员工信息插入eemployee表，EID自增生成，同时eemployee的insert触发器会将EID插入estatus\edetails\ephoto以及相关模块接口表
 */
 --入职
 if exists(select 1 from eStaff_Register where ID=@ID and Type=1)
 begin
 insert into eemployee(Badge,Name,EName,CompID,DepID,JobID,Status,ReportTo,wfreportto,EmpType,EmpGrade,hrg,
  EmpCategory,EmpProperty,EmpGroup,EmpKind,WorkCity,EZID)
 select Badge,Name,EName,CompID,DepID,JobID,Status,ReportTo,wfreportto,EmpType,EmpGrade,hrg,
  EmpCategory,EmpProperty,EmpGroup,EmpKind,WorkCity,EZID
 from estaff_register
 where id=@id


 IF @@Error <> 0
 Goto ErrM

 Select @badge = badge From estaff_register Where ID=@ID
 Select @EID=Max(EID) From eEmployee Where Badge=@badge
 Select @depid=depid From eEmployee Where Badge=@Badge
 end
 --复职 add by Jimmy
 if exists(select 1 from eStaff_Register where ID=@ID and Type=2)
 begin

 Select @badge = badge From estaff_register Where ID=@ID                                                 
 select @eid=OldEID From estaff_register Where ID=@ID                                               
                                               
 update a                                              
 set a.Name=b.Name,                                              
  a.CompID=b.CompID,                                              
  a.DepID=b.DepID,                                              
  a.JobID=b.JobID,                                              
  a.Status=b.Status,                                              
  a.ReportTo=b.reportto,                                              
  a.wfreportto=b.WFReportTo,                                              
  a.EmpType=b.EmpType,                              
  a.EmpGrade=b.EmpGrade,                                              
  a.hrg=b.hrg,                                              
  a.EmpCategory=b.EmpCategory,                                      
  a.EmpProperty=b.EmpProperty,                                              
  a.EmpGroup=b.EmpGroup,                                              
  a.EmpKind=b.EmpKind,           
  a.WorkCity=b.WorkCity,                                              
  a.EZID=b.EZID                                              
 from eEmployee a,eStaff_Register b                                      
 where a.EID=@eid and b.ID=@ID and a.EID=b.OldEID                                              
                   
 IF @@Error <> 0                                                                                                  
 Goto ErrM                                                    
                        
 end                                               
 /*2                                                                                           
 更新人事在职状态表estatus中入职日期、试用、实习状态                                                                         
 */                                                                                                
                                                               
 update a                                                                      
 set a.joindate=convert(varchar(10),b.joindate,120),                                                                                           
  a.isprob=isnull(b.isProb,0),                                           
  a.probterm=b.probterm,                                                  
  a.probenddate=b.probenddate,                                                  
  a.isprac=isnull(b.isprac,0),                                                  
  a.practerm=b.practerm,                                          
  a.pracenddate=b.pracenddate,                                                  
  a.jobbegindate=b.joindate,
  a.RetireYears=(select case when b.gender=1 then 65 when b.gender=2 then 50 else NULL end),
  a.RetireDate=(select case when b.gender=1 then DATEADD(yy,65,b.birthday) when b.gender=2 then DATEADD(yy,50,b.birthday) else NULL end)
 from estatus a,estaff_register b                                                              
 where a.eid=@eid and b.id=@id                                                          
                                                
 IF @@Error <> 0                                                   
 Goto ErrM                                                     
                                                
 --复职标识                                                  
 update a                                                                                            
 set a.isRejoin=1                                                  
 from estatus a,estaff_register b                                                                                                
 where a.eid=@eid and b.id=@id and b.Type=2                                                         
                                                
 IF @@Error <> 0                                                   
 Goto ErrM                                                   
                                                
 --复职更新司龄调整                                                  
 update a                                                                                            
 set a.Cyear_adjust=b.Cyear_adjust                                                  
 from estatus a,estaff_register b                                                                                      
 where a.eid=@eid and b.id=@id and b.Type=2 and isnull(isCyear,0)=1                                                       
                                                
 IF @@Error <> 0                                                   
 Goto ErrM                               
            
 --更新人事状态                              
 update a                              
 set a.HRG=(select DepEmp from odepartment where depid=dbo.eFN_getdepid_XS(a.depid))                            
 from eemployee a                             
 where a.EID=@EID                 
                               
  IF @@Error <> 0                                                   
 Goto ErrM                              
                                                
 /*  3                                                   
 更新人事详细信息表edetails中的相关信息                                                                  
 */                                                   
                                                                                          
 Update a                                                               
 Set a.country=b.country,                                                                                  
  a.certType=b.certType,                                  
  a.certNo=b.certNo,                                                                            
  a.Gender=b.Gender,                                                                            
  a.birthday=b.birthday,              
  a.workbegindate=b.workbegindate,                                                                            
  a.jointype=b.jointype,                                              
  a.eMail_pers=b.eMail_pers,                                              
  a.Address=b.address,                                         
  a.mobile=b.mobile,                                              
  a.Marriage=b.Marriage,  
  a.Nation=b.Nation,  
  a.place=b.place,  
  a.party=b.party,  
  a.partydate=b.partydate,  
  a.resident=b.resident,  
  a.residentaddress=b.residentaddress,
  a.BIRTHPLACE=b.BIRTHPLACE  
 From eDetails a,eStaff_Register b                                                                              
 Where a.eid =@eid  And b.id = @id                                                                
                                                
 IF @@Error <> 0                                                                                    
 Goto ErrM                                                                                   
                                                                                         
                                               
 /* 5                                                             
 入职签订合同，进入历史表，同步更新estatus的最新合同信息                                                                                                               
 */                                                     
                                                
 If Exists (Select 1 From estaff_register Where ID=@ID And [contract] is not null And conType is not null)                                                  
 Begin                                                  
                                                
 Insert Into eContract_register(type,EID,Badge,Name,compid,DepID,jobid,conCount,contract,contype,conProperty,conNo,                                                  
  conBeginDate,conTerm,conEndDate,effectDate,reason,RegBy,RegDate,Initialized,initializedby,                                                  
  InitializedTime,Submit,submitby,SubmitTime,closed,closedby,closedTime,EZID)                                                          
 Select 1,@EID,a.Badge,a.Name,a.compid,a.DepID,a.jobid,1,a.contract,a.contype,a.conProperty,a.conNo,                                                  
  a.conBeginDate,a.conTerm,a.conEndDate,getdate(),N'新员工入职签订合同',@URID,getdate(),1,@URID,                                                  
  getdate(),1,@URID,getdate(),1,@URID,getdate(),a.EZID                                                         
 From estaff_register a                                                         
 Where a.ID=@ID                                                  
                                                
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
                                                  
                                                                            
 IF @@Error <> 0                                 
 Goto ErrM                                                     
                                                
 update a                                                                                            
 set a.concount=1,                                                    
  a.contract=b.contract,                        
  a.contype=b.contype,                                                  
  a.conproperty=b.conproperty,                                                  
  a.conno=b.conno,                                                  
  a.conbegindate=b.conbegindate,                                                  
  a.conterm=b.conterm,                                                  
  a.conenddate=b.conenddate                                             
 from estatus a,estaff_register b                                                                                                
 where a.eid=@eid and b.id=@id                                                     
                                                
 IF @@Error <> 0                                                  
 Goto ErrM                                                         
                                                
End                                               
                                                        
 /* 6                                                                                                   
 插入背景信息                              
 */                                                                           
 ---1.教育经历                                                  
 Insert Into ebg_education(EID,badge,depid2,BeginDate,endDate,SchoolName,Major,MAJORTYPE,GRADTYPE,STUDYTYPE,EDUTYPE                                
 ,DEGREETYPE,ISOUT,REMARK)                                                  
 Select @EID,@badge,dbo.eFN_getdepid2(@depid),BeginDate,endDate,SchoolName,Major,MAJORTYPE,GRADTYPE,STUDYTYPE,EDUTYPE                                
 ,DEGREETYPE,ISOUT,REMARK                                                  
 From eBG_Education1                                                   
 Where SeqID=@ID                                                  
                                                
 IF @@Error <> 0                                                   
 Goto ErrM                                                    
                                          
 Delete From  eBG_Education1 Where SeqID=@ID                                                  
                                                
 IF @@Error <> 0                                                   
 Goto ErrM                                                   
                            
 ---2.工作经历                                                    
 Insert Into ebg_working(EID,badge,depid2,begindate,enddate,WYEAR,COMPANY,INSTITUTION,JOB,WORKPLACE,isout,LEAVEREASON                                
 ,REFERENCE,TEL,REMARK)                                                  
 Select @EID,@badge,dbo.eFN_getdepid2(@depid),begindate,enddate,WYEAR,COMPANY,INSTITUTION,JOB,WORKPLACE,isout,LEAVEREASON                                
 ,REFERENCE,TEL,REMARK                                                 
 From eBG_Working1                                                   
 Where SeqID=@ID                               
                     
 IF @@Error <> 0                                                                                                                
 Goto ErrM                                                    
                                                
 Delete From  eBG_Working1 Where SeqID=@ID                                                     
                                                
 IF @@Error <> 0                                                   
 Goto ErrM                                                     
                                                        
 ---3.职称经历                                                  
 Insert Into ebg_title(EID,badge,depid2,Title,Titletype,TitleGrade,describe,effectdate,certNo,Remark)                                                  
 Select @EID,@badge,dbo.eFN_getdepid2(@depid),Title,Titletype,TitleGrade,describe,effectdate,certNo,Remark                                                  
 From eBG_Title1                                                   
 Where SeqID=@ID                                                  
                                                
 IF @@Error <> 0                                                                 
 Goto ErrM                                                    
                                                
 Delete From  eBG_Title1 Where SeqID=@ID                                                     
                                                
 IF @@Error <> 0                                                   
 Goto ErrM                                                   
                                                
 -----4.培训经历                                                   
 --Insert Into ebg_training(EID,badge,Traintype,IsJoin,TrainKind,BeginDate,EndDate,content,Course,place,Hours,Vendor,Remark,Certificate,CertificateNo)                                                  
 --Select @EID,@badge,Traintype,IsJoin,TrainKind,BeginDate,EndDate,content,Course,place,Hours,Vendor,Remark,Certificate,CertificateNo                                                  
 --From ebg_training_register                                                   
 --Where SeqID=@ID                                                  
                                                
 --IF @@Error <> 0                                                                                              
 --Goto ErrM                                                    
                                                
 --Delete From  ebg_training_register Where SeqID=@ID                                                     
                                                
 --IF @@Error <> 0                                                   
 --Goto ErrM                      
                                                                     
 -----5.项目经历                                                  
 --Insert Into ebg_project(EID,badge,BeginDate,EndDate,ProjName,Description,Job,ProjAddress,Principal,Remark)                      
 --Select @EID,@badge,BeginDate,EndDate,ProjName,Description,Job,ProjAddress,Principal,Remark                                                  
 --From ebg_project_register                                                   
 --Where SeqID=@ID                                                  
                                                
 --IF @@Error <> 0                                                                                                                
 --Goto ErrM                                                    
                                                
 --Delete From  ebg_project_register Where SeqID=@ID                                                     
                                                
 --IF @@Error <> 0                                                   
 --Goto ErrM                                              
                                                
 ---6.奖惩经历                                                  
 Insert Into eBG_Hortation(EID,badge,depid2,InOut,HortationType,HortationKind,HappenDate,Organizer,Reason,Description,Remark)                                                  
 Select @EID,@badge,dbo.eFN_getdepid2(@depid),InOut,HortationType,HortationKind,HappenDate,Organizer,Reason,Description,Remark                                                  
 From eBG_Hortation1                                                   
 Where SeqID=@ID                                                  
                                                
 IF @@Error <> 0                                                                 
 Goto ErrM                                                    
                                                
 Delete From  eBG_Hortation1 Where SeqID=@ID                                                    
                                         
 IF @@Error <> 0                                                   
 Goto ErrM                                                   
                                                
 ---7.家庭背景                                                  
 Insert Into eBG_Family(eid,badge,depid2,fname,relation,gender,Birthday,Company,Job,TEL,ADDRESS,status,remark,CERTID)                                            
 Select @eid,@badge,dbo.eFN_getdepid2(@depid),fname,relation,gender,Birthday,Company,Job,TEL,ADDRESS,status,remark ,familycertno                                               
 From ebg_family1                                                   
 Where SeqID=@ID                                                  

 IF @@Error <> 0                                               
 Goto ErrM   

 update eBG_Family
 set IsSuppMedIns=1
 where relation=6 and EID=@EID
 IF @@Error <> 0
 Goto ErrM
                                                
 Delete From  ebg_family1 Where SeqID=@ID                                                     
                                                
 IF @@Error <> 0                                                   
 Goto ErrM                                 
                                 
  ---8.紧急联系人                                                  
 Insert Into eBG_Emergency(eid,badge,depid2,EMERGENCYNAME,RELATION,TELEPHONE,ADDRESS,EMAIL,POSTCODE,REMARK)                                        
 Select @eid,@badge,dbo.eFN_getdepid2(@depid),EMERGENCYNAME,RELATION,TELEPHONE,ADDRESS,EMAIL,POSTCODE,REMARK                                                 
 From eBG_Emergency1                                                   
 Where SeqID=@ID                                                  
                                                
 IF @@Error <> 0                                                                                                                
 Goto ErrM                                                    
                                                
 Delete From  eBG_Emergency1 Where SeqID=@ID                      
                                                
 IF @@Error <> 0                                    
 Goto ErrM                                 
                                 
   ---9.紧急联系人                                                  
 Insert Into eBG_Certificate(eid,badge,depid2,CERTTYPE,CERTNO,PAYORG,BEGINDATE,TERM,ENDDATE,ISDISABLE,PHOTO,ISPHOTO,REMARK,PHOTOIMG)                                                  
 Select @eid,@badge,dbo.eFN_getdepid2(@depid),CERTTYPE,CERTNO,PAYORG,BEGINDATE,TERM,ENDDATE,ISDISABLE,PHOTO,ISPHOTO,REMARK,PHOTOIMG                                                
 From eBG_Certificate1                                                   
 Where SeqID=@ID                                                  
                                                
 IF @@Error <> 0                                                                                                                
 Goto ErrM                                                    
                                                
 Delete From  eBG_Certificate1 Where SeqID=@ID                                                     
                                                
 IF @@Error <> 0                           
 Goto ErrM                                         
                                                
 -----8.语言能力                                                  
 --Insert Into eBG_language(EID,badge,LanguageType,LanguageGrade,Certificate,effectDate,Remark)                                          
 --Select @EID,@badge,LanguageType,LanguageGrade,Certificate,effectDate,Remark                                                  
 --From eBG_language_register                                                   
 --Where SeqID=@ID                                                  
                                                
 --IF @@Error <> 0                                                                                                                
 --Goto ErrM                                                    
                                                
 --Delete From  eBG_language_register Where SeqID=@ID             
                                                
 --IF @@Error <> 0                                                   
 --Goto ErrM                                                   
                                                
 -----9.专业认证                                                  
 --Insert Into eBG_ProCert(EID,badge,ProCertType,ProCertDate,ProCertNo,remark)                                                  
 --Select @EID,@badge,ProCertType,ProCertDate,ProCertNo,remark                                                  
 --From eBG_ProCert_register                                                   
 --Where SeqID=@ID                                                  
                                                
 --IF @@Error <> 0                                                                                                                
 --Goto ErrM                                                    
                                                
 --Delete From  eBG_ProCert_register Where SeqID=@ID                                                     
                        
 --IF @@Error <> 0                                                   
 --Goto ErrM                                                   
                                               
 --外派管理                                              
 --if exists(select 1 from eStaff_Register where ID=@ID and ISNULL(isout,0)=1)                                              
 --begin                                              
                                               
 --end                                           
                                           
 /* 6                                          
 插入内网邮箱管理                                          
 create lizp                                          
 */                                           
 insert into eemployee_email(badge,name,compid,depid,depid2,jobid,status,joindate,mobile)                                          
 select badge,name,compid,dbo.eFN_getdepid(DepID),dbo.eFN_getdepid2(DepID),jobid,status,joindate,mobile                                          
 from eemployee a,eStatus b,eDetails c                                          
 where a.Badge=@badge and a.Status in (1,2,3) and a.EID=b.EID and a.EID=c.EID                                                                    
                                         
  IF @@Error <> 0                                                                                                  
 GOTO ErrM                                     
                                     
 /* 6.1                                          
 插入干部管理                                         
 create lizp                                          
 */          
 if exists(select 1 from eStaff_Register where ID=@ID and JobID in (select JobID from oJob where isnull(JobType,0)=4))                                    
 begin                                    
  --职务上会                                    
 insert into HPOSITIONW_REGIST(badge,name,compid,depid,depid2,jobid,status,joindate,rebby,rebdate)                                    
 select badge,name,compid,dbo.eFN_getdepid(DepID),dbo.eFN_getdepid2(DepID),jobid,status,joindate,@URID,GETDATE()                                    
 from eemployee a,eStatus b,eDetails c                                          
 where a.Badge=@badge and a.Status in (1,2,3) and a.EID=b.EID and a.EID=c.EID                                    
                                     
   IF @@Error <> 0                                                                                        
 GOTO ErrM                                     
 --高管资格                                    
  insert into EHIGHMANAGER_REGIST(badge,name,compid,depid,depid2,jobid,status,joindate,rebby,DEP_TITLE,DEP2_TITLE,JOB_TITLE)                                    
 select badge,name,compid,dbo.eFN_getdepid(DepID),dbo.eFN_getdepid2(DepID),jobid,status,joindate,@URID                                    
 ,(select title from odepartment where DepID=dbo.eFN_getdepid(a.DepID))                                    
 ,(select title from odepartment where DepID=dbo.eFN_getdepid2(a.DepID))                                    
 ,(select title from ojob where JobID=a.JobID)                                    
 from eemployee a,eStatus b,eDetails c                                          
 where a.Badge=@badge and a.Status in (1,2,3) and a.EID=b.EID and a.EID=c.EID                                    
                                     
   IF @@Error <> 0                                                                                                  
 GOTO ErrM                                 
                                     
 end                        
                   
  --其他信息                  
 insert into ebg_qita(eid,badge)                  
select eid,badge                  
from eemployee a                  
where a.Badge=@badge          
and not exists (select 1 from ebg_qita where badge=a.Badge)                      
              
  IF @@Error <> 0                                                                                                  
 GOTO ErrM   


  --证券期货考试情况                 
 insert into ebg_zqqh(eid,badge,zqjczs,zqjy,jj,zqfx,zqtzzx,qhjczs,qhflfg)                  
select eid,badge,N'证券基础知识',N'证券交易',N'基金',N'证券发行',N'证券投资咨询',N'期货基础知识',N'期货法律法规'                  
from eemployee a                  
where a.Badge=@badge             
and not exists (select 1 from ebg_zqqh where badge=a.Badge)                  
                  
  IF @@Error <> 0                                                                                                  
 GOTO ErrM                               
                                                          
 /*  7                                                         
 进入event事件表                                  
 */                                                                                                
 insert into eEvent(Type,effectdate,EID,CompID,DepID,JobID,status,ReportTo,wfreportto,EmpType,EmpGrade,                                                  
  EmpCategory,EmpProperty,EmpGroup,EmpKind,WorkCity,EZID,Remark)                                                  
 select 1,joindate,@EID,CompID,DepID,JobID,status,ReportTo,wfreportto,EmpType,EmpGrade,                                                  
  EmpCategory,EmpProperty,EmpGroup,EmpKind,WorkCity,EZID,N'新员工入职'                                                               
 from estaff_register                                                                      
 where id=@id                                    
                                                
                                                                
 IF @@Error <> 0                                                                                                  
 GOTO ErrM                                                                                          
                                                                                             
 /*  8                         
 插入入职历史表 并删除记录                                                                                                
 */                                                                                                
 insert into estaff_all(ID,SeqID,Type,EZID,isCyear,Badge,Cyear_adjust,OldEID,OldBadge,Name,eName,CompID,DepID,JobID,reportto,                                                  
  WFReportTo,EmpType,EmpGrade,EmpCategory,EmpProperty,EmpGroup,EmpKind,JoinType,WorkCity,Status,                                                  
  JoinDate,isPrac,PracTerm,PracEndDate,isProb,ProbTerm,ProbEndDate,contract,conType,conProperty,                                                  
  conNO,conBeginDate,conTerm,conEndDate,Country,CertType,CertNo,birthday,Gender,Regby,RegDate,                                                  
  workbegindate,Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,Closed,                                                  
  ClosedBy,ClosedTime,Remark,rappid,hrg,isout,mobile,Marriage,address,eMail_pers   )                                                       
 select ID,SeqID,Type,EZID,isCyear,Badge,Cyear_adjust,OldEID,OldBadge,Name,eName,CompID,DepID,JobID,reportto,                                                  
  WFReportTo,EmpType,EmpGrade,EmpCategory,EmpProperty,EmpGroup,EmpKind,JoinType,WorkCity,Status,                                                  
  JoinDate,isPrac,PracTerm,PracEndDate,isProb,ProbTerm,ProbEndDate,contract,conType,conProperty,                                                  
  conNO,conBeginDate,conTerm,conEndDate,Country,CertType,CertNo,birthday,Gender,Regby,RegDate,                                                  
  workbegindate,Initialized,InitializedBy,InitializedTime,Submit,SubmitBy,SubmitTime,1,                                                  
  @URID,getdate(),Remark,rappid,hrg,isout,mobile,Marriage,address,eMail_pers                                                                                             
 from estaff_register                                                                                                  
 where id=@id                                
                                                                                                            
 IF @@Error <> 0                                                                                                                
 GOTO ErrM                                                   
                                                
 /* 9                                                  
 开通用户账号,赋予员工平台角色权限，开通BPM审批流权限                                                  
 */                                    
 if exists(select 1 from eStaff_Register where ID=@ID and Type=1)                                     
                                     
 begin                                              
 insert into dbo.skysecuser(account,eid,badge,name,password,logintime,logintimes,lgid)                                                  
 select badge,a.eid,badge,name,dbo.skyEnCryptToBase64String(right(b.CertNo,6),0x6B08315047660D2C),getdate(),1,2052                                                  
 from eemployee a,eDetails b                                                  
 where a.eid=@eid and a.EID=b.EID  
  IF @@Error <> 0                                                                                                                
 GOTO ErrM                                                 
                                                
 insert into dbo.skySecRoleMemberMaker(ruid,urid,hrid)                                                  
 select 1001,id,1 from dbo.skysecuser                                                  
 where eid=@eid       
  IF @@Error <> 0                                                                                                                
 GOTO ErrM                                            
                                                
 insert into dbo.skysecrolemember(id,ruid,urid,hrid)                                    
 select id,ruid,urid,hrid                                                   
 from dbo.skySecRoleMemberMaker                                                   
 where id not in(select id from dbo.skysecrolemember)    
  IF @@Error <> 0                                                                                                                
 GOTO ErrM                                 
                                     
 end                                    
                                     
  IF @@Error <> 0                                                                                                  
 GOTO ErrM                                    
                                     
 if exists(select 1 from eStaff_Register where ID=@ID and Type=2)                                     
 update skysecuser set Disabled=0 where EID=@EID                                               
                                                
 --BPM工作流权限,flows字段存储开通权限的skywfflow.ID字段,多个流程用逗号分隔                                                  
 -- insert into skyAccessSecurity                                                  
 -- select eid,4,3,'1,2'                                                  
 -- from skysecuser                                                   
 -- where eid =@eid                                                  
                                                
 IF @@Error <> 0                                   
 GOTO ErrM  

    -- 其他信息
    insert into EBG_QITANEW(eid,badge)
    select eid,badge
    from eemployee a
    where a.Badge=@badge
    and not exists (select 1 from EBG_QITANEW where badge=a.Badge)
    -- 异常流程
    IF @@Error <> 0
    GOTO ErrM
    -- 离职信息更新
    update eStatus
    set LeaDate=NULL
    where EID=@EID and LeaType not in (4)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 薪酬信息
    ---- 薪酬更新
    insert into pEmployeeEmolu(eid)
    select eid
    from eemployee a
    where a.Badge=@badge and a.EID not in (select EID from pEmployeeEmolu)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 薪酬更新(新)
    insert into pEMPSalary(eid)
    select eid
    from eemployee a
    where a.Badge=@badge and a.EID not in (select EID from pEMPSalary)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- MD更新(新)
    insert into pEMPAdminIDMD(eid)
    select eid
    from eemployee a
    where a.Badge=@badge and a.EID not in (select EID from pEMPAdminIDMD)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 补充医疗更新
    insert into pEMPSuppMedIns(eid,IsSuppMedIns,SMIType,SMICertID,SMINo)
    select a.eid,1,0,b.CertNo,0
    from eemployee a,eDetails b
    where a.Badge=@badge and a.EID=b.EID 
    and a.EID not in (select EID from pEMPSuppMedIns)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 公积金添加
    insert into pEMPHousingFund(eid,EMPHousingFundDepart)
    select eid,(case when dbo.eFN_getdeptype(DepID) in (2,3) then depid else NULL end)
    from eemployee a
    where a.EID=@EID
    and a.EID not in (select EID from pEMPHousingFund)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 社保添加
    insert into pEMPInsurance(eid,EMPInsuranceDepart)
    select eid,(case when dbo.eFN_getdeptype(DepID) in (2,3) then depid else NULL end)
    from eemployee a
    where a.EID=@EID
    and a.EID not in (select EID from pEMPInsurance)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 奖金添加
    insert into pEMPBonus(eid)
    select eid
    from eemployee a
    where a.EID=@EID and a.EID not in (select EID from pEMPBonus)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 通讯交通费添加
    insert into pEMPTrafficComm(eid)
    select eid
    from eemployee a
    where a.EID=@EID and a.EID not in (select EID from pEMPTrafficComm)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 专项附加扣除项添加
    insert into pPITSpclMinus(eid)
    select eid
    from eemployee a
    where a.EID=@EID and a.EID not in (select EID from pPITSpclMinus)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 企业年金添加
    insert into pEMPPension(eid)
    select eid
    from eemployee a
    where a.EID=@EID and a.EID not in (select EID from pEMPPension)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 年金
    ---- 前台转后台；根据身份证编号
    ---- 将原前台员工年金数据表信息复制到后台员工数据表中
    update a
    set a.IsPension=b.IsPension,a.IsPensionConfirm=b.IsPensionConfirm,
    a.GrpPensionYearRest=b.GrpPensionYearRest,a.EmpPensionYearRest=b.EmpPensionYearRest,
    a.GrpPensionTotal=b.GrpPensionTotal,a.EmpPensionTotal=b.EmpPensionTotal,
    a.GrpPensionFrozen=b.GrpPensionFrozen,a.EmpPensionFrozen=b.EmpPensionFrozen
    from pEmployeeEmolu a,pSalesDepartMarketerEmolu b,estaff_register c
    where a.EID=@EID and b.Identification=c.CertNo and c.ID=@ID
    and c.CertNo in (select Identification from pSalesDepartMarketerEmolu)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 将原前台员工年金取消,在职状态变成离职
    update a
    set a.IsPension=NULL,a.Status=4
    from pSalesDepartMarketerEmolu a,estaff_register b
    where b.ID=@ID and a.Identification=b.CertNo and b.ID=@ID
    and b.CertNo in (select Identification from pSalesDepartMarketerEmolu)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 薪酬调整
    ---- 新员工添加至薪酬调整表
    Insert Into pChangeMDSalaryPerMM_register(EID,MDID,SalaryPerMM,WorkCityRatio,SalaryPerMMCity,SalaryPayID,SponsorAllowance,CheckUpSalary)
    select a.EID,a.MDID,a.SalaryPerMM,(CASE when d.DepType in (2,3) then c.Ratio else 1 end),
    ROUND(a.SalaryPerMM*(CASE when d.DepType in (2,3) then c.Ratio else 1 end),-2),a.SalaryPayID,a.SponsorAllowance,a.CheckUpSalary
    From pEmployeeEmolu a,eemployee b,eCD_City c,odepartment d
    Where a.EID=@EID and a.EID=b.EID and b.WorkCity=c.ID and b.DepID=d.DepID
    and a.EID not in (select EID from pChangeMDSalaryPerMM_register)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 五险一金调整
    ---- 新员工添加至五险一金调整表
    Insert Into pEMPInsHFChange_register(EID,CompID,DepID1st,DepID2nd,JobID,JobTitle,InsHFChangeType)
    select @EID,a.CompID,a.DepID1st,a.DepID2nd,a.JobID,a.JobTitle,1
    From pvw_Employee a
    Where a.EID=@EID and dbo.eFN_getdeptype(a.DepID) in (1,4)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


 /*  10
 清除登记表数据
 */
  delete from estaff_register where id=@id
  -- 异常流程
  IF @@Error <> 0
  Goto ErrM

 --调整绩效表状态
 update a
 set a.Status=b.Status
 from pEmployee a,eemployee b
 where a.EID=@EID and a.EID=b.EID

  IF @@Error <> 0
 Goto ErrM

  update a
 set a.Status=b.Status                        
 from PEMPLOYEE_CHANGE a,eemployee b                        
 where a.EID=@EID and a.EID=b.EID                        
                         
  IF @@Error <> 0           
 Goto ErrM                         

  -- Update pEmployee_Register
  update a
  set a.Status=b.Status,a.KPIDepID=(case when dbo.eFN_getdeptype(b.DepID) in (2,3) then b.DepID 
   when dbo.eFN_getdeptype(b.DepID) in (1,4) then dbo.eFN_getdepid1st(b.DepID) end),
  a.pStatus=1
  from pEmployee_Register a,eemployee b
  where a.EID=@EID and a.EID=b.EID
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM


 COMMIT TRANSACTION                                                    
 Set @Retval = 0                                                    
 Return @Retval                                                   
                                                
 ErrM:                                                   
 ROLLBACK TRANSACTION                                                     
 Set @Retval = -1                                                  
 Return @Retval                                                   
                                                                      
End 