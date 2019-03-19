USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pYearMDSalaryModifyStart]
-- skydatarefresh eSP_pYearMDSalaryModifyStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度MD职级及薪酬调整流程开启程序
-- @ID 为年度MD职级及薪酬调整流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 年度MD职级及薪酬调整流程中分配年度为空，无法开启！
    If Exists(Select 1 From pYear_MDSalaryModify_Process Where ID=@ID and ISNULL(Date,0)=1)
    Begin
        Set @RetVal = 910110
        Return @RetVal
    End

    -- 年度MD职级及薪酬调整流程已开启，无法开启！
    If Exists(Select 1 From pYear_MDSalaryModify_Process Where ID=@ID and Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 910120
        Return @RetVal
    End

    -- 年度MD职级及薪酬调整流程已关闭，无法开启！
    If Exists(Select 1 From pYear_MDSalaryModify_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 910130
        Return @RetVal
    End

    -- 上一次年度MD职级及薪酬调整流程未关闭，无法开启！
    If Exists(Select 1 From pYear_MDSalaryModify_Process Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 910140
        Return @RetVal
    End


    Begin TRANSACTION

    -- 插入部门年度MD职级及薪酬调整流程表项pYear_MDSalaryModifyDep
    insert into pYear_MDSalaryModifyDep(Date,SupDepID,DepID,Director,MDRemark,SalaryRemark,HRRemark)
    select distinct b.Date,a.SupDepID,a.DepID,a.Director,(select Info from pYear_MDSalaryModifyInfo where ID=1),
    (select Info from pYear_MDSalaryModifyInfo where ID=2),(select Info from pYear_MDSalaryModifyInfo where ID=3)
    from pVW_pYearMDSalaryModifyDep a,pYear_MDSalaryModify_Process b
    where b.ID=@ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
    and a.Director not in (select Director from pYear_MDSalaryModifyDep where Year(Date)=YEAR(b.Date))
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入MD职级及薪酬调整表项pYear_MDSalaryModify_register
    insert into pYear_MDSalaryModify_register (Date,EID,Badge,Name,SupDepID,DepID,JobID,Director,
    Education,Degree,ServingAge,Seniority,pYear,pYearScore,pYearRanking,pYearLevel,MDID,SalaryPerMM)
    select b.Date,a.EID,a.Badge,a.Name,a.SupDepID,a.DepID,a.JobID,a.Director,
    a.Education,a.Degree,a.ServingAge,a.Seniority,YEAR(a.pYear),a.ScoreYear,a.Ranking,a.RankLevel,a.MDID,a.SalaryPerMM
    from pVW_pYearMDSalaryModifyEMP a,pYear_MDSalaryModify_Process b
    where b.ID=@ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 and DATEDIFF(YY,b.Date,a.pYear)=0
    and a.EID not in (select EID from pYear_MDSalaryModify_register where Year(a.pYear)=Year(b.Date))
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新MD职级及薪酬调整表项pYear_MDSalaryModify_register
    ---- 考核为D的需要进行锁定(作废)
    --Update a
    --Set a.Lock=1
    --From pYear_MDSalaryModify_register a
    --Where a.pYearLevel='D'
    ---- 异常流程
    --IF @@Error <> 0
    --Goto ErrM


    -- 更新年度MD职级及薪酬调整流程状态
    update pYear_MDSalaryModify_Process
    set Submit=1,SubmitBy=@URID,SubmitTime=GETDATE()
    where ID=@ID
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