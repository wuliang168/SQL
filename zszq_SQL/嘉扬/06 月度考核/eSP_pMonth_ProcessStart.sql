USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pMonth_ProcessStart]
@id int,
@URID int,
@RetVal int=0 OutPut
as
begin           

    -- 本月月度考核已关闭！
    If Exists(Select 1 From pMonth_Process Where ISNULL(Closed,0)=1 and id=@id)
    Begin
        Set @RetVal = 1100042
        Return @RetVal
    End

    -- 本月月度考核已开启！
    If Exists(Select 1 From pMonth_Process Where ISNULL(Submit,0)=1 and id=@id)
    Begin
        Set @RetVal = 1100043
        Return @RetVal
    End


    Begin TRANSACTION

    -- 插入月度考核员工pMonth_ProcessScore
    insert into pMonth_ProcessScore(KPIMonthID,EID,Initialized,InitializedTime)
    select b.ID,a.EID,1,GETDATE()
    from pEmployee_register a,pMonth_Process b
    where a.pstatus=1 and b.id=@id
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -- 更新月度考核状态pMonth_Process
    update a
    set a.Submit=1,SubmitBy=@URID,a.SubmitTime=GETDATE()
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