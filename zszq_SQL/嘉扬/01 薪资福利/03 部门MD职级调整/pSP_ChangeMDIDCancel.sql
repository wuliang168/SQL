USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Proc  [dbo].[pSP_ChangeMDIDCancel]
-- skydatarefresh pSP_ChangeMDIDCancel
    @ID    int,
	@URID  int,
	@RetVal  int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级变更登记表的取消确认程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

	-- 数据还未确认
	If Exists(Select 1 From pChangeMDID_register Where ID=@ID And Isnull(Submit,0)=0)
	Begin
		Set @RetVal = 910020
		Return @RetVal
	End

    -- 更新MD职级变更登记表
	Update a
	Set a.Submit = NULL,a.SubmitBy=NULL,a.SubmitTime=NULL
	From pChangeMDID_register a
	Where a.ID=@ID
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM

    -- 正常处理流程
	Set @RetVal=0
	Return @RetVal

    -- 异常处理流程
    ErrM:
    If isnull(@RetVal,0)=0
        Set @RetVal=-1
        Return @RetVal

End