USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pAnnualBonus_ProcessClose]
-- skydatarefresh eSP_pAnnualBonus_ProcessClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度奖金流程关闭程序
-- @ID 为年度奖金流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 年度奖金流程未开启!
    If Exists(Select 1 From pYear_AnnualBonus_Process Where ID=@ID and Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930360
        Return @RetVal
    End

    -- 年度奖金流程已关闭!
    If Exists(Select 1 From pYear_AnnualBonus_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930340
        Return @RetVal
    End

    Begin TRANSACTION

    -- 插入年度奖金流程的历史表项pYear_AnnualBonus_all
    insert into pYear_AnnualBonus_all(ProcessID,Year,Date,AnnualBonusDepID,EMPDepID,EID,BID,Identification,AnnualBonusType,AnnualBonus,Lock,Remark)
    select a.ProcessID,a.Year,a.Date,a.AnnualBonusDepID,a.EMPDepID,a.EID,a.BID,a.Identification,a.AnnualBonusType,a.AnnualBonus,a.Lock,a.Remark
    from pYear_AnnualBonus a,pYear_AnnualBonus_Process b
    where a.ProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pYear_AnnualBonusDep
    update b
    set b.IsClosed=1
    from pYear_AnnualBonus_Process a,pYear_AnnualBonusDep b
    where a.ID=@ID and a.ID=b.ProcessID and ISNULL(b.IsClosed,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新年度奖金流程状态
    update a
    set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    from pYear_AnnualBonus_Process a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除年度奖金统计表项
    delete from pYear_AnnualBonus
    where ProcessID=@ID
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