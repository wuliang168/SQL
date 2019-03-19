USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_ChangeSalaryDepTotalAddDep]
--skydatarefresh eSP_ChangeSalaryDepTotalAddDep
    @DEPID int,
    @URID int,
    @RetVal int=0 Output
AS     
/*
-- Create By wuliang E004205
-- 部门加薪总包的添加部门程序
-- @DEPID 为需要添加的部门ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/           
Begin      

  -- 登记表已经添加该部门!
  IF Exists(Select 1 From pSalaryDepTotal_register Where DEPID=@DEPID)
  Begin
    Set @RetVal=920201
    Return @RetVal
  End

  -- 插入月度薪酬递交登记表
  Insert Into pSalaryDepTotal_register (Date,DepID,SupDepID,Director,Remark)
  select getdate(),DepID,dbo.eFN_getdepid1(DepID),director,N'MD职级调整原因中需详细说明调整人员的业绩、工作成果等' 
  From odepartment
  Where DepID=@DEPID
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