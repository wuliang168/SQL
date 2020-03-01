USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPInsuranceHousingFundBack]
-- skydatarefresh eSP_pEMPInsuranceHousingFundBack
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 五险一金分配月度退回程序
-- @ID 为五险一金分配月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
    
    -- 月度五险一金分配未关闭，无法退回!
    If Exists(Select 1 From pEMPInsuranceHousingFund_Process Where ID=@ID And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930460
        Return @RetVal
    End


    Begin TRANSACTION


    -- 更新部门年金月度表项pEMPInsuranceHousingFundDep
    update a
    set a.IsClosed=NULL
    from pEMPInsuranceHousingFundDep a,pEMPInsuranceHousingFund_Process b
    where b.ID=@ID and b.ID=a.pProcessID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入后台员工社保月度分配历史表pEMPInsurancePerMM
    insert into pEMPInsurancePerMM(pProcessID,Month,EID,BID,EndowInsEMP,EndowInsEMPPlus,MedicalInsEMP,MedicalInsEMPPlus,UnemployInsEMP,UnemployInsEMPPlus,
    EndowInsGRP,EndowInsGRPPlus,MedicalInsGRP,MedicalInsGRPPlus,UnemployInsGRP,UnemployInsGRPPlus,MaternityInsGRP,MaternityInsGRPPlus,InjuryInsGRP,InjuryInsGRPPlus,
    InsEMPTotal,InsEMPPlusTotal,InsGRPTotal,InsGRPPlusTotal,Remark)
    select a.pProcessID,a.Month,a.EID,a.BID,a.EndowInsEMP,a.EndowInsEMPPlus,a.MedicalInsEMP,a.MedicalInsEMPPlus,a.UnemployInsEMP,a.UnemployInsEMPPlus,a.EndowInsGRP,a.EndowInsGRPPlus,
    a.MedicalInsGRP,a.MedicalInsGRPPlus,a.UnemployInsGRP,a.UnemployInsGRPPlus,a.MaternityInsGRP,a.MaternityInsGRPPlus,a.InjuryInsGRP,a.InjuryInsGRPPlus,
    a.InsEMPTotal,a.InsEMPPlusTotal,a.InsGRPTotal,a.InsGRPPlusTotal,a.Remark
    from pEMPInsurancePerMM_all a
    where a.pProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入后台员工公积金月度分配历史表pEMPHousingFundPerMM
    insert into pEMPHousingFundPerMM(pProcessID,Month,EID,BID,HousingFundEMP,HousingFundEMPPlus,HousingFundGRP,HousingFundGRPPlus,
    HousingFundEMPTotal,HousingFundEMPPlusTotal,HousingFundGRPTotal,HousingFundGRPPlusTotal,Remark)
    select a.pProcessID,a.Month,a.EID,a.BID,a.HousingFundEMP,a.HousingFundEMPPlus,a.HousingFundGRP,a.HousingFundGRPPlus,
    a.HousingFundEMPTotal,a.HousingFundEMPPlusTotal,a.HousingFundGRPTotal,a.HousingFundGRPPlusTotal,a.Remark
    from pEMPHousingFundPerMM_all a
    where a.pProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    
    -- 更新五险一金月度表项pEMPInsuranceHousingFund_Process
    Update a
    Set a.Closed=NULL,a.ClosedBy=NULL,a.ClosedTime=NULL
    From pEMPInsuranceHousingFund_Process a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除员工社保月度注册表
    delete from pEMPInsurancePerMM_all
    where pProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除员工公积金月度注册表
    delete from pEMPHousingFundPerMM_all
    where pProcessID=@ID
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