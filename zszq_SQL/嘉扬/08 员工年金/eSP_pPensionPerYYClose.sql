USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionPerYYClose]
-- skydatarefresh eSP_pPensionPerYYClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配年度关闭程序
-- @ID 为年金计划分配年度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 申明
    declare @PensionYear smalldatetime
    select @PensionYear=PensionYear from pPensionPerYY where ID=@ID

    -- 年度年金计划分配未开启!
    If Exists(Select 1 From pPensionPerYY Where ID=@ID and ISNULL(Submit,0)=0)
    Begin
        Set @RetVal = 930064
        Return @RetVal
    End

    Begin TRANSACTION

    -- 插入员工年金年度分配详细数据表项
    ---- 后台员工年金年度分配详细数据表项
    insert into pEMPPensionPerYY(PensionYear,Badge,Name,CertNo,IsPension,JoinDate,LeaDate,
    PostModulusPerYY,PostMonthPerYY,PostModulusPerMM,GrpPensionPerYY,EmpPensionPerYY,JobXorder)
    select PensionYear,Badge,Name,CertNo,IsPension,JoinDate,LeaDate,
    PostModulusPerYY,PostMonthPerYY,PostModulusPerMM,GrpPensionPerYY,EmpPensionPerYY,JobXorder
    from pVW_pEMPPensionPerYY
    where Year(PensionYear)=(select Year(PensionYear) from pPensionPerYY where ID=@ID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 投理顾员工年金年度分配详细数据表项
    insert into pSDMarketerPensionPerYY(PensionYear,Identification,Name,IsPension,JoinDate,LeaDate,
    PostModulusPerYY,PostMonthPerYY,PostModulusPerMM,GrpPensionPerYY,EmpPensionPerYY,JobXorder)
    select PensionYear,Identification,Name,IsPension,JoinDate,LeaDate,
    PostModulusPerYY,PostMonthPerYY,PostModulusPerMM,GrpPensionPerYY,EmpPensionPerYY,JobXorder
    from pVW_pSDMarketerPensionPerYY
    where Year(PensionYear)=(select Year(PensionYear) from pPensionPerYY where ID=@ID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    
    -- 更新后台员工的年度企业年金剩余
    update a
    set a.GrpPensionYearRest=ISNULL(a.GrpPensionYearRest,0)
    +(select SUM(GrpPensionPerYY) from pEMPPensionPerYY where badge=(select badge from eemployee where eid=a.EID) and YEAR(PensionYear)=YEAR(@PensionYear)),
    a.EmpPensionYearRest=ISNULL(a.EmpPensionYearRest,0)
    +(select SUM(EmpPensionPerYY) from pEMPPensionPerYY where badge=(select badge from eemployee where eid=a.EID) and YEAR(PensionYear)=YEAR(@PensionYear))
    from pEmployeeEmolu a,eEmployee b
    where a.EID=b.EID and b.Badge in (select Badge from pEMPPensionPerYY where YEAR(PensionYear)=YEAR(@PensionYear))
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 更新后台员工转投理顾员工企业年金剩余
    update a
    set a.GrpPensionYearRest=ISNULL(a.GrpPensionYearRest,0)
    +(select SUM(GrpPensionPerYY) from pEMPPensionPerYY where CertNo=a.Identification and YEAR(PensionYear)=YEAR(@PensionYear)),
    a.EmpPensionYearRest=ISNULL(a.EmpPensionYearRest,0)
    +(select SUM(EmpPensionPerYY) from pEMPPensionPerYY where CertNo=a.Identification and YEAR(PensionYear)=YEAR(@PensionYear))
    from pSalesDepartMarketerEmolu a
    where a.Identification in (select CertNo from pEMPPensionPerYY where YEAR(PensionYear)=YEAR(@PensionYear))
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新后台员工转投理顾员工年金剩余数值(企业年金分配和审批通过期间)
    update a
    set a.GrpPensionYearRest=ISNULL(a.GrpPensionYearRest,0)
    +(select SUM(GrpPensionPerYY) from pSDMarketerPensionPerYY where Identification=a.Identification  and YEAR(PensionYear)=YEAR(@PensionYear)),
    a.EmpPensionYearRest=ISNULL(a.EmpPensionYearRest,0)
    +(select SUM(EmpPensionPerYY) from pSDMarketerPensionPerYY where Identification=a.Identification  and YEAR(PensionYear)=YEAR(@PensionYear))
    from pSalesDepartMarketerEmolu a
    where a.Identification in (select Identification from pSDMarketerPensionPerYY where YEAR(PensionYear)=YEAR(@PensionYear))
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 更新投理顾员工转后台员工年金剩余数值(企业年金分配和审批通过期间)
    update a
    set a.GrpPensionYearRest=ISNULL(a.GrpPensionYearRest,0)
    +(select SUM(GrpPensionPerYY) from pSDMarketerPensionPerYY where Identification=(select CertNo from eDetails where eid=a.EID) and YEAR(PensionYear)=YEAR(@PensionYear)),
    a.EmpPensionYearRest=ISNULL(a.EmpPensionYearRest,0)
    +(select SUM(EmpPensionPerYY) from pSDMarketerPensionPerYY where Identification=(select CertNo from eDetails where eid=a.EID) and YEAR(PensionYear)=YEAR(@PensionYear))
    from pEmployeeEmolu a,eEmployee b
    where a.EID=b.EID and (select CertNo from eDetails where eid=a.EID) in (select Identification from pSDMarketerPensionPerYY where YEAR(PensionYear)=YEAR(@PensionYear))
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    
    ---- 更新实际分配总额
    Update a
    Set a.PensionYearCalcTotal=(select SUM(GrpPensionPerYY) from pEMPPensionPerYY where Year(PensionYear)=YEAR(a.PensionYear))+
    (select SUM(GrpPensionPerYY) from pSDMarketerPensionPerYY where Year(PensionYear)=YEAR(a.PensionYear))
    From pPensionPerYY a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 更新分配差值
    Update a
    Set a.PensionYearDiff=a.PensionYearCalcTotal-a.PensionYearTotal
    From pPensionPerYY a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新年度年金计划分配表项pPensionPerYY
    Update a
    Set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    From pPensionPerYY a
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