USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[BS_DK_Notice_MM]
as
begin

    -- 个人考勤异常提醒
    ---- 短信内容提醒
    INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') 
    select distinct C.Mobile,D.SMS
    from ATTENCE_LLMONTHLY A,eEmployee B,eDetails C,pSMSInfo D
    where (A.ABNORMWORKDAYS<>0 or A.LATEWORKDAYS<>0 or A.EARLYWORKDAYS<>0)
    and dbo.eFN_getdeptype(ISNULL(A.Dep2nd,A.Dep1st))=1 and A.Dep1st not in (349,394)
    and A.EID=B.EID and B.WorkCity=45 and A.EID=C.EID and D.ID=10
    ---- 邮件内容提醒
    INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax) 
    select distinct C.OA_mail,D.Subject,D.Message,0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
    from ATTENCE_LLMONTHLY A,eEmployee B,eDetails C,pEMAILInfo D
    where (A.ABNORMWORKDAYS<>0 or A.LATEWORKDAYS<>0 or A.EARLYWORKDAYS<>0)
    and dbo.eFN_getdeptype(ISNULL(A.Dep2nd,A.Dep1st))=1 and A.Dep1st not in (349,394)
    and A.EID=B.EID and B.WorkCity=45 and A.EID=C.EID and D.ID=1

    -- 部门负责人短信提醒
    ---- 短信内容提醒
    INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') 
    select distinct C.Mobile,D.SMS
    from ATTENCE_LLMMDEP A,eEmployee B,eDetails C,pSMSInfo D
    where A.ReportToDaily=B.EID and B.DepID not in (349,394)
    and A.ReportToDaily=C.EID and D.ID=13

end