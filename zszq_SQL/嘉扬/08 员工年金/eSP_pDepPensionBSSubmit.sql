USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionBSSubmit]
-- skydatarefresh eSP_pDepPensionBSSubmit
    @leftid int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 分支机构年金参与确认程序
-- @leftid 为营业部对应DepID
*/
Begin


    Begin TRANSACTION


    -- 更新员工年金确认状态
    ---- 分支机构后台员工
    Update a
    Set a.IsSubmit=1
    From pPensionUpdatePerEmp a,eEmployee b
    Where a.EID=b.EID and b.DepID=@leftid and ISNULL(a.IsClosed,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 分支机构前台员工
    Update a
    Set a.IsSubmit=1
    From pPensionUpdatePerSDM a
    Where ISNULL(a.DepID,a.SupDepID)=@leftid and ISNULL(a.IsClosed,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 分支机构
    Update a
    Set a.IsSubmit=1
    From pPensionUpdatePerDep a
    Where ISNULL(a.DepID,a.SupDepID)=@leftid and ISNULL(a.IsClosed,0)=0
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