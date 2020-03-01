USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER  Function  [dbo].[eFN_getdepidSup] (@depid int) -- select dbo.eFN_getdepidSup(393)
  returns int
As
/*
-- Create By wuliang E004205
-- 获取部门的上级部门信息
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
Declare @R int

  -- 如果DepGrade为3
  if exists(select 1 from odepartment where depid=@depid and isnull(depgrade,0)<>1)
  Begin
    select @R=(select AdminID from odepartment where depid=@depid)
  End
  else
  Begin
    select @R=NULL
  END

return @R
end