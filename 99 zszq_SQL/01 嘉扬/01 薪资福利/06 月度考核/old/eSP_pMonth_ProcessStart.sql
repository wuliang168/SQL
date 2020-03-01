USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pMonth_ProcessStart]
@id int,
@URID int,
@RetVal int=0 OutPut
as
begin

    --本月已开启，不用重复点击！
    If Exists(Select 1 From pMonth_Process Where ISNULL(Initialized,0)=1 and isnull(id,0)=@id and begindate is not null)
    Begin
        Set @RetVal = 1100043
        Return @RetVal
    End

    Begin TRANSACTION

    -- 更新
    update a
    set a.Initialized=1,a.InitializedTime=GETDATE(),begindate=GETDATE(),eid=@URID
    from pMonth_Process a
    where a.id=@id
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