USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pReserveTalents_ProcessClose]
-- skydatarefresh eSP_pReserveTalents_ProcessClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 后备人才流程关闭程序
-- @ID 为后备人才流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 后备人才流程未开启，无法关闭!
    If Exists(Select 1 From pReserveTalents_Process Where ID=@ID and Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 960150
        Return @RetVal
    End

    -- 后备人才流程已关闭，无法关闭!
    If Exists(Select 1 From pReserveTalents_Process Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 960160
        Return @RetVal
    End

    Begin TRANSACTION

    -- 插入后备人才流程的历史表项pReserveTalents_all
    insert into pReserveTalents_all(Director,EID,Badge,Name,CompID,DepID1st,DepID2nd,Age,cYear,JobID,Education,Degree,MDID,
    LLYAssessRanking,BLYAssessRanking,LYAssessRanking,ReserveTalentsType,Remark)
    select a.Director,a.EID,a.Badge,a.Name,a.CompID,a.DepID1st,a.DepID2nd,a.Age,a.cYear,a.JobID,a.Education,a.Degree,a.MDID,
    a.LLYAssessRanking,a.BLYAssessRanking,a.LYAssessRanking,a.ReserveTalentsType,Remark
    from pReserveTalents_Register a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pReserveTalentsDep
    update b
    set b.IsSubmit=1
    from pReserveTalents_Process a,pReserveTalentsDep b
    where a.ID=@ID and a.Date=b.Date and ISNULL(b.IsSubmit,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新后备人才流程状态
    update a
    set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    from pReserveTalents_Process a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除后备人才统计表项
    delete from pReserveTalents_Register
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