USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pYear_ReportEvalSubmit]
    @EID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- EID Submit
*/
Begin

    -------- pYear_ReportEval --------

    -- 考核评分为空，无法递交考核评分！
    IF Exists(select 1 from pYear_ReportEval a
    where a.Eval_EID=@EID AND a.ScoreTotal is NULL)
    Begin
        Set @RetVal=1002130
        Return @RetVal
    End

    -- 考核评分超出上限，无法递交员工考核评分！
    IF Exists(select 1 from pYear_ReportEval where Eval_EID=@EID
    and (Score1 not between 0 and 20 or Score2 not between 0 and 20 
    or Score3 not between 0 and 20 or Score4 not between 0 and 20
    or Score5 not between 0 and 20 or ScoreTotal not between 0 and 100))
    Begin
        Set @RetVal=1002120
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pYear_ReportEval --------
    -- Set Current Submit=1
    ---- 非合规普通员工
    update a
    set a.Submit=1,a.SubmitBy=@EID,a.SubmitTime=GETDATE()
    from pYear_ReportEval a
    where a.Eval_EID=@EID
    -- Exception
    IF @@Error <> 0
    Goto ErrM


    -- Common Control Flow
    COMMIT TRANSACTION
    Set @RetVal=0
    Return @RetVal

    -- Exception Control Flow
    ErrM:
    ROLLBACK TRANSACTION
    If ISNULL(@RetVal,0)=0
        Set @RetVal=-1
        Return @RetVal
End