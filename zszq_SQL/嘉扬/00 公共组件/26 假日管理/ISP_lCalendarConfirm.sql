USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[ISP_lCalendarConfirm]
    @id int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 假日管理确定程序
*/
Begin


    Begin TRANSACTION

    -------- lCalendar --------
    update lCalendar
    set Initialized=1,InitializedTime=GETDATE()
    where id=@id
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