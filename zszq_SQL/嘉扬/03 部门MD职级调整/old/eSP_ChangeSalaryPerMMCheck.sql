USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Proc  [dbo].[eSP_ChangeSalaryPerMMCheck]
-- skydatarefresh eSP_ChangeSalaryPerMMCheck
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度薪酬递交登记表的确认检查程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 数据已经确认
    If Exists(Select 1 From pSalaryPerMM_register
    Where ID=@ID And ISNULL(Submit,0)=1)
    Begin
        Set @RetVal = 910000
        Return @RetVal
    End
               
    -- 月度薪酬递交登记表的检查程序
    -- 月薪酬数据为空！
    if Exists(Select 1 from pSalaryPerMM_register a Where a.ID=@ID and ISNULL(SalaryPerMMtoModify,0)=0)
    Begin
        Set @RetVal=930037
        Return @RetVal
    End
    -- 异常流程
    If @RetVal <> 0
    Return @RetVal

    -- 更新月度薪酬递交登记表
    Update a
    Set a.Submit = 1,a.SubmitBy = @URID,a.SubmitTime = GetDate()
    From  pSalaryPerMM_register a
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