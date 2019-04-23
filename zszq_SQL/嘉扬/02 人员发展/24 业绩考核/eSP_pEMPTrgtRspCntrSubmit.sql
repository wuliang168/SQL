USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPTrgtRspCntrSubmit]
-- skydatarefresh eSP_pEMPTrgtRspCntrSubmit
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

    -- 业务考核目标任务起始结束日期为空，无法递交！
    IF Exists(select 1 from pEMPTrgtRspCntr_register where ID=@ID
    and (TRCBeginDate is NULL or TRCEndDate is NULL))
    Begin
        Set @RetVal=930510
        Return @RetVal
    End

    -- 业务考核目标任务起始结束日期错误，无法递交！
    IF Exists(select 1 from pEMPTrgtRspCntr_register where ID=@ID
    and DATEDIFF(dd,TRCBeginDate,TRCEndDate)<0)
    Begin
        Set @RetVal=930515
        Return @RetVal
    End

    -- 业务考核目标任务考核内容为空，无法递交！
    ---- 无业务考核目标任务
    IF (select COUNT(ID) from pEMPTrgtRspCntr_KPI where KPIID=(select KPIID from pEMPTrgtRspCntr_register where ID=@ID))=0
    Begin
        Set @RetVal=930520
        Return @RetVal
    End
    ---- 业务考核目标任务内容存在未填写
    IF Exists(select 1 from pEMPTrgtRspCntr_KPI where KPIID=(select KPIID from pEMPTrgtRspCntr_register where ID=@ID)
    and (TRCKPI is NULL or TRCWeight is NULL or TRCTarget is NULL))
    Begin
        Set @RetVal=930520
        Return @RetVal
    End

    Begin TRANSACTION

    -- 更新pEMPTrgtRspCntr_register
    update a
    set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    from pEMPTrgtRspCntr_register a
    where ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加至业务考核新员工项pEMPTrgtRspCntr
    insert into pEMPTrgtRspCntr(EID,CompID,DepID1st,DepID2nd,JobID,TRCBeginDate,TRCEndDate,KPIID,Remark)
    select a.EID,a.CompID,a.DepID1st,a.DepID2nd,a.JobID,a.TRCBeginDate,a.TRCEndDate,a.KPIID,a.Remark
    from pEMPTrgtRspCntr_register a
    where ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加至业务考核新员工项pEMPTrgtRspCntr_all
    insert into pEMPTrgtRspCntr_all(EID,CompID,DepID1st,DepID2nd,JobID,TRCBeginDate,TRCEndDate,KPIID,Submit,SubmitBy,SubmitTime,Remark)
    select a.EID,a.CompID,a.DepID1st,a.DepID2nd,a.JobID,a.TRCBeginDate,a.TRCEndDate,a.KPIID,a.Submit,a.SubmitBy,a.SubmitTime,a.Remark
    from pEMPTrgtRspCntr_register a
    where ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pEMPTrgtRspCntr_register
    delete from pEMPTrgtRspCntr_register where ID=@ID


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