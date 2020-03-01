USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPInsuranceBSUpdate]
-- skydatarefresh eSP_pEMPInsuranceBSUpdate
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 员工社保更新程序
-- @EID 为员工对应EID
*/
Begin
    
    -- 员工社保基数为空或者0，无法递交!
    --If Exists(Select 1 From pEMPInsurance Where EID=@EID And Isnull(EMPInsuranceBase,0)=0)
    --Begin
    --    Set @RetVal = 946010
    --    Return @RetVal
    --End

    -- 员工社保缴纳地为空，无法递交!
    If Exists(Select 1 From pEMPInsurance Where ID=@ID And InsRatioLocID is NULL)
    Begin
        Set @RetVal = 946020
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新员工月度社保表项pEMPInsurancePerMM
    Update a
    Set a.EndowInsEMP=b.EndowInsEMP,a.MedicalInsEMP=b.MedicalInsEMP,a.UnemployInsEMP=b.UnemployInsEMP,
    a.EndowInsGRP=b.EndowInsGRP,a.MedicalInsGRP=b.MedicalInsGRP,a.UnemployInsGRP=b.UnemployInsGRP,a.MaternityInsGRP=b.MaternityInsGRP,a.InjuryInsGRP=b.InjuryInsGRP,
    a.InsEMPTotal=ISNULL(b.EndowInsEMP,0)+ISNULL(b.MedicalInsEMP,0)+ISNULL(b.UnemployInsEMP,0),
    a.InsGRPTotal=ISNULL(b.EndowInsGRP,0)+ISNULL(b.MedicalInsGRP,0)+ISNULL(b.UnemployInsGRP,0)+ISNULL(b.MaternityInsGRP,0)+ISNULL(b.InjuryInsGRP,0)
    From pEMPInsurancePerMM a,pVW_EMPInsuranceDetails b
    Where ISNULL(a.EID,a.BID)=(select ISNULL(EID,BID) from pEMPInsurance where ID=@ID) and ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 月度表单中未出现员工，更新后自动添加
    insert into pEMPInsurancePerMM(pProcessID,Month,EID,BID,EndowInsEMP,MedicalInsEMP,UnemployInsEMP,EndowInsGRP,MedicalInsGRP,UnemployInsGRP,MaternityInsGRP,InjuryInsGRP,
    InsEMPTotal,InsGRPTotal)
    select a.ID,a.Date,b.EID,b.BID,b.EndowInsEMP,b.MedicalInsEMP,b.UnemployInsEMP,b.EndowInsGRP,b.MedicalInsGRP,b.UnemployInsGRP,b.MaternityInsGRP,b.InjuryInsGRP,
    b.MedicalInsEMP+b.UnemployInsEMP+b.EndowInsEMP,b.EndowInsGRP+b.MedicalInsGRP+b.UnemployInsGRP+b.MaternityInsGRP+b.InjuryInsGRP
    from pEMPInsuranceHousingFund_Process a,pVW_EMPInsuranceDetails b
    where ISNULL(a.Submit,0)=1 and ISNULL(a.Closed,0)=0 and ISNULL(b.EID,b.BID)=(select ISNULL(EID,BID) from pEMPInsurance where ID=@ID)
    and ISNULL(b.EID,b.BID) not in (select ISNULL(EID,BID) from pEMPInsurancePerMM where pProcessID=a.ID)
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