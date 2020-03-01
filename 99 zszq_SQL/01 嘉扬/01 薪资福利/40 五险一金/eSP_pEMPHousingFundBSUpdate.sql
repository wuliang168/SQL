USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPHousingFundBSUpdate]
-- skydatarefresh eSP_pEMPHousingFundBSUpdate
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 员工公积金更新程序
-- @EID 为员工对应EID
*/
Begin
    
    -- 员工公积金基数为空或者0，无法递交!
    --If Exists(Select 1 From pEMPHousingFund Where EID=@EID And Isnull(EMPHousingFundBase,0)=0)
    --Begin
    --    Set @RetVal = 946030
    --    Return @RetVal
    --End

    -- 员工公积金缴纳地为空，无法递交!
    If Exists(Select 1 From pEMPHousingFund Where ID=@ID And HFRatioLocID is NULL)
    Begin
        Set @RetVal = 946040
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新员工月度公积金表项pEMPHousingFundPerMM
    Update a
    Set a.HousingFundEMP=b.HousingFundEMP,a.HousingFundGRP=b.HousingFundGRP,a.HousingFundEMPTotal=b.HousingFundEMP,a.HousingFundGRPTotal=b.HousingFundGRP
    From pEMPHousingFundPerMM a,pVW_EMPHousingFundDetails b
    Where ISNULL(a.EID,a.BID)=(select ISNULL(EID,BID) from pEMPHousingFund where ID=@ID) and ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 月度表单中未出现员工，更新后自动添加
    insert into pEMPHousingFundPerMM(pProcessID,Month,EID,BID,HousingFundEMP,HousingFundGRP,HousingFundEMPTotal,HousingFundGRPTotal)
    select a.ID,a.Date,b.EID,b.BID,b.HousingFundEMP,b.HousingFundGRP,b.HousingFundEMP,b.HousingFundGRP
    from pEMPInsuranceHousingFund_Process a,pVW_EMPHousingFundDetails b
    where ISNULL(a.Submit,0)=1 and ISNULL(a.Closed,0)=0 and ISNULL(b.EID,b.BID)=(select ISNULL(EID,BID) from pEMPHousingFund where ID=@ID)
    and ISNULL(b.EID,b.BID) not in (select ISNULL(EID,BID) from pEMPHousingFundPerMM where pProcessID=a.ID)
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