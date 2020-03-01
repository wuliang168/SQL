declare @name nvarchar(20),@begindate smalldatetime,@enddate smalldatetime
set @name=N'耿晓东'
set @begindate='2018-2-1 0:0:0'
set @enddate='2018-2-28 0:0:0'

-- 插入全天均未打卡记录
insert into BS_DK_time(term,termType,eid,badge,name,ip,beginTime,endTime)
select Term,1,(select EID from eEmployee where Name=@name),(select Badge from eEmployee where Name=@name),(select Name from eEmployee where Name=@name),NULL,
Dateadd(n,Convert(int,RAND(CheckSum(NewID()))*30),DATEADD(hh,8,Term)),
Dateadd(n,Convert(int,RAND(CheckSum(NewID()))*40),DATEADD(hh,17,Term))
from lCalendar 
where DATEDIFF(DD,term,@begindate)<=0 and DATEDIFF(DD,term,@enddate)>=0
and Term not in (select Term from BS_DK_time where EID=(select EID from eEmployee where Name=@name))
and xType=1

-- 更新上午未打卡、下午已打卡记录
update a
set beginTime=Dateadd(n,Convert(int,RAND(CheckSum(NewID()))*30),DATEADD(hh,8,Term))
from BS_DK_time a
where name=@name and DATEDIFF(DD,term,@begindate)<=0 and DATEDIFF(DD,term,@enddate)>=0
and beginTime is NULL

-- 更新上午已打卡、下午未打卡记录
update a
set endTime=Dateadd(n,Convert(int,RAND(CheckSum(NewID()))*40),DATEADD(hh,17,Term))
from BS_DK_time a
where name=@name and DATEDIFF(DD,term,@begindate)<=0 and DATEDIFF(DD,term,@enddate)>=0
and endTime is NULL

-- 删除打卡异常记录
delete from BS_YC_DK where name=@name and DATEDIFF(DD,term,@begindate)<=0 and DATEDIFF(DD,term,@enddate)>=0