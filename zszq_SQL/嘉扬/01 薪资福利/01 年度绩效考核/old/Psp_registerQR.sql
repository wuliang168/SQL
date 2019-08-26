USE [zszq]
GO
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
**/
Begin


  --数据已经确认！
  If Exists(Select 1
  From pEmployee_register
  Where eID=@eid And Isnull(Initialized,0)=1)
    Begin
    Set @RetVal = 910000
    Return @RetVal
  End

  --状态不能为空
  if Exists(Select 1
  From pEmployee_register
  Where eID=@eid And Isnull(pstatus,0)=0) 
    begin
    Set @RetVal = 910071
    Return @RetVal
  end

  --状态为开启状态时  
  if Exists(Select 1
  From pEmployee_register
  Where eID=@eid And Isnull(pstatus,0)=1 and ISNULL(perole,0)=0)
  Begin
    Set @RetVal = 910067
    -- 910067,N'确认失败，考核角色不能为空!'
    Return @RetVal
  End

  Begin TRANSACTION

  -------- pEmployee_register --------
  -- 更新Initialized和InitializedTime
  update pEmployee_register 
  set Initialized=1,InitializedTime=GETDATE() 
  where EID=@eid
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