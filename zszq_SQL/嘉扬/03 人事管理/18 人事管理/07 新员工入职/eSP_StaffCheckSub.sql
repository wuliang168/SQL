USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Proc [dbo].[eSP_StaffCheckSub]
-- skydatarefresh eSP_StaffCheckSub
    @ID int,
    @RetVal int output
as
/*
-- Create By kayang
-- 员工入职的通用检查，入职确认和入职处理都调用，通过type字段区分新员工入职和老员工复职.
-- 重要字段的检查都涉及到，如不需要该检查请注释，不要删除；新增检查请参考程序的写法
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
--alter by Jimmy 2013-11-10
*/
Begin
    --姓名不能为空!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And name is null)
    Begin
         Set @RetVal=920000
         Return @RetVal
    End

    --公司、部门、岗位必须选择!
    if Exists(Select 1 from eStaff_Register
    Where ID=@ID And
    (Compid is null
     or Depid is null
     or Jobid is null))
    Begin
         Set @RetVal=920001
         Return @RetVal
    End
                  
    --员工类型必须选择!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And emptype is null)
    Begin
         Set @RetVal=920002
         Return @RetVal
    End

    --人事等级必须选择!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And empGrade is null)
    Begin
         Set @RetVal=920003
         Return @RetVal
    End

    --用工性质必须选择!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And empKind is null)
    Begin
         Set @RetVal=920006
         Return @RetVal
    End

    --工作地必须选择!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And workcity is null)
    Begin
         Set @RetVal=920007
         Return @RetVal
    End

    --入职状态必须选择!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And [status] is null)
    Begin
         Set @RetVal=920008
         Return @RetVal
    End

    --入职状态不能为离职\退休!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And isnull([status],0) in (4,5))
    Begin
         Set @RetVal=920009
         Return @RetVal
    End

    --入职日期必须填写!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And Joindate is null)
    Begin
         Set @RetVal=920010
         Return @RetVal
    End

    --国籍必须选择!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And country is null)
    Begin
         Set @RetVal=920011
         Return @RetVal
    End

    --国籍不为中华人民共和国,证件类型不能选择身份证!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And isnull(country,0)<>41 And CertType=1)
    Begin
         Set @RetVal=920183
         Return @RetVal
    End

    --证件类型、证件编号必须填写!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And (CertType is null Or CertNo is null))
    Begin
         Set @RetVal=920012
         Return @RetVal
    End

    --出生日期必须填写!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And birthday is null)
    Begin
         Set @RetVal=920013
         Return @RetVal
    End

    --性别必须选择!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And Gender is null)
    Begin
         Set @RetVal=920098
         Return @RetVal
    End

    --婚姻情况必须选择!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And Marriage is null)
    Begin
         Set @RetVal=920199
         Return @RetVal
    End

    --入职日期必须为当天,在check中判断
    ----入职日期不能早于当天
    --if Exists(Select 1 from eStaff_Register
    --          Where ID=@ID
    --             and datediff(day,isnull(joindate,'2049-12-31'),getdate())<0
    --          )
    --Begin
    --     Set @RetVal=920014
    --     Return @RetVal
    --End

    -- --入职日期不能早于开始工作日
    --if Exists(Select 1 from eStaff_Register
    --          Where ID=@ID And Joindate is Not Null And WorkBeginDate is Not Null
    --             and datediff(day,joindate,WorkBeginDate)>0
    --          )
    --Begin
    --     Set @RetVal=920182
    --     Return @RetVal
    --End
    --工号在入职处理时完成,不需要判断
    ----员工工号已经存在!
    --if Exists(Select 1 from eStaff_Register a,eemployee b
    --          Where a.ID=@ID And a.Badge =b.badge
    --          )
    --Begin
    --     Set @RetVal=920015
    --     Return @RetVal
    --End

    ----员工工号与入职登记表工号重复!
    --if Exists(Select 1 from eStaff_Register a,eStaff_Register b
    --          Where a.ID=@ID And a.ID<>b.ID and a.Badge =b.badge
    --          )
    --Begin
    --     Set @RetVal=920016
    --     Return @RetVal
    --End

    ----员工工号存在无效字符!
 --if Exists(Select 1 From eStaff_Register
    --          Where ID=@ID and Len(Badge)=8 and Isnumeric(Badge) = 0
    --          --Isnumeric(Case Len(Badge) When 18 Then Substring(Badge,1,17) Else Badge End) = 0
    --          )
    --Begin
    --     Set @RetVal=920197
    --     Return @RetVal
    --End

 ---所选公司不存在!
 if Not Exists(Select 1 from eStaff_Register a,ocompany b
               Where a.ID=@ID And a.compid=b.compid )
 Begin
  Set @RetVal=920017
  Return @RetVal
 End

 ---所选公司还未创建!
 if Exists(Select 1 from eStaff_Register a,ocompany b
           Where a.ID=@ID And a.compid=b.compid
     and datediff(day,b.effectdate,a.joindate)<0
 )
 Begin
  Set @RetVal=920018
  Return @RetVal
 End

 ---所选公司已经失效!
 if Exists(Select 1 from eStaff_Register a,ocompany b
     Where a.ID=@ID And a.compid=b.compid
     and  isnull(b.isdisabled,0)=1
 )
 Begin
  Set @RetVal=920019
  Return @RetVal
 End
                  
 ---所选部门不存在!
 if Not Exists(Select 1 from eStaff_Register a,odepartment b
      Where a.ID=@ID And a.depid=b.depid )
 Begin
  Set @RetVal=920020
  Return @RetVal
 End

 -----所选部门还未创建!
 --if Exists(Select 1 from eStaff_Register a,odepartment b                                                  
 --   Where a.ID=@ID And a.depid=b.depid                                          
 --   and datediff(day,b.effectdate,a.joindate)<0                   
 --)                   
 --Begin                                                  
 -- Set @RetVal=920021                  
 -- Return @RetVal                                                  
 --End                   
                
 ---所选部门已经失效!                                        
 if Exists(Select 1 from eStaff_Register a,odepartment b                                                  
     Where a.ID=@ID And a.depid=b.depid                                          
     and  isnull(b.isdisabled,0)=1                   
 )                   
 Begin                                                  
  Set @RetVal=920022                                                
  Return @RetVal                                                  
 End                   
                
 ---所选岗位不存在!                                        
 if Not Exists(Select 1 from eStaff_Register a,ojob b                                                  
               Where a.ID=@ID And a.jobid=b.jobid )                   
 Begin                                              
  Set @RetVal=920023                                                
  Return @RetVal                                                  
 End                    
                  
 -----所选岗位还未创建!                                        
 --if Exists(Select 1 from eStaff_Register a,ojob b                                                  
 --    Where a.ID=@ID And a.jobid=b.jobid                                          
 --  and datediff(day,b.effectdate,a.joindate)<0                   
 --)                   
 --Begin                                                  
 -- Set @RetVal=920024                                                
 -- Return @RetVal                                                  
 --End                   
                
 ---所选岗位已经失效!                       
 if Exists(Select 1 from eStaff_Register a,ojob b                                                  
     Where a.ID=@ID And a.jobid=b.jobid                                          
     and  isnull(b.isdisabled,0)=1                   
 )                   
 Begin                                
  Set @RetVal=920025                                                
  Return @RetVal                                                  
 End                   
 --实习生不入职               
 -----员工状态为实习，实习期、实习结束日期不能为空!                                        
 --if Exists(Select 1 from eStaff_Register                                               
 --    Where ID=@ID And status= 3                                      
 --    and ( isnull(isprac,0) =0 or isnull(PracTerm,0)=0 Or pracenddate is NULL)                    
 --)                   
 --Begin                                                  
 -- Set @RetVal=920026                                                
 -- Return @RetVal                                                  
 --End                   
                  
 -----员工状态不为实习，实习期、实习结束日期必须为空!                                        
 --if Exists(Select 1 from eStaff_Register                                               
 --    Where ID=@ID And status<>3                                      
 --    and ( isnull(isprac,0) =1 or isnull(PracTerm,0)<>0 Or pracenddate is not NULL)                    
 --)                   
 --Begin                                                  
 -- Set @RetVal=920027                        
 -- Return @RetVal                                                  
 --End             
                
 -----实习结束日期不能早于入职日期!                                        
 --if Exists(Select 1 from eStaff_Register                                               
 --       Where ID=@ID And pracenddate is not null                                       
 --       And datediff(dd,joindate,pracenddate)<0                  
 --)                   
 --Begin                                                  
 -- Set @RetVal=920028                                                
 -- Return @RetVal                                                  
 --End                   
               
 ---员工状态为试用，试用期、试用结束日期不能为空!                                        
 if Exists(Select 1 from eStaff_Register                                               
     Where ID=@ID And status= 2                                      
     and ( isnull(isprob,0) =0 or isnull(probTerm,0)=0 Or probenddate is NULL)                    
 )                   
 Begin                                                  
  Set @RetVal=920029                                                
  Return @RetVal                                                  
 End                   
                  
 ---员工状态不为试用，实习期、实习结束日期必须为空!                         
 if Exists(Select 1 from eStaff_Register                                               
     Where ID=@ID And status<>2                                      
     and ( isnull(isprob,0) =1 or isnull(probTerm,0)<>0 Or probenddate is not NULL)                    
 )                   
 Begin                                                  
  Set @RetVal=920030                                                
  Return @RetVal                                                  
 End                   
                
 ---试用结束日期不能早于入职日期!                                        
 if Exists(Select 1 from eStaff_Register                                               
     Where ID=@ID And probenddate is not null                                       
     And datediff(dd,joindate,probenddate)<0                  
 )                   
 Begin                                                  
  Set @RetVal=920031                                                
  Return @RetVal                                                  
 End                   
           
 ---国籍为中华人民共和国的员工必须填写身份证!                                        
 if Exists(Select 1 from eStaff_Register                                               
     Where ID=@ID And isnull(country,0)=41                                       
     And (isnull(certType,0)<>1 or certNo is null)                    
 )                  
 Begin                                                  
  Set @RetVal=920032                                                
  Return @RetVal                                                  
 End                   
                  
    --身份证不符合要求，请看身份证验证提示窗口!                                                  
    if Exists(Select 1 from eVW_certno                                                  
              Where ID = @ID                                                  
              )                                                  
    Begin                                                  
         Set @RetVal=920033                                                  
         Return @RetVal                                                  
    End          
          
    ---合同类型不能为空      
    if exists(select 1 from eStaff_Register where ID=@ID       
  and conType is null       
    )                 
  begin      
         Set @RetVal=920200                     
         Return @RetVal          
  end      
                  
      
    ---- 合同类型为空，合同相关属性都必须为空                                            
    --If Exists (Select 1 From eStaff_Register                                                   
    --            Where ID=@ID And ConType is null                  
    --And (  contract is not null                  
    -- or conProperty is not null                  
    -- or conNo is not null                  
    -- or conBeginDate is not null                  
    -- or conTerm is not null                  
    -- or conEnddate is not null)          
    -- )                                                   
    --Begin                                                    
    --     Set @RetVal=920177                             
    --     Return @RetVal                                                    
    --End                    
                  
    -- 合同开始日期不能为空                                            
    If Exists (Select 1 From eStaff_Register                                                   
               Where ID=@ID And ConType is Not null                  
               And conbegindate is null                  
    )                                                    
    Begin                                                    
         Set @RetVal=920034                          
         Return @RetVal                                                    
    End                                           
                                          
    -- 合同开始日期不能早于入职日期                                            
    If Exists (Select 1 From eStaff_Register                                                   
               Where ID=@ID And ConType is Not null                  
               And datediff(day,conbegindate,joindate)>0                  
    )                                                    
    Begin                                                    
         Set @RetVal=920035                             
         Return @RetVal                                                    
    End                   
                  
    -- 合同属性不能为空                                            
    If Exists (Select 1 From eStaff_Register                          
                Where ID=@ID And ConType is Not null And conProperty is  null                  
    )                                                
    Begin                                                    
         Set @RetVal=920178                             
         Return @RetVal                                                    
    End                    
                  
    -- 合同签约单位不能为空                                            
    If Exists (Select 1 From eStaff_Register                                                   
                Where ID=@ID And ConType is Not null And contract is  null                  
    )                                                    
    Begin                                                    
         Set @RetVal=920179                             
         Return @RetVal                                                    
    End                     
                  
    -- 合同编号不能为空                                            
    --If Exists (Select 1 From eStaff_Register                                                   
    --            Where ID=@ID And ConType is Not null And conNo is  null                  
    --)                                                    
    --Begin                                                    
    --     Set @RetVal=920039                     
    --     Return @RetVal                                                    
    --End                    
                                                    
                                        
    --合同属性为固定期合同，合同期和合同结束日期必须填写                                                 
    if Exists(Select 1 from eStaff_Register                                                  
              Where ID=@ID And ConType is Not null And conproperty = 1                                                 
                    And (conterm is null or conenddate is null )                                                                                  
             )                                                  
    Begin                                                  
         Set @RetVal=920036                           
         Return @RetVal                                                  
    End                   
                  
    --合同属性为非固定期合同，合同期和合同结束日期必须为空                                               
    if Exists(Select 1 from eStaff_Register                                                  
              Where ID=@ID And ConType is Not null And conproperty = 2                                                 
              And (conterm is not null or conenddate is not null )                                                                                  
             )                                                  
    Begin                                                  
         Set @RetVal=920037                                          
         Return @RetVal                   
    End                   
                  
    -- 合同结束日期不能早于合同开始日期                                          
    If Exists (Select 1 From eStaff_Register                                           
               Where ID=@ID And ConType is Not null And conBegindate is Not Null And conenddate is Not Null                  
               And datediff(day,conenddate,conBegindate)>0                  
    )                                                    
    Begin                                                    
         Set @RetVal=920181                             
         Return @RetVal                                                    
    End                     
                  
    -- 合同结束日期不能早于试用结束日期                                          
    If Exists (Select 1 From eStaff_Register                                                   
               Where ID=@ID And ConType is Not null And conenddate is Not Null And ProbEndDate is Not Null                  
               And datediff(day,conenddate,ProbEndDate)>0                  
    )                                                    
    Begin                                                    
         Set @RetVal=920180                             
         Return @RetVal                                                
    End                                        
                                        
                              
    Set @RetVal =0                                           
    Return @RetVal                                          
               
End 