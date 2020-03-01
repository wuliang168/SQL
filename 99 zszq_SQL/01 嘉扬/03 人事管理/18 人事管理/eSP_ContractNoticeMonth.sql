USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_ContractNoticeMonth]
as
Begin


    IF Exists (select 1 from eStatus a,eEmployee b 
    where a.EID=b.EID and b.Status not in (4,5) and DATEDIFF(MM,GETDATE(),a.ConEndDate)<=1 and DATEDIFF(MM,GETDATE(),a.ConEndDate)>=0)
    Begin
        -- 发送短信提醒
        ---- 合同到期者本人
        --INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        --select c.Mobile,b.Name+N'的劳动合同将于'+Convert(nvarchar(4),YEAR(a.ConEndDate))+N'年'+Convert(nvarchar(2),MONTH(a.ConEndDate))+
        --N'月'+Convert(nvarchar(2),DAY(a.ConEndDate))+N'日到期，请及时发起续签流程或办理终止手续【人力资源部】'
        --from eStatus a,eEmployee b,eDetails c
        --where a.EID=b.EID and b.Status not in (4,5) and a.EID=c.EID
        --and DATEDIFF(MM,GETDATE(),a.ConEndDate)<=2 and DATEDIFF(MM,GETDATE(),a.ConEndDate)>=0
        ---- 合同到期者部门负责人
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        select c.Mobile,b.Name+N'的劳动合同将于'+Convert(nvarchar(4),YEAR(a.ConEndDate))+N'年'+Convert(nvarchar(2),MONTH(a.ConEndDate))+
        N'月'+Convert(nvarchar(2),DAY(a.ConEndDate))+N'日到期，请及时发起续签流程或办理终止手续【人力资源部】'
        from eStatus a,eEmployee b,eDetails c,oDepartment d
        where a.EID=b.EID and b.Status not in (4,5)
        and DATEDIFF(MM,GETDATE(),a.ConEndDate)<=2 and DATEDIFF(MM,GETDATE(),a.ConEndDate)>=0
        and (b.DepID=d.DepID and d.DepType in (2,3))
        and ISNULL(d.Director,d.Director2)=c.EID
        ---- 人力资源部人事管理室劳动关系岗
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES')
        select (select a.Mobile from eDetails a,eEmployee b where a.EID=b.EID and b.JobID=391),
        b.Name+N'的劳动合同将于'+Convert(nvarchar(4),YEAR(a.ConEndDate))+N'年'+Convert(nvarchar(2),MONTH(a.ConEndDate))+
        N'月'+Convert(nvarchar(2),DAY(a.ConEndDate))+N'日到期，请及时发起续签流程或办理终止手续【人力资源部】'
        from eStatus a,eEmployee b,oDepartment c
        where a.EID=b.EID and b.Status not in (4,5)
        and DATEDIFF(MM,GETDATE(),a.ConEndDate)<=2 and DATEDIFF(MM,GETDATE(),a.ConEndDate)>=0
        and (b.DepID=c.DepID and c.DepType in (2,3))


        -- 发送邮箱提醒
        ---- 合同到期者本人
        --INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
        --select c.OA_mail,N'合同到期提醒通知',b.Name+N'的劳动合同将于'+Convert(nvarchar(4),YEAR(a.ConEndDate))+N'年'+Convert(nvarchar(2),MONTH(a.ConEndDate))+
        --N'月'+Convert(nvarchar(2),DAY(a.ConEndDate))+N'日到期，请及时发起续签流程或办理终止手续【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
        --from eStatus a,eEmployee b,eDetails c
        --where a.EID=b.EID and b.Status not in (4,5) and a.EID=c.EID
        --and DATEDIFF(MM,GETDATE(),a.ConEndDate)<=2 and DATEDIFF(MM,GETDATE(),a.ConEndDate)>=0
        ---- 合同到期者部门负责人
        INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
        select c.OA_mail,N'合同到期提醒通知',b.Name+N'的劳动合同将于'+Convert(nvarchar(4),YEAR(a.ConEndDate))+N'年'+Convert(nvarchar(2),MONTH(a.ConEndDate))+
        N'月'+Convert(nvarchar(2),DAY(a.ConEndDate))+N'日到期，请及时发起续签流程或办理终止手续【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
        from eStatus a,eEmployee b,eDetails c,oDepartment d
        where a.EID=b.EID and b.Status not in (4,5)
        and DATEDIFF(MM,GETDATE(),a.ConEndDate)<=2 and DATEDIFF(MM,GETDATE(),a.ConEndDate)>=0
        and (b.DepID=d.DepID and d.DepType in (2,3))
        and ISNULL(d.Director,d.Director2)=c.EID
        ---- 人力资源部人事管理室劳动关系岗
        INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)
        select (select a.OA_mail from eDetails a,eEmployee b where a.EID=b.EID and b.JobID=391),
        N'合同到期提醒通知',b.Name+N'的劳动合同将于'+Convert(nvarchar(4),YEAR(a.ConEndDate))+N'年'+Convert(nvarchar(2),MONTH(a.ConEndDate))+
        N'月'+Convert(nvarchar(2),DAY(a.ConEndDate))+N'日到期，请及时发起续签流程或办理终止手续【人力资源部】',0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
        from eStatus a,eEmployee b,oDepartment c
        where a.EID=b.EID and b.Status not in (4,5)
        and DATEDIFF(MM,GETDATE(),a.ConEndDate)<=2 and DATEDIFF(MM,GETDATE(),a.ConEndDate)>=0
        and (b.DepID=c.DepID and c.DepType in (2,3))

    End

End