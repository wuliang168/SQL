USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER  Function  [dbo].[eFN_getdepadmin] (@depid int) -- select dbo.eFN_getdepadmin(393)
  returns int
As
/*
-- Create By wuliang E004205
-- 获取部门的上级信息(含虚拟)
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
Declare @R int

  -- 如果DepID有效
  if exists(select 1 from odepartment where depid=@depid and isnull(isdisabled,0)=0 and xorder<>9999999999999)
  Begin
    select @R=(select AdminID from odepartment where depid=@depid)
  End
  else
  Begin
    select @R=NULL
  END

return @R
end