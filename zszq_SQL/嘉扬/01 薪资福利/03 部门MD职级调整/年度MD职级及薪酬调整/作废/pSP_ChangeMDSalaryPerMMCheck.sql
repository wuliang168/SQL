USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Proc  [dbo].[pSP_ChangeMDSalaryPerMMCheck]
-- skydatarefresh pSP_ChangeMDSalaryPerMMCheck
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级及薪酬变更登记表的确认检查程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 数据已经确认
    If Exists(Select 1 From pChangeMDSalaryPerMM_register
    Where ID=@ID And ISNULL(Submit,0)=1)
    Begin
        Set @RetVal = 910000
        Return @RetVal
    End
               
    -- MD职级变更登记表的检查程序
    -- 新薪酬数值为空！
    if Exists(Select 1 from pChangeMDSalaryPerMM_register a Where a.ID=@ID and ISNULL(SalaryPerMMCity,0)=0)
    Begin
        Set @RetVal=930048
        Return @RetVal
    End

    -- MD职级及薪酬调整原因为空!
    if Exists(Select 1 from pChangeMDSalaryPerMM_register a Where a.ID=@ID and ISNULL(MDSalaryModifyReason,0)=0)
    Begin
        Set @RetVal=930049
        Return @RetVal
    End

    -- MD职级及薪酬发薪类型为空!
    if Exists(Select 1 from pChangeMDSalaryPerMM_register a Where a.ID=@ID and ISNULL(SalaryPayID,0)=0)
    Begin
        Set @RetVal=930054
        Return @RetVal
    End

    -- MD职级及薪酬生效日期为空!
    if Exists(Select 1 from pChangeMDSalaryPerMM_register a Where a.ID=@ID and ISNULL(EffectiveDate,0)=0)
    Begin
        Set @RetVal=930050
        Return @RetVal
    End


    -- 更新MD职级变更登记表
    Update a
    Set a.Submit = 1,a.SubmitBy = @URID,a.SubmitTime = GetDate()
    From  pChangeMDSalaryPerMM_register a
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