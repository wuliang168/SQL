USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionPerMMClose]
-- skydatarefresh eSP_pPensionPerMMClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配月度关闭程序
-- @ID 为年金计划分配月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 月度年金计划分配未开启!
    If Exists(Select 1 From pPensionPerMM Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930067
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新年金月度表项pPensionPerMM
    Update a
    Set a.Closed=1,ClosedBy=@URID,ClosedTime=GETDATE()
    From pPensionPerMM a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新部门年金月度表项pDepPensionPerMM
    update a
    set a.IsClosed=1
    from pDepPensionPerMM a,pPensionPerMM b
    where b.ID=@ID and a.PensionMonth=b.PensionMonth
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 插入年金月度历史数据表项
    -- 插入后台人员月度历史数据表项pEmpPensionPerMM_all
    insert pEmpPensionPerMM_all(PensionMonth,EID,BID,SalaryPayID,DepID,GrpPensionPerMM,EmpPensionPerMMBTax,EmpPensionPerMMATax,
    GrpPensionMonthTotal,GrpPensionMonthRest,EmpPensionMonthTotal,EmpPensionMonthRest,Remark,PensionContact,Submit,SubmitBy,SubmitTime)
    select a.PensionMonth,a.EID,a.BID,b.SalaryPayID,c.DepID,a.GrpPensionPerMM,a.EmpPensionPerMMBTax,a.EmpPensionPerMMATax,a.GrpPensionMonthTotal,
    a.GrpPensionMonthRest,a.EmpPensionMonthTotal,a.EmpPensionMonthRest,a.Remark,a.PensionContact,a.Submit,a.SubmitBy,a.SubmitTime
    from pEmpPensionPerMM_register a,pEMPSalary b,pVW_Employee c
    where ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID) and ISNULL(a.EID,a.BID)=ISNULL(c.EID,c.BID) 
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 删除年金月度数据表项
    -- 删除后台人员月度数据表项pEmpPensionPerMM_register
    delete from pEmpPensionPerMM_register
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