USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionContactChange]
-- skydatarefresh eSP_pDepPensionContactChange
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门年金联系人更换程序
-- @ID 为部门年金计划分配月度对应ID
*/
Begin

    Begin TRANSACTION

    -- 更新后台人员年金月度分配注册表pEmpPensionPerMM_register
    -- 薪酬类型非营业部;
    ------ 总部
    IF Exists(select 1 from pDepPensionPerMM where SalaryPayID in (1,2,3,10,11,12,13,14,15,16,19) and ID=@ID)
    BEGIN
        update a
        set a.PensionContact=b.PensionContact
        from pEmpPensionPerMM_register a,pDepPensionPerMM b,pEmpSalary c
        where b.ID=@ID and c.SalaryPayID in (1,2,3,10,11,12,13,14,15,16,19) and a.EID=c.EID
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    END
    ------ 资管
    IF Exists(select 1 from pDepPensionPerMM where SalaryPayID in (4,5) and ID=@ID)
    BEGIN
        update a
        set a.PensionContact=b.PensionContact
        from pEmpPensionPerMM_register a,pDepPensionPerMM b,pEmpSalary c
        where b.ID=@ID and c.SalaryPayID in (4,5) and a.EID=c.EID 
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    END
    ------ 资本
    IF Exists(select 1 from pDepPensionPerMM where SalaryPayID=7 and ID=@ID)
    BEGIN
        update a
        set a.PensionContact=b.PensionContact
        from pEmpPensionPerMM_register a,pDepPensionPerMM b,pEmpSalary c
        where b.ID=@ID and b.SalaryPayID=c.SalaryPayID and a.EID=c.EID 
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    END

    -- 薪酬类型营业部;
    IF Exists(select 1 from pDepPensionPerMM where SalaryPayID=6 and ID=@ID)
    BEGIN
        update a
        set a.PensionContact=b.PensionContact
        from pEmpPensionPerMM_register a,pDepPensionPerMM b,pVW_employee c
        where b.ID=@ID and b.SalaryPayID=6 and ISNULL(a.EID,a.BID)=ISNULL(c.EID,c.BID) 
        and ISNULL(b.DepID,b.SupDepID)=c.DepID
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    END


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