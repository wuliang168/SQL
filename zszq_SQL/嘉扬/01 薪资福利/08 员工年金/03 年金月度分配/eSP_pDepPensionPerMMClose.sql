USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionPerMMClose]
-- skydatarefresh eSP_pDepPensionPerMMClose
    @ID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门年金月度开启程序
-- @ID 为部门年金计划分配月度对应ID
*/
Begin
    
    -- 部门年金月度计划分配已关闭!
    If Exists(Select 1 From pDepPensionPerMM Where ID=@ID And Isnull(IsSubmit,0)=1)
    Begin
        Set @RetVal = 930069
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新年金月度表项pPensionPerMM
    Update a
    Set a.IsSubmit=1
    From pDepPensionPerMM a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新后台人员年金月度分配注册表pEmpPensionPerMM_register
    -- 薪酬类型非营业部;
    IF Exists(select 1 from pDepPensionPerMM where SalaryPayID not in (6) and ID=@ID)
    BEGIN
        update a
        set a.Submit=1
        from pEmpPensionPerMM_register a,pDepPensionPerMM b,pEmployeeEmolu c
        where b.ID=@ID and b.SalaryPayID=c.SalaryPayID and a.EID=c.EID 
    END
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 薪酬类型营业部;
    IF Exists(select 1 from pDepPensionPerMM where SalaryPayID in (6) and ID=@ID)
    BEGIN
        update a
        set a.Submit=1
        from pEmpPensionPerMM_register a,pDepPensionPerMM b,eemployee c
        where b.ID=@ID and a.EID=c.EID and b.DepID=c.DepID
    END
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新投理顾人员年金月度分配注册表pSDMarketerPensionPerMM_register
    IF Exists(select 1 from pDepPensionPerMM where SalaryPayID in (6) and ID=@ID)
    BEGIN
        update a
        set a.Submit=1
        from pSDMarketerPensionPerMM_register a,pDepPensionPerMM b,pSalesDepartMarketerEmolu c
        where b.ID=@ID and a.Identification=c.Identification and ISNULL(b.DepID,b.SupDepID)=ISNULL(c.DepID,c.SupDepID)
    END
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