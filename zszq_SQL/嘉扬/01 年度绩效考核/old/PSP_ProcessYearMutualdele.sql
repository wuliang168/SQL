USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[PSP_ProcessYearMutualdele]    Script Date: 12/13/2016 13:30:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[PSP_ProcessYearMutualdele]           
@id int,                    
@URID int,                    
@RetVal int=0 output               
as
/**          
*** 1. 年度考核互评关闭
*** pProcess：年度考核流程
*** PASSDEP_PROCESS：
*** SkyPAFormConfig：
*** pscore
**/  
begin     
  -- 1100024	年度普通员工互评和胜任素质测评还未开启，无法关闭
  if exists(select 1 from PPROCESS where id=@id and ISNULL(HPKQ,0)=0)
    begin
      set @RetVal=1100024
      return @RetVal
    end


  Begin TRANSACTION                  
  -------- PPROCESS --------
  -- 更新HPGB()
  update a              
  set a.HPGB=1              
  from PPROCESS a              
  where id=@id              
  -- 异常处理
  IF @@Error <> 0                                       
  Goto ErrM   


  -------- PASSDEP_PROCESS --------
  -- 更新Closed和Closedtime
  update a   
  set a.Closed=1,a.Closedtime=GETDATE()
  from PASSDEP_PROCESS a
  where pProcessid=@id
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM 


  -------- pscore --------
  -- 更新score_status
  --------- 普通员工互评测评 --------
  -- sLevel 1：关闭员工互评
  -- 4-总部普通员工；29-分公司普通员工；11-子公司普通员工；12-一级营业部普通员工；13-二级营业部普通员工
  update pscore 
  set Closed=1, ClosedTime=GETDATE(),Closedby=@URID
  where SCORE_TYPE in (4,29,11,12,13) AND SCORE_STATUS=1
  -- 异常处理    
  IF @@Error <> 0
  Goto ErrM

  --------- 胜任素质测评 --------
  -- sLevel 1：关闭胜任素质测评
  -- 1-总部部门负责人；2-总部部门副职；10-子公司部门负责人；24-分公司负责人；25-分公司副职；5-一级营业部负责人；6-一级营业部副职；7-二级营业部经理室成员
  update pscore 
  set Closed=1, ClosedTime=GETDATE(),Closedby=@URID
  where SCORE_TYPE in (1,2,10,24,25,5,6,7) AND SCORE_STATUS=1
  -- 异常处理    
  IF @@Error <> 0
  Goto ErrM
  

  -------- SkyPAFormConfig --------
  -- 删除互评节点
  delete from SkyPAFormConfig where xyear= @id and RIGHT(id,2)=38 and xtype=7
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