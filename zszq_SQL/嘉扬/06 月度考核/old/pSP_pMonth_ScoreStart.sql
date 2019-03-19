USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pMonth_ScoreStart]
@id int,
@URID int,
@RetVal int=0 OutPut
as
begin
    -- 月度评分不能为空！
    If Exists(Select 1 From pMonth_Score Where ID=@ID And PINGFEN is null)
    Begin
        Set @RetVal = 1000044
        Return @RetVal
    End

    Begin TRANSACTION

    -- 更新pMonth_Score
    -- pstatus为5表示完成月度考核评分和评语
    update a          
    set a.ClosedTime=GETDATE(),a.Closed=1,a.pingfendate=GETDATE(),a.pstatus=5
    from pMonth_Score a
    where id=@id
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