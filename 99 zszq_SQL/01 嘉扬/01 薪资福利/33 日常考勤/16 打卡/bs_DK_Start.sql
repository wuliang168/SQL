USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[bs_DK_Start]
    @eid int,
    @RetVal int=0 output
as
begin

    -- 声明@ip变量
    declare @ip varchar(50)

    -- 定义@ip变量值
    ---- 实际意义不大，个人PC到人力资源服务器之间会做源IP的NAT转换，因此源IP地址可能会被修改
    select @ip=SUBSTRING(LocalUser,19,LEN(localuser))
    from skySecUserLog a, skySecUser b
    where a.URID=b.ID and b.EID=@eid and CONVERT(VARCHAR(20),a.OPData)=N'v8bs' and a.OPText='login ok'
        and a.ID=(select MAX(ID)
        from skySecUserLog
        where URID=b.ID and CONVERT(VARCHAR(20),a.OPData)=N'v8bs')
    -- 如果@ip为空
    if LEN(@ip)=0
    begin
        select @ip=SUBSTRING(HostName,1,LEN(HostName)-1)
        from skySecUserLog a, skySecUser b
        where a.URID=b.ID and b.EID=@eid and CONVERT(VARCHAR(20),a.OPData)=N'v8bs' and a.OPText='login ok'
            and a.ID=(select MAX(ID)
            from skySecUserLog
            where URID=b.ID and CONVERT(VARCHAR(20),a.OPData)=N'v8bs')
    end


    -- 如果存在上午的打卡记录，则提示上午重复打卡
    if exists(select 1
    from BS_DK_time
    where eid=@eid
        and datediff(day,getdate(),beginTime)=0
        and DATEPART(HOUR,GETDATE()) between 0 and 11
    )
    begin
        set @RetVal=999008
        return @RetVal
    end

    ---如果存在下午的打卡记录，则提示下午重复打卡
    if exists(select 1
    from BS_DK_time
    where eid=@eid
        and datediff(day,getdate(),endTime)=0
        and DATEPART(HOUR,GETDATE()) between 12 and 24 )
    begin
        set @RetVal=999011
        return @RetVal
    end


    --insert into skyMSGAlarm(ID,Title)
    --select 999011,N'您下午已打卡！'


    -- 如果上午未打卡，则新增上午打卡记录
    if not exists(select 1
        from BS_DK_time
        where DATEDIFF(DAY,term,GETDATE())=0
            and eid=@eid )
        and DATEPART(HOUR,GETDATE()) between 0 and 11
    begin
        insert into BS_DK_time
            (term,termType,eid,badge,name,ip,beginTime)
        select convert(varchar(10),GETDATE(),120), a.xType, b.EID, b.Badge, b.Name, @ip, GETDATE()
        from lCalendar a, eemployee b
        where DATEDIFF(DAY,Term,GETDATE())=0 and b.EID=@eid

    end
    -- 如果上午已经打卡，则更新下午打卡记录
    update BS_DK_time 
    set endTime=GETDATE() 
    where DATEPART(HOUR,GETDATE()) between 12 and 24
    and eid=@eid and DATEDIFF(DAY,term,GETDATE())=0

    -- 如果上午未打卡，则新增下班打卡数据
    if not exists(select 1
        from BS_DK_time
        where DATEDIFF(DAY,term,GETDATE())=0 and eid=@eid)
        and DATEPART(HOUR,GETDATE()) between 12 and 24
    begin
        insert into BS_DK_time
            (term,termType,eid,badge,name,ip,endTime)
        select convert(varchar(10),GETDATE(),120), a.xType, b.EID, b.Badge, b.Name, @ip, GETDATE()
        from lCalendar a, eemployee b
        where DATEDIFF(DAY,Term,GETDATE())=0 and b.EID=@eid
    end

    set @RetVal=0
    return @RetVal


end