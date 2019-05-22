USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pTrgtRspCntr_Auto]
-- skydatarefresh eSP_pTrgtRspCntr_Auto
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 目标协议考核(月度)自动执行程序
*/
Begin

    -- 定义pTrgtRspCntr_Process的ID
    declare @ID int

    Begin TRANSACTION

    -- 关闭上个月度目标协议考核流程
    ---- 如果存在上个月未关闭的月度目标协议考核流程
    IF Exists(select 1 from pTrgtRspCntr_Process where ISNULL(Submit,0)=1 and ISNULL(Closed,0)=0)
    Begin
        set @ID=(select ID from pTrgtRspCntr_Process where ISNULL(Submit,0)=1 and ISNULL(Closed,0)=0)
        -- 执行关闭业绩考核
        exec eSP_pTrgtRspCntr_ProcessClose @ID,1
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    End

    -- 开启本月度目标协议考核流程
    -- 如果存在业绩员工满三个月或者剩余最后一个月
    IF Exists (select 1 from pEMPTrgtRspCntr 
    where DATEDIFF(mm,DATEADD(dd,1,TRCBeginDate),GETDATE())%3=0 or DATEDIFF(MM,GETDATE(),TRCEndDate)=0)
    Begin
        IF not Exists(select 1 from pTrgtRspCntr_Process where DATEDIFF(mm,TRCMonth,GETDATE())=0)
        Begin
            -- 新建业绩考核(季度)进程 pTrgtRspCntr_Process
            insert into pTrgtRspCntr_Process(TRCMonth)
            values (GETDATE())
            -- 异常流程
            If @@Error<>0
            Goto ErrM
        End

        -- 赋值@ID
        set @ID=(select ID from pTrgtRspCntr_Process where DATEDIFF(MM,TRCMonth,GETDATE())=0 and ISNULL(Submit,0)=0 and ISNULL(Closed,0)=0)

        -- 执行开启业绩考核
        exec eSP_pTrgtRspCntr_ProcessStart @ID,1
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    End


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