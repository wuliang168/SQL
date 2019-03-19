USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMSummStart]
-- skydatarefresh eSP_pSalaryPerMMSummStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资统计流程开启程序
-- @ID 为月度工资统计流程月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin


    -- 月度工资统计流程中日期为空!
    If Exists(Select 1 From pSalaryPerMMSumm_Process Where ID=@ID and ISNULL(Date,0)=1)
    Begin
        Set @RetVal = 930210
        Return @RetVal
    End

    -- 月度工资统计流程已开启!
    If Exists(Select 1 From pSalaryPerMMSumm_Process Where ID=@ID and Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930220
        Return @RetVal
    End

    -- 月度工资统计流程已关闭!
    If Exists(Select 1 From pSalaryPerMMSumm_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930230
        Return @RetVal
    End

    -- 上月度工资统计流程未关闭!
    If Exists(Select 1 From pSalaryPerMMSumm_Process Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930240
        Return @RetVal
    End


    Begin TRANSACTION

    -- 插入月度工资统计流程的部门月度工资统计流程表项pSalaryPerMMSummDep
    insert into pSalaryPerMMSummDep(Date,DepID,SalaryContact)
    select b.Date,a.DepID,a.DepSalaryContact
    from oDepartment a,pSalaryPerMMSumm_Process b
    where b.ID=@ID and a.DepType in (2,3) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999
    and a.DepID not in (select DepID from pSalaryPerMMSummDep where DATEDIFF(MONTH,DATE,b.Date)=0)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    
    -- 插入月度工资统计的表格
    ---- 中后台员工
    insert into pSalaryPerMMSumm_register(Date,DepID,SalaryContact,EMPType,xOrder)
    select b.Date,a.DepID,a.DepSalaryContact,N'中后台员工',1
    from oDepartment a,pSalaryPerMMSumm_Process b
    where b.ID=@ID and a.DepType in (2,3) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999
    and a.DepID not in (select DepID from pSalaryPerMMSumm_register where EMPType=N'中后台员工')
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 投资顾问
    insert into pSalaryPerMMSumm_register(Date,DepID,SalaryContact,EMPType,xOrder)
    select b.Date,a.DepID,a.DepSalaryContact,N'投资顾问',2
    from oDepartment a,pSalaryPerMMSumm_Process b
    where b.ID=@ID and a.DepType in (2,3) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999
    and a.DepID not in (select DepID from pSalaryPerMMSumm_register where EMPType=N'投资顾问')
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 理财顾问
    insert into pSalaryPerMMSumm_register(Date,DepID,SalaryContact,EMPType,xOrder)
    select b.Date,a.DepID,a.DepSalaryContact,N'理财顾问',3
    from oDepartment a,pSalaryPerMMSumm_Process b
    where b.ID=@ID and a.DepType in (2,3) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999
    and a.DepID not in (select DepID from pSalaryPerMMSumm_register where EMPType=N'理财顾问')
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 小计
    insert into pSalaryPerMMSumm_register(Date,DepID,SalaryContact,EMPType,xOrder)
    select b.Date,a.DepID,a.DepSalaryContact,N'小计',4
    from oDepartment a,pSalaryPerMMSumm_Process b
    where b.ID=@ID and a.DepType in (2,3) and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999
    and a.DepID not in (select DepID from pSalaryPerMMSumm_register where EMPType=N'小计')
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度工资统计流程状态
    update pSalaryPerMMSumm_Process
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