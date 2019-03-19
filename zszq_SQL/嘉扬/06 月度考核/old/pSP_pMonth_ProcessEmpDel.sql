USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pMonth_ProcessEmpDel]
@id int,
@badge varchar(10),
@URID int,
@RetVal int=0 OutPut
as
begin

    -- 该员工已提交月度审批,不可删除!
    if exists(select 1 from pMonth_Score where isnull(Initialized,0)=1 and badge=@badge and monthID=@id)
    begin
        set @RetVal=1000029
        return @RetVal
    end

    -- 本月度流程已关闭，不可删除员工！
    if exists(select 1 from pProcess_month where ISNULL(Submit,0)=1 and id=@id)
    begin
        set @RetVal=1000034
        return @RetVal
    end

    Begin TRANSACTION

    /*
    delete from SkyPAFormConfig
    where xtype=4 and beforeorafter=1 and xyear= @processid  and PID=(select eid from eemployee where Badge=@badge)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    */

    -- 设置员工考核状态为Closed
    update pMonth_Score set Closed=1 where badge=@badge and isnull(monthid,0)=@id
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