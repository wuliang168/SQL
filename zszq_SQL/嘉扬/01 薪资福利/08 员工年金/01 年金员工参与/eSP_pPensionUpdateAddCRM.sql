USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionUpdateAddCRM]
-- skydatarefresh eSP_pPensionUpdateAddCRM
    @pPensionUpdateID int,
    @BID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金新增前台员工程序
-- @leftid为前台员工对应的部门ID
-- @BID 为年金参与前台员工的ID
*/
Begin

    -- 员工已经存在，不可重复添加
    If Exists(Select 1 From pPensionUpdatePerEmp_register Where BID=@BID AND pPensionUpdateID=@pPensionUpdateID)
    Begin
        Set @RetVal = 1100001
        Return @RetVal
    End


    Begin TRANSACTION


    -- 新增前台员工
    insert into pPensionUpdatePerEmp_register(pPensionUpdateID,BID,Status,JoinDate,LeaDate,IsPension)
    select @pPensionUpdateID,a.BID,a.Status,a.JoinDate,a.LeaDate,1
    from pVW_employee a
    where BID=@BID
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