USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[ASP_OUTCheckPass]
    @id int,
    @URID int,
    @RetVal int=0 output
AS

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
    /* if exists(select 1 from aout_register where isnull(Initialized,0)=1  and id=@id)                  
    begin                  
    set @RetVal=999013                
    return @RetVal                   
    end       
    if exists(select 1 from aout_register where DATEPART(m,begintime)<>DATEPART(m,endtime)  and id=@id)
    begin                  
        set @RetVal=999014                
        return @RetVal                   
    end*/
    if exists(select 1
    from BS_KQJG
    where DATEPART(Yyyy,@begintime)=term2 and DATEPART(mm,@begintime)=term1)
    begin
        set @RetVal=999015
        return @RetVal
    end
    if exists(select 1
    from aout_register
    where begintime>endtime and DATEDIFF(DD,begintime,EndTime)<>0 and id=@id)
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

    -- 更新外出登记审核结果，标记submit为1
    update aout_register
    set Submit=1,SubmitTime=GETDATE(),SubmitBy= @EID
    where id=@id
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM

    -- 更新考勤异常表，outid对应的添加情况属实标记
    update a
    set Submit=1,SubmitTime=GETDATE(),YCKQJG=N'情况属实，正常出勤'
    from BS_YC_DK a
    where outid=@id
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