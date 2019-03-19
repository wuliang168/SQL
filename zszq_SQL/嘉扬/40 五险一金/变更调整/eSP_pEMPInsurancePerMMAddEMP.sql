USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPInsurancePerMMAddEMP]
-- skydatarefresh eSP_pEMPInsurancePerMMAddEMP
    @EID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 添加员工(社会保险)(基于员工的EID)
-- @EID为EID信息，表示员工的EID
*/
Begin

    -- 员工已存在，无法新增该员工!
    If Exists(Select 1 From pEMPInsurancePerMM Where EID=@EID)
    Begin
        Set @RetVal = 930390
        Return @RetVal
    End


    Begin TRANSACTION

    -- 添加pEMPInsurancePerMM
    insert into pEMPInsurancePerMM(Month,EID,EndowInsEMP,MedicalInsEMP,UnemployInsEMP,EndowInsGRP,MedicalInsGRP,UnemployInsGRP,MaternityInsGRP,InjuryInsGRP,
    InsEMPTotal,InsGRPTotal)
    select a.Date,b.EID,b.EndowInsEMP,b.MedicalInsEMP,b.UnemployInsEMP,b.EndowInsGRP,b.MedicalInsGRP,b.UnemployInsGRP,b.MaternityInsGRP,b.InjuryInsGRP,
    b.MedicalInsEMP+b.UnemployInsEMP+b.EndowInsEMP,b.EndowInsGRP+b.MedicalInsGRP+b.UnemployInsGRP+b.MaternityInsGRP+b.InjuryInsGRP
    from pEMPInsuranceHousingFund_Process a,pVW_EMPInsuranceDetails b
    where ISNULL(a.Submit,0)=1 and ISNULL(a.Closed,0)=0 and b.EID=@EID
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