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

    update aout_register
    set Initialized=1,InitializedTime=GETDATE(),InitializedBy=@EID
    where id=@id

    IF @@Error <> 0
    Goto ErrM

    update a 
    set a.initialized=1 ,InitializedTime=GETDATE(),outid=@id
    --,Submit=1,SubmitTime=GETDATE(),YCKQJG=N'情况属实，正常出勤'
    from BS_YC_DK a where eid=@EID and DateDiff (day,a.term,@begintime)<=0 and DateDiff (day,a.term,@endtime)>=0


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