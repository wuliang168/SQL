USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Proc  [dbo].[eSP_ChangeSalaryDepTotalCheck]
-- skydatarefresh eSP_ChangeSalaryDepTotalCheck
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门加薪总包的确认检查程序
-- @ID 为部门加薪添加的ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 数据已经确认
    If Exists(Select 1 From pSalaryDepTotal_register Where ID=@ID And ISNULL(Submit,0)=1)
    Begin
        Set @RetVal = 910000
        Return @RetVal
    End
               
    -- 部门加薪总包递交登记表的检查程序
    -- 暂时不涉及薪酬调整功能
    -- 新增部门的薪酬包配额为空！
    /*
    if Exists(Select 1 from pSalaryDepTotal_register a Where a.ID=@ID and ISNULL(SalaryDepTotal,0)=0)
    Begin
        Set @RetVal=930038
        Return @RetVal
    End
    */

    -- 新增部门的MD包配额为空！
    if Exists(Select 1 from pSalaryDepTotal_register a Where a.ID=@ID and ISNULL(MDDepTotal,0)=0)
    Begin
        Set @RetVal=930040
        Return @RetVal
    End

    -- 存在相同年度和部门加薪总包记录!
    If Exists(select 1 from pSalaryDepTotal 
    where Director=(select Director from pSalaryDepTotal_register where ID=@ID)
    AND YEAR(Date)=(select Year(Date) from pSalaryDepTotal_register where ID=@ID)
    AND DepID=(select DepID from pSalaryDepTotal_register where ID=@ID))
    Begin
        Set @RetVal = 930047
        Return @RetVal
    End

    -- 更新部门加薪总包递交登记表
    Update a
    Set a.Submit = 1,a.SubmitBy = @URID,a.SubmitTime = GetDate()
    From  pSalaryDepTotal_register a
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