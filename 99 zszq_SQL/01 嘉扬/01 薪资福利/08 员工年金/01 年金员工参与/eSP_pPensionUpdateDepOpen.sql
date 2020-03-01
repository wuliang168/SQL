USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionUpdateDepOpen]
-- skydatarefresh eSP_pPensionUpdateDepOpen
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金分支机构人员重新开启程序
-- @ID 为年金前台人员对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新员工年金确认状态
    ---- 分支机构员工
    Update a
    Set a.IsSubmit=NULL
    From pPensionUpdatePerEmp_register a,pVW_employee b,pPensionUpdatePerDep c
    Where c.ID=@ID and ISNULL(a.BID,a.EID)=ISNULL(b.BID,b.EID)
    AND a.pPensionUpdateID=c.pPensionUpdateID AND b.DepID=ISNULL(c.DepID,c.SupDepID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 分支机构部门
    Update a
    Set a.IsSubmit=NULL
    From pPensionUpdatePerDep a
    Where a.ID=@ID
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