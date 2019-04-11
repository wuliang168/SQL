USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pExpensesSummBSSubmit]
-- skydatarefresh eSP_pExpensesSummBSSubmit
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 费用统计递交(基于DepID的leftid)
-- @leftid为DepID信息，表示部门ID
*/
Begin

    Begin TRANSACTION

    -- 更新pExpensesSummDep
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pExpensesSummDep a 
    where ISNULL(a.DepID2nd,a.DepID1st)=@leftid and ISNULL(a.IsSubmit,0)=0 and ISNULL(a.IsClosed,0)=0


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