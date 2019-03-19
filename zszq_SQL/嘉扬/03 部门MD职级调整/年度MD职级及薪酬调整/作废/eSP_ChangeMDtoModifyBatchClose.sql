USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_ChangeMDtoModifyBatchClose]
-- skydatarefresh eSP_ChangeMDtoModifyBatchClose
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级及薪酬调整的批量关闭程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    Begin TRANSACTION

    -- 更新MD职级及薪酬调整表项pMDtoModify_register
    Update a
    Set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    From pMDtoModify_register a
    Where ISNULL(a.Submit,0)=1
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新MD职级(MD职级最终由调整后MD职级为准)
    Update a
    Set a.MDID=b.HRMDIDAM
    From pEmployeeEmolu a,pMDtoModify_register b
    Where a.EID=b.EID AND ISNULL(b.Closed,0)=1 AND ISNULL(b.HRMDIDAM,0)<>0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新薪酬(薪酬最终由调整后薪酬为准)
    Update a
    Set a.SalaryPerMM=b.HRSalaryPerMMAM
    From pEmployeeEmolu a,pMDtoModify_register b
    Where a.EID=b.EID AND ISNULL(b.Closed,0)=1 AND ISNULL(b.HRSalaryPerMMAM,0)<>0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入部门加薪总包历史表pMDtoModify_all
    insert into pMDtoModify_all (Date,EID,Badge,Name,DepID,SupDepID,JobID,Education,Degree,ServingAge,Seniority,pYearScore,pYearRanking,
    MDID,MDIDtoModify,HRMDID,SalaryPerMM,SalaryPerMMtoModify,HRSalaryPerMM,HRMDIDAM,HRSalaryPerMMAM,
    Initialized,Initializedby,Initilizedtime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime,MDRemark,SalaryRemark)
    select Date,EID,Badge,Name,DepID,SupDepID,JobID,Education,Degree,ServingAge,Seniority,pYearScore,pYearRanking,
    MDID,MDIDtoModify,HRMDID,SalaryPerMM,SalaryPerMMtoModify,HRSalaryPerMM,HRMDIDAM,HRSalaryPerMMAM,
    Initialized,Initializedby,Initilizedtime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime,MDRemark,SalaryRemark
    from pMDtoModify_register
    where ISNULL(Closed,0)=1

    -- 插入MD职级及薪酬调整历史表pChangeMDSalaryPerMM_all
    insert into pChangeMDSalaryPerMM_all(EID,MDID,SalaryPerMM,MDIDtoModify,SalaryPerMMtoModify,MDSalaryModifyReason,EffectiveDate,
    Submit,Submitby,SubmitTime)
    select EID,MDID,SalaryPerMM,HRMDIDAM,HRSalaryPerMMAM,2,GETDATE(),1,@URID,GETDATE()
    From pMDtoModify_register
    Where ISNULL(Closed,0)=1 AND ISNULL(HRSalaryPerMMAM,0)<>0


    -- 删除登记表
    delete from pMDtoModify_register where ISNULL(Closed,0)=1
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