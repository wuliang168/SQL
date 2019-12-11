USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec bs_DK_Start_OA  

ALTER proc  [dbo].[bs_DK_Start_OA]
    @RetVal int=0 output
as
begin

    declare @ip varchar(50)
    declare @time smalldatetime
    select @time=GETDATE()

    -- 同步OA上班时间(最小打卡日期) qtype=0
    ---- 同步的时候时间未存在
    insert into BS_DK_time(term,termType,eid,badge,name,beginTime,remark)
    select qday, c.xType, EID, Badge, Name, qday+' '+MIN(qtime), 'OA_Begin_i'
    from skysecuser a, openquery(OA, 'select * from QIANDAO') b, lCalendar c
    where datediff(day, @time,Qday)=0 and b.userid=a.Account and qtype=0 and c.Term=b.qday
    and not exists (select 1 from BS_DK_time where eid=a.EID and DATEDIFF(DAY,term,b.qday)=0)
    group by qday,EID,Badge,Name,c.xType

    -- 同步OA下班时间(最大打卡日期) qtype=1
    ---- 同步的时候时间未存在
    insert into BS_DK_time(term,termType,eid,badge,name,endTime,remark)
    select qday, c.xType, EID, Badge, Name, qday+' '+MAX(qtime), 'OA_END_i'
    from skysecuser a, openquery(OA, 'select * from QIANDAO') b, lCalendar c
    where datediff(day, @time,Qday)=0 and b.userid=a.Account and qtype=1 and c.Term=b.qday
    and not exists (select 1 from BS_DK_time where eid=a.EID and DATEDIFF(DAY,term,b.qday)=0)
    group by qday,EID,Badge,Name,c.xType

    -- 更新eHR上班时间(最小打卡日期)
    ---- 同步的时候已经存在数据，更新的目的未知
    Update a 
    set a.begintime=a1.begintime,a.remark=isnull(a.remark,'')+'|OA_BEGIN_u'
    from BS_DK_time a,(select qday, EID, qday+' '+MIN(qtime) as begintime 
        from skysecuser a, openquery(OA, 'select * from QIANDAO') b
        where datediff(day, @time,Qday)=0 and b.userid=a.Account and qtype=0
        group by qday,EID) a1
    where a.eid=a1.EID and datediff(day,a.term,a1.qday)=0 and isnull(a.beginTime,a1.begintime)>=a1.begintime

    -- 更新eHR下班时间(最大打卡日期)
    ---- 同步的时候已经存在数据，更新的目的未知
    Update a 
    set a.endtime=a1.endtime,a.remark=isnull(a.remark,'')+'|OA_End_u'    
    from BS_DK_time a,(select qday, EID, qday+' '+MAX(qtime) as endtime
        from skysecuser a, openquery(OA, 'select * from QIANDAO') b
        where datediff(day, @time,Qday)=0 and b.userid=a.Account and qtype=1
        group by qday,EID) a1    
    where a.eid=a1.EID and datediff(day,a.term,a1.qday)=0 and isnull(a.endTime,a1.endtime)<=a1.endtime

end