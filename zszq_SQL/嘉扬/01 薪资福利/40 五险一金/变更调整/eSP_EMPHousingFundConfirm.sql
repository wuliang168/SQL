USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_EMPHousingFundConfirm]
-- skydatarefresh eSP_EMPHousingFundConfirm
    @ID int, 
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 员工变更确认(社会保险)(基于员工的ID)
-- @ID为ID信息，表示员工的EID或者BID
*/
Begin

    -- 员工五险一金的公积金基数为空！
    If Exists(Select 1 From pEMPHousingFund_register Where ID=@ID and EMPHousingFundBase is NULL)
    Begin
        Set @RetVal = 930121
        Return @RetVal
    End

    -- 员工五险一金的公积金发放地为空！
    If Exists(Select 1 From pEMPHousingFund_register Where ID=@ID and EMPHousingFundLoc is NULL)
    Begin
        Set @RetVal = 930122
        Return @RetVal
    End


    Begin TRANSACTION

    -- 添加pEMPHousingFund_register
    update a
    set a.EMPHousingFundBase=ISNULL(b.EMPHousingFundBase,a.EMPHousingFundBase),a.EMPHousingFundDate=ISNULL(b.EMPHousingFundDate,a.EMPHousingFundDate),
    a.EMPHousingFundLoc=ISNULL(b.EMPHousingFundLoc,a.EMPHousingFundLoc),a.IsPostRetirement=ISNULL(b.IsPostRetirement,a.IsPostRetirement),
    a.IsLeave=ISNULL(b.IsLeave,a.IsLeave),a.Isabandon=ISNULL(b.Isabandon,a.Isabandon)
    from pEMPHousingFund a,pEMPHousingFund_register b
    where b.ID=@ID and ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 拷贝到pEMPHousingFund_all
    insert into pEMPHousingFund_all(EID,BID,EMPHousingFundBase,EMPHousingFundDate,EMPHousingFundLoc,EMPHousingFundDepart,IsPostRetirement,IsLeave,Isabandon)
    select a.EID,a.BID,a.EMPHousingFundBase,a.EMPHousingFundDate,a.EMPHousingFundLoc,a.EMPHousingFundDepart,a.IsPostRetirement,a.IsLeave,a.Isabandon
    from pEMPHousingFund_register a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pEMPHousingFund_register
    delete from pEMPHousingFund_register where ID=@ID
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