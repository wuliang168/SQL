USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPSalaryCheckSubmit]
-- skydatarefresh eSP_pEMPSalaryCheckSubmit
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 员工工资信息检查提交程序
-- @EID 为部门负责人对应EID
*/
Begin


    Begin TRANSACTION

    -- 更新员工年金确认状态
    ---- 后台员工
    Update a
    Set a.IsSubmit=1
    From pEMPSalaryCheck a,pVW_employee b
    Where ISNULL(a.IsSubmit,0)=0 and dbo.eFN_getdepdirector(b.DepID)=@EID
    and ISNULL(a.BID,a.EID)=ISNULL(b.BID,b.EID) and b.status in (1,2,3)
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