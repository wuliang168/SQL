USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionPerMMBSStart]
-- skydatarefresh eSP_pDepPensionPerMMBSStart
    @leftid varchar(20),
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

    declare @DepID int,@SalaryPayID int
    set @DepID=convert(int,SUBSTRING(@leftid,0,CHARINDEX('-',@leftid)))
    set @SalaryPayID=convert(int,REVERSE(SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid)))))


    -- 个人年金分配额超过个人年金分配剩余！
    ---- 非营业部发薪员工
    If Exists(Select 1 From pEmpPensionPerMM_register a,pEmpSalary b
    Where a.PensionContact=@EID And ISNULL(a.EmpPensionMonthRest,0)<0 And a.EID=b.EID AND @DepID=0
    And ((b.SalaryPayID in (1,2,3,10,11,12,13,14,15,16) and @SalaryPayID=1)
    or (b.SalaryPayID in (4,5) and @SalaryPayID=4)
    or (b.SalaryPayID in (7) and @SalaryPayID=7)))
    Begin
        Set @RetVal = 930085
        Return @RetVal
    End
    ---- 营业部发薪员工
    If Exists(Select 1 From pEmpPensionPerMM_register a,pVW_employee b
    Where a.PensionContact=@EID And ISNULL(a.EmpPensionMonthRest,0)<0 And ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID)
    and @SalaryPayID=6 and b.DepID=@DepID)
    Begin
        Set @RetVal = 930085
        Return @RetVal
    End


    Begin TRANSACTION

    
    -- 年金联系人添加年金分配员工金额
    update a
    set a.IsSubmit=1
    from pDepPensionPerMM a
    where ((a.SalaryPayID=@SalaryPayID and (@SalaryPayID in (1,2,3,10,11,12,13,14,15,16) or @SalaryPayID=7 or @SalaryPayID in (4,5)) and @DepID=0) 
    or (a.SalaryPayID=@SalaryPayID and @SalaryPayID=6 and ISNULL(a.DepID,a.SupDepID)=@DepID))
    AND ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0
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