USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[eSP_ProbCheck]    Script Date: 03/13/2017 13:28:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_ProbCheck]
--skydatarefresh eSP_ProbCheck
    @ID    int,
    @URID  int,
    @RetVal  int=0 Output
As
/*
-- Create By wuliang E004205
-- 试用管理的确认检查程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    --已经确认
    If Exists(Select 1 From eProb_Register Where ID=@ID And Isnull(Initialized,0)=1)
    Begin
        Set @RetVal =910000
		Return @RetVal
	End

    -- 试用期员工转正评估结果为空！
    If Exists(Select 1 From eProb_Register Where ID=@ID And Isnull(Result,0)=0)
    Begin
        Set @RetVal =920095
		Return @RetVal
	End

    -- 试用期员工转正日期未到！
    If Exists(Select 1 From eProb_Register Where ID=@ID And DATEDIFF(dd,getdate(),effectdate) > 0)
    Begin
        Set @RetVal =920096
		Return @RetVal
	End

    Begin TRANSACTION
    --将确认标志置为1
    Update a
    Set a.Initialized=1,a.InitializedBy=@URID,a.InitializedTime=Getdate()
    From eProb_Register a 
    Where a.ID=@ID
    -- 异常处理
    If @@Error<>0
    Goto ErrM

    -- 正常处理流程
    COMMIT TRANSACTION
    Set @RetVal = 0
    Return @RetVal

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    if isnull(@RetVal,0)=0
        Set @Retval = -1
        Return @RetVal

End