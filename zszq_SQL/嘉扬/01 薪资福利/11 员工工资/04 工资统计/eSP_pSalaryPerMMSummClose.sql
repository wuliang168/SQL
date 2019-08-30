USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMSummClose]
-- skydatarefresh eSP_pSalaryPerMMSummClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资统计流程关闭程序
-- @ID 为月度工资统计流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 月度工资统计流程未开启!
    If Exists(Select 1 From pSalaryPerMMSumm_Process Where ID=@ID and Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930250
        Return @RetVal
    End

    -- 月度工资统计流程已关闭!
    If Exists(Select 1 From pSalaryPerMMSumm_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930260
        Return @RetVal
    End

    Begin TRANSACTION

    -- 插入月度工资统计流程的历史表项pSalaryPerMMSumm_all
    insert into pSalaryPerMMSumm_all(ProcessID,Date,DepID,SalaryContact,PerMMSummType,EMPType,EMPNum,EMPSalary,
    EMPPerf,EMPWelfare,EMPPerfLY,EMPSummTotal,xOrder)
    select a.ProcessID,a.Date,a.DepID,a.SalaryContact,a.PerMMSummType,a.EMPType,a.EMPNum,a.EMPSalary,
    a.EMPPerf,a.EMPWelfare,a.EMPPerfLY,a.EMPSummTotal,a.xOrder
    from pSalaryPerMMSumm_register a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资统计流程的历史表项pSalaryPerMMPWSumm_all
    insert into pSalaryPerMMPWSumm_all(ProcessID,DepID,SalaryContact,PerMMSummType,EMPType,EMPPerfWelYear,EMPPerfWelType,EMPPerfWelSumm)
    select a.ProcessID,a.DepID,a.SalaryContact,a.PerMMSummType,a.EMPType,a.EMPPerfWelYear,a.EMPPerfWelType,a.EMPPerfWelSumm
    from pSalaryPerMMPWSumm a
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新pSalaryPerMMSummDep
    update b
    set b.IsSubmit=1
    from pSalaryPerMMSumm_Process a,pSalaryPerMMSummDep b
    where a.ID=@ID and a.Date=b.Date and ISNULL(b.IsSubmit,0)=0

    -- 更新月度工资流程状态
    update a
    set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    from pSalaryPerMMSumm_Process a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除月度工资统计表项
    delete from pSalaryPerMMSumm_register
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