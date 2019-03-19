USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPInsuranceHousingFundClose]
-- skydatarefresh eSP_pEMPInsuranceHousingFundClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 五险一金分配月度关闭程序
-- @ID 为五险一金分配月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
    
    -- 月度五险一金分配未开启，无法关闭!
    If Exists(Select 1 From pEMPInsuranceHousingFund_Process Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930440
        Return @RetVal
    End


    -- 月度五险一金分配已关闭，无法关闭!
    If Exists(Select 1 From pEMPInsuranceHousingFund_Process Where ID=@ID And Isnull(Closed,0)=1)
    Begin
        Set @RetVal = 930450
        Return @RetVal
    End


    Begin TRANSACTION


    -- 更新部门年金月度表项pEMPInsuranceHousingFundDep
    update a
    set a.IsClosed=1
    from pEMPInsuranceHousingFundDep a,pEMPInsuranceHousingFund_Process b
    where b.ID=@ID and b.Date=a.Month and ISNULL(a.IsClosed,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入后台员工社保月度分配历史表pEMPInsurancePerMM_all
    insert into pEMPInsurancePerMM_all(Month,EID,EndowInsEMP,EndowInsEMPPlus,MedicalInsEMP,MedicalInsEMPPlus,UnemployInsEMP,UnemployInsEMPPlus,
    EndowInsGRP,EndowInsGRPPlus,MedicalInsGRP,MedicalInsGRPPlus,UnemployInsGRP,UnemployInsGRPPlus,MaternityInsGRP,MaternityInsGRPPlus,InjuryInsGRP,InjuryInsGRPPlus,
    InsEMPTotal,InsEMPPlusTotal,InsGRPTotal,InsGRPPlusTotal,Remark)
    select a.Month,a.EID,a.EndowInsEMP,a.EndowInsEMPPlus,a.MedicalInsEMP,a.MedicalInsEMPPlus,a.UnemployInsEMP,a.UnemployInsEMPPlus,a.EndowInsGRP,a.EndowInsGRPPlus,
    a.MedicalInsGRP,a.MedicalInsGRPPlus,a.UnemployInsGRP,a.UnemployInsGRPPlus,a.MaternityInsGRP,a.MaternityInsGRPPlus,a.InjuryInsGRP,a.InjuryInsGRPPlus,
    a.InsEMPTotal,a.InsEMPPlusTotal,a.InsGRPTotal,a.InsGRPPlusTotal,a.Remark
    from pEMPInsurancePerMM a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入后台员工公积金月度分配历史表pEMPHousingFundPerMM_all
    insert into pEMPHousingFundPerMM_all(Month,EID,HousingFundEMP,HousingFundEMPPlus,HousingFundGRP,HousingFundGRPPlus,
    HousingFundEMPTotal,HousingFundEMPPlusTotal,HousingFundGRPTotal,HousingFundGRPPlusTotal,Remark)
    select a.Month,a.EID,a.HousingFundEMP,a.HousingFundEMPPlus,a.HousingFundGRP,a.HousingFundGRPPlus,
    a.HousingFundEMPTotal,a.HousingFundEMPPlusTotal,a.HousingFundGRPTotal,a.HousingFundGRPPlusTotal,a.Remark
    from pEMPHousingFundPerMM a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    
    -- 更新五险一金月度表项pEMPInsuranceHousingFund_Process
    Update a
    Set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    From pEMPInsuranceHousingFund_Process a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除员工社保月度注册表
    delete from pEMPInsurancePerMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除员工公积金月度注册表
    delete from pEMPHousingFundPerMM
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