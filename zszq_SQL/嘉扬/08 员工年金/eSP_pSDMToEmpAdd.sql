USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSDMToEmpAdd]
-- skydatarefresh eSP_pSDMToEmpAdd
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 后台转前台员工新增程序
*/
Begin


    Begin TRANSACTION

    -- 插入后台人员年金月度分配注册表pEmpPensionPerMM_register
    -- 薪酬类型非营业部;
    insert into pEmpPensionPerMM_register(PensionMonth,EID,GrpPensionMonthTotal,GrpPensionMonthRest,PensionContact)
    select a.PensionMonth,b.EID,b.GrpPensionYearRest,b.GrpPensionYearRest,d.PensionContact
    from pPensionPerMM a,pEmployeeEmolu b,eEmployee c,oCD_SalaryPayType d
    where a.ID=(select ID from pPensionPerMM where ISNULL(Submit,0)=1 and ISNULL(Closed,0)=0) and ISNULL(b.GrpPensionYearRest,0)>0 
    and b.eid=c.eid and ISNULL(b.GrpPensionYearRest,0)<>0 and c.status not in (4)
    and b.SalaryPayID=d.ID and b.SalaryPayID not in (6)
    and b.EID not in (select EID from pEmpPensionPerMM_register)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 薪酬类型营业部;
    insert into pEmpPensionPerMM_register(PensionMonth,EID,GrpPensionMonthTotal,GrpPensionMonthRest,PensionContact)
    select a.PensionMonth,b.EID,b.GrpPensionYearRest,b.GrpPensionYearRest,d.DepPensionContact
    from pPensionPerMM a,pEmployeeEmolu b,eEmployee c,odepartment d
    where a.ID=(select ID from pPensionPerMM where ISNULL(Submit,0)=1 and ISNULL(Closed,0)=0) and ISNULL(b.GrpPensionYearRest,0)>0 
    and b.eid=c.eid and ISNULL(b.GrpPensionYearRest,0)<>0 and c.status not in (4)
    and c.DepID=d.DepID and b.SalaryPayID in (6)
    and b.EID not in (select EID from pEmpPensionPerMM_register)
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