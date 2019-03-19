USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pMonth_PlanSummStart]
  @id int,
  @URID int,
  @RetVal int=0 OutPut
as
begin
  -- 0106begin
  declare @EID int,@monthid int

  select @monthid=monthID from pMonth_Score where id=@id
  select @EID=EID from pMonth_Score where id=@id

  -- 没有上月工作小结，不可递交！
  if exists (select 1 from pMonth_PlanSumm where EID=@EID and MONTHSCOOP is null and MONTHID=(@monthid-1))
  begin
    set @RetVal=1100037
    return @retval
  end

  -- 月度计划内容为空
  if exists (select 1 from pMonth_PlanSumm where EID=@EID and monthtitle is null and MONTHID=@monthid)
  begin
    set @RetVal=1100049
    return @retval
  end

  Begin TRANSACTION

  -- 更新pMonth_Score
  -- pstatus为3表示完成当月月度工作计划以及上月工作小结
  update a
  set a.InitializedTime=GETDATE(),a.Initialized=1,a.SubmitTime=GETDATE(),pstatus=3
  from pMonth_Score a
  where id=@id
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM

  -- 更新pMonth_PlanSumm的当月月度工作计划初始化状态和初始化时间
  update a
  set a.InitializedTime=GETDATE(),a.Initialized=1
  from pMonth_PlanSumm a
  where monthid=@monthid and EID=@EID
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM

  -- 更新pMonth_PlanSumm的上月月度工作计划初始化状态和初始化时间
  update a
  set a.InitializedTime=GETDATE(),a.Initialized=1
  from pMonth_PlanSumm a
  where monthid=(@monthid-1) and EID=@EID
  -- 异常处理
  IF @@Error <> 0
  Goto ErrM

  -- perole为1和5表示总部部门负责人、分公司负责人和一级营业部负责人，其考核不需要考评
  if @EID in (select EID from PEMPLOYEE_REGISTER where isnull(PEROLE,0) in (1,5,24))
  begin
    update a
    set a.ClosedTime=GETDATE(),a.Closed=1,a.pingfendate=GETDATE(),a.pstatus=5
    from pMonth_Score a
    where id=@id
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
  end

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