USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMonthStart]
-- skydatarefresh eSP_pSalaryPerMonthStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资流程开启程序
-- @ID 为月度工资流程月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 定义月度工资同步开启月度年金的ID
    Declare @PensionPerMMID int

    -- 上月度年金计划分配未关闭!
    If Exists(Select 1 From pPensionPerMM
    Where ID>1 and Isnull(Closed,0)=0
    AND ID=(select a.ID from pPensionPerMM a,pSalaryPerMonth b where DATEDIFF(MM,a.PensionMonth,b.Date)=0 and b.ID=@ID)-1)
    Begin
        Set @RetVal = 930070
        Return @RetVal
    End

    -- 月度工资流程中日期为空!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and ISNULL(Date,0)=1)
    Begin
        Set @RetVal = 930091
        Return @RetVal
    End

    -- 月度工资流程已开启!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930092
        Return @RetVal
    End

    -- 月度工资流程已关闭!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930093
        Return @RetVal
    End

    -- 上月度工资流程未关闭!
    If Exists(Select 1 From pSalaryPerMonth Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930099
        Return @RetVal
    End


    Begin TRANSACTION

    -- 同步开启月度年金分配流程
    ---- 新建月度年金分配流程
    IF not Exists(Select 1 From pPensionPerMM a,pSalaryPerMonth b where b.ID=@ID and DATEDIFF(mm,a.PensionMonth,b.Date)=0)
    Begin
        insert into pPensionPerMM (PensionMonth)
        select a.Date
        from pSalaryPerMonth a
        where a.ID=@ID
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    End
    -- 定义@PensionPerMMID值
    select @PensionPerMMID=a.ID From pPensionPerMM a,pSalaryPerMonth b where b.ID=@ID and DATEDIFF(mm,a.PensionMonth,b.Date)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 开启月度年金分配流程
    exec eSP_pPensionPerMMStart @PensionPerMMID,@URID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的部门月度工资流程表项pDepSalaryPerMonth
    insert into pDepSalaryPerMonth(Date,SupDepID,DepID,Status,SalaryPayID,SalaryContact,IsSubmit)
    select b.Date,a.SupDepID,a.DepID,a.Status,a.SalaryPayID,a.SalaryContact,NULL
    from pVW_DepSalaryContact a,pSalaryPerMonth b
    where b.ID=@ID
    -- 营业部
    and ((a.DepID is not NULL and a.DepID not in (select DepID from pDepSalaryPerMonth where DATEDIFF(MM,b.Date,Date)=0))
    -- 非营业部
    or (a.DepID is NULL and a.SalaryPayID not in (select SalaryPayID from pDepSalaryPerMonth where DATEDIFF(MM,b.Date,Date)=0)))
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    
    -- 插入月度工资流程的交通费
    ---- 非营业部，非离职退休员工
    insert into pEmployeeTraffic(EID,Date,TrafficAllowance,SalaryContact)
    select a.EID,b.Date,a.TrafficAllowance,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeTraffic)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeTraffic(EID,Date,TrafficAllowance,SalaryContact)
    select a.EID,b.Date,a.TrafficAllowance,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeTraffic)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的年金
    ---- 非营业部，非离职退休员工
    insert into pEmployeePension(EID,Date,GrpPensionMonthTotal,GrpPensionMonthRest,SalaryContact)
    select a.EID,b.Date,a.GrpPensionYearRest,a.GrpPensionYearRest,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeePension) and ISNULL(a.GrpPensionYearRest,0)>0
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeePension(EID,Date,GrpPensionMonthTotal,GrpPensionMonthRest,SalaryContact)
    select a.EID,b.Date,a.GrpPensionYearRest,a.GrpPensionYearRest,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeePension) and ISNULL(a.GrpPensionYearRest,0)>0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的五险一金表项pEmployeeEmoluFundIns
    ---- 非营业部，非离职退休员工
    insert into pEmployeeEmoluFundIns(EID,Date,HousingFundEMP,HousingFundGRP,HousingFundOverEMP,HousingFundOverGRP,EndowInsEMP,EndowInsGRP,
    MedicalInsEMP,MedicalInsGRP,UnemployInsEMP,UnemployInsGRP,MaternityInsGRP,InjuryInsGRP,FundInsEMPTotal,FundInsGRPTotal,SalaryContact)
    select a.EID,b.Date,a.HousingFundEMP,a.HousingFundGRP,a.HousingFundOverEMP,a.HousingFundOverGRP,a.EndowInsEMP,a.EndowInsGRP,
    a.MedicalInsEMP,a.MedicalInsGRP,a.UnemployInsEMP,a.UnemployInsGRP,a.MaternityInsGRP,a.InjuryInsGRP,
    a.HousingFundEMP+a.EndowInsEMP+a.MedicalInsEMP+a.UnemployInsEMP,HousingFundGRP+a.EndowInsGRP+a.MedicalInsGRP+a.UnemployInsGRP+a.MaternityInsGRP+a.InjuryInsGRP,
    d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeEmoluFundIns)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeEmoluFundIns(EID,Date,HousingFundEMP,HousingFundGRP,HousingFundOverEMP,HousingFundOverGRP,EndowInsEMP,EndowInsGRP,
    MedicalInsEMP,MedicalInsGRP,UnemployInsEMP,UnemployInsGRP,MaternityInsGRP,InjuryInsGRP,FundInsEMPTotal,FundInsGRPTotal,SalaryContact)
    select a.EID,b.Date,a.HousingFundEMP,a.HousingFundGRP,a.HousingFundOverEMP,a.HousingFundOverGRP,a.EndowInsEMP,a.EndowInsGRP,
    a.MedicalInsEMP,a.MedicalInsGRP,a.UnemployInsEMP,a.UnemployInsGRP,a.MaternityInsGRP,a.InjuryInsGRP,
    a.HousingFundEMP+a.EndowInsEMP+a.MedicalInsEMP+a.UnemployInsEMP,HousingFundGRP+a.EndowInsGRP+a.MedicalInsGRP+a.UnemployInsGRP+a.MaternityInsGRP+a.InjuryInsGRP,
    d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeEmoluFundIns)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的奖金分配表项pEmployeeEmoluBonus
    ---- 非营业部，非离职退休员工
    insert into pEmployeeEmoluBonus(EID,Date,SalaryContact)
    select a.EID,b.Date,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeEmoluBonus)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeEmoluBonus(EID,Date,SalaryContact)
    select a.EID,b.Date,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeEmoluBonus)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的过节费分配表项pEmployeeEmoluFestivalFee
    ---- 非营业部，非离职退休员工
    insert into pEmployeeEmoluFestivalFee(EID,Date,SalaryContact)
    select a.EID,b.Date,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeEmoluFestivalFee)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeEmoluFestivalFee(EID,Date,SalaryContact)
    select a.EID,b.Date,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeEmoluFestivalFee)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的补发工资分配表项pEmployeeEmoluBackPay
    ---- 非营业部，非离职退休员工
    insert into pEmployeeEmoluBackPay(EID,Date,SalaryContact)
    select a.EID,b.Date,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeEmoluBackPay)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeEmoluBackPay(EID,Date,SalaryContact)
    select a.EID,b.Date,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeEmoluBackPay)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税前补贴分配表项pEmployeeEmoluAllowanceBT
    ---- 非营业部，非离职退休员工
    insert into pEmployeeEmoluAllowanceBT(EID,Date,CommAllowanceBT,SalaryContact)
    select a.EID,b.Date,a.CommAllowance,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeEmoluAllowanceBT) and a.CommAllowanceType in (4)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeEmoluAllowanceBT(EID,Date,CommAllowanceBT,SalaryContact)
    select a.EID,b.Date,a.CommAllowance,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeEmoluAllowanceBT) and a.CommAllowanceType in (4)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税前扣款分配表项pEmployeeEmoluDeductionBT
    ---- 非营业部，非离职退休员工
    insert into pEmployeeEmoluDeductionBT(EID,Date,SalaryContact)
    select a.EID,b.Date,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeEmoluDeductionBT)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeEmoluDeductionBT(EID,Date,SalaryContact)
    select a.EID,b.Date,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeEmoluDeductionBT)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税后扣款分配表项pEmployeeEmoluDeductionAT
    ---- 非营业部，非离职退休员工
    insert into pEmployeeEmoluDeductionAT(EID,Date,SalaryContact)
    select a.EID,b.Date,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeEmoluDeductionAT)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeEmoluDeductionAT(EID,Date,SalaryContact)
    select a.EID,b.Date,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeEmoluDeductionAT)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税后补贴分配表项pEmployeeEmoluAllowanceAT
    ---- 非营业部，非离职退休员工
    insert into pEmployeeEmoluAllowanceAT(EID,Date,CommAllowanceAT,SalaryContact)
    select a.EID,b.Date,a.CommAllowance,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeEmoluAllowanceAT) and a.CommAllowanceType in (1)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeEmoluAllowanceAT(EID,Date,CommAllowanceAT,SalaryContact)
    select a.EID,b.Date,a.CommAllowance,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeEmoluAllowanceAT) and a.CommAllowanceType in (1)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税务调整分配表项pEmployeeEmoluTax
    ---- 非营业部，非离职退休员工
    insert into pEmployeeEmoluTax(EID,Date,SalaryContact)
    select a.EID,b.Date,d.SalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeEmoluTax)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeEmoluTax(EID,Date,SalaryContact)
    select a.EID,b.Date,d.DepSalaryContact
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeEmoluTax)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的通讯费
    ---- 非营业部，非离职退休员工
    insert into pEmployeeComm(EID,Date,CommAllowance)
    select a.EID,b.Date,a.CommAllowance
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oCD_SalaryPayType d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and a.SalaryPayID=d.ID and a.SalaryPayID<>6
    and a.EID not in (select EID from pEmployeeComm)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部，非离职退休员工
    insert into pEmployeeComm(EID,Date,CommAllowance)
    select a.EID,b.Date,a.CommAllowance
    from pEmployeeEmolu a,pSalaryPerMonth b,eEmployee c,oDepartment d
    where b.ID=@ID and a.EID=c.EID and c.Status not in (4,5) and c.DepID=d.DepID and a.SalaryPayID=6
    and a.EID not in (select EID from pEmployeeComm)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新员工年金
    ---- 年金已开启并未关闭
    update a
    set a.PensionEMPBT=b.EmpPensionPerMMBTax,a.PensionEMPAT=b.EmpPensionPerMMATax
    from pEmployeePension a,pEmpPensionPerMM_register b
    where a.EID=b.EID and DATEDIFF(mm,a.Date,b.PensionMonth)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 年金已开启并已关闭
    update a
    set a.PensionEMPBT=b.EmpPensionPerMMBTax,a.PensionEMPAT=b.EmpPensionPerMMATax
    from pEmployeePension a,pEmpPensionPerMM_all b
    where a.EID=b.EID and DATEDIFF(mm,a.Date,b.PensionMonth)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新员工月度奖项奖金
    ---- 普通奖金
    update a
    set a.GeneralBonus=(select ISNULL(SUM(BonusAmount1),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth1)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount2),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth2)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount3),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth3)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount4),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth4)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount5),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth5)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount6),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth6)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount7),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth7)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount8),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth8)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount9),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth9)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount10),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth10)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount11),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth11)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount12),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth12)=0 and EID=a.EID and ISNULL(Submit,0)=1),
    a.BonusTotalMM=(select ISNULL(SUM(BonusAmount1),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth1)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount2),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth2)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount3),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth3)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount4),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth4)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount5),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth5)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount6),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth6)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount7),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth7)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount8),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth8)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount9),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth9)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount10),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth10)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount11),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth11)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    +(select ISNULL(SUM(BonusAmount12),0) from pEmpEmoluBonusAdd where DATEDIFF(MM,a.Date,BonusMonth12)=0 and EID=a.EID and ISNULL(Submit,0)=1)
    from pEmployeeEmoluBonus a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新员工通讯费
    ---- 税前通讯费补缴
    update a
    set a.CommAllowancePlus=b.CommAllowance,a.AllowanceBTTotal=ISNULL(a.AllowanceBTTotal,0)+ISNULL(b.CommAllowance,0)
    from pEmployeeEmoluAllowanceBT a,pEmployeeEmolu b,eStatus c
    where a.EID=b.EID and a.EID=c.EID and DAY(c.joindate)<=10 and DATEDIFF(mm,c.joindate,a.date)=1 and b.CommAllowanceType=4
    and a.EID not in (select EID from pEmployeeEmoluAllowanceBT_all where DATEDIFF(mm,date,a.date)=1)
    ---- 税后通讯费补缴
    update a
    set a.CommAllowancePlus=b.CommAllowance,a.AllowanceATTotal=ISNULL(a.AllowanceATTotal,0)+ISNULL(b.CommAllowance,0)
    from pEmployeeEmoluAllowanceAT a,pEmployeeEmolu b,eStatus c
    where a.EID=b.EID and a.EID=c.EID and DAY(c.joindate)<=10 and DATEDIFF(mm,c.joindate,a.date)=1 and b.CommAllowanceType=1
    and a.EID not in (select EID from pEmployeeEmoluAllowanceAT_all where DATEDIFF(mm,date,a.date)=1)

    ---- 补发工资
    ---- 试用期补差额
    ------ 已转正人员且发薪月份比转正月份大1，固定工资+固定工资/21.75天*实际工作日
    update a
    set a.ProbationBackPay=ISNULL(b.SalaryPerMM,0)/21.75*(dbo.aFN_GetWorkday(b.AppraisedDate,dateadd(d,-day(b.AppraisedDate),dateadd(m,1,b.AppraisedDate))))
    from pEmployeeEmoluBackPay a,pEmployeeEmolu b
    where a.EID=b.EID and ISNULL(b.IsAppraised,0)=1 and DATEDIFF(mm,b.AppraisedDate,a.Date)=1
    and b.SalaryPayID<>6
    ---- 新入职补上月工资
    ------ 已入职人员且发薪月份比入职月份大1，固定工资+固定工资/21.75天*实际工作日
    update a
    set a.NewStaffBackPay=ISNULL(c.SalaryPerMM,0)/21.75*(dbo.aFN_GetWorkday(b.JoinDate,dateadd(d,-day(b.JoinDate),dateadd(m,1,b.JoinDate))))
    from pEmployeeEmoluBackPay a,eStatus b,pEmployeeEmolu c
    where a.EID=b.EID and DATEDIFF(mm,b.JoinDate,a.Date)=1
    and a.EID=c.EID and c.SalaryPayID<>6
    ---- 公司任命补差额
    ------ 已任命人员且发薪月份比任命月份大1，固定工资+固定工资/21.75天*实际工作日
    update a
    set a.AppointBackPay=ISNULL(c.SalaryPerMM,0)/21.75*(dbo.aFN_GetWorkday(b.EffectiveDate,dateadd(d,-day(b.EffectiveDate),dateadd(m,1,b.EffectiveDate))))
    from pEmployeeEmoluBackPay a,pChangeMDSalaryPerMM_all b,pEmployeeEmolu c
    where a.EID=b.EID and DATEDIFF(mm,b.EffectiveDate,a.Date)=1 and b.MDSalaryModifyReason=8
    and a.EID=c.EID and c.SalaryPayID<>6
    ---- 调岗期补差额
    ------ 已调岗人员且发薪月份比调岗月份大1，固定工资+固定工资/21.75天*实际工作日
    update a
    set a.TransPostBackPay=ISNULL(c.SalaryPerMM,0)/21.75*(dbo.aFN_GetWorkday(b.EffectiveDate,dateadd(d,-day(b.EffectiveDate),dateadd(m,1,b.EffectiveDate))))
    from pEmployeeEmoluBackPay a,pChangeMDSalaryPerMM_all b,pEmployeeEmolu c
    where a.EID=b.EID and DATEDIFF(mm,b.EffectiveDate,a.Date)=1 and b.MDSalaryModifyReason=3
    and a.EID=c.EID and c.SalaryPayID<>6

    -- 更新月度工资流程状态
    update pSalaryPerMonth
    set Submit=1,SubmitBy=@URID,SubmitTime=GETDATE()
    where ID=@ID
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