USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionUpdateEmpOpen]
-- skydatarefresh eSP_pPensionUpdateEmpOpen
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金总部子公司人员重新开启程序
-- @ID 为年金总部子公司人员对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新员工年金确认状态
    ---- 总部子公司员工
    Update a
    Set a.IsSubmit=NULL
    From pPensionUpdatePerEmp_register a
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