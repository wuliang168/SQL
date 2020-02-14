USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pEpidemicSuitationLoc_EMPAdd]
    @EID int,
    @BID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 疫情现场办公新增员工
*/
Begin

    -- 员工已存在，请勿重复递交！
    IF Exists(select 1 from pEpidemicSuitationLoc a
    where ISNULL(BID,EID)=ISNULL(@BID,@EID))
    Begin
        Set @RetVal=209702
        Return @RetVal
    End

    Begin TRANSACTION

    -------- pEpidemicSuitationLoc --------
    -- 新增员工
    insert into pEpidemicSuitationLoc(EID,BID,Name,Type,CertNoR6,CompID,DepID,DepID1st,DepID2nd)
    select @EID,@BID,(select Name from pVW_employee where ISNULL(BID,EID)=ISNULL(@BID,@EID)),
    1,(select RIGHT(Identification,6) from pVW_employee where ISNULL(BID,EID)=ISNULL(@BID,@EID)),
    (select CompID from pVW_employee where ISNULL(BID,EID)=ISNULL(@BID,@EID)),
    (select DepID from pVW_employee where ISNULL(BID,EID)=ISNULL(@BID,@EID)),
    (select dbo.eFN_getdepid1st(DepID) from pVW_employee where ISNULL(BID,EID)=ISNULL(@BID,@EID)),
    (select dbo.eFN_getdepid2nd(DepID) from pVW_employee where ISNULL(BID,EID)=ISNULL(@BID,@EID))
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -- 正常处理流程
    COMMIT TRANSACTION
    Set @RetVal=0
    Return @RetVal

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    If isnull(@RetVal,0)=0
        Set @RetVal=-1
    Return @RetVal
end