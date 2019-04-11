USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[psp_score_each]    Script Date: 12/16/2016 17:20:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- psp_score_each 1109,2,1,1  
ALTER  proc [dbo].[psp_score_each]
@SCOREEID int,
@TYPE int,
-- 对应skysecuser的ID
@URID int,
@RetVal int=0 OutPut                           
as
/**
*** 递交胜任素质评测结果
*** pscore_each
*** score1：团队领导力（20分）
*** score2：目标执行力（20分）
*** score3：系统思维能力（20分）
*** score4：创新能力（20分）
*** score5：人才培养（20分）
*** score9：胜任素质测评合计
*** 胜任素质测评
*** pscore：员工评分及排名信息
*** score8：胜任素质测评合计总分
*** Weight8：
**/
begin

  -- 1000068 递交胜任素质评测失败，各项得分不得超出20分
  -- score1
  if exists (select * from pscore_each where SCOREEID=@SCOREEID  and Eachtype=@TYPE  
  and ISNULL(score1,0) not between 0.1 and 20 
  and isnull(score9,0)<>0 )
    begin
      Set @RetVal=1000068
      Return @RetVal
    end

  -- 1000068 递交胜任素质评测失败，各项得分不得超出20分	
  -- score2
  if exists (select 1 from pscore_each where SCOREEID=@SCOREEID  and Eachtype=@TYPE  
  and  ISNULL(score2,0) not between 0.1 and 20
  and isnull(score9,0)<>0)
    begin                                        
      Set @RetVal=1000068
      Return @RetVal                                        
    end
  
  -- 1000068 递交胜任素质评测失败，各项得分不得超出20分	
  -- score3
  if exists (select 1 from pscore_each where SCOREEID=@SCOREEID  and Eachtype=@TYPE
  and  ISNULL(score3,0) not between 0.1 and 20  
  and isnull(score9,0)<>0)
    begin                                        
      Set @RetVal=1000068
      Return @RetVal                                        
    end

  -- 1000068 递交胜任素质评测失败，各项得分不得超出20分	
  -- score4
  if exists (select 1 from pscore_each where SCOREEID=@SCOREEID  and Eachtype=@TYPE  
  and  ISNULL(score4,0) not between 0.1 and 20  
  and isnull(score9,0)<>0)
    begin                                        
      Set @RetVal=1000068                                        
      Return @RetVal                                        
    end

  -- 1000068 递交胜任素质评测失败，各项得分不得超出20分	
  -- score5
  if exists (select 1 from pscore_each where SCOREEID=@SCOREEID  and Eachtype=@TYPE  
  and  ISNULL(score5,0) not between 0.1 and 20  
  and isnull(score9,0)<>0)
    begin                                        
      Set @RetVal=1000068                                        
      Return @RetVal                                        
    end

  -- 1100026	递交胜任素质评测失败，存在部分字段分数为空！(实际存在问题！！！需要验证)
  if exists (select 1 from pscore_each where SCOREEID=@SCOREEID and Eachtype=@TYPE       
  and isnull(score9,0)<>0 
  and ((isnull(score1,0)=0 
  or isnull(score2,0)=0 
  or isnull(score3,0)=0 
  or isnull(score4,0)=0 
  or isnull(score5,0)=0)))                         
    begin                                        
      Set @RetVal=1100026                                        
      Return @RetVal
    end
         
  Begin TRANSACTION                          

  -------- pscore_each --------
  -- 更新SUBMITTime、SUBMIT和SUBMITby
  update a                      
  set a.SubmitTime=GETDATE(),a.SUBMIT=1,a.Submitby=@URID
  from pscore_each a where SCOREEID=@SCOREEID and Eachtype=@TYPE
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM


  -------- pscore --------
  -- 更新score8
  update a set a.score8=b.score1+b.score2+b.score3
  from pscore a,Pvw_EachScore b
  where a.eid=b.eid
  and a.SCORE_STATUS in (1) and isnull(a.SCORE_EID,0)=0
  and a.eid in  (select eid  from pscore_each a where SCOREEID=@SCOREEID and Eachtype=@TYPE)
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