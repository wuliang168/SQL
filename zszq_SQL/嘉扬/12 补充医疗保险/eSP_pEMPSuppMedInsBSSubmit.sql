USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pEMPSuppMedInsBSSubmit]
    @ID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 补充医疗保险子女确认递交
*/
Begin

    Begin TRANSACTION

    -- 备份补充医疗保险递交记录
    insert into pEMPSuppMedIns_all(EID,IsSuppMedIns,SMIDebitCard,SMIType,SMICertID,SMINo,IsConfirm,ConfirmTime,Remark)
    select a.EID,a.IsSuppMedIns,a.SMIDebitCard,a.SMIType,a.SMICertID,a.SMINo,1,GETDATE(),a.Remark
    from pEMPSuppMedIns a
    where a.ID=@ID and a.IsConfirm is NULL
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pEMPSuppMedIns --------
    update a
    set a.IsConfirm=1,a.ConfirmTime=GETDATE()
    from pEMPSuppMedIns a
    where a.ID=@ID
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