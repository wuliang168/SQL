USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pEpidemicSuitation_Submit]
    @ReportTo int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 疫情现场办公新增员工确认
*/
Begin

    -- 在岗员工存在重复填报，无法提交！
    IF (select COUNT(CONVERT(VARCHAR(10),ESDate,120)) from pEpidemicSuitation a
    where CONVERT(VARCHAR(10),ESDate,120) in (select CONVERT(VARCHAR(10),ESDate,120) from pEpidemicSuitation where ReportTo=@ReportTo and Name=a.Name group by CONVERT(VARCHAR(10),ESDate,120) having count(CONVERT(VARCHAR(10),ESDate,120)) > 1)
    and ReportTo=@ReportTo and DATEDIFF(dd,ESDate,GETDATE())=0)>0
    Begin
        Set @RetVal=1100065
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pEpidemicSuitation --------
    -- 新增员工
    update pEpidemicSuitation
    set Submit=1,SubmitBy=@ReportTo,SubmitTime=GETDATE()
    Where ReportTo=@ReportTo and ISNULL(Submit,0)=0
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