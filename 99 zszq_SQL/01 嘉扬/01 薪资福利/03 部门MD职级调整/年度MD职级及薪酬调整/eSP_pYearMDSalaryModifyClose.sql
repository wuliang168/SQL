USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pYearMDSalaryModifyClose]
-- skydatarefresh eSP_pYearMDSalaryModifyClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度MD职级及薪酬调整流程关闭程序
-- @ID 为年度MD职级及薪酬调整流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 年度MD职级及薪酬调整流程未开启，无法关闭!
    If Exists(Select 1 From pYear_MDSalaryModify_Process Where ID=@ID and Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 910150
        Return @RetVal
    End

    -- 年度MD职级及薪酬调整流程已关闭，无法关闭!
    If Exists(Select 1 From pYear_MDSalaryModify_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 910160
        Return @RetVal
    End

    Begin TRANSACTION

    -- 插入年度MD职级及薪酬调整流程的历史表项pYear_MDSalaryModify_all
    insert into pYear_MDSalaryModify_all(pProcessID,Date,EID,Badge,Name,SupDepID,DepID,JobID,Director,Education,Degree,ServingAge,Seniority,
    pYear,pYearScore,pYearRanking,pYearLevel,MDID,SalaryPerMM,MDIDtoModify,SalaryPerMMtoModify,MDSalaryRemark,
    HRMDID,HRSalaryPerMM,MDIDtoReModify,SalaryPerMMtoReModify,MDSalaryReRemark,HRMDIDAM,HRSalaryPerMMAM,Lock)
    select a.pProcessID,a.Date,a.EID,a.Badge,a.Name,a.SupDepID,a.DepID,a.JobID,a.Director,a.Education,a.Degree,a.ServingAge,a.Seniority,
    a.pYear,a.pYearScore,a.pYearRanking,a.pYearLevel,a.MDID,a.SalaryPerMM,a.MDIDtoModify,a.SalaryPerMMtoModify,a.MDSalaryRemark,
    a.HRMDID,a.HRSalaryPerMM,a.MDIDtoReModify,a.SalaryPerMMtoReModify,a.MDSalaryReRemark,a.HRMDIDAM,a.HRSalaryPerMMAM,a.Lock
    from pYear_MDSalaryModify_register a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入MD职级及薪酬调整的历史表项pChangeMDSalaryPerMM_all
    insert into pChangeMDSalaryPerMM_all(EID,MDID,SalaryPerMM,MDIDtoModify,SalaryPerMMtoModify,MDSalaryModifyReason,EffectiveDate,
    Submit,SubmitBy,SubmitTime)
    select a.EID,a.MDID,a.SalaryPerMM,a.HRMDIDAM,a.HRSalaryPerMMAM,2,(select EffectiveDate from pYear_MDSalaryModify_Process where ID=@ID),1,1,GETDATE()
    from pYear_MDSalaryModify_register a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新员工MD职级
    update a
    set a.MDID=ISNULL(c.HRMDIDAM,a.MDID)
    from pEMPAdminIDMD a,pYear_MDSalaryModify_register c
    where a.EID=c.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
	-- 更新员工薪酬
    update b
    set b.SalaryPerMM=ISNULL(c.HRSalaryPerMMAM,b.SalaryPerMM)
    from pEMPSalary b,pYear_MDSalaryModify_register c
    where b.EID=c.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pYear_MDSalaryModifyDep
    update b
    set b.IsClosed=1
    from pYear_MDSalaryModify_Process a,pYear_MDSalaryModifyDep b
    where a.ID=@ID and a.Date=b.Date
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新年度MD职级及薪酬调整流程状态pYear_MDSalaryModify_Process
    update a
    set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    from pYear_MDSalaryModify_Process a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除后备人才统计表项
    delete from pYear_MDSalaryModify_register
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