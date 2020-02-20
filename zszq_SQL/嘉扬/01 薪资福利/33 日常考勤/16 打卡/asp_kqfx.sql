USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[asp_KQFX]
as
begin

    declare @time smalldatetime
    select @time=GETDATE()

    -- 插入日常考勤异常表
    ---- 上午和下午均未打卡：上午未打卡
    insert into BS_YC_DK(term,termType,eid,badge,name,beginTime,endTime,KQSJ,YCKQNX,ReportToDaily)
    select @TIME, (select xtype from lCalendar where datediff(dd,term,@TIME)=0 and ezid=100) xtype, a.eid, a.badge, a.name, 
    null begintime, null endtime, N'上午' KQSJ, N'未打卡' YCKQNX,b.ReportToDaily
    from eemployee a,pVW_EMPReportToDaily b
    where a.Status in (1,2,3) and a.EID=b.EID
    and a.eid not in (select eid from BS_DK_TIME where datediff(dd,term,@TIME)=0)
    ---- 上午和下午均未打卡：下午未打卡
    insert into BS_YC_DK(term,termType,eid,badge,name,beginTime,endTime,KQSJ,YCKQNX,ReportToDaily)
    select @TIME, (select xtype from lCalendar where datediff(dd,term,@TIME)=0 and ezid=100) xtype, a.eid, a.badge, a.name, 
    null begintime, null endtime, N'下午' KQSJ, N'未打卡' YCKQNX,b.ReportToDaily
    from eemployee a,pVW_EMPReportToDaily b
    where a.Status in (1,2,3) and a.EID=b.EID 
    and a.eid not in (select eid from BS_DK_TIME where datediff(dd,term,@TIME)=0)
    ---- 仅仅上午未打卡
    insert into BS_YC_DK(term,termType,eid,badge,name,beginTime,endTime,KQSJ,YCKQNX,ReportToDaily)
    select @TIME, (select xtype from lCalendar where datediff(dd,term,@TIME)=0 and ezid=100) xtype, a.eid, a.badge, a.name, 
    null begintime, (select endtime from BS_DK_TIME where eid=a.EID and datediff(dd,term,@TIME)=0 and beginTime is null) endtime, 
    N'上午' KQSJ, N'未打卡' YCKQNX,b.ReportToDaily
    from eemployee a,pVW_EMPReportToDaily b
    where a.Status in (1,2,3) and a.EID=b.EID 
    and a.eid in (select eid from BS_DK_TIME where datediff(dd,term,@TIME)=0 and beginTime is null)
    ---- 仅仅下午未打卡
    insert into BS_YC_DK(term,termType,eid,badge,name,beginTime,endTime,KQSJ,YCKQNX,ReportToDaily)
    select @TIME, (select xtype from lCalendar where datediff(dd,term,@TIME)=0 and ezid=100) xtype, a.eid, a.badge, a.name, 
    (select begintime from BS_DK_TIME where eid=a.EID and datediff(dd,term,@TIME)=0 and endTime is null) begintime, null endtime, 
    N'下午' KQSJ, N'未打卡' YCKQNX,b.ReportToDaily
    from eemployee a,pVW_EMPReportToDaily b
    where a.Status in (1,2,3) and a.EID=b.EID 
    and a.eid in (select eid from BS_DK_TIME where datediff(dd,term,@TIME)=0 and endTime is null)
    ---- 上班迟到
    insert into BS_YC_DK(term,termType,eid,badge,name,beginTime,endTime,KQSJ,YCKQNX,ReportToDaily)
    select @TIME, (select xtype from lCalendar where datediff(dd,term,@TIME)=0 and ezid=100) xtype, a.eid, a.badge, a.name, 
    (select beginTime from BS_DK_TIME where eid=a.EID and datediff(dd,term,@TIME)=0 and beginTime is not null
    and DatedIff(MI,(Convert(Varchar(10),@TIME,120)+' '+'08:30'),beginTime)>0) begintime, 
    (select endtime from BS_DK_TIME where eid=a.EID and datediff(dd,term,@TIME)=0 and beginTime is not null
    and DatedIff(MI,(Convert(Varchar(10),@TIME,120)+' '+'08:30'),beginTime)>0) endtime, N'上午' KQSJ, N'迟到' YCKQNX,b.ReportToDaily
    from eemployee a,pVW_EMPReportToDaily b
    where a.Status in (1,2,3) and a.EID=b.EID
    and a.eid in (select eid from BS_DK_TIME where datediff(dd,term,@TIME)=0 and beginTime is not null
    and DatedIff(MI,(Convert(Varchar(10),@TIME,120)+' '+'08:30'),beginTime)>0)
    ---- 下班早退
    insert into BS_YC_DK(term,termType,eid,badge,name,beginTime,endTime,KQSJ,YCKQNX,ReportToDaily)
    select @TIME, (select xtype from lCalendar where datediff(dd,term,@TIME)=0 and ezid=100) xtype, a.eid, a.badge, a.name, 
    (select beginTime from BS_DK_TIME where eid=a.EID and datediff(dd,term,@TIME)=0 and endTime is not null
    and DatedIff(MI,endTime,(Convert(Varchar(10),@TIME,120)+' '+'17:00'))>0) begintime, 
    (select endtime from BS_DK_TIME where eid=a.EID and datediff(dd,term,@TIME)=0 and endTime is not null
    and DatedIff(MI,endTime,(Convert(Varchar(10),@TIME,120)+' '+'17:00'))>0) endtime, N'下午' KQSJ, N'早退' YCKQNX,b.ReportToDaily
    from eemployee a,pVW_EMPReportToDaily b
    where a.Status in (1,2,3) and a.EID=b.EID
    and a.eid in (select eid from BS_DK_TIME where datediff(dd,term,@TIME)=0 and endTime is not null
    and DatedIff(MI,endTime,(Convert(Varchar(10),@TIME,120)+' '+'17:00'))>0)

    -- 删除节假日的异常考勤
    delete from BS_YC_DK where isnull(termType,0)<>1

    -- 有外出登记的确认过的自动提交
    update a
    set a.initialized=1,a.InitializedTime=@TIME,a.initializedby=1
    from aOut_register a
    where isnull(a.Initialized,0)=0

    -- 外出登记的考核人为空的自动调整
    update a
    set a.ReportTo=b.ReportToDaily
    from aOut_register a,pVW_EMPReportToDaily b
    where a.ReportTo is NULL and a.EID=b.EID and b.ReportToDaily is not NULL
    and YEAR(a.BeginTime)>=2019 and ISNULL(a.submit,0)=0

    -- 外出登记
    ---- 外出登记异常记录自动处理
    update a 
    set a.initialized=1 ,InitializedTime=@TIME,outid=b.id
    from BS_YC_DK a,aOut_register b
    where a.eid=b.eid and b.Initialized=1 and isnull(a.Submit,0)=0
    and DATEDIFF(day,a.term,b.beginTime)<=0
    and DATEDIFF(day,a.term,b.EndTime)>=0
    ---- 外出登记异常记录自动确认
    update a 
    set Submit=1,SubmitTime=@TIME,YCKQJG=N'情况属实，正常出勤',a.YCKQSM=b.Remark
    from BS_YC_DK a ,aOut_register b 
    where a.eid=b.eid and b.Submit=1 and isnull(a.Submit,0)=0
    and DATEDIFF(day,a.term,b.beginTime)<=0
    and DATEDIFF(day,a.term,b.EndTime)>=0

    -- OA关联
    ---- OA请假记录自动处理
    update a
    set a.initialized=1 ,InitializedTime=@TIME,a.OAID=b.OAID,a.Submit=1,a.SubmitTime=@TIME,a.YCKQSM=c.Title,YCKQJG=N'情况属实，正常出勤'
    from BS_YC_DK a,pEmpOALeave b,oCD_LeaveType c
    where a.eid=b.EID and b.LeaveBeginDate is not NULL and b.LeaveEndDate is not NULL and b.LeaveType=c.ID
    and DATEDIFF(dd,a.term,b.LeaveBeginDate)<=0
    and DATEDIFF(dd,a.term,b.LeaveEndDate)>=0
    and b.ApprDep=N'绩效管理室' and ((b.LeaveType=7 and b.LeaveDays<=15) or b.LeaveType<>7) 
    and ISNULL(a.Submit,0)=0
    ---- 哺乳假
    ------ 非分支机构员工
    ------ 仅上午
    -------- 产假单次
    update a
    set a.initialized=1 ,InitializedTime=@TIME,a.OAID=b.OAID,a.Submit=1,a.SubmitTime=@TIME,YCKQSM=N'哺乳假',YCKQJG=N'情况属实，正常出勤'
    from BS_YC_DK a,pEmpOALeave b
    where b.LeaveType=4 and a.EID=b.EID
    and DATEDIFF(DD,b.LeaveEndDate,GETDATE())<=365 and DATEDIFF(DD,b.LeaveEndDate,GETDATE())>=0
    and (select dbo.eFN_getdeptype(DepID) from eEmployee where EID=a.EID)=1
    and (select Gender from eDetails where EID=a.eid)=2
    and a.YCKQNX=N'早退' and b.ApprDep=N'绩效管理室'
    and (b.OAContent not like N'%流产%' and b.OAContent not like N'%小产%')
    and ISNULL(a.Submit,0)=0
    -------- 产假多次
    ------ 仅下午
    -------- 产假单次
    update a
    set a.initialized=1 ,InitializedTime=@TIME,a.OAID=b.OAID,a.Submit=1,a.SubmitTime=@TIME,YCKQSM=N'哺乳假',YCKQJG=N'情况属实，正常出勤'
    from BS_YC_DK a,pEmpOALeave b
    where b.LeaveType=4 and a.EID=b.EID
    and DATEDIFF(DD,b.LeaveEndDate,GETDATE())<=365 and DATEDIFF(DD,b.LeaveEndDate,GETDATE())>=0
    and (select dbo.eFN_getdeptype(DepID) from eEmployee where EID=a.EID)=1
    and (select Gender from eDetails where EID=a.eid)=2
    and a.YCKQNX=N'迟到' and b.ApprDep=N'绩效管理室'
    and (b.OAContent not like N'%流产%' and b.OAContent not like N'%小产%')
    and ISNULL(a.Submit,0)=0

    -- 公司中层
    ---- 异常记录自动处理
    --update a 
    --set a.initialized=1 ,InitializedTime=@TIME ,outid=1 ,YCKQSM='default',
    --Submit=1,SubmitTime=@TIME,YCKQJG=N'情况属实，正常出勤'
    --from BS_YC_DK a ,aemployee b 
    --where a.eid=b.eid and isnull(a.Initialized,0)=0
    --and (EmpGrade in (1) or a.eid in (select DIRECTOR from odepartment 
    --where DepGrade=1 and isnull(isDisabled,0)=0 and (deptype in (1,4) or depid =384) and compid<>13
    --and xOrder<>9999999999999 and Director is not NULL)
    --研究所、区域财务、内退部门忽略
    --or b.DepID in (361,655,481,393))
    ---- 有填写说明的自动提交
    --update BS_YC_DK
    --set Initialized=1,InitializedTime=@TIME,OUTID=0
    --where YCKQSM is not null and isnull(Initialized,0)=0
    ---- 部门领导自动审核
    --update BS_YC_DK
    --set Submit=1,SubmitTime=@TIME,YCKQJG=N'情况属实，正常出勤'
    --where isnull(Initialized,0)=0 and YCKQSM is not null
    --and eid in (select DIRECTOR from ODEPARTMENT where DIRECTOR is not null and depgrade=1 and compid<>13
    --and xOrder<>9999999999999 and Director is not NULL)

    --哺乳假(马宁1308\)          
    --update  a set a.YCKQSM=N'哺乳假' ,a.initialized=1 ,InitializedTime=@TIME ,outid=1,
    --Submit=1,SubmitTime=@TIME,YCKQJG=N'情况属实，正常出勤'
    ----select *
    --from BS_YC_DK a where isnull(Initialized,0)=0 and KQSJ=N'早退' and EID in(1308)
    ----

    -- 最高学历、专业、学校名称更新
    update a
    set a.HighLevel=b.EduType,
    a.schoolname=b.schoolname,
    a.Major=b.Major
    from edetails a, eBG_Education b, 
    (select eid, min(EduType) as EduType from eBG_Education where  schoolname is not null and isnull(GradType,0)=1 group by eid) c
    where a.eid=b.eid and a.eid=c.eid and b.EduType<=c.EduType

    -- 最高学位
    update a
    set a.HighDegree=b.DegreeType
    from edetails a, eBG_Education b, 
    (select eid, min(DegreeType) as DegreeType from eBG_Education where schoolname is not null and isnull(GradType,0)=1 group by eid) c
    where a.eid=b.eid and a.eid=c.eid and b.DegreeType<=c.DegreeType

    -- 疫情六类表格更新
    ---- 新增在人事表格中确认的人员
    insert into pEpidemicSuitationLoc(eid,name,type,compid,depid,depid1st,depid2nd)
    select eid,name,1,compid,depid,dbo.eFN_getdepid1st(depid),dbo.eFN_getdepid2nd(depid)
    from eemployee a
    where a.EID not in (select EID from pEpidemicSuitationLoc where EID is not NULL) and a.status not in (4,5)
    and a.EID<>6216
    ---- 删除在人事表格中离职退休的人员
    delete from pEpidemicSuitationLoc
	where EID in (select EID from eEmployee where Status in (4,5))
	and EID is not NULL

end