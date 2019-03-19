USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPHousingFundPerMMAddEMP]
-- skydatarefresh eSP_pEMPHousingFundPerMMAddEMP
    @EID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 添加员工(公积金)(基于员工的EID)
-- @EID为EID信息，表示员工的EID
*/
Begin

    -- 员工已存在，无法新增该员工!
    If Exists(Select 1 From pEMPHousingFundPerMM Where EID=@EID)
    Begin
        Set @RetVal = 930390
        Return @RetVal
    End


    Begin TRANSACTION

    -- 添加pEMPHousingFundPerMM
    insert into pEMPHousingFundPerMM(Month,EID,HousingFundEMP,HousingFundGRP,HousingFundEMPTotal,HousingFundGRPTotal)
    select a.Date,b.EID,b.HousingFundEMP,b.HousingFundGRP,b.HousingFundEMP,b.HousingFundGRP
    from pEMPInsuranceHousingFund_Process a,pVW_EMPHousingFundDetails b
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