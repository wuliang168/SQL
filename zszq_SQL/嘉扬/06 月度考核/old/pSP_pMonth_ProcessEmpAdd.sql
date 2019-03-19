USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pMonth_ProcessEmpAdd]
@id int,
@eid int,
@URID int,
@RetVal int=0 OutPut
as
begin

    declare @kpimonth smalldatetime,@pProcessid int
    select @kpimonth=kpimonth,@pProcessid=pProcessid from pMonth_Process where id=@id

    -- 本员工已经存在于调整表，请确认管理员是否关闭上次调整！
    if exists(select 1 from pMonth_Process where ISNULL(Initialized,0)=0 and id=@id)
    begin
        set @RetVal=1100003
        return @RetVal
    end

    -- 本月度流程已关闭，不可添加员工！
    if exists(select 1 from pMonth_Process where ISNULL(Submit,0)=1 and id=@id)
    begin
        set @RetVal=1000033
        return @RetVal
    end

    -- 员工已经存在，不可重复添加！
    if exists(select 1 from pMonth_Score where EID=@eid and monthID=@id)
    begin
        set @RetVal=1100001
        return @RetVal
    end

    Begin TRANSACTION
    --插入员工
    insert into pMonth_Score(period,badge,name,depid,depid2,jobid,reportto,wfreportto,kpidepid,pegroup,pstatus,kpiReportTo,monthid)
    select @kpimonth,badge,name,dbo.eFN_getdepid(depid),dbo.eFN_getdepid2(depid),jobid,reportto,wfreportto
    ,kpidepid,pegroup,2,kpiReportTo,@id
    from pEmployee a
    where EID=@eid
    and not exists (select 1 from pMonth_Score where badge=a.badge and monthID=@id)
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