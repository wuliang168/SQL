USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pMonth_ReSubmit]
    @id int,
    @RetVal int=0 OutPut
/*
	pStatus状态
	0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
*/
as
begin

    -- 该月已评分，无法再次开启！
    If Exists(Select 1 From pEmpProcess_Month Where ISNULL(pingfen,0)<>0 and id=@id
    and monthID in (select id from pProcess_month where DATEDIFF(mm,kpimonth,getdate())>1))
    Begin
        Set @RetVal = 1100043
        Return @RetVal
    End

    -- 该月未开启评分，无法再次开启！
    If Exists(Select 1 From pEmpProcess_Month Where ISNULL(pingfen,0)=0 
    and monthID=(select id from pProcess_month where DATEDIFF(mm,kpimonth,getdate())=0))
    Begin
        Set @RetVal = 1100043
        Return @RetVal
    End

    -- 该月正开启评分，无法再次开启！
    If Exists(Select 1 From pEmpProcess_Month Where ISNULL(pingfen,0)=0 
    and monthID=(select id from pProcess_month where DATEDIFF(mm,kpimonth,getdate())=1))
    Begin
        Set @RetVal = 1100043
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEmpProcess_Month
    -- pStatus状态:0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
    -- 5-已审批|6-已封账 -> 4-历史修改待审批
    update a
    set a.Initialized=NULL,a.InitializedTime=NULL,a.Submit=NULL,a.SubmitTime=NULL,a.Closed=NULL,a.ClosedTime=NULL,
    a.pStatus=4
    from pEmpProcess_Month a
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