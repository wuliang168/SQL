USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPTrgtRspCntrMMHRSubmit]
-- skydatarefresh eSP_pEMPTrgtRspCntrMMHRSubmit
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 业务考核递交程序
*/
BEGIN

    -- 业务考核评语为空，无法递交！
    IF Exists(select 1 from pEMPTrgtRspCntrKPIMM a
    where a.ID=@ID and a.CommHR is NULL)
    Begin
        Set @RetVal=930550
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEMPTrgtRspCntrMM
    ---- 人力资源部业务考核递交
    update a
    set a.SubmitHR=1
    from pEMPTrgtRspCntrMM a
    where ISNULL(a.SubmitHR,0)=0 and ISNULL(a.SubmitRT,0)=1
    and a.ID=@ID
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