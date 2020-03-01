USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pEMPSuppMedInsAddChildBS]
    @ID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 补充医疗保险新增子女
*/
Begin

    -- 申明及定义已参保子女个数
    declare @ChildNopSMI int
    set @ChildNopSMI=(select COUNT(SMICertID) from pEMPSuppMedIns where EID=(select EID from ebg_family where ID=@ID) and SMIType=1)

    -- 子女参保超过1人，无法确认递交！
    IF (@ChildNopSMI>0)
    Begin
        Set @RetVal=1004040
        Return @RetVal
    End

    -- 子女参保身份证错误，无法确认递交！
    IF Exists(select 1 from ebg_family where ID=@ID and dbo.eFN_CID18CheckSum(CERTID)<>CERTID and LEN(CERTID)=18)
    Begin
        Set @RetVal=1004080
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pEMPSuppMedIns --------
    -- 新增子女
    insert into pEMPSuppMedIns(EID,SMIType,SMICertID,SMINo,IsSuppMedIns)
    select a.EID,1,a.CERTID,@ChildNopSMI+1,1
    from ebg_family a
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