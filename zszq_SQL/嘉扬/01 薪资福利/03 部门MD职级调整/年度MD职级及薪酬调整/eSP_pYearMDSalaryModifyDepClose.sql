USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pYearMDSalaryModifyDepClose]
-- skydatarefresh eSP_pYearMDSalaryModifyDepClose
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度MD职级及薪酬调整部门流程递交关闭程序
-- @ID 为部门工资统计对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新年度MD职级及薪酬调整部门流程状态
    Update a
    Set a.IsDepSubmit=1
    From pYear_MDSalaryModifyDep a
    Where ID=@ID
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