USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_CRMToeHRDaily]
    @RetVal int=0 Output
as
Begin

    Begin TRANSACTION
    
    IF Exists (select 1 from pVW_CRM_Staff where Identification not in (select Identification from pCRMStaff where DepID is not NULL))
    Begin
        -- 如果pVW_CRM_Staff的Identification未出现在pCRMStaff中，则插入该Identification
        insert into pCRMStaff(Identification,Name,DepID,DepAbbr,DepxOrder,JobTitle,Status,JoinDate,WorkDate,
        Party,ConBeginDate,ConEndDate,HighLevel,HighDegree,Mobile,Telephone,LeaDate)
        select Identification,Name,DepID,DepAbbr,DepxOrder,JobTitle,Status,JoinDate,WorkDate,Party,
        ConBeginDate,ConEndDate,HighLevel,HighDegree,Mobile,Telephone,LeaDate
        from pVW_CRM_Staff
        where Identification not in (select Identification from pCRMStaff) and DepID is not NULL
        -- 异常处理
        IF @@Error <> 0
        Goto ErrM
        -- 生成BID和Badge
        Update a
        Set BID=a.ID+9000100,a.Badge='B'+REPLICATE('0',6-len(a.ID+100))+CAST(a.ID+100 as varchar(6))
        From pCRMStaff a
        Where a.BID is NULL
        -- 异常处理
        IF @@Error <> 0
        Goto ErrM
    End
    ELSE
    Begin
        -- 如果pVW_CRM_Staff的Identification出现在pCRMStaff中，则更新该Identification
        update a
        set a.Name=b.Name,a.DepID=b.DepID,a.DepAbbr=b.DepAbbr,a.DepxOrder=b.DepxOrder,a.JobTitle=b.JobTitle,a.Status=b.Status,
        a.JoinDate=b.JoinDate,a.WorkDate=b.WorkDate,a.Party=b.Party,a.ConBeginDate=b.ConBeginDate,a.ConEndDate=b.ConEndDate,
        a.HighLevel=b.HighLevel,a.HighDegree=b.HighDegree,a.Mobile=b.Mobile,a.Telephone=b.Telephone,a.LeaDate=b.LeaDate
        from pCRMStaff a,pVW_CRM_Staff b
        where a.Identification=b.Identification
        -- 异常处理
        IF @@Error <> 0
        Goto ErrM
    End

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

End