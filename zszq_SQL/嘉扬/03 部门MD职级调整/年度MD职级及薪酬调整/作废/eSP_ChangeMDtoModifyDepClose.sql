USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_ChangeMDtoModifyDepClose]
-- skydatarefresh eSP_ChangeMDtoModifyDepClose
    @EID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级及薪酬调整的部门关闭程序
-- @EID 为MD职级及薪酬调整的部门负责人EID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 部门负责人未完成MD职级及薪酬调整!
    If Exists(Select 1 From pMDtoModify_register Where Director=@EID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930046
        Return @RetVal
    End

    Begin TRANSACTION

    -- 更新MD职级及薪酬调整表项pMDtoModify_register
    Update a
    Set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    From pMDtoModify_register a
    Where a.Director=@EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新MD职级
    Update a
    Set a.MDID=b.MDIDtoModify
    From pEmployeeEmolu a,pMDtoModify_register b
    Where a.EID=b.EID AND b.Director=@EID AND ISNULL(b.MDIDtoModify,b.HRMDID)<>0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新薪酬
    Update a
    Set a.SalaryPerMM=b.SalaryPerMMtoModify
    From pEmployeeEmolu a,pMDtoModify_register b
    Where a.EID=b.EID AND b.Director=@EID AND ISNULL(b.SalaryPerMMtoModify,ISNULL(b.HRSalaryPerMM,b.SalaryPerMM))<>0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入部门加薪总包历史表pMDtoModify_all
    insert into pMDtoModify_all (Date,EID,Badge,Name,DepID,SupDepID,JobID,Director,Education,Degree,ServingAge,Seniority,pYear,pYearScore,pYearRanking,pYearLevel,
    MDID,MDIDtoModify,HRMDID,SalaryPerMM,SalaryPerMMtoModify,HRSalaryPerMM,
    Initialized,Initializedby,Initilizedtime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime,MDRemark,SalaryRemark)
    select Date,EID,Badge,Name,DepID,SupDepID,JobID,Director,Education,Degree,ServingAge,Seniority,pYear,pYearScore,pYearRanking,pYearLevel,
    MDID,MDIDtoModify,HRMDID,SalaryPerMM,SalaryPerMMtoModify,HRSalaryPerMM,
    Initialized,Initializedby,Initilizedtime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime,MDRemark,SalaryRemark
    from pMDtoModify_register
    where Director=@EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除登记表
    delete from pMDtoModify_register where Director=@EID
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