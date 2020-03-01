USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_ChangeSalaryPerMMAddEmp]
--skydatarefresh eSP_ChangeSalaryPerMMAddEmp
 @EID int,
 @URID int,
 @RetVal int=0 Output
AS     
/*
-- Create By wuliang E004205
-- 月度薪酬递交登记表的添加员工程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/           
Begin      

  -- 登记表已经添加该员工!
  IF Exists(Select 1 From pSalaryPerMM_register Where EID=@EID)
  Begin
    Set @RetVal=920065
    Return @RetVal
  End

  -- 插入月度薪酬递交登记表         
  Insert Into pSalaryPerMM_register (EID,SalaryPerMM)
  select a.EID,a.SalaryPerMM
  From pEmployeeEmolu a
  Where a.EID=@EID
  -- 异常状态判断
  If @@Error<>0
  Goto ErrM

  -- 正常流程处理
  Set @RetVal = 0
  Return @RetVal

  -- 异常流程处理
  ErrM:
  if isnull(@RetVal,0)=0
    Set @RetVal = -1
    Return @RetVal

End