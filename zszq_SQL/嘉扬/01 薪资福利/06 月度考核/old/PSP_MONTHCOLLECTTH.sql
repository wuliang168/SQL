USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_monthcollectTH]
@id int,
@URID int,
@RetVal int=0 OutPut
AS
begin

	--0106begin
	-- 声明@kpimonth
	declare @kpimonth smalldatetime
	-- 定义@kpimonth
	select @kpimonth=kpimonth from pProcess_month where id=(select monthID from pEmpProcess_Month where id=@id)

	--0106end
	--当退回时必须填写评语 Add By Jimmy 3-18
	if exists (select 1 from pEmpProcess_Month where id=@id and pingyu is null)
	begin
		set @RetVal=1100039
		return @retval
	end

	Begin TRANSACTION

	-- 退回员工时，调整状态
	-- pStatus状态:0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|5-已审批|6-已封账
	---- 1-已自评待审核 -> 2-已审核被退回
	update a
	set a.InitializedTime=NULL,a.Initialized=0,a.pstatus=2
	from pEmpProcess_Month a
	where id=@id
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	/*
	update a
	set a.InitializedTime=null,a.Initialized=0
	from PMONTH_KPI a
	where monthid=(select monthid from pEmpProcess_Month where id=@id)
	and badge=(select badge from pEmpProcess_Month where id=@id)

	IF @@Error <> 0
	Goto ErrM

	update a
	set a.InitializedTime=null,a.Initialized=0
	from PMONTH_GS a
	where monthid=(select monthid from pEmpProcess_Month where id=@id)
	and badge=(select badge from pEmpProcess_Month where id=@id)

	IF @@Error <> 0
	Goto ErrM
	*/

	-- 更新pMonth_Plan的状态
	update a
	set a.InitializedTime=NULL,a.Initialized=NULL
	from PMONTH_PLAN a
	where monthid=(select monthid from pEmpProcess_Month where id=@id)
	and badge=(select badge from pEmpProcess_Month where id=@id)
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM

	-- 更新PMONTH_ASS的状态
	update a
	set a.InitializedTime=NULL,a.Initialized=NULL
	from PMONTH_ASS a
	where monthid=(select id from pProcess_month where DATEDIFF(MM,kpimonth,DATEADD(MM,-1,@kpimonth))=0 and ISNULL(submit,0)=1)--0106
	and badge=(select badge from pEmpProcess_Month where id=@id)
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM


	COMMIT TRANSACTION
	Set @RetVal=0
	Return @RetVal

	ErrM:
	ROLLBACK TRANSACTION
	If isnull(@RetVal,0)=0
	Set @RetVal=-1
	Return @RetVal

end