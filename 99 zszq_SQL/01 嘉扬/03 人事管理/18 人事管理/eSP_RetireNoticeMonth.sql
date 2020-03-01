USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_RetireNoticeMonth]
as
Begin

    -- 申明及定义人力资源部人事管理室劳动关系岗
    declare @HR int
    set @HR=(select EID from eEmployee where Name=N'庄武君')

    -- 人力资源部人事管理室劳动关系岗(提前45天通知)
    ---- 发送短信提醒
    INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
    select (select a.Mobile from eDetails a,eEmployee b where a.EID=b.EID and b.EID=@HR),
    N'提前45天通知内容：'+b.Name+'('+b.Badge+')'+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
    N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄【人力资源部】'
    from eStatus a,eEmployee b
    where a.EID=b.EID and b.Status not in (4,5)
    and DATEDIFF(dd,GETDATE(),a.RetireDate)<=45 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
    ---- 发送邮箱提醒
    INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
    select (select a.OA_mail from eDetails a,eEmployee b where a.EID=b.EID and b.EID=@HR),
    N'提前45天通知内容',b.Name+'('+b.Badge+')'+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
    N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
    from eStatus a,eEmployee b
    where a.EID=b.EID and b.Status not in (4,5)
    and DATEDIFF(dd,GETDATE(),a.RetireDate)<=45 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0


    -- 发送短信提醒(提前30天通知)
    ---- 退休者本人
    INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
    select c.Mobile,b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
    N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】'
    from eStatus a,eEmployee b,eDetails c
    where a.EID=b.EID and b.Status not in (4,5) and a.EID=c.EID and b.DepID<>349
    and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
    ---- 退休者部门负责人
    ------ 非公司领导，非部门负责人
    INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
    select c.Mobile,b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
    N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】'
    from eStatus a,eEmployee b,eDetails c,oDepartment d
    where a.EID=b.EID and b.Status not in (4,5) and b.DepID<>349
    and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
    and ((dbo.eFN_getdepid1st(b.DepID)=d.DepID and d.DepType in (1,4)) or (b.DepID=d.DepID and d.DepType in (2,3)))
    and ISNULL(d.Director,d.Director2)=c.EID and ISNULL(d.Director,d.Director2)<>b.EID
    ------ 公司领导
    -------- 董事长
    --INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
    --select c.Mobile,b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
    --N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】'
    --from eStatus a,eEmployee b,eDetails c,oDepartment d
	--where a.EID=b.EID and b.Status not in (4,5) and b.DepID=349
	--and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
	--and ((dbo.eFN_getdepid1st(b.DepID)=d.DepID and d.DepType in (1,4)) or (b.DepID=d.DepID and d.DepType in (2,3)))
	--and ISNULL(d.Director,d.Director2)=c.EID and b.EID<>1112
	-------- 书记
	--INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
	--select c.Mobile,b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
	--N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】'
	--from eStatus a,eEmployee b,eDetails c,oDepartment d
	--where a.EID=b.EID and b.Status not in (4,5) and b.DepID=349
	--and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
	--and ((dbo.eFN_getdepid1st(b.DepID)=d.DepID and d.DepType in (1,4)) or (b.DepID=d.DepID and d.DepType in (2,3)))
	--and 5587=c.EID and b.EID<>1112
	-------- 总裁
	--INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
	--select c.Mobile,b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
	--N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】'
	--from eStatus a,eEmployee b,eDetails c,oDepartment d
	--where a.EID=b.EID and b.Status not in (4,5) and b.DepID=349
	--and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
	--and ((dbo.eFN_getdepid1st(b.DepID)=d.DepID and d.DepType in (1,4)) or (b.DepID=d.DepID and d.DepType in (2,3)))
	--and 5014=c.EID and b.EID<>1112
	---- 人力资源部人事管理室劳动关系岗
	INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
	select (select a.Mobile from eDetails a,eEmployee b where a.EID=b.EID and b.EID=@HR),
	b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
	N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】'
	from eStatus a,eEmployee b
	where a.EID=b.EID and b.Status not in (4,5)
	and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0


	-- 发送邮箱提醒(提前30天通知)
	---- 退休者本人
	INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
	select c.OA_mail,N'退休提醒通知',b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
	N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
	from eStatus a,eEmployee b,eDetails c
	where a.EID=b.EID and b.Status not in (4,5) and a.EID=c.EID and b.DepID<>349
	and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
	---- 退休者部门负责人
	------ 非公司领导，非部门负责人
	INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
	select c.OA_mail,N'退休提醒通知',b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
	N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
	from eStatus a,eEmployee b,eDetails c,oDepartment d
	where a.EID=b.EID and b.Status not in (4,5) and b.DepID<>349
	and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
	and ((dbo.eFN_getdepid1st(b.DepID)=d.DepID and d.DepType in (1,4)) or (b.DepID=d.DepID and d.DepType in (2,3)))
	and ISNULL(d.Director,d.Director2)=c.EID and ISNULL(d.Director,d.Director2)<>b.EID
	------ 公司领导
	-------- 董事长
	--INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
	--select c.OA_mail,N'退休提醒通知',b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
	--N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
	--from eStatus a,eEmployee b,eDetails c,oDepartment d
	--where a.EID=b.EID and b.Status not in (4,5) and b.DepID=349
	--and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
	--and ((dbo.eFN_getdepid1st(b.DepID)=d.DepID and d.DepType in (1,4)) or (b.DepID=d.DepID and d.DepType in (2,3)))
	--and ISNULL(d.Director,d.Director2)=c.EID and b.EID<>1112
	-------- 书记
	--INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
	--select c.OA_mail,N'退休提醒通知',b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
	--N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
	--from eStatus a,eEmployee b,eDetails c,oDepartment d
	--where a.EID=b.EID and b.Status not in (4,5) and b.DepID=349
	--and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
	--and ((dbo.eFN_getdepid1st(b.DepID)=d.DepID and d.DepType in (1,4)) or (b.DepID=d.DepID and d.DepType in (2,3)))
	--and 5587=c.EID and b.EID<>1112
	-------- 总裁
	--INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
	--select c.OA_mail,N'退休提醒通知',b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
	--N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
	--from eStatus a,eEmployee b,eDetails c,oDepartment d
	--where a.EID=b.EID and b.Status not in (4,5) and b.DepID=349
	--and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0
	--and ((dbo.eFN_getdepid1st(b.DepID)=d.DepID and d.DepType in (1,4)) or (b.DepID=d.DepID and d.DepType in (2,3)))
	--and 5014=c.EID and b.EID<>1112
	---- 人力资源部人事管理室劳动关系岗
	INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
	select (select a.OA_mail from eDetails a,eEmployee b where a.EID=b.EID and b.EID=@HR),
	N'退休提醒通知',b.Name+N'将于'+Convert(nvarchar(4),YEAR(a.RetireDate))+N'年'+Convert(nvarchar(2),MONTH(a.RetireDate))+
	N'月'+Convert(nvarchar(2),DAY(a.RetireDate))+N'日达到法定退休年龄，请做好工作交接并办理退休手续【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
	from eStatus a,eEmployee b
	where a.EID=b.EID and b.Status not in (4,5)
	and DATEDIFF(dd,GETDATE(),a.RetireDate)<=30 and DATEDIFF(dd,GETDATE(),a.RetireDate)>=0

End