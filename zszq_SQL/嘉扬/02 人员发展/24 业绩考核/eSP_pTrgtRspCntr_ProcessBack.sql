USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_pTrgtRspCntr_ProcessBack]
-- skydatarefresh eSP_pTrgtRspCntr_ProcessBack
    @ID int,
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

    -- 本季度业绩考核未关闭，无法重新关闭！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id and ISNULL(Closed,0)=0)
    Begin
        Set @RetVal=930585
        Return @RetVal
    end

    Begin TRANSACTION

    -- 更新pTrgtRspCntr_Process
    update a
    set a.Closed=NULL,a.ClosedBy=NULL,a.ClosedTime=NULL
    from pTrgtRspCntr_Process a
    where ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度业务考核部门表项pTrgtRspCntrDep
    update a
    set a.IsClosed=NULL
    from pTrgtRspCntrDep a
    where a.ProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 添加至月度业务考核员工表项pEMPTrgtRspCntrMM
    insert into pEMPTrgtRspCntrMM(ProcessID,EID,CompID,DepID1st,DepID2nd,JobID,TRCBeginDate,TRCEndDate,KPIID,
    SubmitSelf,DateSelf,PT,SubmitPT,DatePT,RT,SubmitRT,DateRT,HR,SubmitHR,RRT,SubmitRRT,DateRRT,RHR,IsCont,
    CommPT,CommRT,CommHR,CommRRT,CommRHR,Remark)
    select a.ProcessID,a.EID,a.CompID,a.DepID1st,a.DepID2nd,a.JobID,a.TRCBeginDate,a.TRCEndDate,a.KPIID,
    a.SubmitSelf,a.DateSelf,a.PT,a.SubmitPT,a.DatePT,a.RT,a.SubmitRT,a.DateRT,a.HR,a.SubmitHR,a.RRT,a.SubmitRRT,a.DateRRT,a.RHR,a.IsCont,
    a.CommPT,a.CommRT,a.CommHR,a.CommRRT,a.CommRHR,a.Remark
    from pEMPTrgtRspCntrMM_all a
    where a.ProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加至月度业务考核员工KPI历史表项pEMPTrgtRspCntrKPIMM
    insert into pEMPTrgtRspCntrKPIMM(ProcessID,EID,KPIID,TRCKPI,TRCWeight,TRCTarget,
    TRCActualTarget,TRCTargetValue,TRCActualValue,TRCAchRate,Remark)
    select a.ProcessID,a.EID,a.KPIID,a.TRCKPI,a.TRCWeight,a.TRCTarget,a.TRCActualTarget,
    a.TRCTargetValue,a.TRCActualValue,a.TRCAchRate,a.Remark
    from pEMPTrgtRspCntrKPIMM_all a
    where a.ProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pEMPTrgtRspCntrMM
    delete from pEMPTrgtRspCntrMM_all
    where ProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pEMPTrgtRspCntrKPIMM
    delete from pEMPTrgtRspCntrKPIMM_all
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