USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[Psp_registerQR]    Script Date: 12/15/2016 17:58:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_registerQR]                       
@eid int,                         
@URID int,                          
@RetVal int=0 OutPut                          
as
/**
*** 考核关系设置确认处理
*** pEmployee_register：
*** pemployee：
*** pEmpprocess_month：
**/
Begin    
  declare     
  @Kpidepid int,  
  @pegroup int,  
  @perole int,  
  @pstatus int,  
  @compliance int,  
  @kpireportto int,  
  @kpieid1 int,  
  @kpieid2 int

  -- 
  select @Kpidepid=Kpidepid,@pegroup=pegroup,@perole=perole,@pstatus=pstatus,@compliance=compliance,
  @kpireportto=kpireportto,@kpieid1=kpieid1,@kpieid2=kpieid2 
  from pEmployee_register 
  where eid=@eid           

  --数据已经确认！                                   
  If Exists(Select 1 From pEmployee_register Where eID=@eid And Isnull(Initialized,0)=1)
    Begin                                  
      Set @RetVal = 910000                              
      Return @RetVal                                  
    End

  --状态不能为空                  
  if isnull(@pstatus,0)=0  
    begin  
      Set @RetVal = 910071                              
      Return @RetVal    
    end

  --状态为开启状态时  
  if @pstatus=1  
  Begin
    -- 
    If Exists(Select 1 From pEmployee_register Where eID=@eid And ISNULL(perole,0)=0)                                  
      Begin                                  
        Set @RetVal = 910067 -- 910067,N'确认失败，考核角色不能为空!'                         
        Return @RetVal                                  
      End
    -- 
    --If Exists(Select 1 From pEmployee_register Where eID=@eid And ISNULL(kpiReportTo,0)=0)                                  
    --  Begin                                  
    --    Set @RetVal = 910070 -- 910070,N'确认失败，审核人不能为空，审核人应为本人直接主管!'                         
    --    Return @RetVal                                  
    --  End
    -- 
    --If Exists(Select 1 From pEmployee_register  Where eID=@eid And ISNULL(kpieid1,0)=0)                                  
    --  Begin                                  
    --    Set @RetVal = 910068 -- 910068,N'确认失败，考核人1不能为空，考核人1应为部门总经理或分管领导!'                         
    --    Return @RetVal
    --  End                    
    -- 请确认权重和是否为100！！                                   
    --If Exists(Select 1 From pEmployee_register Where eID=@eid 
    --And isnull(modulus1,0)+isnull(modulus2,0)+isnull(modulus3,0)+isnull(modulus4,0)+isnull(modulus5,0)+isnull(modulus6,0)<>100)                                  
      --Begin                                  
        --Set @RetVal = 1000032                              
        --Return @RetVal                                  
      --End                                  
  end  

  Begin TRANSACTION                       

  -------- pEmployee_register --------
  -- 更新Initialized和InitializedTime
  update pEmployee_register 
  set Initialized=1,InitializedTime=GETDATE() 
  where EID=@eid                      
  -- 异常处理
  IF @@Error <> 0                                         
  Goto ErrM                         


  -------- pemployee--------
  -- 
  update a                      
  set a.kpidepid=b.kpidepid,a.pegroup=b.pegroup,a.perole=b.perole,a.pstatus=b.pstatus,a.compliance=b.compliance                      
  ,a.kpiReportTo=b.kpiReportTo,a.kpieid1=b.kpieid1,a.modulus1=b.modulus1,a.kpieid2=b.kpieid2,a.modulus2=b.modulus2                      
  ,a.kpieid3=b.kpieid3,a.modulus3=b.modulus3,a.kpieid4=b.kpieid4,a.modulus4=b.modulus4,a.kpieid5=b.kpieid5                      
  ,a.modulus5=b.modulus5,a.kpieid6=b.kpieid6,a.modulus6=b.modulus6                      
  from pemployee a,pEmployee_register b                      
  where a.EID=b.EID and b.EID=@eid                      
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM


  -------- pEmpprocess_month --------
  --更新未完成的打分的月度计划            
  update a
  set a.kpidepid=b.kpidepid,a.pegroup=b.pegroup,
  a.kpiReportTo=b.kpiReportTo
  from pEmpprocess_month a,pEmployee_register b
  where a.badge=b.Badge and isnull(a.Closed,0)=0  and b.EID=@eid
  -- 异常处理 
  IF @@Error <> 0
  Goto ErrM

  -- 正常处理流程
  COMMIT TRANSACTION
  Set @RetVal=0
  Return @RetVal

  -- 异常处理流程
  ErrM:
  ROLLBACK TRANSACTION
  If isnull(@RetVal,0)=0
    Set @RetVal=-1
    Return @RetVal
                            
end