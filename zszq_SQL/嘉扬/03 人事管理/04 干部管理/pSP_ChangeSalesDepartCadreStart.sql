USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[pSP_ChangeSalesDepartCadreStart]
-- skydatarefresh pSP_ChangeSalesDepartCadreStart
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 营业部干部调动登记表的处理程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 数据还未确认!
    If Exists(Select 1 From pChangeSalesDepartCadre_Register Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 910020
        Return @RetVal
    End
    -- 异常流程
    if @RetVal<>0
    return @RetVal

    Begin TRANSACTION

    -- 根据调动类型ChangeType更新数据表项
    -- 强制离岗
    -- 更新eStatus项JobLeavedate
    IF EXISTS(Select 1 From pChangeSalesDepartCadre_Register Where ChangeType=1)
    Begin
        Update a
        Set a.JobLeavedate=b.Changedate
        From eStatus a,pChangeSalesDepartCadre_Register b
        Where a.EID=b.EID and b.ID=@ID
    End
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 重新上岗
    -- 更新eStatus项JobRepostdate
    IF EXISTS(Select 1 From pChangeSalesDepartCadre_Register Where ChangeType=2)
    Begin
        Update a
        Set a.JobRepostdate=b.Changedate
        From eStatus a,pChangeSalesDepartCadre_Register b
        Where a.EID=b.EID and b.ID=@ID
    End
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入营业部干部调动登记表pChangeSalesDepartCadre_all
    insert into pChangeSalesDepartCadre_all (EID,Badge,Name,CompID,SupDepID,DepID,JobID,Status,JoinDate,ChangeType,ChangeDate,
    FtgBy,FtgDepID,FtgJobID,FtgMobile,Remark,Submit,SubmitBy,SubmitTime)                            
    select EID,Badge,Name,CompID,SupDepID,DepID,JobID,Status,JoinDate,ChangeType,ChangeDate,FtgBy,FtgDepID,FtgJobID,FtgMobile,Remark,Submit,SubmitBy,SubmitTime
    from pChangeSalesDepartCadre_Register
    where id=@id
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除登记表
    delete from pChangeSalesDepartCadre_Register where id=@id
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