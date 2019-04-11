USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[pSP_ChangeMDIDStart]
-- skydatarefresh pSP_ChangeMDIDStart
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级变更登记表的处理程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 数据还未确认!
    If Exists(Select 1 From pChangeMDID_register Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 910020
        Return @RetVal
    End
    -- 异常流程
    if @RetVal<>0
    return @RetVal

    Begin TRANSACTION
    
    -- 变更类型为发薪类型调整时，将地区系数调整后薪酬调为目前薪酬
    Update a
    Set a.MDIDtoModify=a.MDID
    From pChangeMDID_register a
    Where a.ID=@ID and a.MDIDtoModifyReason=11
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新eemployee项MDID
    Update a
    Set a.MDID=b.MDID
    From pEmployeeEmolu a,pChangeMDID_register b
    Where a.EID=b.EID and b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入MD职级变更登记表pChangeMDID_all
    insert into pChangeMDID_all (EID,Badge,Name,CompID,SupDepID,DepID,JobID,MDID,MDIDtoModify,MDIDtoModifyReason,Submit,SubmitBy,SubmitTime)
    select a.EID,b.Badge,b.Name,b.CompID,dbo.eFN_getdepid1(b.DepID),b.DepID,b.JobID,a.MDID,a.MDIDtoModify,a.MDIDtoModifyReason,a.Submit,a.SubmitBy,a.SubmitTime
    from pChangeMDID_register a,eemployee b
    where id=@id and a.EID=b.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 删除登记表
    delete from pChangeMDID_register where id=@id
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 递交
    COMMIT TRANSACTION

    -- 正常处理流程
    Set @Retval = 0
    Return @Retval

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval

End