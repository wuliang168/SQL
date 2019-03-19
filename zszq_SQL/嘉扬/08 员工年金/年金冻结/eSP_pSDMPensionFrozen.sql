USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSDMPensionFrozen]
-- skydatarefresh eSP_pSDMPensionFrozen
    @Identification varchar(100),
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
    ---- 前台员工
    Update a
    Set a.GrpPensionFrozen=ISNULL(a.GrpPensionYearRest,a.GrpPensionFrozen)
    From pSalesDepartMarketerEmolu a
    Where a.Identification=@Identification
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 同步后台员工
    Update b
    Set b.GrpPensionFrozen=ISNULL(a.GrpPensionYearRest,a.GrpPensionFrozen)
    From pSalesDepartMarketerEmolu a,pEmployeeEmolu b,eDetails c
    Where a.Identification=@Identification and a.Identification=c.CertNo and b.EID=c.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 剩余的年金置为0
    ---- 前台员工
    Update a
    Set a.GrpPensionYearRest=0
    From pSalesDepartMarketerEmolu a
    Where a.Identification=@Identification
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 同步后台员工
    Update b
    Set b.GrpPensionYearRest=0
    From pSalesDepartMarketerEmolu a,pEmployeeEmolu b,eDetails c
    Where a.Identification=@Identification and a.Identification=c.CertNo and b.EID=c.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pSDMarketerPensionPerMM_register信息
    ---- 前台员工
    delete from pSDMarketerPensionPerMM_register 
    where Identification=@Identification
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