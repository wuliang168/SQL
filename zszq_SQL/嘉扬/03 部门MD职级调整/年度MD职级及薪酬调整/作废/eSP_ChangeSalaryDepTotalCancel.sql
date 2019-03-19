USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Proc  [dbo].[eSP_ChangeSalaryDepTotalCancel]
-- skydatarefresh eSP_ChangeSalaryDepTotalCancel
    @ID int,
	@URID int,
	@RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门加薪总包的取消确认程序
-- @ID 为部门加薪添加的ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

	-- 数据还未确认
	If Exists(Select 1 From pSalaryDepTotal_register Where ID=@ID And Isnull(Submit,0)=0)
	Begin
		Set @RetVal = 910020
		Return @RetVal
	End

    -- 更新月度薪酬递交登记表
	Update a
	Set a.Submit = 0,a.SubmitBy = null,a.SubmitTime = null
	From pSalaryDepTotal_register a
	Where a.ID=@ID

    -- 正常处理流程
	Set @RetVal=0
	Return @RetVal

    -- 异常处理流程
    ErrM:
    If isnull(@RetVal,0)=0
        Set @RetVal=-1
        Return @RetVal

End