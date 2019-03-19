USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMSummContactChange]
-- skydatarefresh eSP_pSalaryPerMMSummContactChange
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资统计部门工资联系人更换程序
-- @ID 为部门月度工资统计对应ID
*/
Begin

    Begin TRANSACTION

    -- 更新后台人员年金月度分配注册表pEmpPensionPerMM_register
    update a
    set a.SalaryContact=b.SalaryContact
    from pSalaryPerMMSumm_register a,pSalaryPerMMSummDep b
    where b.ID=@ID and a.DepID=b.DepID
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