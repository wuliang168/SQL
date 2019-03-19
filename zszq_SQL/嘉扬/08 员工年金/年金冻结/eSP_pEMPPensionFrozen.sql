USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPPensionFrozen]
-- skydatarefresh eSP_pEMPPensionFrozen
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 员工年金冻结程序
-- @ID 为年金员工对应ID
*/
Begin


    Begin TRANSACTION

    -- 拷贝剩余的年金到年金冻结中
    ---- 后台员工
    Update a
    Set a.GrpPensionFrozen=ISNULL(a.GrpPensionYearRest,a.GrpPensionFrozen)
    From pEmployeeEmolu a
    Where a.EID=@EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 同步前台员工
    Update b
    Set b.GrpPensionFrozen=ISNULL(a.GrpPensionYearRest,a.GrpPensionFrozen)
    From pEmployeeEmolu a,pSalesDepartMarketerEmolu b,eDetails c
    Where a.EID=@EID and a.EID=c.EID and b.Identification=c.CertNo
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 剩余的年金置为0
    ---- 后台员工
    Update a
    Set a.GrpPensionYearRest=0
    From pEmployeeEmolu a
    Where a.EID=@EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 同步前台员工
    Update b
    Set b.GrpPensionYearRest=0
    From pEmployeeEmolu a,pSalesDepartMarketerEmolu b,eDetails c
    Where a.EID=@EID and a.EID=c.EID and b.Identification=c.CertNo
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pEmpPensionPerMM_register信息
    ---- 前台员工
    delete from pEmpPensionPerMM_register 
    where EID=@EID
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