USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pEpidemicSuitation_EMPBlankAdd]
    @ReportTo int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 疫情现场办公新增空白外包员工
*/
Begin


    Begin TRANSACTION

    -------- pEpidemicSuitation --------
    -- 新增员工
    insert into pEpidemicSuitation(Type,CompID,DepID,DepID1st,DepID2nd,ReportTo,Location,ESDate)
    select 2,a.CompID,a.DepID,a.DepID1st,a.DepID2nd,@ReportTo,1,GETDATE()
    from pVW_employee a
    where a.EID=@ReportTo
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