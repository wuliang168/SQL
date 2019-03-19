USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER  Function  [dbo].[eFN_getdepid3th] (@depid int) -- select dbo.eFN_getdepid3th(393)
  returns int
As
/*
-- Create By wuliang E004205
-- 获取部门的三级部门信息
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
Declare @R int

  -- 如果DepGrade为4
  if exists(select 1 from odepartment where depid=@depid and isnull(depgrade,0)=4)
  Begin
    select @R=dbo.eFN_getdepidSup(@depid)
  End

  -- 如果DepGrade为3
  if exists(select 1 from odepartment where depid=@depid and isnull(depgrade,0)=3)
  Begin
    select @R=@depid
  End

  -- 如果DepGrade为2
  if exists(select 1 from odepartment where depid=@depid and isnull(depgrade,0)=2)
  Begin
    select @R=NULL
  End

  -- 如果DepGrade为1
  if exists(select 1 from odepartment where depid=@depid and isnull(depgrade,0)=1)
  Begin
    select @R=NULL
  End

return @R
end