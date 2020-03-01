USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_EmpGradeCalcUpdate]
-- skydatarefresh eSP_EmpGradeCalcUpdate
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 人员统计更新程序
-- @calcdate 为统计时对应的日期
*/
Begin

    declare @calcdate smalldatetime
    -- 上一个月的最后一天
    set @calcdate=dateadd(month, datediff(month, 0, dateadd(month, 0, getdate())), -1)

    Begin TRANSACTION

    -- 删除原有数据
    delete from pEmpGradeStat
    where DATEDIFF(MM,MonthStat,@calcdate)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 月度表单中未出现员工，更新后自动添加
    insert into pEmpGradeStat(MonthStat,DepType,CompID,EmpGrade,EMPSum,GenderMSum,GenderFSum,AVGAGESum,HighLev_ASSTTSum,HighLev_UGTTSum,HighLev_MSTTSum,HighLev_DTTTSum,
    WorkDate1YTTSum,WorkDate1t5YTTSum,WorkDate5t10YTTSum,WorkDate10YTTSum,JoinDate1YTTSum,JoinDate1t3YTTSum,JoinDate3t5YTTSum,JoinDate5t8YTTSum,JoinDate8YTTSum,
    JoinMMSum,JoinYYSum,LeaMMSum,LeaYYSum)
    select @calcdate,a.DepType,a.CompID,a.EmpGrade,a.EMPSum,a.GenderMSum,a.GenderFSum,a.AVGAGESum,a.HighLev_ASSTTSum,a.HighLev_UGTTSum,a.HighLev_MSTTSum,a.HighLev_DTTTSum,
    a.WorkDate1YTTSum,a.WorkDate1t5YTTSum,a.WorkDate5t10YTTSum,a.WorkDate10YTTSum,
    a.JoinDate1YTTSum,a.JoinDate1t3YTTSum,a.JoinDate3t5YTTSum,a.JoinDate5t8YTTSum,a.JoinDate8YTTSum,
    b.JoinMMSum,b.JoinYYSum,b.LeaMMSum,b.LeaYYSum
    from (select a.DepType,a.CompID,a.EmpGrade,SUM(a.EMP) as EMPSum,SUM(a.GenderM) as GenderMSum,SUM(a.GenderF) as GenderFSum,SUM(a.EMP*a.AVGAGE)/SUM(a.EMP) as AVGAGESum,
	SUM(a.HighLev_ASSTT) as HighLev_ASSTTSum,SUM(a.HighLev_UGTT) as HighLev_UGTTSum,SUM(a.HighLev_MSTT) as HighLev_MSTTSum,SUM(a.HighLev_DTTT) as HighLev_DTTTSum,
	SUM(a.WorkDate1YTT) as WorkDate1YTTSum,SUM(a.WorkDate1t5YTT) as WorkDate1t5YTTSum,SUM(a.WorkDate5t10YTT) as WorkDate5t10YTTSum,SUM(a.WorkDate10YTT) as WorkDate10YTTSum,
	SUM(a.JoinDate1YTT) as JoinDate1YTTSum,SUM(a.JoinDate1t3YTT) as JoinDate1t3YTTSum,SUM(a.JoinDate3t5YTT) as JoinDate3t5YTTSum,SUM(a.JoinDate5t8YTT) as JoinDate5t8YTTSum,
	SUM(a.JoinDate8YTT) as JoinDate8YTTSum
	from (select b.DepType,a.CompID,a.EmpGrade,COUNT(a.EID) as EMP,(case when c.Gender=1 then COUNT(a.EID) end) as GenderM,(case when c.Gender=2 then COUNT(a.EID) end) as GenderF,
    AVG(DATEDIFF(YY,c.BirthDay,@calcdate)) as AVGAGE,
    (case when c.HighLevel in (4,5,6,7,8,9,10) then COUNT(a.EID) end) as HighLev_ASSTT,(case when c.HighLevel=3 then COUNT(a.EID) end) as HighLev_UGTT,
    (case when c.HighLevel=2 then COUNT(a.EID) end) as HighLev_MSTT,(case when c.HighLevel=1 then COUNT(a.EID) end) as HighLev_DTTT,
    (case when DATEDIFF(YY,c.WorkBeginDate,@calcdate)<1 then COUNT(a.EID) end) as WorkDate1YTT,
    (case when DATEDIFF(YY,c.WorkBeginDate,@calcdate)>=1 and DATEDIFF(YY,c.WorkBeginDate,@calcdate)<5 then COUNT(a.EID) end) as WorkDate1t5YTT,
    (case when DATEDIFF(YY,c.WorkBeginDate,@calcdate)>=5 and DATEDIFF(YY,c.WorkBeginDate,@calcdate)<10 then COUNT(a.EID) end) as WorkDate5t10YTT,
    (case when DATEDIFF(YY,c.WorkBeginDate,@calcdate)>=10 then COUNT(a.EID) end) as WorkDate10YTT,
    (case when DATEDIFF(YY,d.JoinDate,@calcdate)<1 then COUNT(a.EID) end) as JoinDate1YTT,
    (case when DATEDIFF(YY,d.JoinDate,@calcdate)>=1 and DATEDIFF(YY,d.JoinDate,@calcdate)<3 then COUNT(a.EID) end) as JoinDate1t3YTT,
    (case when DATEDIFF(YY,d.JoinDate,@calcdate)>=3 and DATEDIFF(YY,d.JoinDate,@calcdate)<5 then COUNT(a.EID) end) as JoinDate3t5YTT,
    (case when DATEDIFF(YY,d.JoinDate,@calcdate)>=5 and DATEDIFF(YY,d.JoinDate,@calcdate)<8 then COUNT(a.EID) end) as JoinDate5t8YTT,
    (case when DATEDIFF(YY,d.JoinDate,@calcdate)>=8 then COUNT(a.EID) end) as JoinDate8YTT
    from eEmployee a
    left join oDepartment b on a.DepID=b.DepID
    left join eDetails c on a.EID=c.EID
    left join eStatus d on a.EID=d.EID
    where DATEDIFF(dd,d.JoinDate,@calcdate)>=0 and (DATEDIFF(dd,d.LeaDate,@calcdate)<0 or d.LeaDate is NULL) and a.EmpGrade<>18
    group by b.DepType,a.CompID,a.EmpGrade,c.Gender,c.HighLevel,c.WorkBeginDate,d.JoinDate) a
	group by a.DepType,a.CompID,a.EmpGrade) a
    left join (SELECT DepType,CompID,EmpGrade,SUM(JoinMM) AS JoinMMSum,SUM(JoinYY) AS JoinYYSum,SUM(LeaMM) AS LeaMMSum,SUM(LeaYY) AS LeaYYSum
	from (select m.DepType,n.CompID,n.EmpGrade,
    (case when DATEDIFF(MM,o.JoinDate,@calcdate)=0 then COUNT(n.EID) end) as JoinMM,
    (case when DATEDIFF(YY,o.JoinDate,@calcdate)=0 then COUNT(n.EID) end) as JoinYY,
    (case when DATEDIFF(MM,o.LeaDate,@calcdate)=0 then COUNT(n.EID) end) as LeaMM,
    (case when DATEDIFF(YY,o.LeaDate,@calcdate)=0 then COUNT(n.EID) end) as LeaYY
    from eEmployee n,oDepartment m,eStatus o 
    where n.DepID=m.DepID and n.EID=o.EID 
    group by m.DepType,n.CompID,n.EmpGrade,o.JoinDate,o.LeaDate) a
	GROUP BY DepType,CompID,EmpGrade) b on a.DepType=b.DepType and a.EmpGrade=b.EmpGrade and a.CompID=b.CompID
    where 0 not in (select distinct DATEDIFF(MM,@calcdate,MonthStat) from pEmpGradeStat)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 递交
    COMMIT TRANSACTION

    -- 正常处理流程
    Set @Retval = 0
    Return @Retval

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval

End