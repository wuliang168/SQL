USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMSummBSSubmit]
-- skydatarefresh eSP_pSalaryPerMMSummBSSubmit
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资统计递交(基于DepID的leftid)
-- @leftid为DepID信息，表示部门ID
*/
Begin

    Begin TRANSACTION

    -- 更新pSalaryPerMMSumm_register
    ---- 统计
    update a
    set a.EMPNum=(select SUM(EMPNum) from pSalaryPerMMSumm_register where xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPSalary=(select SUM(EMPSalary) from pSalaryPerMMSumm_register where xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPPerf=(select SUM(EMPPerf) from pSalaryPerMMSumm_register where xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPWelfare=(select SUM(EMPWelfare) from pSalaryPerMMSumm_register where xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPPerfLY=(select SUM(EMPPerfLY) from pSalaryPerMMSumm_register where xOrder<>9 and DepID=a.DepID and PerMMSummType=1),
    a.EMPSUMMTotal=(select SUM(EMPSUMMTotal) from pSalaryPerMMSumm_register where xOrder<>9 and DepID=a.DepID and PerMMSummType=1)
    from pSalaryPerMMSumm_register a 
    where a.DepID=@leftid and a.xOrder=9 and a.PerMMSummType=1

    ---- 预算
    update a
    set a.EMPNum=(select SUM(EMPNum) from pSalaryPerMMSumm_register where xOrder<>9 and DepID=a.DepID and PerMMSummType=2),
    a.EMPSalary=(select SUM(EMPSalary) from pSalaryPerMMSumm_register where xOrder<>9 and DepID=a.DepID and PerMMSummType=2),
    a.EMPPerf=b.EMPPerfSumm,a.EMPWelfare=b.EMPWelfareSumm,
    a.EMPSUMMTotal=(select SUM(EMPSUMMTotal) from pSalaryPerMMSumm_register where xOrder<>9 and DepID=a.DepID and PerMMSummType=2)
    from pSalaryPerMMSumm_register a,pVW_pSalaryPerMMPWSumm b
    where a.DepID=@leftid and a.DepID=b.DepID and a.PerMMSummType=b.PerMMSummType and a.PerMMSummType=2
    and a.xOrder=9


    -- 更新pSalaryPerMMSummDep
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pSalaryPerMMSummDep a 
    where a.DepID=@leftid and ISNULL(a.IsSubmit,0)=0


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