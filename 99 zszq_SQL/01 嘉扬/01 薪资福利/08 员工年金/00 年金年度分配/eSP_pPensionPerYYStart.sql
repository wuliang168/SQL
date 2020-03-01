USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionPerYYStart]
-- skydatarefresh eSP_pPensionPerYYStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配年度开启程序
-- @ID 为年金计划分配年度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 年度年金计划分配总额为空!
    If Exists(Select 1 From pPensionPerYY Where ID=@ID and Isnull(PensionYearTotal,0)=1)
    Begin
        Set @RetVal = 930061
        Return @RetVal
    End

    -- 年度年金计划分配已开启!
    If Exists(Select 1 From pPensionPerYY Where ID=@ID and ISNULL(Submit,0)=1)
    Begin
        Set @RetVal = 930062
        Return @RetVal
    End

    -- 年度年金计划分配已关闭!
    If Exists(Select 1 From pPensionPerYY Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930063
        Return @RetVal
    End

    Begin TRANSACTION

    -- 更新年度年金计划分配表项pPensionPerYY
    ---- 更新开启信息
    Update a
    Set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE(),a.IsDisMM=1
    From pPensionPerYY a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 更新月度分配状态
    --Update a
    --Set a.IsDisMM=NULL
    --From pPensionPerYY a
    --Where a.ID<@ID and ISNULL(a.Closed,0)=1
    ---- 异常流程
    --If @@Error<>0
    --Goto ErrM


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