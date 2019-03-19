USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionPerMMBSSPStart]
-- skydatarefresh eSP_pDepPensionPerMMBSSPStart
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
    select @PensionMonth=a.PensionMonth from pEmpPensionPerMM_register a,pEmployeeEmolu b where b.SalaryPayID=@leftid and a.EID=b.EID

    -- 企业年金分配额为空！
    ---- 后台员工(非营业部)(退休)
    If Exists(Select 1 From pEmpPensionPerMM_register a,pEmployeeEmolu b,eEmployee c
    Where a.PensionContact=@EID And ISNULL(a.GrpPensionPerMM,0)=0 And a.EID=b.EID And a.EID=c.EID
    And b.SalaryPayID=8 And b.SalaryPayID=@leftid And c.Status=5)
    Begin
        Set @RetVal = 930082
        Return @RetVal
    End

    -- 个人年金分配额超过个人年金分配剩余！
    ---- 后台员工(非营业部)(在职)
    ------ 总部
    If Exists(Select 1 From pEmpPensionPerMM_register a,pEmployeeEmolu b 
    Where a.PensionContact=@EID And ISNULL(a.EmpPensionMonthRest,0)<0 And a.EID=b.EID
    And ((b.SalaryPayID in (1,2,3,10,11,12,13,14,15,16) and @leftid=1)
    or (b.SalaryPayID in (4,5) and @leftid=4)
    or (b.SalaryPayID in (7) and @leftid=7)))
    Begin
        Set @RetVal = 930085
        Return @RetVal
    End

    -- 企业缴费超过企业分配剩余！
    ---- 后台员工(非营业部)(退休)
    If Exists(Select 1 From pEmpPensionPerMM_register a,pEmployeeEmolu b 
    Where a.PensionContact=@EID And ISNULL(a.GrpPensionMonthRest,0)<0 And a.EID=b.EID
    And b.SalaryPayID=8 and @leftid=8)
    Begin
        Set @RetVal = 930083
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新员工月度工资的年金金额
    --update a
    --set a.PensionEMPBT=b.EmpPensionPerMMBTax,a.PensionEMPAT=b.EmpPensionPerMMATax
    --from pEmployeePension a,pEmpPensionPerMM_register b,pEmployeeEmolu c
    --where a.EID=b.EID and a.EID=c.EID and DATEDIFF(mm,a.Date,b.PensionMonth)=0 and b.PensionContact=@EID and c.SalaryPayID=@leftid
    ---- 异常流程
    --If @@Error<>0
    --Goto ErrM

    -- 更新月度年金员工的递交状态
    ---- 后台员工
    update b
    set b.Submit=1,b.SubmitBy=(select id from skysecuser where eid=@EID),b.Submittime=getdate()
    from pEmployeeEmolu a,pEmpPensionPerMM_register b
    where a.EID=b.EID and b.PensionContact=@EID 
    And ((a.SalaryPayID in (1,2,3,10,11,12,13,14,15,16) and @leftid=1)
    or (a.SalaryPayID in (4,5) and @leftid=4)
    or (a.SalaryPayID in (7) and @leftid=7)
    or (a.SalaryPayID in (8) and @leftid=8))
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    
    -- 年金联系人添加年金分配员工金额
    update a
    set a.IsSubmit=1
    from pDepPensionPerMM a
    where a.PensionMonth=@PensionMonth
    And ((a.SalaryPayID in (1,2,3,10,11,12,13,14,15,16) and @leftid=1)
    or (a.SalaryPayID in (4,5) and @leftid=4)
    or (a.SalaryPayID in (7) and @leftid=7)
    or (a.SalaryPayID in (8) and @leftid=8))
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