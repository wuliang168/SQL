USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[Psp_Year_leader_1]    Script Date: 12/16/2016 17:28:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_Year_leader_1]  --Psp_Year_leader_1 1297,1,1                                                       
@SCORE_Eid int,                        
@type int, -- score_type=perole
@URID int,                                                            
@RetVal int=0 OutPut                                                             
as
/**          
*** 考核递交评分结果
*** Pscore_temp
*** pSCORE：员工评分及排名信息
*** 总部负责人
**** score1：年度工作评分(百分制)
**** WEIGHT1：年度工作权重
**** score2：履职情况打分(百分制)
**** WEIGHT2：履职情况权重
**** SCORE5：目前得分(80*40%+20分)
**** SCORE6：分管领导评分（80分）
**** WEIGHT6：分管领导权重
**** score9：小计(80分)
**** SCORE8：胜任素质测评（20分）
**** WEIGHT：总裁权重(%)
**** SCORETOTAL：总计
**** 普通员工
**** score1：工作业绩(50分)
**** score2：工作纪律性(5分)
**** score3：上进意识(5分)
**** score4：工作主动性(10分)
**** score5：沟通协调能力(5分)
**** score6：团队协作能力(5分)
**** score7：学习发展能力(10分)
**** score8：合规风控有效性(10分)
**** score9：评分小计
**** score12：其他上级评分
**** score13：员工互评
**** score14：兼职合规得分
**** SCORETOTAL：总分
**/
begin

  -------- Pscore --------

  -- 总部普通员工
  if @Type=4
    begin
      -- 1000070	提交失败，各项得分不能超出标题中标识的范围！
      if exists (isnull(Score1,0) not between 0 and 50
      or isnull(Score2,0) not between 0 and 5
      or isnull(Score3,0) not between 0 and 5
      or isnull(Score4,0) not between 0 and 10
      or isnull(Score5,0) not between 0 and 5
      or isnull(Score6,0) not between 0 and 5
      or isnull(Score7,0) not between 0 and 10
      or isnull(Score8,0) not between 0 and 10)
        begin
          Set @RetVal=1000070
          Return @RetVal
        end
      -- 1000050	提交失败，每项评分都不能为空或等于0
      if exists (isnull(Score1,0)=0 
      or isnull(Score2,0)=0 
      or isnull(Score3,0)=0 
      or isnull(Score4,0)=0                             
      or isnull(Score5,0)=0 
      or isnull(Score6,0)=0 
      or isnull(Score7,0)=0 
      or isnull(Score8,0)=0)
        begin                                                                                
          Set @RetVal=1000050                                                                                
          Return @RetVal                                                                                
        end 
    end


  -- 
  select * 
  from Pscore_temp
  if not exists (select 1 from Pscore where SCORE_EID=@SCORE_Eid and score_type IN (select score_type from Pscore_temp) and isnull(submit,0)=0)
    begin
      Set @RetVal=1100031
      Return @RetVal
    end

  -- 
  if @type in (1,2)
    begin
      -- 
      if exists (select 1 from Pscore where SCORE_EID=@SCORE_Eid and score_type IN (select score_type from Pscore_temp) 
      and (isnull(Score1,0) not between 0 and 50
      or isnull(Score2,0) not between 0 and 5
      or isnull(Score3,0) not between 0 and 5
      or isnull(Score4,0) not between 0 and 10
      or isnull(Score5,0) not between 0 and 5
      or isnull(Score6,0) not between 0 and 5
      or isnull(Score7,0) not between 0 and 10
      or isnull(Score8,0) not between 0 and 10))
        begin
          Set @RetVal=1000070
          Return @RetVal
        end                         
      -- Score均不能为空
      if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid and score_type IN (select score_type from Pscore_temp)                            
      and (isnull(Score1,0)=0 
      or isnull(Score2,0)=0 
      or isnull(Score3,0)=0 
      or isnull(Score4,0)=0                             
      or isnull(Score5,0)=0 
      or isnull(Score6,0)=0 
      or isnull(Score7,0)=0 
      or isnull(Score8,0)=0))                                                     
        begin                                                                                
          Set @RetVal=1000050                                                                                
          Return @RetVal                                                                                
        end                        
    end                           

  -- 
  if @type in (3,4,6,7)
    begin
      -- 
      if exists (select 1 from Pscore where SCORE_EID=@SCORE_Eid and score_type IN (select score_type from Pscore_temp)
      and (isnull(Score1,0) not between 0 and 100
      or isnull(Score2,0) not between 0 and 100))
        begin
          Set @RetVal=1000056
          Return @RetVal
        end                       
      -- 
      if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid and score_type IN (select score_type from Pscore_temp)                            
      and (isnull(Score1,0)=0 
      or isnull(Score2,0)=0))                                                        
        begin                                                                                
          Set @RetVal=1000050                    
          Return @RetVal                                                          
        end                        
    end

  -- 
  if @type in (5) --营业部副职
    begin
      if exists (select 1 from Pscore where SCORE_EID=@SCORE_Eid and score_type IN (select score_type from Pscore_temp)
      and (isnull(Score1,0) not between 0 and 100
      or isnull(Score2,0) not between 0 and 100  
      or isnull(Score7,0) not between 0 and 100))
        begin
          Set @RetVal=1000056
          Return @RetVal
        end
      ---评分为空，不能提交！SCORE_STATUS=1 表示自评
      if exists (select 1 from Pscore Where SCORE_EID=@SCORE_Eid and score_type IN (select score_type from Pscore_temp)
      and (isnull(Score1,0)=0 
      or isnull(Score2,0)=0 
      or isnull(Score7,0)=0))
        begin
          Set @RetVal=1000050
          Return @RetVal
        end
    end

  -- 
  if exists (select * from pvw_ScoreEID a Left join Pscore b on a.EID=b.EID and b.SCORE_TYPE=a.perole and  b.score_status=a.slevel
  where a.kpieid1=@SCORE_Eid and b.id is null and a.perole IN (select score_type from Pscore_temp))
    begin
      Set @RetVal=1000069
      Return @RetVal
    end

  Begin TRANSACTION                                                            

  -------- pSCORE --------
  -- 总部负责人
  if @Type=1
    begin
      insert into Pscore_temp
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (1) and SCORE_STATUS<>1 and isnull(submit,0)=0
    end

  -- 总部合规负责人
  -- 
  if @Type=
    begin
      insert into Pscore_temp
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (1) and SCORE_STATUS<>1 and isnull(submit,0)=0
    end

  -- 总部副职
  if @Type=2
    begin
      insert into Pscore_temp
      select EID,SCORE_EID,score_type
      from pscore
      where SCORE_EID=@SCORE_Eid and score_type in (2) and SCORE_STATUS<>1 and isnull(submit,0)=0
    end

  -- 子公司部门负责人
  if @Type=10
    begin
      insert into Pscore_temp
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (10) and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end                        

  -- 分公司负责人
  if @Type=24
    begin
      insert into Pscore_temp                         
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (24) and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end     

  -- 分公司副职
  if @Type=25
    begin
      insert into Pscore_temp                         
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (25) and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end     

  -- 一级营业部负责人
  if @Type=5
    begin
      insert into Pscore_temp
      select  EID,SCORE_EID,score_type
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (5) and SCORE_STATUS<>1 and isnull(submit,0)=0
    end       

  -- 一级营业部副职
  if @Type=6
    begin
      insert into Pscore_temp
      select EID,SCORE_EID,score_type
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (6) and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end   

  -- 二级营业部经理室
  if @Type=7
    begin
      insert into Pscore_temp                         
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (7) and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end     

  -- 总部普通员工
  if @Type=4
    begin
      update Pscore
      set submit=1,submitby=@SCORE_Eid,submittime=GETDATE()
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (4) and SCORE_STATUS=2
    end

  -- 子公司普通员工
  if @Type=11
    begin
      insert into Pscore_temp
      select  EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (11) and SCORE_STATUS<>1
    end

  -- 分公司普通员工
  if @Type=29
    begin
      insert into Pscore_temp                         
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (29) and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end

  -- 一级营业部普通员工
  if @Type=12
    begin                         
      insert into Pscore_temp                         
      select EID,SCORE_EID,score_type
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (12) and SCORE_STATUS<>1 and isnull(submit,0)=0                        
    end   

  -- 二级营业部普通员工
  if @Type=13
    begin
      insert into Pscore_temp                         
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (13) and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end

  -- 合规风控专员
  if @Type=14
    begin                         
      insert into Pscore_temp                        
      select EID,SCORE_EID,score_type
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (14) and SCORE_STATUS<>1 and isnull(submit,0)=0                        
    end  

  -- 营业部合规分控联系人
  -- 
  if @Type=
    begin
      insert into Pscore_temp                         
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in () and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end

  -- 总部兼职合规专员
  -- 
  if @Type=
    begin
      insert into Pscore_temp                         
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in () and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end

  -- 区域财务经理
  if @Type=17
    begin                         
      insert into Pscore_temp                        
      select EID,SCORE_EID,score_type
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (17) and SCORE_STATUS<>1 and isnull(submit,0)=0                        
    end

  -- 综合会计（集中）
  if @Type=19
    begin
      insert into Pscore_temp
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (19) and SCORE_STATUS<>1 and isnull(submit,0)=0                       
    end

  -- 综合会计（非集中）
  if @Type=20
    begin
      insert into Pscore_temp
      select EID,SCORE_EID,score_type 
      from pscore 
      where SCORE_EID=@SCORE_Eid and score_type in (20) and SCORE_STATUS<>1 and isnull(submit,0)=0
    end

  -- 异常处理
  IF @@Error <> 0
  Goto ErrM                                          

  -- 
  insert into pSCORE(eid,badge,name,kpidep,PPROCESSid,period,SCORE_EID,SCORE_STATUS,Weight,Score_type,Initialized,InitializedTime,Initializedby,PREID,isRanking)
  select b.EID,b.Badge,b.name,b.kpidep,pProcessID,period,a.kpieid1,slevel,a.modulus1,a.perole,0,GETDATE(),@SCORE_EID,id ,isRanking
  from Pscore b ,pvw_ScoreEID a
  where a.EID=b.EID and b.SCORE_TYPE=a.perole and b.score_status+1=a.slevel and b.score_status=2
  and SCORE_EID=@SCORE_Eid and score_type IN (select score_type from Pscore_temp)
  and not exists (select 1 from pSCORE where eid=b.EID and SCORE_EID=a.kpieid1 and Score_type=a.perole)
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM

  -- 取上级分数--中层                    
  update  a set a.score6=b.score9,a.Weight6=b.Weight                    
  from pscore a,pscore b                    
  where a.eid=b.eid and a.SCORE_TYPE=b.SCORE_TYPE and a.SCORE_STATUS=b.SCORE_STATUS+1                    
  and a.SCORE_TYPE in (1,2,10,5,6,7,8) and a.SCORE_STATUS=3                    
  and b.SCORE_EID=@SCORE_Eid and b.score_type IN (select score_type from Pscore_temp)

  --取营业部和专业部门分数--合规电脑财务
  update  a set a.score5=b.EIDSCore1,a.weight5=b.weight1,a.score6=b.EIDSCore2,a.weight6=b.weight2
  from pscore a,pvw_bizscore b
  where a.eid=b.eid and a.SCORE_TYPE=b.SCORE_TYPE and a.SCORE_STATUS=3
  and a.SCORE_TYPE in (14,17,21)
  and a.SCORE_EID=@SCORE_Eid and a.score_type IN (select score_type from Pscore_temp)
  -- 异常处理
  IF @@Error <> 0                                                                                 
  Goto ErrM

  -- 取上级分数--二级员工
  update  a set a.score12=b.SCORE9 ,a.Weight12=b.Weight
  from pscore a,pscore b                    
  where a.eid=b.eid and a.SCORE_TYPE=b.SCORE_TYPE and a.SCORE_STATUS=b.SCORE_STATUS+1                    
  and a.SCORE_TYPE in (4,11,12,13,19,20) and a.SCORE_STATUS=3                    
  and b.SCORE_EID=@SCORE_Eid and b.score_type IN (select score_type from Pscore_temp)                    
  -- 异常处理
  IF @@Error <> 0                                                                                 
  Goto ErrM
   
  -- 取胜任力测评分数
  update a set a.score8=b.totle*c.Weight8/100
  from pscore a,Pvw_EachScore b,pCD_PeRole c
  where a.eid=b.eid and a.SCORE_TYPE=c.ID
  and a.SCORE_STATUS=(select maxlevel from  pvw_MaxLevel where eid=a.eid and perole=a.SCORE_TYPE)
  and a.SCORE_EID=@SCORE_Eid and a.score_type IN (select score_type from Pscore_temp)
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM
   
  -- 更新互评分数    
  update a set a.score13=c.Score_huping
  from pscore a 
  Left join pscore b on b.id=a.PreID
  left join pVW_HuPingScore c on a.eid=c.eid
  where isnull(a.SCORE13,0)<>c.Score_huping and b.SCORE_STATUS=2
  and c.rate1=1
  and b.SCORE_TYPE not in (14,15,16,22,23)
  and b.SCORE_EID=@SCORE_Eid and b.score_type IN (select score_type from Pscore_temp)
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM
   
  --   
  update a set a.ranking=b.ranking1              
  from pscore a , pvw_ranking b  ,pvw_MaxLevel c              
  where a.eid=b.eid and a.eid=c.EID and a.SCORE_TYPE=c.perole and a.SCORE_STATUS=c.MaxLevel              
  and a.SCORE_EID=@SCORE_Eid and a.score_type IN (select score_type from Pscore_temp)                 
  and a.SCORE_TYPE not in (15,16)   
  -- 异常处理
  IF @@Error <> 0                                             
  Goto ErrM
   
                     
                  
  -- 删除Pscore_temp
  delete from Pscore_temp                        

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
