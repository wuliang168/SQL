USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[pSP_ChangeMDSalaryPerMMAddEmp]
--skydatarefresh pSP_ChangeMDSalaryPerMMAddEmp
 @EID int,
 @URID int,
 @RetVal int=0 Output
AS
/*
-- Create By wuliang E004205
-- MD职级及薪酬变更登记表的添加员工程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

  -- 登记表已经添加该员工!
  IF Exists(Select 1 From pChangeMDSalaryPerMM_register Where EID=@EID)
  Begin
    Set @RetVal=920065
    Return @RetVal
  End

  -- 插入MD职级及薪酬变更登记表
  Insert Into pChangeMDSalaryPerMM_register(EID,MDID,SalaryPerMM,WorkCityRatio,SalaryPerMMCity,SalaryPayID,SponsorAllowance,CheckUpSalary)
  select a.EID,a.MDID,a.SalaryPerMM,(CASE when d.DepType in (2,3) then c.Ratio else 1 end),
  ROUND(a.SalaryPerMM*(CASE when d.DepType in (2,3) then c.Ratio else 1 end),-2),a.SalaryPayID,a.SponsorAllowance,a.CheckUpSalary
  From pEmployeeEmolu a,eemployee b,eCD_City c,odepartment d
  Where a.EID=@EID and a.EID=b.EID and b.WorkCity=c.ID and b.DepID=d.DepID
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