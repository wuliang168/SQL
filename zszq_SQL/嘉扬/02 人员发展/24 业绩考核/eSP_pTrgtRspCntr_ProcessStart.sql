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

    -- 上月度业绩考核未关闭，无法再次开启
    if exists (select 1 from pTrgtRspCntr_Process where id=@id-1 and isnull(Closed,0)=0)
    Begin
        Set @RetVal=930530
        Return @RetVal
    End

    -- 本月度业绩考核已开启，无需重新开启！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id and isnull(Submit,0)=1)
    Begin
        Set @RetVal=930540
        Return @RetVal
    End

    -- 业绩考核月度日期为空，无法重新开启！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id and TRCMonth is NULL)
    Begin
        Set @RetVal=930550
        Return @RetVal
    end

    -- 本月度业绩考核已封帐，无法重新开启！
    if exists (select 1 from pTrgtRspCntr_Process where id=@id and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal=930560
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
    insert into pTrgtRspCntrDep(TRCMonth,CompID,DepID1st,DepID2nd,TRCLev,ReportTo)
    select b.TRCMonth,a.CompID,a.DepID1st,a.DepID2nd,a.TRCLev,a.ReportTo
    from pVW_TrgtRspCntrReportTo a,pTrgtRspCntr_Process b
    where b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加至月度业务考核员工表项pEMPTrgtRspCntrMM
    insert into pEMPTrgtRspCntrMM(TRCMonth,EID,CompID,DepID1st,DepID2nd,JobID,TRCBeginDate,TRCEndDate,KPIID)
    select b.TRCMonth,a.EID,a.CompID,a.DepID1st,a.DepID2nd,a.JobID,a.TRCBeginDate,a.TRCEndDate,a.KPIID
    from pEMPTrgtRspCntr a,pTrgtRspCntr_Process b
    where b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加至月度业务考核员工KPI表项pEMPTrgtRspCntrKPIMM
    insert into pEMPTrgtRspCntrKPIMM(TRCMonth,EID,KPIID,TRCKPI,TRCWeight,TRCTargetValue)
    select b.TRCMonth,a.EID,a.KPIID,a.TRCKPI,a.TRCWeight,a.TRCTargetValue
    from pEMPTrgtRspCntr_KPI a,pTrgtRspCntr_Process b
    where b.ID=@ID
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