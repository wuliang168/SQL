USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionPerMMBSChange]
-- skydatarefresh eSP_pDepPensionPerMMBSChange
    @DepID int, 
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配月度联系人更换程序
-- @DepID 为年金计划分配月度联系人对应DepID
-- @EID为年金计划分配月度联系人对应的EID
*/
Begin

    -- 非分公司/营业部负责人无法修改年金联系人!
    If Exists(Select 1 From pDepPensionPerMM Where @EID <> (select director from odepartment where depid=@DepID))
    Begin
        Set @RetVal = 930081
        Return @RetVal
    End


    Begin TRANSACTION

    -- 分公司/营业部负责人修改年金联系人
    ---- 更换部门年金月度表项pDepPensionPerMM
    update pDepPensionPerMM
    set PensionContact=(select PensionContact from pDepPensionPerMM where DepID=@DepID)
    where DepID=@DepID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 更换后台员工年金联系人pEmpPensionPerMM_register
    update a
    set a.PensionContact=(select PensionContact from pDepPensionPerMM where DepID=@DepID)
    from pEmpPensionPerMM_register a,pEmployeeEmolu b
    where a.EID=b.EID and b.SalaryPayID in (6) and
    a.EID in (select eid from eemployee where depid=@DepID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 更换投理顾员工年金联系人pSDMarketerPensionPerMM_register
    update pSDMarketerPensionPerMM_register
    set PensionContact=(select PensionContact from pDepPensionPerMM where DepID=@DepID)
    where DepID=@DepID
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