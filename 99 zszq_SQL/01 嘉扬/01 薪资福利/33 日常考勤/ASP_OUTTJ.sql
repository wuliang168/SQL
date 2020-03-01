USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[ASP_OUTTJ]
    @id int,
    @URID int,
    @RetVal int=0 output
as

Declare @badge varchar(20),
        @EID int,
        @depid int,
        @begintime smalldatetime,
        @endtime  smalldatetime

begin
    select @begintime=begintime
    from aout_register
    where id=@id
    select @endtime=endtime
    from aout_register
    where id=@id

    -- 开始日期不能大于结束日期
    If DATEDIFF(DD,@begintime,@endtime)<0
    Begin
        Set @RetVal = 941105
        Return @RetVal
    End

    --if exists(select 1 from aout_register where ltrim(rtrim(REMARk)) is null and id=@id)
    --begin
    -- set @RetVal=999012
    -- return @RetVal
    --end

    if exists(select 1
    from aout_register
    where (begintime is null or endtime is null) and id=@id)
    begin
        set @RetVal=999017
        return @RetVal
    end

    if exists(select 1
    from aout_register
    where isnull(Initialized,0)=1 and id=@id)
    begin
        set @RetVal=999013
        return @RetVal
    end

    if exists(select 1
    from BS_KQJG
    where DATEPART(Yyyy,@begintime)=term2 and DATEPART(mm,@begintime)=term1)
    begin
        set @RetVal=999015
        return @RetVal
    end

    if exists(select 1
    from aout_register
    where DATEDIFF(dd,begintime,endtime)<0 and id=@id)
    begin
        set @RetVal=999016
        return @RetVal
    end

    Begin TRANSACTION

    Select @badge = badge
    From aout_register
    Where ID=@ID

    Select @EID=EID
    From aout_register
    Where ID=@ID

    Select @depid=depid
    From aout_register
    Where ID=@ID

    -- 更新外出登记的递交状态，并添加部门考核人
    update a
    set a.Initialized=1,a.InitializedTime=GETDATE(),a.InitializedBy=@EID,a.ReportTo=b.ReportToDaily
    from aout_register a,pVW_EMPReportToDaily b
    where a.EID=b.EID and a.id=@id
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM

    -- 在考勤异常表中，插入外出登记的ID
    update a 
    set a.initialized=1 ,InitializedTime=GETDATE(),outid=@id
    --,Submit=1,SubmitTime=GETDATE(),YCKQJG=N'情况属实，正常出勤'
    from BS_YC_DK a 
    where eid=@EID and DateDiff (day,a.term,@begintime)<=0 and DateDiff (day,a.term,@endtime)>=0
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM

    -- 外出登记人为部门负责人，自动批复
    ---- 外出登记
    update a
    set Submit=1,SubmitTime=GETDATE(),SubmitBy=@EID
    from aout_register a
    where a.id=@id and a.EID=a.ReportTo
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM
    ---- 考核异常
    update a
    set a.Submit=1,a.SubmitTime=GETDATE(),a.YCKQJG=N'情况属实，正常出勤'
    from BS_YC_DK a
    where a.EID=@EID and a.outid is not NULL 
    and a.outid=ISNULL((select ID from aout_register where id=@id and EID=ReportTo),0)
    and DateDiff (day,a.term,@begintime)<=0 and DateDiff (day,a.term,@endtime)>=0
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM


    COMMIT TRANSACTION
    Set @Retval = 0
    Return @Retval

    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval

end