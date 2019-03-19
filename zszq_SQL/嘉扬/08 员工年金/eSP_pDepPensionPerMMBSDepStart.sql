USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionPerMMBSDepStart]
-- skydatarefresh eSP_pDepPensionPerMMBSDepStart
    @leftid int,
    @EID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配月度开启程序
-- @leftid 为年金计划分配月度对应ID
-- @EID 为前台操作账号的EID，前台通过 {U_EID} 全局参数获取
*/
Begin

    declare @PensionMonth smalldatetime
    select @PensionMonth=a.PensionMonth from PDEPPENSIONPERMM a where ISNULL(a.DepID,a.SupDepID)=@leftid and ISNULL(IsSubmit,0)=0

    -- 企业年金分配额为空！
    ---- 后台员工(营业部)
    --If Exists(Select 1 From pEmpPensionPerMM_register a,pEmployeeEmolu b,eemployee c
    --Where a.PensionContact=@EID And ISNULL(a.GrpPensionPerMM,0)=0 And a.EID=b.EID And a.EID=c.EID
    --And b.SalaryPayID in (6) And c.DepID=@leftid And c.Status not in (4,5) and a.GrpPensionMonthTotal is not NULL)
    --Begin
    --    Set @RetVal = 930082
    --    Return @RetVal
    --End

    -- 个人年金分配额为超过个人年金分配剩余！
    ---- 后台员工(营业部)
    If Exists(Select 1 From pEmpPensionPerMM_register a,pEmployeeEmolu b,eemployee c
    Where a.PensionContact=@EID And ISNULL(a.EmpPensionMonthRest,0)<0 And a.EID=b.EID And a.EID=c.EID
    And b.SalaryPayID in (6) And c.DepID=@leftid)
    Begin
        Set @RetVal = 930085
        Return @RetVal
    End

    -- 个人年金分配未等于企业年金分配的25%!
    ---- 后台员工(营业部)
    --If Exists(Select 1 From pEmpPensionPerMM_register a,pEmployeeEmolu b,eemployee c
    --Where a.PensionContact=@EID And a.EID=B.EID And a.EID=c.EID And b.SalaryPayID in (6) And c.DepID=@leftid And c.status not in (4,5)
    --And (ROUND(ISNULL(a.GrpPensionPerMM,0)/4+0.02,2) < (ISNULL(a.EmpPensionPerMMBTax,0) + ISNULL(a.EmpPensionPerMMATax,0))
    --OR ROUND(ISNULL(a.GrpPensionPerMM,0)/4-0.02,2) > (ISNULL(a.EmpPensionPerMMBTax,0) + ISNULL(a.EmpPensionPerMMATax,0))))
    --Begin
    --    Set @RetVal = 930083
    --    Return @RetVal
    --End


    Begin TRANSACTION

    -- 更新员工月度工资的年金金额
    --update a
    --set a.PensionEMPBT=b.EmpPensionPerMMBTax,a.PensionEMPAT=b.EmpPensionPerMMATax
    --from pEmployeePension a,pEmpPensionPerMM_register b,eemployee c
    --where a.EID=b.EID and a.EID=c.EID and DATEDIFF(mm,a.Date,b.PensionMonth)=0 and b.PensionContact=@EID and c.DepID=@leftid
    ---- 异常流程
    --If @@Error<>0
    --Goto ErrM

    -- 更新月度年金部门的中后台递交状态pDepPensionPerMM
    update a
    set a.IsEmpSubmit=1
    from pDepPensionPerMM a
    where ISNULL(a.DepID,a.SupDepID)=@leftid and a.PensionMonth=@PensionMonth
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 更新月度年金部门的递交状态pDepPensionPerMM
    IF EXISTS(select 1 from pDepPensionPerMM where ISNULL(DepID,SupDepID)=@leftid and ISNULL(IsSDMSubmit,0)=1 and PensionMonth=@PensionMonth)
    Begin
        update a
        set a.IsSubmit=1
        from pDepPensionPerMM a
        where ISNULL(a.DepID,a.SupDepID)=@leftid and a.PensionMonth=@PensionMonth
        -- 异常流程
        If @@Error<>0
        Goto ErrM 
    End

    -- 更新月度年金员工的递交状态
    ---- 后台员工
    update b
    set b.Submit=1,b.SubmitBy=(select id from skysecuser where eid=@EID),b.Submittime=getdate()
    from pEmployeeEmolu a,pEmpPensionPerMM_register b,eemployee c
    where a.EID=b.EID and a.EID=c.EID
    and b.PensionContact=@EID and c.DepID=@leftid
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