USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pReserveTalentsBSSubmit]
    @EID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 后备人才个人自评递交
*/
Begin

    -- 后备人才评选个人未选择后备人才类型，无法递交！
    ---- 相同的团队
    IF Exists(select 1 from pReserveTalents_Register where Director=@EID and ReserveTalentsType is NULL)
    Begin
        Set @RetVal=960160
        Return @RetVal
    End
    

    Begin TRANSACTION

    -------- pReserveTalentsDep --------
    -- 更新后备人才部门负责人递交状态
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pReserveTalentsDep a
    where a.Director=@EID
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
end