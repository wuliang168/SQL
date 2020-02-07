USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pEpidemicSuitation_RedDup]
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 疫情现场办公去除重复操作
*/
Begin


    Begin TRANSACTION

    ---- 去除当日重复递交的员工
    delete from pEpidemicSuitation
    where ISNULL(EID,BID) in (select ISNULL(EID,BID) from pEpidemicSuitation where DATEDIFF(DD,ESDate,GETDATE())=0 group by ISNULL(EID,BID) having count(ISNULL(EID,BID)) > 1)
    and ID not in (select min(ID) from pEpidemicSuitation where DATEDIFF(DD,ESDate,GETDATE())=0 group by ISNULL(EID,BID) having count(ISNULL(EID,BID)) > 1)
    and DATEDIFF(DD,ESDate,GETDATE())=0
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