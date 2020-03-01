USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_eBGChange_Remove]
    --skydatarefresh eSP_eBGChange_Remove
    @ID int,
    @EID int,
    @leftid int,
    @RetVal int=0 Output
AS
/*
-- Create By wuliang E004205
-- 背景信息调动登记表的添加员工程序
*/
Begin

    Begin TRANSACTION

    -- 更新背景信息调动
    ---- Initialized=0表示该背景做删除处理
    ---- eBG_Education_change
    update eBG_Education_change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=0
    Where ID=@ID and @leftid=1
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Working_change
    update eBG_Working_change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=0
    Where ID=@ID and @leftid=2
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Family_change
    update eBG_Family_change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=0
    Where ID=@ID and @leftid=3
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Emergency_change
    update eBG_Emergency_change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=0
    Where ID=@ID and @leftid=4
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM


    -- 正常流程处理
    COMMIT TRANSACTION
    Set @RetVal = 0
    Return @RetVal

    -- 异常流程处理
    ErrM:
    ROLLBACK TRANSACTION
    if isnull(@RetVal,0)=0
    Set @RetVal = -1
    Return @RetVal

End