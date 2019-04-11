USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMBSDepSubmit]
-- skydatarefresh eSP_pSalaryPerMMBSDepSubmit
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资薪酬信息确认(基于DepID的leftid)
-- @leftid为DepID信息，表示薪酬发薪类型
*/
Begin

    -- 年金(企业)月分配剩余小于-0.03，月度工资无法递交！
    if exists (select 1 from pEmployeePension a,pEmployeeEmolu b,eEmployee c 
    where ISNULL(a.GrpPensionMonthRest,0)<-0.03 and a.EID=b.EID and b.SalaryPayID=6
    and a.EID=c.EID and c.DepID=@leftid)
    Begin
        Set @RetVal=930104
        Return @RetVal
    end

    Begin TRANSACTION

    -- 更新月度年金分配
    update b
    set b.EmpPensionPerMMBTax=a.PensionEMPBT,b.EmpPensionPerMMATax=a.PensionEMPAT,
    b.GrpPensionPerMM=a.GrpPensionPerMM,b.GrpPensionMonthRest=a.GrpPensionMonthRest
    from pEmployeePension a,pEmpPensionPerMM_register b,pEmployeeEmolu c,eEmployee d
    where a.EID=b.EID and DATEDIFF(mm,a.Date,b.PensionMonth)=0 
    and a.EID=c.EID and c.SalaryPayID=6 and a.EID=d.EID and d.DepID=@leftid
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度工资流程的部门月度工资流程表项pDepSalaryPerMonth
    update a
    set a.IsSubmit=1
    from pDepSalaryPerMonth a
    where a.DepID=@leftid and a.SalaryPayID=6


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