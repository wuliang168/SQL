USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pTrgtRspCntr_ProcessStart]
-- skydatarefresh eSP_pTrgtRspCntr_ProcessStart
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 业务考核员工添加程序
-- @ID 为后备人才流程对应ID
-- @URID为
*/
Begin

    -- 上季度业绩考核未关闭，无法再次开启！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id-1 and isnull(Closed,0)=0)
    Begin
        Set @RetVal=930560
        Return @RetVal
    End

    -- 本季度业绩考核已开启，无需重新开启！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id and isnull(Submit,0)=1)
    Begin
        Set @RetVal=930570
        Return @RetVal
    End

    -- 本季度业绩考核月度日期为空，无法重新开启！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id and TRCMonth is NULL)
    Begin
        Set @RetVal=930580
        Return @RetVal
    end

    -- 本季度业绩考核已封帐，无法重新开启！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal=930590
        Return @RetVal
    end

    Begin TRANSACTION

    -- 更新pTrgtRspCntr_Process
    update a
    set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    from pTrgtRspCntr_Process a
    where ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加至月度业务考核部门表项pTrgtRspCntrDep
    ---- 被考核人
    insert into pTrgtRspCntrDep(TRCMonth,CompID,DepID1st,DepID2nd,ReportTo,TRCLev)
    select b.TRCMonth,a.CompID,a.DepID1st,a.DepID2nd,a.EID,1
    from pEMPTrgtRspCntr a,pTrgtRspCntr_Process b
    where b.ID=@ID
    and (select COUNT(ID) from pEMPTrgtRspCntr_KPI where KPIID=a.KPIID and ISNULL(TRCAchRate,0)<1)>0
    and ((DATEDIFF(mm,DATEADD(dd,1,a.TRCBeginDate),b.TRCMonth)%3=0 and DATEDIFF(mm,DATEADD(dd,1,a.TRCBeginDate),b.TRCMonth)<>0) or DATEDIFF(MM,b.TRCMonth,a.TRCEndDate)=0)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 考核人 提交建议
    insert into pTrgtRspCntrDep(TRCMonth,CompID,DepID1st,DepID2nd,ReportTo,TRCLev)
    select distinct b.TRCMonth,(select CompID from eEmployee where EID=a.ReportTo),(select dbo.eFN_getdepid1st(DepID) from eEmployee where EID=a.ReportTo),
    (select dbo.eFN_getdepid2nd(DepID) from eEmployee where EID=a.ReportTo),a.ReportTo,2
    from pVW_TrgtRspCntrDep a,pTrgtRspCntr_Process b,pEMPTrgtRspCntr c
    where b.ID=@ID and ISNULL(a.DepID2nd,a.DepID1st)=ISNULL(c.DepID2nd,c.DepID1st)
    and (select COUNT(ID) from pEMPTrgtRspCntr_KPI where KPIID=c.KPIID and ISNULL(TRCAchRate,0)<1)>0
    and ((DATEDIFF(mm,DATEADD(dd,1,c.TRCBeginDate),b.TRCMonth)%3=0 and DATEDIFF(mm,DATEADD(dd,1,c.TRCBeginDate),b.TRCMonth)<>0) or DATEDIFF(MM,b.TRCMonth,c.TRCEndDate)=0)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 考核人 提交反馈
    insert into pTrgtRspCntrDep(TRCMonth,CompID,DepID1st,DepID2nd,ReportTo,TRCLev)
    select distinct b.TRCMonth,(select CompID from eEmployee where EID=a.ReportTo),(select dbo.eFN_getdepid1st(DepID) from eEmployee where EID=a.ReportTo),
    (select dbo.eFN_getdepid2nd(DepID) from eEmployee where EID=a.ReportTo),a.ReportTo,3
    from pVW_TrgtRspCntrDep a,pTrgtRspCntr_Process b,pEMPTrgtRspCntr c
    where b.ID=@ID and ISNULL(a.DepID2nd,a.DepID1st)=ISNULL(c.DepID2nd,c.DepID1st)
    and (select COUNT(ID) from pEMPTrgtRspCntr_KPI where KPIID=c.KPIID and ISNULL(TRCAchRate,0)<1)>0
    and ((DATEDIFF(mm,DATEADD(dd,1,c.TRCBeginDate),b.TRCMonth)%3=0 and DATEDIFF(mm,DATEADD(dd,1,c.TRCBeginDate),b.TRCMonth)<>0) or DATEDIFF(MM,b.TRCMonth,c.TRCEndDate)=0)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 被考核人
    -- 添加至月度业务考核员工表项pEMPTrgtRspCntrMM
    insert into pEMPTrgtRspCntrMM(TRCMonth,EID,CompID,DepID1st,DepID2nd,JobID,TRCBeginDate,TRCEndDate,KPIID)
    select a.TRCMonth,b.EID,b.CompID,b.DepID1st,b.DepID2nd,b.JobID,b.TRCBeginDate,b.TRCEndDate,b.KPIID
    from pTrgtRspCntr_Process a,pEMPTrgtRspCntr b
    where a.ID=@ID 
    and ((DATEDIFF(mm,DATEADD(dd,1,b.TRCBeginDate),a.TRCMonth)%3=0 and DATEDIFF(mm,DATEADD(dd,1,b.TRCBeginDate),a.TRCMonth)<>0) or DATEDIFF(MM,a.TRCMonth,b.TRCEndDate)=0)
    and exists (select 1 from pEMPTrgtRspCntr_KPI where KPIID=b.KPIID and ISNULL(TRCAchRate,0)<1)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加至月度业务考核员工KPI表项pEMPTrgtRspCntrKPIMM
    insert into pEMPTrgtRspCntrKPIMM(TRCMonth,EID,KPIID,TRCKPI,TRCWeight,TRCTargetValue,TRCTarget)
    select distinct b.TRCMonth,a.EID,a.KPIID,a.TRCKPI,a.TRCWeight,a.TRCTargetValue,TRCTarget
    from pEMPTrgtRspCntr_KPI a,pTrgtRspCntr_Process b,pEMPTrgtRspCntr c
    where b.ID=@ID and ISNULL(a.TRCAchRate,0)<1 and a.KPIID=c.KPIID
    and ((DATEDIFF(mm,DATEADD(dd,1,c.TRCBeginDate),b.TRCMonth)%3=0 and DATEDIFF(mm,DATEADD(dd,1,c.TRCBeginDate),b.TRCMonth)<>0) or DATEDIFF(MM,b.TRCMonth,c.TRCEndDate)=0)
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