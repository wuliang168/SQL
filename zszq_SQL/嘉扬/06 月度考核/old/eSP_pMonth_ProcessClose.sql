USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pMonth_ProcessClose]
@id int,
@URID int,
@RetVal int=0 OutPut
as
begin

    -- 该月已关闭，不用重复点击！
    If Exists(Select 1 From pMonth_Process Where ISNULL(Submit,0)=1 and isnull(id,0)=@id and enddate is not null)
    Begin
        Set @RetVal = 1100042
        Return @RetVal
    End

    -- 存在未完成员工不允许关闭！
    If Exists(Select 1 From pMonth_Score Where ISNULL(Closed,0)=0 and isnull(monthid,0)=@id)
    Begin
        Set @RetVal = 1000012
        Return @RetVal
    End

    Begin TRANSACTION
    -- 如果部门负责人未填写月度工作计划，关闭月度考核时直接完成部门负责人
    update a
    set a.Closed=1,a.ClosedTime=GETDATE()
    from pMonth_Score a
    where badge in (select badge from eemployee where EID in (select DIRECTOR from ODEPARTMENT where DIRECTOR is not null))
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -- 更新pMonth_Process
    update a
    set a.Submit=1,a.SubmitTime=GETDATE(),enddate=GETDATE(),eidclose=@URID
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