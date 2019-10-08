USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pTrgtRspCntr_ProcessClose]
-- skydatarefresh eSP_pTrgtRspCntr_ProcessClose
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

    -- 本月度业绩考核未开启，无需关闭！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id and isnull(Submit,0)=0)
    Begin
        Set @RetVal=930570
        Return @RetVal
    End

    -- 本月度业绩考核已关闭，无法重新关闭！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal=930580
        Return @RetVal
    end

    Begin TRANSACTION

    -- 更新pTrgtRspCntr_Process
    update a
    set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    from pTrgtRspCntr_Process a
    where ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度业务考核部门表项pTrgtRspCntrDep
    update a
    set a.IsClosed=1
    from pTrgtRspCntrDep a,pTrgtRspCntr_Process b
    where b.ID=@ID and a.ProcessID=b.ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pEMPTrgtRspCntrMM中的IsCont标记位
    ---- IsCont表示归档，后续该员工对应的绩效协议将不再考核
    update a
    set a.IsCont=1
    from pEMPTrgtRspCntr a,pEMPTrgtRspCntrMM b
    where a.EID=b.EID and a.KPIID=b.KPIID and ISNULL(b.IsCont,0)=1
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加至月度业务考核员工表项pEMPTrgtRspCntrMM_all
    insert into pEMPTrgtRspCntrMM_all(ProcessID,EID,CompID,DepID1st,DepID2nd,JobID,TRCBeginDate,TRCEndDate,KPIID,
    SubmitSelf,DateSelf,PT,SubmitPT,DatePT,RT,SubmitRT,DateRT,HR,SubmitHR,RRT,SubmitRRT,DateRRT,RHR,IsCont,
    CommPT,CommRT,CommHR,CommRRT,CommRHR,Remark)
    select a.ProcessID,a.EID,a.CompID,a.DepID1st,a.DepID2nd,a.JobID,a.TRCBeginDate,a.TRCEndDate,a.KPIID,
    a.SubmitSelf,a.DateSelf,a.PT,a.SubmitPT,a.DatePT,a.RT,a.SubmitRT,a.DateRT,a.HR,a.SubmitHR,a.RRT,a.SubmitRRT,a.DateRRT,a.RHR,a.IsCont,
    a.CommPT,a.CommRT,a.CommHR,a.CommRRT,a.CommRHR,a.Remark
    from pEMPTrgtRspCntrMM a,pTrgtRspCntr_Process b
    where b.ID=@ID and a.ProcessID=b.ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加至月度业务考核员工KPI历史表项pEMPTrgtRspCntrKPIMM_all
    insert into pEMPTrgtRspCntrKPIMM_all(ProcessID,EID,KPIID,TRCKPI,TRCWeight,TRCTarget,
    TRCActualTarget,TRCTargetValue,TRCActualValue,TRCAchRate,Remark)
    select a.ProcessID,a.EID,a.KPIID,a.TRCKPI,a.TRCWeight,a.TRCTarget,a.TRCActualTarget,
    a.TRCTargetValue,a.TRCActualValue,a.TRCAchRate,a.Remark
    from pEMPTrgtRspCntrKPIMM a,pTrgtRspCntr_Process b
    where b.ID=@ID and a.ProcessID=b.ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pEMPTrgtRspCntrMM
    delete from pEMPTrgtRspCntrMM
    where ProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pEMPTrgtRspCntrKPIMM
    delete from pEMPTrgtRspCntrKPIMM
    where ProcessID=@ID
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