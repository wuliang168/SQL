USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMSummBSSubmit]
-- skydatarefresh eSP_pSalaryPerMMSummBSSubmit
    @leftid varchar(20),  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资统计递交(基于DepID的leftid)
-- @leftid为DepID信息，表示部门ID
*/
Begin

    declare @DepID int,@ProcessID int
    set @DepID=convert(int,SUBSTRING(@leftid,0,CHARINDEX('-',@leftid)))
    set @ProcessID=convert(int,REVERSE(SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid)))))

    Begin TRANSACTION

    -- 更新pSalaryPerMMSumm_register
    ---- 更新由pVW_pSalaryPerMMPWSumm提供的数据
    update a
    set a.EMPPerf=b.EMPPerfSumm,a.EMPWelfare=b.EMPWelfareSumm,a.EMPSUMMTotal=b.EMPSUMMTotalSumm
    from pSalaryPerMMSumm_register a,pVW_pSalaryPerMMPWSumm b
    where a.DepID=b.DepID and a.ProcessID=b.ProcessID and a.PerMMSummType=b.PerMMSummType and a.EMPType=b.EMPType
    and a.DepID=@DepID and a.xOrder<>9 and a.PerMMSummType=1 and a.ProcessID=@ProcessID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 统计
    update a
    set a.EMPNum=(select SUM(EMPNum) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPSalary=(select SUM(EMPSalary) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPPerf=(select SUM(EMPPerf) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPWelfare=(select SUM(EMPWelfare) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPPerfLY=(select SUM(EMPPerfLY) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPSUMMTotal=(select SUM(EMPSUMMTotal) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=1)
    from pSalaryPerMMSumm_register a 
    where a.DepID=@DepID and a.xOrder=9 and a.PerMMSummType=1 and a.ProcessID=@ProcessID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 预算
    update a
    set a.EMPNum=(select SUM(EMPNum) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=2),
    a.EMPSalary=(select SUM(EMPSalary) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=2),
    a.EMPPerf=(select SUM(EMPPerf) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=2),
    a.EMPWelfare=(select SUM(EMPWelfare) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=2),
    a.EMPSUMMTotal=(select SUM(EMPSUMMTotal) from pSalaryPerMMSumm_register where ProcessID=a.ProcessID and xOrder<>9 and DepID=a.DepID and PerMMSummType=2)
    from pSalaryPerMMSumm_register a,pVW_pSalaryPerMMPWSumm b
    where a.DepID=@DepID and a.DepID=b.DepID and a.PerMMSummType=b.PerMMSummType and a.PerMMSummType=2
    and a.xOrder=9 and a.ProcessID=b.ProcessID and a.ProcessID=@ProcessID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新pSalaryPerMMSummDep
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pSalaryPerMMSummDep a 
    where a.DepID=@DepID and ISNULL(a.IsSubmit,0)=0 and a.ProcessID=@ProcessID
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