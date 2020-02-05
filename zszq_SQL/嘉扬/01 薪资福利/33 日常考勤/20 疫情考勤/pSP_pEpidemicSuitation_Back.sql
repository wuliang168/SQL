USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pEpidemicSuitation_Back]
    @ID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 疫情现场办公新增员工确认
*/
Begin


    Begin TRANSACTION

    -------- pEpidemicSuitation --------
    -- 新增员工
    update pEpidemicSuitation
    set Submit=NULL,SubmitBy=NULL,SubmitTime=NULL
    Where ID=@ID
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