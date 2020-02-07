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
    @ReportTo,1,
    (case 
    -- 不存在
    when ISNULL(@BID,@EID) not in (select ISNULL(BID,EID) from pEpidemicSuitation where ESDate is not NULL and ISNULL(BID,EID) is not NULL) then GETDATE() 
    -- 今天未添加
    when ISNULL(@BID,@EID) not in (select ISNULL(BID,EID) from pEpidemicSuitation where DATEDIFF(dd,ESDATE,GETDATE())=0 and ISNULL(BID,EID) is not NULL) then GETDATE() 
    -- 今天存在 ，且第一大的日期比第二大的日期+1天还大
    when ISNULL(@BID,@EID) in (select ISNULL(BID,EID) from pEpidemicSuitation where DATEDIFF(dd,ESDATE,GETDATE())=0 and ISNULL(BID,EID) is not NULL) 
        and (select MAX(ESDATE) from pEpidemicSuitation where ISNULL(BID,EID)=ISNULL(@BID,@EID))
            >DATEADD(dd,1,(select ESDATE from pEpidemicSuitation a,(select ROW_NUMBER() over (order by ESDATE desc) as num,ID from pEpidemicSuitation where ISNULL(@BID,@EID)=ISNULL(BID,EID)) b where a.ID=b.ID and b.num=2)) 
        then DATEADD(dd,1,(select ESDATE from pEpidemicSuitation a,(select ROW_NUMBER() over (order by ESDATE desc) as num,ID from pEpidemicSuitation where ISNULL(@BID,@EID)=ISNULL(BID,EID)) b where a.ID=b.ID and b.num=2))
    -- 今天存在，且第一大的日期等于第二大的日期+1，或者小
    else DATEADD(dd,1,(select MAX(ESDATE) from pEpidemicSuitation where ISNULL(BID,EID)=ISNULL(@BID,@EID))) end)
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