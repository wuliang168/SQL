USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_eBGChange_Append]
    --skydatarefresh eSP_eBGChange_Append
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

    -- 开启背景信息调动
    ---- eBG_Education_change
    if @leftid=1
    Begin
        insert into eBG_Education_change(EID)
        values (@EID)
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    End
    ---- eBG_Working_change
    if @leftid=2
    Begin
        insert into eBG_Working_change(EID)
        values (@EID)
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    End
    ---- eBG_Family_change
    if @leftid=3
    Begin
        insert into eBG_Family_change(EID)
        values (@EID)
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    End
    ---- eBG_Emergency_change
    if @leftid=4
    Begin
        insert into eBG_Emergency_change(EID)
        values (@EID)
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    End

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