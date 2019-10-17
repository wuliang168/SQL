USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPInsuranceHousingFundStart]
-- skydatarefresh eSP_pEMPInsuranceHousingFundStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 五险一金分配月度开启程序
-- @ID 为五险一金分配月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
    
    -- 月度五险一金分配已开启!
    If Exists(Select 1 From pEMPInsuranceHousingFund_Process Where ID=@ID And Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930410
        Return @RetVal
    End

    -- 月度五险一金分配未选择月份!
    If Exists(Select 1 From pEMPInsuranceHousingFund_Process Where ID=@ID And Date is NULL)
    Begin
        Set @RetVal = 930420
        Return @RetVal
    End

    -- 上月度五险一金分配未关闭!
    If Exists(Select 1 From pEMPInsuranceHousingFund_Process Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930430
        Return @RetVal
    End


    Begin TRANSACTION


    -- 插入部门年金月度表项pEMPInsuranceHousingFundDep
    insert into pEMPInsuranceHousingFundDep(pProcessID,Month,DepID1st,DepID2nd,DepInsHFContact)
    select a.ID,a.Date,b.DepID1st,b.DepID2nd,b.DepInsHFContact
    from pEMPInsuranceHousingFund_Process a,pVW_DepInsHFContact b
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入后台员工社保月度分配注册表pEMPInsurancePerMM
    insert into pEMPInsurancePerMM(pProcessID,Month,EID,BID,EndowInsEMP,MedicalInsEMP,UnemployInsEMP,EndowInsGRP,MedicalInsGRP,UnemployInsGRP,MaternityInsGRP,InjuryInsGRP,
    InsEMPTotal,InsGRPTotal)
    select a.ID,a.Date,b.EID,b.BID,b.EndowInsEMP,b.MedicalInsEMP,b.UnemployInsEMP,b.EndowInsGRP,b.MedicalInsGRP,b.UnemployInsGRP,b.MaternityInsGRP,b.InjuryInsGRP,
    b.MedicalInsEMP+b.UnemployInsEMP+b.EndowInsEMP,b.EndowInsGRP+b.MedicalInsGRP+b.UnemployInsGRP+b.MaternityInsGRP+b.InjuryInsGRP
    from pEMPInsuranceHousingFund_Process a,pVW_EMPInsuranceDetails b
    where a.ID=@ID and b.Status not in (4,5)
    and ISNULL(b.EID,b.BID) not in (select ISNULL(EID,BID) from pEMPInsurancePerMM)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入后台员工公积金月度分配注册表pEMPHousingFundPerMM
    insert into pEMPHousingFundPerMM(pProcessID,Month,EID,BID,HousingFundEMP,HousingFundGRP,HousingFundEMPTotal,HousingFundGRPTotal)
    select a.ID,a.Date,b.EID,b.BID,b.HousingFundEMP,b.HousingFundGRP,b.HousingFundEMP,b.HousingFundGRP
    from pEMPInsuranceHousingFund_Process a,pVW_EMPHousingFundDetails b
    where a.ID=@ID and b.Status not in (4,5)
    and ISNULL(b.EID,b.BID) not in (select ISNULL(EID,BID) from pEMPHousingFundPerMM)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    
    -- 更新五险一金月度表项pEMPInsuranceHousingFund_Process
    Update a
    Set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    From pEMPInsuranceHousingFund_Process a
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