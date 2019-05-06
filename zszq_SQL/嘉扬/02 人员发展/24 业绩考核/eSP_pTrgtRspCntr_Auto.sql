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
-- 业务考核(季度)自动执行程序
*/
Begin

    -- 定义pTrgtRspCntr_Process的ID
    declare @ID int

    Begin TRANSACTION

    -- 新建业绩考核(季度)进程 pTrgtRspCntr_Process
    insert into pTrgtRspCntr_Process(TRCMonth)
    values (GETDATE())
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 赋值@ID
    set @ID=(select ID from pTrgtRspCntr_Process where ISNULL(Submit,0)=0 and ISNULL(Closed,0)=0)

    -- 执行开启业绩考核(季度)
    exec eSP_pTrgtRspCntr_ProcessStart @ID,1
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