USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_monthcollectTG]
	@id int,
	@URID int,
	@RetVal int=0 OutPut
/*
	pStatus状态
	0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
*/
as
begin
	--月度评分不能为空！
	If Exists(Select 1 From pEmpProcess_Month Where ID=@ID And PINGFEN is null)
	Begin
		Set @RetVal = 1000044
		Return @RetVal
	End

	Begin TRANSACTION

	-- pStatus状态:0-未自评|1-已自评待审核|2-已审核被退回|3-已修改待审核|4-历史修改待审批|5-已审批|6-已封账
	---- 1-已自评待审核 -> 5-已审批
	update a
	set a.ClosedTime=GETDATE(),a.Closed=1,a.pingfendate=GETDATE(),a.pstatus=5
	from pEmpProcess_Month a
	where id=@id and a.pstatus=1
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM
	---- 3-已修改待审核 -> 5-已审批
	update a
	set a.ClosedTime=GETDATE(),a.Closed=1,a.pingfendate=GETDATE(),a.pstatus=5
	from pEmpProcess_Month a
	where id=@id and a.pstatus=3
	-- 异常处理
	IF @@Error <> 0
	Goto ErrM
	---- 4-历史修改待审批 -> 5-已审批
	update a
	set a.ClosedTime=GETDATE(),a.Closed=1,a.pingfendate=GETDATE(),a.pstatus=5
	from pEmpProcess_Month a
	where id=@id and a.pstatus=4
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