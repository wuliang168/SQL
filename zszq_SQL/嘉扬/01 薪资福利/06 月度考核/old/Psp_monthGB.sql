USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_monthGB]
	@ID int,
	@URID int,
	@RetVal int=0 OutPut
/*
	pStatus状态
	0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
*/
as
begin

	-- 该月已关闭，不用重复点击！
	If Exists(Select 1 From pProcess_month Where ISNULL(Submit,0)=1 and isnull(id,0)=@ID and enddate is not null)
	Begin
		Set @RetVal = 1100042
		Return @RetVal
	End

	/*
	-- 存在未完成员工不允许关闭！
	If Exists(Select 1 From pEmpProcess_Month Where ISNULL(Closed,0)=0 and isnull(monthid,0)=@ID)
	Begin
		Set @RetVal = 1000012
		Return @RetVal
	End
	*/


	Begin TRANSACTION

	-- 关闭员工月度考核
	update a
	set a.Closed=1,a.ClosedTime=GETDATE()
	from pEmpProcess_Month a
	where a.ID=@ID
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	-- 如果员工状态未达到5，则直接设置为6
	-- pStatus状态:0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
	--update a
	--set a.pstatus=6
	--from pEmpProcess_Month a
	--where a.pstatus < 5
	-- 异常处理
	--IF @@Error <> 0
	--Goto ErrM

	-- 关闭月度考核流程
	update a
	set a.Submit=1,a.SubmitTime=GETDATE(),enddate=GETDATE(),eidclose=@URID
	from pProcess_month a
	where a.id=@ID
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	-- 将pMonth_Plan拷贝到pMonth_Plan_all
	insert into pMonth_Plan_all(monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,remark,
	Initialized,InitializedTime,Submit,SubmitTime,Closed,Closedtime,badge,monthid)
	select monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,remark,Initialized,InitializedTime,
	Submit,SubmitTime,Closed,Closedtime,badge,monthid
	from pMonth_Plan
	where monthid=@ID
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	-- 删除本月的pMonth_Plan
	delete from pMonth_Plan
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	-- 将上月的考核总结pMonth_ASS拷贝到pMonth_ASS_all
	insert into pMonth_ASS_all(monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,monthscoop,grade,Scoreadjust,remark,
	Initialized,InitializedTime,Submit,SubmitTime,Closed,Closedtime,adjustsonce,badge,monthid)
	select monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,monthscoop,grade,Scoreadjust,remark,
	Initialized,InitializedTime,Submit,SubmitTime,Closed,Closedtime,adjustsonce,badge,monthid
	from pMonth_ASS a
	where DATEDIFF(mm,(select kpimonth from pProcess_month where id=a.monthid),(select kpimonth from pProcess_month where id=@ID))>0
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	-- 删除上月的考核总结pMonth_ASS
	delete from pMonth_ASS
	where DATEDIFF(mm,(select kpimonth from pProcess_month where id=monthid),(select kpimonth from pProcess_month where id=@ID))>0
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	/*
	-- 将pEmpProcess_Month拷贝到pEmpProcess_Month_all
	insert into pEmpProcess_Month_all(period,EID,Badge,Name,DepID,DepID2,JobID,ReportTo,WFReportTo,KPIDepID,PeGroup,pStatus,
	KPIReportTo,Remark,Initialized,InitializedTime,Submit,SubmitTime,Closed,ClosedTime,MonthID,Pingfen,Pingyu,PingfenDate)
	select period,EID,Badge,Name,DepID,DepID2,JobID,ReportTo,WFReportTo,KPIDepID,PeGroup,pStatus,
	KPIReportTo,Remark,Initialized,InitializedTime,Submit,SubmitTime,Closed,ClosedTime,MonthID,Pingfen,Pingyu,PingfenDate
	from pEmpProcess_Month
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	-- 删除本月的pEmpProcess_Month
	delete from pEmpProcess_Month
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM
	*/

	--绩效节点数生成 Add By Jimmy
	--declare @processid int
	--select @processid=pProcessID from pProcess_month where id=@ID

	--delete from SkyPAFormConfig where xyear=@processid and xtype=4

	--  IF @@Error <> 0
	--  Goto ErrM

	--insert into SkyPAFormConfig(xyear,PID,id,XID,xorder,title,xtype,URL,remark,Condition,beforeorafter)
	--select @processid,cast (c.EID as varchar),cast (@processid as varchar)+cast (EID as varchar)+cast (a.id as varchar),
	--case when xid <> 0 then cast (@processid as varchar)+cast (EID as varchar)+cast (XID as varchar) else 0 end,
	--a.xorder,a.title,a.xtype,a.URL,a.remark,'select {U_EID}',beforeorafter
	--from pAFormConfig a,pEmpProcess_Month b,pEmployee c,pAForm_Role d
	--where b.badge=c.Badge and a.xtype=4 and a.beforeorafter=2 and c.perole=d.Roleid and d.Formid=a.id
	--and d.isUsed=1 and b.monthID=@ID
	--and cast (@processid as varchar)+cast (EID as varchar)+cast (a.id as varchar) not in (select id from SkyPAFormConfig)

	COMMIT TRANSACTION
	Set @RetVal=0
	Return @RetVal

	ErrM:
	ROLLBACK TRANSACTION
	If isnull(@RetVal,0)=0
	Set @RetVal=-1
	Return @RetVal

end