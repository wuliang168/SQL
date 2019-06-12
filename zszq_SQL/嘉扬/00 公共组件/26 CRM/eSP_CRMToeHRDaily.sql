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


    -- 如果pVW_CRM_Staff的Identification未出现在pCRMStaff中，则插入该Identification
    insert into pCRMStaff
        (Identification,Name,DepID,DepAbbr,DepxOrder,JobTitle,Status,JoinDate,WorkDate,
        Party,ConBeginDate,ConEndDate,HighLevel,HighDegree,Mobile,Telephone,LeaDate)
    select Identification, Name, DepID, DepAbbr, DepxOrder, JobTitle, Status, JoinDate, WorkDate, Party,
        ConBeginDate, ConEndDate, HighLevel, HighDegree, Mobile, Telephone, LeaDate
    from pVW_CRM_Staff
    where Identification in (select Identification
        from pVW_CRM_Staff
        where LEN(Identification)<=18 and DepID is not NULL
        except
        select Identification
        from pCRMStaff)
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

    -- 如果pVW_CRM_Staff的DepID或Status变更时，则同步更新pCRMStaff的DepID或Status
    update a
        set a.DepID=(select DepID from pVW_CRM_Staff where Identification=a.Identification),
        a.Status=(select Status from pVW_CRM_Staff where Identification=a.Identification)
        from pCRMStaff a,
        (select Identification,DepID,Status from pVW_CRM_Staff
        where LEN(Identification)<=18 and DepID is not NULL
        except
        select Identification,DepID,Status
        from pCRMStaff) b
        where a.Identification=b.Identification
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

End