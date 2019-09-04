USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_monthcollectQRTJ]
	@id int,
	@URID int,
	@RetVal int=0 OutPut
/*
	pStatus状态
	0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
*/
as
begin
	--0106begin
	declare @kpimonth smalldatetime,@badge varchar(20),@monthid int

	select @kpimonth=kpimonth from pProcess_month
	where id=(select monthID from pEmpProcess_Month where id=@id)

	select @monthid=monthID from pEmpProcess_Month where id=@id
	
	select @badge=badge from pEmpProcess_Month where id=@id
	--0106end

	--提交校验 Add By Jimmy 3-18
	-- 没有当月工作计划
	if not exists (select 1 from PMONTH_PLAN
	where badge=@badge and monthid=@monthid)
	begin
		set @RetVal=1100036
		return @retval
	end

	-- 数据已经提交！
	If Exists(Select 1 From pEmpProcess_Month
	Where id=@id And Isnull(Initialized,0)=1
	)
	Begin
		Set @RetVal = 1100007
		Return @RetVal
	End

	-- 没有月工作小结
	if exists (select 1 from PMONTH_ASS
	where BADGE=@badge and MONTHSCOOP is null 
	and MONTHID=(select id from pProcess_month 
		where DATEDIFF(MM,kpimonth,DATEADD(MM,-1,(select kpimonth from PVW_MONTHCOLLECT1 where badge=@badge)))=0 
		and ISNULL(submit,0)=1))
	begin
		set @RetVal=1100037
		return @retval
	end

	-- 月度计划内容为空
	if exists (select 1 from PMONTH_PLAN where BADGE=@badge and monthtitle is null and MONTHID=@monthid)
	begin
		set @RetVal=1100049
		return @retval
	end

	-- 月度工作小结超过150字上限
	if exists (select 1 from PMONTH_ASS where BADGE=@badge and LEN(MONTHSCOOP)>150 and MONTHID=@monthid)
	begin
		set @RetVal=1100054
		return @retval
	end

	-- 月度工作小结超150字上限
	if exists (select 1 from PMONTH_PLAN where BADGE=@badge and LEN(monthtitle)>150 and MONTHID=@monthid)
	begin
		set @RetVal=1100055
		return @retval
	end

	-- 已审核被退回月度考核未做修改
	if exists (select 1 from pEmpProcess_Month where BADGE=@badge 
	and monthID=(select id from pProcess_month where DATEDIFF(mm,kpimonth,@kpimonth)=1) and pstatus=2)
	begin
		set @RetVal=1100054
		return @retval
	end

	--没有KPI进度
	/* if exists (select 1 from PMONTH_KPI where BADGE=@badge and KPIRATE is null
	and MONTHID=@monthid)
	begin
	set @RetVal=1100038
	return @retval
	end
	*/

	Begin TRANSACTION

	-- pStatus状态:0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
	-- 本月考核状态调整
	---- 0-未自评 -> 1-已自评待审核
	update a
	set a.InitializedTime=GETDATE(),a.Initialized=1,pstatus=1
	from pEmpProcess_Month a
	where a.id=@id and a.pstatus=0
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM
	---- 2-已审核被退回 -> 3-已修改待审核
	update a
	set a.InitializedTime=GETDATE(),a.Initialized=1,pstatus=3
	from pEmpProcess_Month a
	where a.id=@id and a.pstatus=2
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM
	---- IsReSubmit为1，表示在本月自评上月小结(已审核被退回并做了调整)
	update a
	set a.InitializedTime=GETDATE(),a.Initialized=1
	from pEmpProcess_Month a
	where a.id=@id and ISNULL(a.IsReSubmit,0)=1
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	/*
	update a
	set a.InitializedTime=GETDATE(),a.Initialized=1,a.SubmitTime=GETDATE()
	from PMONTH_KPI a
	where monthid=(select monthid
		from pEmpProcess_Month
		where id=@id) and
		badge=(select badge
		from pEmpProcess_Month
		where id=@id)
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	update a
	set a.InitializedTime=GETDATE(),a.Initialized=1,a.SubmitTime=GETDATE()
	from PMONTH_GS a
	where monthid=(select monthid
		from pEmpProcess_Month
		where id=@id) and
		badge=(select badge
		from pEmpProcess_Month
		where id=@id)
	-- 异常处理
	IF @@Error <> 0
 	Goto ErrM
	*/
	
	-- 更新到下月度总结
	insert into PMONTH_ASS(monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,remark,badge,monthid)
	select monthtitle,pMonth_ASSID,begindate,enddate, xorder,datemodulus,remark,badge,monthid
	from PMONTH_PLAN a
	where a.monthid=(select monthid from pEmpProcess_Month where id=@id) 
	and a.badge=(select badge from pEmpProcess_Month where id=@id)
	and a.InitializedTime is NULL and Initialized is NULL
	and a.xorder not in (select xorder from PMONTH_ASS where monthid=a.monthid and badge=a.badge)
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	-- 更新本月度工作考核计划状态
	update a
	set a.InitializedTime=GETDATE(),a.Initialized=1
	from PMONTH_PLAN a
	where monthid=(select monthid from pEmpProcess_Month where id=@id) 
	and badge=(select badge from pEmpProcess_Month where id=@id)
	and a.InitializedTime is NULL and a.Initialized is NULL
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	-- 更新上月度工作总结状态
	update a
	set a.InitializedTime=GETDATE(),a.Initialized=1
	from PMONTH_ASS a
	where monthid=(select id from pProcess_month where DATEDIFF(MM,kpimonth,DATEADD(MM,-1,@kpimonth))=0 and ISNULL(submit,0)=1)
	and badge=(select badge from pEmpProcess_Month where id=@id)
	and a.InitializedTime is NULL and a.Initialized is NULL
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	--add20140527chap.lee
	-- 部门负责人月度考核递交后直接关闭
	-- pStatus状态:0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|5-已审批|6-已封账
	-- 1:总部部门负责人;10:子公司部门行政负责人;24:分公司负责人;5:一级营业部负责人
	if @badge in (select badge from PEMPLOYEE_REGISTER where isnull(PEROLE,0) in (1,5,10,24))
	begin
		update a
		set a.ClosedTime=GETDATE(),a.Closed=1,a.pstatus=6
		from pEmpProcess_Month a
		where id=@id
		-- 异常处理
		IF @@Error <> 0
		Goto ErrM
	end
	--end20140527

	/*
	-- 删除已经存在本月的PMONTH_ASS,避免重复更新
	delete from PMONTH_ASS
	where monthid=(select monthid from pEmpProcess_Month where id=@id) 
	and badge=(select badge from pEmpProcess_Month where id=@id) 
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM
	*/

	COMMIT TRANSACTION
	Set @RetVal=0
	Return @RetVal

	ErrM:
	ROLLBACK TRANSACTION
	If isnull(@RetVal,0)=0
		Set @RetVal=-1
	Return @RetVal

end 