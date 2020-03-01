USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   Procedure [dbo].[SP_pMonthAutoOpen](
    @RetVal int=0 output 
)
As
Begin

    -- 申明邮件发送内容
    declare @LMonth smalldatetime,@TMonth smalldatetime,@Tid int,@Lid int

    -- 定义邮件发送内容项
    ---- 上个月
    set @LMonth=DATEADD(m,-1,GETDATE())
    ---- 本月
    set @TMonth=GETDATE()


    -- 开启本月度工作计划
    ---- 插入PPROCESS_MONTH
    IF not Exists (select 1 from PPROCESS_MONTH where DATEDIFF(mm,kpimonth,@TMonth)=0)
    Begin
        insert into PPROCESS_MONTH(kpimonth)
        values (@TMonth)
        -- 异常处理
        IF @@Error <> 0
        Goto ErrM
    End
    ---- @id
    set @Tid=(select ID from PPROCESS_MONTH where DATEDIFF(mm,kpimonth,@TMonth)=0)
    set @Lid=(select ID from PPROCESS_MONTH where DATEDIFF(mm,kpimonth,@LMonth)=0)

    -- 关闭上月度考核
    exec PSP_MONTHGB @Lid,1
    -- 开启本月度考核
    exec PSP_MONTHKQ @Tid,1
    


    Begin TRANSACTION
    
    -- 工资单内容发送
    -- 向主任务表 skyJobQueueSMTP 插入内容
    insert Into skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)   
    select B.OA_mail,
    -- 邮件正文标题内容
    N'关于制定'+CONVERT(varchar(4),YEAR(@TMonth))+N'年'+CONVERT(varchar(2),MONTH(@TMonth))+N'月份月度计划与'
    +CONVERT(varchar(4),YEAR(@LMonth))+N'年'+CONVERT(varchar(2),MONTH(@LMonth))+N'月份小结、填写工作日志、考勤封存的提醒',
    -- 邮件正文标题内容
    +'<p>'+N'各位同事：'+'<br></p>'
    +'<p>'+N'根据公司要求，现将人力资源系统中填写月度计划与小结、工作日志、考勤等工作提醒如下：'+'<br></p>'
    +'<p>'+N'一、'+CONVERT(varchar(4),YEAR(@TMonth))+N'年'+CONVERT(varchar(2),MONTH(@TMonth))+N'月份月度计划与'+CONVERT(varchar(4),YEAR(@LMonth))+N'年'+CONVERT(varchar(2),MONTH(@LMonth))+N'月小结'+'<br></p>'
    +'<p>'+N'1、请于'+CONVERT(varchar(4),YEAR(@TMonth))+N'年'+CONVERT(varchar(2),MONTH(@TMonth))+N'月15日下班前完成'+CONVERT(varchar(4),YEAR(@TMonth))+N'年'+CONVERT(varchar(2),MONTH(@TMonth))+N'月份月度工作计划与'+CONVERT(varchar(4),YEAR(@LMonth))+N'年'+CONVERT(varchar(2),MONTH(@LMonth))+N'月份月度工作小结，并提交直接上级评分，操作方法详见链接 <a href="url">http://10.51.190.162/bs/help/plan_m.pdf</a>'+'<br></p>'
    +'<p>'+N'2、请部门内各级领导于'+CONVERT(varchar(4),YEAR(@TMonth))+N'年'+CONVERT(varchar(2),MONTH(@TMonth))+N'月16日起审核下属的工作小结；'+'<br></p>'
    +'<p>'+N'3、各级领导可以在“绩效查询”菜单中查看下属月度计划。'+'<br></p>'
    +'<p>'+N'二、工作日志'+'<br></p>'
    +'<p>'+N'1、人力资源部定期对于合格率较低的部门（分支机构）和个人进行通报；'+'<br></p>'
    +'<p>'+N'2、按规定全月累计未填写超过5天判定不合格，各部门（分支机构）不合格率及不合格人员可在HR系统绩效查询菜单中查看；'+'<br></p>'
    +'<p>'+N'3、各级领导可以在“绩效查询”菜单中查看下属工作日志。'+'<br></p>'
    +'<p>'+N'4、各部门（分支机构）绩效管理员可在部门绩效管理-日志计划-工作日志中查看并督促大家及时完成。'+'<br></p>'
    +'<p>'+N'工作日志操作说明详见链接 <a href="url">http://10.51.190.162/bs/help/workrecord.pdf</a>'+'<br></p>'
    +'<p>'+N'三、考勤（截止'+CONVERT(varchar(4),YEAR(@LMonth))+N'年'+CONVERT(varchar(2),MONTH(@LMonth))+N'月）'+'<br></p>'
    +'<p>'+N'1、总部人员请根据本人的异常出勤记录，在本月内填写异常说明或补充外出登记并提交领导审核确认，'+CONVERT(varchar(4),YEAR(@TMonth))+N'年'+CONVERT(varchar(2),MONTH(@TMonth))+N'月底前下班封存数据。'+'<br></p>'
    +'<p>'+N'2、分支机构的日常考勤参照总部执行，具体以分支机构规定为准。'+'<br></p>'
    +'<p>'+N'有任何疑问或操作问题请及时与本部门（分支机构）绩效管理员（综合人事管理员）或人力资源部吴亮联系。'+'<br></p>'
    +'<p>'+N'PS：目前新OA打卡功能已经开放使用，各位同事可以在新OA的右上角点击姓名选择上班或下班打卡完成考勤，并确认OA已经记录您的打卡时间，数据隔天自动同步到HR系统，同时HR系统打卡功能仍可正常使用。'+'<br></p>'
    --- 第二行内容
    -- 邮件正文人力资源页脚
    +'<HR style="HEIGHT: 2px; WIDTH: 122px" align="left" SIZE="2"><FONT color="#c0c0c0" size="2" face="Verdana">'+N'浙商证券人力资源部'+'</FONT>'
    ,0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3
    from PEMPPROCESS_MONTH A,eDetails B
	where A.EID=B.EID and A.monthID=@Tid
    AND (select CompID from eEmployee where EID=A.EID)<>12
    -- 异常处理 
    IF @@Error <> 0
    Goto ErrM


    -- 正常处理流程
    COMMIT TRANSACTION
    Set @RetVal=0
    Return @RetVal

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    If isnull(@RetVal,0)=0
        Set @RetVal=-1
        Return @RetVal

End