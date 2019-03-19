USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pReserveTalents_ProcessStart]
-- skydatarefresh eSP_pReserveTalents_ProcessStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 后备人才流程开启程序
-- @ID 为后备人才流程月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 后备人才流程中分配月份为空，无法开启!
    If Exists(Select 1 From pReserveTalents_Process Where ID=@ID and ISNULL(Date,0)=1)
    Begin
        Set @RetVal = 960110
        Return @RetVal
    End

    -- 后备人才流程已开启，无法开启!
    If Exists(Select 1 From pReserveTalents_Process Where ID=@ID and Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 960120
        Return @RetVal
    End

    -- 后备人才流程已关闭，无法开启!
    If Exists(Select 1 From pReserveTalents_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 960130
        Return @RetVal
    End

    -- 上一次后备人才流程未关闭，无法开启!
    If Exists(Select 1 From pReserveTalents_Process Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 960140
        Return @RetVal
    End


    Begin TRANSACTION

    -- 插入后备人才流程的部门后备人才流程表项pReserveTalentsDep
    insert into pReserveTalentsDep(Date,DepID,Director,Remark)
    select distinct b.Date,(select depid from eEmployee where EID=a.Director),a.Director,c.Info
    from pVW_ReserveTalentsDep a,pReserveTalents_Process b,pReserveTalentsInfo c
    where b.ID=@ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0 and c.ID=1
    and a.Director not in (select Director from pReserveTalentsDep where ISNULL(IsSubmit,0)=0)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新后备人才流程状态
    update pReserveTalents_Process
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