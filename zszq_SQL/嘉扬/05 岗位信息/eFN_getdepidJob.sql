USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER  Function  [dbo].[eFN_getdepidJob] (@jobid int) -- select dbo.eFN_getdepidJob(393)
  returns int
As
/*
-- Create By wuliang E004205
-- 获取岗位的最小部门信息
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
Declare @R int

  -- 如果DepID4th,DepID3th,DepID2nd,DepID1st均非NULL
  if exists(select 1 from ojob where jobid=@jobid 
  and isnull(DepID4th,0)<>0 and isnull(DepID3th,0)<>0 and isnull(DepID2nd,0)<>0 and isnull(DepID1st,0)<>0)
  Begin
    select @R=(select DepID4th from ojob where jobid=@jobid)
  End

  -- 如果DepID4th为NULL,DepID3th,DepID2nd,DepID1st均非NULL
  if exists(select 1 from ojob where jobid=@jobid
  and isnull(DepID4th,0)=0 and isnull(DepID3th,0)<>0 and isnull(DepID2nd,0)<>0 and isnull(DepID1st,0)<>0)
  Begin
    select @R=(select DepID3th from ojob where jobid=@jobid)
  End

  -- 如果DepID4th,DepID3th均为NULL,DepID2nd,DepID1st均非NULL
  if exists(select 1 from ojob where jobid=@jobid
  and isnull(DepID4th,0)=0 and isnull(DepID3th,0)=0 and isnull(DepID2nd,0)<>0 and isnull(DepID1st,0)<>0)
  Begin
    select @R=(select DepID2nd from ojob where jobid=@jobid)
  End

  -- 如果DepID4th,DepID3th,DepID2nd均为NULL,DepID1st非NULL
  if exists(select 1 from ojob where jobid=@jobid
  and isnull(DepID4th,0)=0 and isnull(DepID3th,0)=0 and isnull(DepID2nd,0)=0 and isnull(DepID1st,0)<>0)
  Begin
    select @R=(select DepID1st from ojob where jobid=@jobid)
  End

return @R
end