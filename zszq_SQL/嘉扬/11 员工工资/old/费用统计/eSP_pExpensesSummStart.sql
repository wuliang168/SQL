USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pExpensesSummStart]
-- skydatarefresh eSP_pExpensesSummStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 费用统计流程开启程序
-- @ID 为费用统计流程月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin


    -- 费用统计流程中日期为空!
    If Exists(Select 1 From pExpensesSumm_Process Where ID=@ID and ISNULL(Date,0)=1)
    Begin
        Set @RetVal = 930210
        Return @RetVal
    End

    -- 费用统计流程已开启!
    If Exists(Select 1 From pExpensesSumm_Process Where ID=@ID and Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930220
        Return @RetVal
    End

    -- 费用统计流程已关闭!
    If Exists(Select 1 From pExpensesSumm_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930230
        Return @RetVal
    End

    -- 上次费用统计流程未关闭!
    If Exists(Select 1 From pExpensesSumm_Process Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930240
        Return @RetVal
    End


    Begin TRANSACTION

    -- 插入费用统计流程的部门费用统计流程表项pExpensesSummDep
    insert into pExpensesSummDep(Date,DepID1st,DepID2nd,SalaryContact)
    select b.Date,dbo.eFN_getdepid1st(a.DepID),dbo.eFN_getdepid2nd(a.DepID),a.DepSalaryContact
    from oDepartment a,pExpensesSumm_Process b
    where b.ID=@ID and a.DepType in (2,3) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999
    and a.DepID not in (select ISNULL(DepID2nd,DepID1st) from pExpensesSummDep where DATEDIFF(MONTH,DATE,b.Date)=0)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    
    -- 插入费用统计的表格
    insert into pExpensesSumm_register(Date,DepID1st,DepID2nd,SalaryContact)
    select b.Date,dbo.eFN_getdepid1st(a.DepID),dbo.eFN_getdepid2nd(a.DepID),a.DepSalaryContact
    from oDepartment a,pExpensesSumm_Process b
    where b.ID=@ID and a.DepType in (2,3) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999
    and a.DepID not in (select ISNULL(DepID2nd,DepID1st) from pExpensesSumm_register where DATEDIFF(MONTH,DATE,b.Date)=0)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新费用统计流程状态
    update pExpensesSumm_Process
    set Submit=1,SubmitBy=@URID,SubmitTime=GETDATE()
    where ID=@ID
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