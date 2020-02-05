USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pEpidemicSuitation_EMPAdd]
    @EID int,
    @BID int,
    @DepID int,
    @ReportTo int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 疫情现场办公新增员工
*/
Begin


    Begin TRANSACTION

    -------- pEpidemicSuitation --------
    -- 新增员工
    insert into pEpidemicSuitation(EID,BID,Name,CompID,DepID,DepID1st,DepID2nd,ReportTo,Location,ESDate)
    select @EID,@BID,(select Name from pVW_employee where ISNULL(BID,EID)=ISNULL(@BID,@EID)),
    dbo.eFN_getcompid(@DepID),@DepID,
    (select dbo.eFN_getdepid1st(DepID) from pVW_employee where ISNULL(BID,EID)=ISNULL(@BID,@EID)),
    (select dbo.eFN_getdepid2nd(DepID) from pVW_employee where ISNULL(BID,EID)=ISNULL(@BID,@EID)),
    @ReportTo,1,GETDATE()
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