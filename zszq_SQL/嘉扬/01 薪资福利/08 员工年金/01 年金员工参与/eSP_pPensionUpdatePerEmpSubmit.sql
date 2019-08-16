USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_pPensionUpdatePerEmpSubmit]
-- skydatarefresh eSP_pPensionUpdatePerEmpSubmit
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金后台员工确认程序
-- @EID 为年金参与员工EID
*/
Begin

    Begin TRANSACTION


    -- 设置年金参与数据
    ---- 更新参与人员状态
    ------ 后台员工
    update a
    set a.IsSubmit=1
    from pPensionUpdatePerEmp a
    where ISNULL(a.IsClosed,0)=0 and ISNULL(a.IsSubmit,0)=0 and EID=@EID
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