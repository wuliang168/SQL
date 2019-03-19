USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pYearMDSalaryModifyBack]
-- skydatarefresh eSP_pYearMDSalaryModifyBack
    @ID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级及薪酬调整的部门HR返回程序
*/
Begin

    -- 年度MD职级及薪酬调整流程未开启，无法开启!
    If Exists(Select 1 From pYear_MDSalaryModify_Process Where ID=@ID and Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 910170
        Return @RetVal
    End

    -- 年度MD职级及薪酬调整流程已关闭，无法开启！
    If Exists(Select 1 From pYear_MDSalaryModify_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 910130
        Return @RetVal
    End

    -- 部门负责人未完成MD职级及薪酬调整！
    If Exists(Select 1 From pYear_MDSalaryModifyDep where YEAR(Date)=YEAR((select Date from pYear_MDSalaryModify_Process Where ID=@ID))
    And Isnull(IsDepSubmit,0)=0 and ISNULL(IsClosed,0)=0)
    Begin
        Set @RetVal = 930046
        Return @RetVal
    End
    

    Begin TRANSACTION

    -- 更新MD职级及薪酬调整表项pYear_MDSalaryModifyDep
    Update a
    Set a.IsHRSubmit=1
    From pYear_MDSalaryModifyDep a
    Where YEAR(a.Date)=YEAR((select Date from pYear_MDSalaryModify_Process Where ID=@ID))
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