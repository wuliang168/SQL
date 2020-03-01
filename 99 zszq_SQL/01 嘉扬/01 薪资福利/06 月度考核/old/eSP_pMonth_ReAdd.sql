USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pMonth_ReAdd]
    @id int,
    @badge varchar(50),
    @monthid int,
    @RetVal int=0 OutPut
/*
	pStatus状态
	0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
*/
as
begin

    declare @period smalldatetime

    set @period=(select period from pEmpProcess_Month where ID=@ID)

    -- 该月未开启评分，无法再次开启！
    If Exists(Select 1 From pEmpProcess_Month a
    Where id=@id and (select ISNULL(Submit,0) from pProcess_month where ID=a.monthID)=0
    and (select ISNULL(Initialized,0) from pProcess_month where ID=a.monthID)=1)
    Begin
        Set @RetVal = 1100050
        Return @RetVal
    End

    -- 该月正开启评分，无法再次开启！
    If Exists(Select 1 From pEmpProcess_Month a
    Where id=@id 
    and DATEDIFF(MM,a.period,(select kpimonth from pProcess_month where ISNULL(Initialized,0)=1 and ISNULL(Submit,0)=0))=1)
    Begin
        Set @RetVal = 1100051
        Return @RetVal
    End

    -- 该月已评分，无法再次开启！
    If Exists(Select 1 From pEmpProcess_Month Where ISNULL(pingfen,0)<>0 and id=@id)
    Begin
        Set @RetVal = 1100052
        Return @RetVal
    End

    -- 该月已重新递交过，无法再次开启！
    If Exists(Select 1 From pEmpProcess_Month Where ISNULL(IsReSubmit,0)<>0 and id=@id)
    Begin
        Set @RetVal = 1100053
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEmpProcess_Month
    -- pStatus状态:0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
    -- 5-已审批|6-已封账 -> 4-历史修改待审批
    insert into pMonth_ASS_all (xorder,begindate,enddate,badge,monthid)
    values ((select count(1)+1 from PMONTH_ASS_ALL where BADGE=@badge and monthid=@monthid),
    DATEADD(dd, 0, DATEADD(mm, DATEDIFF(m, 0, @period), 0)),
    DATEADD(dd, -1, DATEADD(mm, DATEDIFF(m, 0, @period) + 1, 0)),@badge,@monthid)
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