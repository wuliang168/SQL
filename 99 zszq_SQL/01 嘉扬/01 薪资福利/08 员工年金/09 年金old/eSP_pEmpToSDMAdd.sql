USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEmpToSDMAdd]
-- skydatarefresh eSP_pEmpToSDMAdd
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 后台转前台员工新增程序
*/
Begin


    Begin TRANSACTION

    -- 更新职能部门考核人递交状态
    insert into pSDMarketerPensionPerMM_register(PensionMonth,Name,Status,SupDepID,DepID,JobID,SalaryPayID,Gender,Identification,
    JoinDate,LeaveDate,IsPension,GrpPensionMonthTotal,GrpPensionMonthRest,PensionContact)
    select a.PensionMonth,b.Name,b.Status,b.SupDepID,b.DepID,b.JobID,b.SalaryPayID,b.Gender,b.Identification,
    b.JoinDate,b.LeaveDate,b.IsPension,b.GrpPensionYearRest,b.GrpPensionYearRest,c.DepPensionContact
    from pPensionPerMM a,pSalesDepartMarketerEmolu b,odepartment c
    where a.ID=(select ID from pPensionPerMM where ISNULL(Submit,0)=1 and ISNULL(Closed,0)=0) and ISNULL(b.GrpPensionYearRest,0)>0 
    and c.DepID=ISNULL(b.DepID,b.SupDepID) and ISNULL(b.GrpPensionYearRest,0)<>0 and b.status not in (4)
    and b.Identification not in (select Identification from pSDMarketerPensionPerMM_register)
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