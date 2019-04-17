USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPTrgtRspCntrAdd]
-- skydatarefresh eSP_pEMPTrgtRspCntrAdd
    @EID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 业务考核员工添加程序
-- @EID 为后备人才流程对应ID
*/
Begin

    Begin TRANSACTION

    -- 插入业务考核新员工注册表项pEMPTrgtRspCntr_register
    insert into pEMPTrgtRspCntr_register(EID,CompID,DepID1st,DepID2nd,JobID,KPIID)
    select a.EID,a.CompID,dbo.eFN_getdepid1st(a.DepID),dbo.eFN_getdepid2nd(a.DepID),a.JobID,Convert(varchar(5),EID)+Convert(varchar(8),GETDATE(),112)
    from eEmployee a
    where EID=@EID
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