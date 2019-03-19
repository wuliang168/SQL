USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepSalaryPerMonthClose]
-- skydatarefresh eSP_pDepSalaryPerMonthClose
    @id int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门月度工资关闭
-- @id为ID信息，表示部门月度工资开启对应的ID
*/
Begin

    -- 部门月度工资流程已关闭！
    If Exists(Select 1 From pDepSalaryPerMonth a Where a.ID=@id and a.IsSubmit is not NULL)
    Begin
        Set @RetVal = 930095
        Return @RetVal
    End

    -- 月度工资流程已关闭!
    If Exists(Select 1 From pDepSalaryPerMonth a,pSalaryPerMonth b
    Where a.ID=@id and a.Date=b.Date and ISNULL(b.Closed,0)=1)
    Begin
        Set @RetVal = 930093
        Return @RetVal
    End


    Begin TRANSACTION


    -- 更新月度工资流程表项pDepSalaryPerMonth
    update a
    set a.IsSubmit=1
    from pDepSalaryPerMonth a
    where a.ID=@id
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