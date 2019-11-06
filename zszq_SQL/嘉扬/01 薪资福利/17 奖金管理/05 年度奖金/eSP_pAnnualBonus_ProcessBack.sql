USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_pAnnualBonus_ProcessBack]
-- skydatarefresh eSP_pAnnualBonus_ProcessBack
    @ID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年度奖金流程退回程序
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

    -- 年度奖金流程未关闭!
    If Exists(Select 1 From pYear_AnnualBonus_Process Where ID=@ID and ISNULL(Closed,0)=NULL)
    Begin
        Set @RetVal = 930345
        Return @RetVal
    End

    Begin TRANSACTION

    -- 插入年度奖金流程的历史表项pYear_AnnualBonus_all
    insert into pYear_AnnualBonus(ProcessID,Year,Date,AnnualBonusDepID,EMPDepID,EID,BID,Identification,AnnualBonusType,AnnualBonus,Lock,Remark)
    select a.ProcessID,a.Year,a.Date,a.AnnualBonusDepID,a.EMPDepID,a.EID,a.BID,a.Identification,a.AnnualBonusType,a.AnnualBonus,a.Lock,a.Remark
    from pYear_AnnualBonus_all a
    where a.ProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pYear_AnnualBonusDep
    update a
    set a.IsClosed=NULL
    from pYear_AnnualBonusDep a
    where a.ProcessID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新年度奖金流程状态
    update a
    set a.Closed=NULL,a.ClosedTime=NULL
    from pYear_AnnualBonus_Process a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除年度奖金统计表项
    delete from pYear_AnnualBonus_all
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