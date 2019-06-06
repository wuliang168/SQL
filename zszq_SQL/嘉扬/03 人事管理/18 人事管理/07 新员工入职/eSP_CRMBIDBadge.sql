USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Proc [dbo].[eSP_CRMBIDBadge]
    @ID int,
    @RetVal int=0 OUTPUT
As
/*
-- author: wuliang
-- version:1.0
-- date:2019-06-06
-- description:CRM员工入人力资源系统分配内部编号和工号
*/
Begin

    -- 内部关联：ID、BID、Badge
    -- BID=ID+9000100
    -- Badge='B'+ID+000100
    If Exists(select 1 from pCRMStaff where ID=@ID and (BID is NULL or Badge is NULL))
    Begin
        Update a
        Set BID=@ID+9000100,a.Badge='B'+REPLICATE('0',6-len(@ID+100))+CAST(@ID+100 as varchar(6))
        From pCRMStaff a
        Where a.ID=@ID
    End

End