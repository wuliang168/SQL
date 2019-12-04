USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pMonthExpenseStart]
-- skydatarefresh eSP_pMonthExpenseStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度费用流程开启程序
-- @ID 为月度费用流程月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 月度费用流程中月度为空!
    If Exists(Select 1 From pMonthExpense_Process Where ID=@ID and ISNULL(Month,0)=1)
    Begin
        Set @RetVal = 930310
        Return @RetVal
    End

    -- 月度费用流程已开启!
    If Exists(Select 1 From pMonthExpense_Process Where ID=@ID and Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930330
        Return @RetVal
    End

    -- 月度费用流程已关闭!
    If Exists(Select 1 From pMonthExpense_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930340
        Return @RetVal
    End

    -- 上一月度费用流程未关闭!
    If Exists(Select 1 From pMonthExpense_Process Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930350
        Return @RetVal
    End


    Begin TRANSACTION

    -- 插入月度费用流程的部门月度费用流程表项pMonthExpenseDep
    ---- 营业部
    insert into pMonthExpenseDep(Month,DepID1st,DepID2nd,DepSalaryContact)
    select b.Month,dbo.eFN_getdepid1st(a.DepID),dbo.eFN_getdepid2nd(a.DepID),a.DepSalaryContact
    from oDepartment a,pMonthExpense_Process b
    where b.ID=@ID and a.DepType in (2,3) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999
    and a.DepID not in (select ISNULL(DepID2nd,DepID1st) from pMonthExpenseDep where ISNULL(IsClosed,0)=0)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度费用通讯费pMonthExpensePerMM
    insert into pMonthExpensePerMM(EID,Month,MonthExpenseDepID,MonthExpenseType,MonthExpense)
    select a.EID,b.Month,c.DepID,16,a.CommAllowance
    from pEMPTrafficComm a,pMonthExpense_Process b,eEmployee c,pEMPSalary d
    where b.ID=@ID and a.EID=c.EID and a.EID=d.EID
    and c.status not in (4,5) and d.SalaryPayID not in (4,6,7,8,17,18) and dbo.eFN_getdeptype(c.DepID) in (2,3)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新月度费用流程状态
    update pMonthExpense_Process
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