USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_pReserveTalentsEMPAdd]
    @EID int,
    @RetVal int=0 Output
AS
/*
-- Create By wuliang
-- 后备人才部门添加
-- @AppraiseEID 为后备人才评选人，前台通过{U_EID}全局参数获取
*/
Begin

    -- 后备人才员工请勿重复添加!
    IF Exists(Select 1 From pReserveTalents_Register Where EID=@EID)
    Begin
        Set @RetVal=960150
        Return @RetVal
    End


    Begin TRANSACTION

    -- 添加后备人才团队
    Insert Into pReserveTalents_Register(Date,Director,EID,Badge,Name,CompID,DepID1st,DepID2nd,Age,cYear,JobID,Education,Degree,MDID,
    LLYAssessRanking,BLYAssessRanking,LYAssessRanking)
    select b.Date,a.Director,a.EID,a.Badge,a.Name,a.CompID,a.DepID1st,a.DepID2nd,a.Age,a.cYear,a.JobID,a.Education,a.Degree,a.MDID,
    a.LLYAssessRanking,a.BLYAssessRanking,a.LYAssessRanking
    from pVW_ReserveTalentsPool a,pReserveTalents_Process b
    where a.EID=@EID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -- 正常处理流程
    COMMIT TRANSACTION
    Set @RetVal=0
    Return @RetVal

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    If isnull(@RetVal,0)=0
        Set @RetVal=-1
    Return @RetVal

End