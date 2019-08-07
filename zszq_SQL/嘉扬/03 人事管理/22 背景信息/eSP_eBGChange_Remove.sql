USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_eBGChange_Remove]
    --skydatarefresh eSP_eBGChange_Remove
    @ID int,
    @EID int,
    @leftid int,
    @RetVal int=0 Output
AS
/*
-- Create By wuliang E004205
-- 背景信息调动登记表的添加员工程序
*/
Begin

    Begin TRANSACTION

    -- 更新背景信息调动
    ---- eBG_Education_change
    update eBG_Education_change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=0
    Where ID=@ID and @leftid=1
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Working_change
    update eBG_Working_change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=0
    Where ID=@ID and @leftid=2
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Family_change
    update eBG_Family_change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=0
    Where ID=@ID and @leftid=3
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Emergency_change
    update eBG_Emergency_change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=0
    Where ID=@ID and @leftid=4
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM

    
    -- 删除原项
    ---- eBG_Education
    delete from eBG_Education where ID=(select oldID from eBG_Education_Change where ID=@ID and @leftid=1 and IsSubmit=1 and Initialized=0)
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Working
    delete from eBG_Working where ID=(select oldID from eBG_Working_Change where ID=@ID and @leftid=2 and IsSubmit=1 and Initialized=0)
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Family
    delete from eBG_Family where ID=(select oldID from eBG_Family_Change where ID=@ID and @leftid=3 and IsSubmit=1 and Initialized=0)
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Emergency
    delete from eBG_Emergency where ID=(select oldID from eBG_Emergency_Change where ID=@ID and @leftid=4 and IsSubmit=1 and Initialized=0)
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM


    -- 先拷贝到历史
    ---- eBG_Education_change
    insert into eBG_Education_all(oldID,EID,BID,BeginDate,endDate,SchoolName,GradType,StudyType,EduType,DegreeType,DegreeName,Major,EduNo,
    EduNoDate,DegreeNo,DegreeNoDate,SchoolPlace,Reference,Tel,isout,remark,majortype,Initialized,IsSubmit,SubmitBy,SubmitTime)
    select a.oldID,a.EID,a.BID,a.BeginDate,a.endDate,a.SchoolName,a.GradType,a.StudyType,a.EduType,a.DegreeType,a.DegreeName,a.Major,a.EduNo,
    a.EduNoDate,a.DegreeNo,a.DegreeNoDate,a.SchoolPlace,a.Reference,a.Tel,a.isout,a.remark,a.majortype,a.Initialized,a.IsSubmit,a.SubmitBy,a.SubmitTime
    From eBG_Education_Change a
    where a.ID=@ID and @leftid=1 and a.IsSubmit=1 and a.Initialized=0
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Working_change
    insert into eBG_Working_all(oldID,EID,BID,begindate,enddate,company,job,workplace,Reference,Tel,isout,remark,Wyear,
    institution,leavereason,Initialized,IsSubmit,SubmitBy,SubmitTime)
    select a.oldID,a.EID,a.BID,a.begindate,a.enddate,a.company,a.job,a.workplace,a.Reference,a.Tel,a.isout,a.remark,a.Wyear,
    a.institution,a.leavereason,a.Initialized,a.IsSubmit,a.SubmitBy,a.SubmitTime
    from eBG_Working_Change a
    where a.ID=@ID and @leftid=2 and a.IsSubmit=1 and a.Initialized=0
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Family_change
    insert into eBG_Family_all(oldID,EID,BID,Fname,relation,gender,Birthday,Company,Job,status,remark,tel,address,CERTID,
    IsSuppMedIns,isyj,OversResidNo,Initialized,IsSubmit,SubmitBy,SubmitTime)
    select a.oldID,a.EID,a.BID,a.Fname,a.relation,a.gender,a.Birthday,a.Company,a.Job,a.status,a.remark,a.tel,a.address,a.CERTID,
    a.IsSuppMedIns,a.isyj,a.OversResidNo,a.Initialized,a.IsSubmit,a.SubmitBy,a.SubmitTime
    from eBG_Family_Change a
    where a.ID=@ID and @leftid=3 and a.IsSubmit=1 and a.Initialized=0
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Emergency_change
    insert into eBG_Emergency_all(oldID,EID,BID,EmergencyName,Relation,Telephone,address,email,PostCode,
    Remark,Initialized,IsSubmit,SubmitBy,SubmitTime)
    select a.oldID,a.EID,a.BID,a.EmergencyName,a.Relation,a.Telephone,a.address,a.email,a.PostCode,
    a.Remark,a.Initialized,a.IsSubmit,a.SubmitBy,a.SubmitTime
    from eBG_Emergency_Change a
    where a.ID=@ID and @leftid=4 and a.IsSubmit=1 and a.Initialized=0
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM


    -- 删除调整项
    ---- eBG_Education_Change
    delete from eBG_Education_Change where ID=@ID and @leftid=1 and IsSubmit=1 and Initialized=0
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Working_Change
    delete from eBG_Working_Change where ID=@ID and @leftid=2 and IsSubmit=1 and Initialized=0
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Family_Change
    delete from eBG_Family_Change where ID=@ID and @leftid=3 and IsSubmit=1 and Initialized=0
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Emergency_Change
    delete from eBG_Emergency_Change where ID=@ID and @leftid=4 and IsSubmit=1 and Initialized=0
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM


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