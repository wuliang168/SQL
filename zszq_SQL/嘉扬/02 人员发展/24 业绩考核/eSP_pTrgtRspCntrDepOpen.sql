USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pTrgtRspCntrDepOpen]
-- skydatarefresh eSP_pTrgtRspCntrDepOpen
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 业绩考核季度部门统计重新开启程序
-- @ID 为部门费用统计对应ID
*/
Begin


    Begin TRANSACTION

    -- 更新部门费用统计状态
    Update a
    Set a.IsClosed=NULL,a.IsSubmit=NULL
    From pTrgtRspCntrDep a
    Where a.ID=@ID
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