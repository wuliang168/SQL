USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER  Function  [dbo].[eFN_getdepid1st] (@depid int) -- select dbo.eFN_getdepid1st(393)
  returns int
As
/*
-- Create By wuliang E004205
-- 获取部门的一级部门信息
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
Declare @R int

  -- 如果DepGrade为2
  if exists(select 1 from odepartment where depid=@depid and isnull(depgrade,0)=2)
  Begin
    select @R=(select AdminID from oDepartment where DepID=@depid)
  End
  -- 如果DepGrade为1
  else IF exists(select 1 from odepartment where depid=@depid and (isnull(depgrade,0)=1 or isnull(depgrade,0)=0))
  Begin
    select @R=@depid
  End

  return @R

end