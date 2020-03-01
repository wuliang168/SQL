USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_eBGChange_AddEMP]
    --skydatarefresh eSP_eBGChange_AddEMP
    @EID int,
    @leftid int,
    @RetVal int=0 Output
AS
/*
-- Create By wuliang E004205
-- 背景信息调动登记表的添加员工程序
*/
Begin

    -- 登记表已经添加该员工!
    IF Exists(Select 1 From pVW_eBG_Change Where EID=@EID and ChangeType=@leftid)
    Begin
        Set @RetVal=920065
        Return @RetVal
    End

    Begin TRANSACTION

    -- 插入背景信息调动调动登记表
    ---- eBG_Education_change
    IF Exists (select 1 from eBG_Education where EID=@EID and @leftid=1)
    BEGIN
        Insert Into eBG_Education_change(oldID,EID,BID,BeginDate,endDate,SchoolName,GradType,StudyType,EduType,DegreeType,DegreeName,Major,EduNo,
        EduNoDate,DegreeNo,DegreeNoDate,SchoolPlace,Reference,Tel,isout,remark,majortype,Initialized)
        select a.ID,a.EID,NULL,a.BeginDate,a.endDate,a.SchoolName,a.GradType,a.StudyType,a.EduType,a.DegreeType,a.DegreeName,a.Major,a.EduNo,
        a.EduNoDate,a.DegreeNo,a.DegreeNoDate,a.SchoolPlace,a.Reference,a.Tel,a.isout,a.remark,a.majortype,1
        From eBG_Education a
        Where a.EID=@EID and @leftid=1
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    END
    ---- 如果该员工一条记录都没有
    else  if @leftid=1
    BEGIN
        Insert Into eBG_Education_change(EID,Initialized)
        values(@EID,1)
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    END

    ---- eBG_Working_change
    IF Exists (select 1 from eBG_Working where EID=@EID and @leftid=2)
    BEGIN
        Insert Into eBG_Working_change(oldID,EID,BID,begindate,enddate,company,job,workplace,Reference,Tel,isout,remark,Wyear,institution,leavereason,Initialized)
        select a.ID,a.EID,NULL,a.begindate,a.enddate,a.company,a.job,a.workplace,a.Reference,a.Tel,a.isout,a.remark,a.Wyear,a.institution,a.leavereason,1
        From eBG_Working a
        Where a.EID=@EID and @leftid=2
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    END
    ---- 如果该员工一条记录都没有
    else  if @leftid=2
    BEGIN
        Insert Into eBG_Working_change(EID,Initialized)
        values(@EID,1)
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    END

    ---- eBG_Family_change
    IF Exists (select 1 from eBG_Family where EID=@EID and @leftid=3)
    BEGIN
        Insert Into eBG_Family_change(oldID,EID,BID,Fname,relation,gender,Birthday,Company,Job,status,remark,tel,address,CERTID,IsSuppMedIns,isyj,OversResidNo,Initialized)
        select a.ID,a.EID,NULL,a.Fname,a.relation,a.gender,a.Birthday,a.Company,a.Job,a.status,a.remark,a.tel,a.address,a.CERTID,a.IsSuppMedIns,a.isyj,a.OversResidNo,1
        From eBG_Family a
        Where a.EID=@EID and @leftid=3
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    END
    ---- 如果该员工一条记录都没有
    else  if @leftid=3
    BEGIN
        Insert Into eBG_Family_change(EID,Initialized)
        values(@EID,1)
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    END

    ---- eBG_Emergency_change
    IF Exists (select 1 from eBG_Emergency where EID=@EID and @leftid=4)
    BEGIN
        Insert Into eBG_Emergency_change(oldID,EID,BID,EmergencyName,Relation,Telephone,address,email,PostCode,Remark,Initialized)
        select a.ID,a.EID,NULL,a.EmergencyName,a.Relation,a.Telephone,a.address,a.email,a.PostCode,a.Remark,1
        From eBG_Emergency a
        Where a.EID=@EID and @leftid=4
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    END
    ---- 如果该员工一条记录都没有
    else if @leftid=4
    BEGIN
        Insert Into eBG_Emergency_change(EID,Initialized)
        values(@EID,1)
        -- 异常状态判断
        If @@Error<>0
        Goto ErrM
    END

    -- 正常流程处理
    COMMIT TRANSACTION
    Set @RetVal = 0
    Return @RetVal

    -- 异常流程处理
    ErrM:
    ROLLBACK TRANSACTION
    if isnull(@RetVal,0)=0
    Set @RetVal = -1
    Return @RetVal

End