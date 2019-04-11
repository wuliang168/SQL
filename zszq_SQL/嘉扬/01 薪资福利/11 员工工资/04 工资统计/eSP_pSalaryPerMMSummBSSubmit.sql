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
    update a
    set a.EMPNum=(select SUM(EMPNum) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID),
    a.EMPSalary=(select SUM(EMPSalary) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID),
    a.EMPPerf=(select SUM(EMPPerf) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID),
    a.EMPWelfare=(select SUM(EMPWelfare) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID),
    a.EMPPerfLY=(select SUM(EMPPerfLY) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID),
    a.EMPSUMMTotal=(select SUM(EMPSUMMTotal) from pSalaryPerMMSumm_register where xOrder in (1,2,3) and DepID=a.DepID)
    from pSalaryPerMMSumm_register a 
    where a.DepID=@leftid and a.xOrder in (4)

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