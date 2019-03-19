USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMBSSubmit]
-- skydatarefresh eSP_pSalaryPerMMBSSubmit
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资薪酬信息确认(基于SalaryPayID的leftid)
-- @leftid为SalaryPayID信息，表示薪酬发薪类型
*/
Begin

    -- 年度考核已封帐，无法重新开启！
    if exists (select 1 from pEmployeePension a,pEmployeeEmolu b
    where ISNULL(a.GrpPensionMonthRest,0)<-0.03 and a.EID=b.EID and b.SalaryPayID=@leftid)
    Begin
        Set @RetVal=1001030
        Return @RetVal
    end

    Begin TRANSACTION

    -- 更新月度年金分配
    update b
    set b.EmpPensionPerMMBTax=a.PensionEMPBT,b.EmpPensionPerMMATax=a.PensionEMPAT,
    b.GrpPensionPerMM=a.GrpPensionPerMM,b.GrpPensionMonthRest=a.GrpPensionMonthRest
    from pEmployeePension a,pEmpPensionPerMM_register b,pEmployeeEmolu c
    where a.EID=b.EID and DATEDIFF(mm,a.Date,b.PensionMonth)=0
    and a.EID=c.EID and c.SalaryPayID=@leftid
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度工资流程的部门月度工资流程表项pDepSalaryPerMonth
    update a
    set a.IsSubmit=1
    from pDepSalaryPerMonth a
    where a.SalaryPayID=@leftid and a.DepID is NULL
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