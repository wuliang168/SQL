USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pAnnualBonus_ProcessStart]
-- skydatarefresh eSP_pAnnualBonus_ProcessStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度奖金流程开启程序
-- @ID 为年度奖金流程月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 年度奖金流程中奖金年度为空!
    If Exists(Select 1 From pYear_AnnualBonus_Process Where ID=@ID and ISNULL(Year,0)=0)
    Begin
        Set @RetVal = 930310
        Return @RetVal
    End

    -- 年度奖金流程中分配月份为空!
    If Exists(Select 1 From pYear_AnnualBonus_Process Where ID=@ID and ISNULL(Date,0)=0)
    Begin
        Set @RetVal = 930320
        Return @RetVal
    End

    -- 年度奖金流程已开启!
    If Exists(Select 1 From pYear_AnnualBonus_Process Where ID=@ID and Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930330
        Return @RetVal
    End

    -- 年度奖金流程已关闭!
    If Exists(Select 1 From pYear_AnnualBonus_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930340
        Return @RetVal
    End

    -- 上一次年度奖金流程未关闭!
    --If Exists(Select 1 From pYear_AnnualBonus_Process Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    --Begin
    --    Set @RetVal = 930350
    --    Return @RetVal
    --End


    Begin TRANSACTION

    -- 插入年度奖金流程的部门年度奖金流程表项pYear_AnnualBonusDep
    ---- 一级部门
    insert into pYear_AnnualBonusDep(Year,Date,AnnualBonusDepID,Director,Remark)
    select b.Year,b.Date,a.DepID,a.Director,b.Remark
    from oDepartment a,pYear_AnnualBonus_Process b
    where b.ID=@ID and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999 and a.DepGrade=1 and a.DepType in (2,3)
    and a.DepID not in (select AnnualBonusDepID from pYear_AnnualBonusDep where ISNULL(IsClosed,0)=0 and Year=b.Year and Date=b.Date)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 二级部门 需要将IsSubmit置为NULL(0-开启|1-已递交|NULL-关闭)
    insert into pYear_AnnualBonusDep(Year,Date,AnnualBonusDepID,Director,IsSubmit,Remark)
    select b.Year,b.Date,a.DepID,a.Director,NULL,b.Remark
    from oDepartment a,pYear_AnnualBonus_Process b
    where b.ID=@ID and ISNULL(a.IsDisabled,0)=0 and a.xOrder<>9999999999999 and a.DepGrade=2 and a.DepType in (2,3)
    and a.DepID not in (select AnnualBonusDepID from pYear_AnnualBonusDep where ISNULL(IsClosed,0)=0 and Year=b.Year and Date=b.Date)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 总部(奖金由总部发放员工)
    insert into pYear_AnnualBonusDep(Year,Date,AnnualBonusDepID,Director,IsSubmit,Remark)
    select b.Year,b.Date,780,a.SalaryContact,NULL,b.Remark
    from oCD_SalaryPayType a,pYear_AnnualBonus_Process b
    where b.ID=@ID and ISNULL(a.IsDisabled,0)=0 and a.Title=N'总部'
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    
    -- 插入年度奖金的表格
    ---- 员工
    --insert into pYear_AnnualBonus(Year,Date,AnnualBonusDepID,EMPDepID,EID)
    --select b.Year,b.Date,dbo.eFN_getdepid1st(a.DepID),a.DepID,a.EID
    --from eEmployee a,pYear_AnnualBonusDep b,oDepartment c,pYear_AnnualBonus_Process d
    --where d.ID=@ID and DATEDIFF(YY,d.Year,b.Year)=0 and DATEDIFF(MM,d.Date,b.Date)=0
    --and dbo.eFN_getdepid1st(a.DepID)=b.AnnualBonusDepID
    --and a.DepID=c.DepID and c.DepType in (2,3) and a.Status not in (4,5)
    --and a.EID not in (select EID from pYear_AnnualBonus)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新年度奖金流程状态
    update pYear_AnnualBonus_Process
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