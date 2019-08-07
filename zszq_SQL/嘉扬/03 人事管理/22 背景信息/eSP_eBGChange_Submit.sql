USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_eBGChange_Submit]
    --skydatarefresh eSP_eBGChange_Submit
    @EID int,
    @leftid int,
    @RetVal int=0 Output
AS
/*
-- Create By wuliang E004205
-- 背景信息调动登记表的添加员工程序
*/
Begin

    -- 教育背景信息填写不完整，无法递交！
    IF Exists(Select 1 From eBG_Education_Change Where EID=@EID and @leftid=1 and ISNULL(Initialized,0)=0
    and (BeginDate is NULL or SchoolName is NULL or GradType is NULL or StudyType is NULL
    -- or endDate is NULL or EduType is NULL or DegreeType is NULL or DegreeName is NULL or Major is NULL or EduNo is NULL or EduNoDate is NULL
    -- or DegreeNo is NULL or DegreeNoDate is NULL or SchoolPlace is NULL or Reference is NULL or Tel is NULL or majortype is NULL
    ))
    Begin
        Set @RetVal=920210
        Return @RetVal
    End

    -- 工作经历信息填写不完整，无法递交！
    IF Exists(Select 1 From eBG_Working_Change Where EID=@EID and @leftid=2 and ISNULL(Initialized,0)=0
    and (begindate is NULL or company is NULL or job is NULL or workplace is NULL or institution is NULL
    -- or enddate is NULL or Reference is NULL or Tel is NULL or isout is NULL or Wyear is NULL or leavereason is NULL
    ))
    Begin
        Set @RetVal=920220
        Return @RetVal
    End

    -- 家庭背景信息填写不完整，无法递交！
    IF Exists(Select 1 From eBG_Family_Change Where EID=@EID and @leftid=3 and ISNULL(Initialized,0)=0
    and (Fname is NULL or relation is NULL or gender is NULL or Birthday is NULL or CERTID is NULL
    -- or Company is NULL or Job is NULL or status is NULL or remark is NULL or tel is NULL or address is NULL 
    -- or IsSuppMedIns is NULL or isyj is NULL or OversResidNo is NULL
    ))
    Begin
        Set @RetVal=920230
        Return @RetVal
    End

    -- 身份证编号输入错误，请再次填写确认!
    IF Exists(Select 1 from eBG_Family_Change WHERE EID=@EID and @leftid=3 and ISNULL(Initialized,0)=0 
    and ((CERTID<>dbo.eFN_CID18CheckSum(CERTID) AND Len(CERTID)=18) or Len(CERTID)<>18 or CERTID IS NULL))
    Begin
        Set @RetVal=920033
        Return @RetVal
    End

    -- 紧急联系人信息填写不完整，无法递交！
    IF Exists(Select 1 From eBG_Emergency_Change Where EID=@EID and @leftid=4 and ISNULL(Initialized,0)=0
    and (EmergencyName is NULL or Relation is NULL or Telephone is NULL 
    -- or address is NULL or email is NULL or PostCode is NULL
    ))
    Begin
        Set @RetVal=920240
        Return @RetVal
    End

    Begin TRANSACTION

    -- 更新员工背景信息
    ---- eBG_Education
    update a
    set a.BeginDate=b.BeginDate,a.endDate=b.endDate,a.SchoolName=b.SchoolName,a.GradType=b.GradType,a.StudyType=b.StudyType,a.EduType=b.EduType,
    a.DegreeType=b.DegreeType,a.DegreeName=b.DegreeName,a.Major=b.Major,a.EduNo=b.EduNo,a.EduNoDate=b.EduNoDate,a.DegreeNo=b.DegreeNo,
    a.DegreeNoDate=b.DegreeNoDate,a.SchoolPlace=b.SchoolPlace,a.Reference=b.Reference,a.Tel=b.Tel,a.isout=b.isout,a.remark=b.remark,a.majortype=b.majortype
    from eBG_Education a,eBG_Education_Change b
    where a.ID=b.oldID and b.EID=@EID and @leftid=1 and b.Initialized is NULL
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Working
    update a
    set a.begindate=b.begindate,a.enddate=b.enddate,a.company=b.company,a.job=b.job,a.workplace=b.workplace,a.Reference=b.Reference,
    a.Tel=b.Tel,a.isout=b.isout,a.remark=b.remark,a.Wyear=b.Wyear,a.institution=b.institution,a.leavereason=b.leavereason
    from eBG_Working a,eBG_Working_Change b
    where a.ID=b.oldID and b.EID=@EID and @leftid=2 and b.Initialized is NULL
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Family
    update a
    set a.Fname=b.Fname,a.relation=b.relation,a.gender=b.gender,a.Birthday=b.Birthday,a.Company=b.Company,a.Job=b.Job,a.status=b.status,
    a.remark=b.remark,a.tel=b.tel,a.address=b.address,a.CERTID=b.CERTID,a.isyj=b.isyj,a.OversResidNo=b.OversResidNo
    from eBG_Family a,eBG_Family_Change b
    where a.ID=b.oldID and b.EID=@EID and @leftid=3 and b.Initialized is NULL
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Emergency
    update a
    set a.EmergencyName=b.EmergencyName,a.Relation=b.Relation,a.Telephone=b.Telephone,a.address=b.address,a.email=b.email,a.PostCode=b.PostCode,a.Remark=b.Remark
    from eBG_Emergency a,eBG_Emergency_Change b
    where a.ID=b.oldID and b.EID=@EID and @leftid=4 and b.Initialized is NULL
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM


    -- 更新递交状态
    ---- eBG_Education_Change
    update eBG_Education_Change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=1
    where EID=@EID and @leftid=1 and Initialized is NULL
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Working_Change
    update eBG_Working_Change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=1
    where EID=@EID and @leftid=2 and Initialized is NULL
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Family_Change
    update eBG_Family_Change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=1
    where EID=@EID and @leftid=3 and Initialized is NULL
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Emergency_Change
    update eBG_Emergency_Change
    set IsSubmit=1,SubmitBy=@EID,SubmitTime=GETDATE(),Initialized=1
    where EID=@EID and @leftid=4 and Initialized is NULL
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM


    -- 记录备份
    -- eBG_Education_all
    insert into eBG_Education_all(oldID,EID,BID,BeginDate,endDate,SchoolName,GradType,StudyType,EduType,DegreeType,DegreeName,Major,EduNo,
    EduNoDate,DegreeNo,DegreeNoDate,SchoolPlace,Reference,Tel,isout,remark,majortype,Initialized,IsSubmit,SubmitBy,SubmitTime)
    select a.oldID,a.EID,a.BID,a.BeginDate,a.endDate,a.SchoolName,a.GradType,a.StudyType,a.EduType,a.DegreeType,a.DegreeName,a.Major,a.EduNo,
    a.EduNoDate,a.DegreeNo,a.DegreeNoDate,a.SchoolPlace,a.Reference,a.Tel,a.isout,a.remark,a.majortype,a.Initialized,a.IsSubmit,a.SubmitBy,a.SubmitTime
    From eBG_Education_Change a
    where EID=@EID and @leftid=1 and ISNULL(a.IsSubmit,0)=1
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    -- eBG_Working_all
    insert into eBG_Working_all(oldID,EID,BID,begindate,enddate,company,job,workplace,Reference,Tel,isout,remark,Wyear,
    institution,leavereason,Initialized,IsSubmit,SubmitBy,SubmitTime)
    select a.oldID,a.EID,a.BID,a.begindate,a.enddate,a.company,a.job,a.workplace,a.Reference,a.Tel,a.isout,a.remark,a.Wyear,
    a.institution,a.leavereason,a.Initialized,a.IsSubmit,a.SubmitBy,a.SubmitTime
    from eBG_Working_Change a
    where EID=@EID and @leftid=2 and ISNULL(a.IsSubmit,0)=1
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    -- eBG_Family_all
    insert into eBG_Family_all(oldID,EID,BID,Fname,relation,gender,Birthday,Company,Job,status,remark,tel,address,CERTID,
    IsSuppMedIns,isyj,OversResidNo,Initialized,IsSubmit,SubmitBy,SubmitTime)
    select a.oldID,a.EID,a.BID,a.Fname,a.relation,a.gender,a.Birthday,a.Company,a.Job,a.status,a.remark,a.tel,a.address,a.CERTID,
    a.IsSuppMedIns,a.isyj,a.OversResidNo,a.Initialized,a.IsSubmit,a.SubmitBy,a.SubmitTime
    from eBG_Family_Change a
    where EID=@EID and @leftid=3 and ISNULL(a.IsSubmit,0)=1
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    -- eBG_Emergency_all
    insert into eBG_Emergency_all(oldID,EID,BID,EmergencyName,Relation,Telephone,address,email,PostCode,
    Remark,Initialized,IsSubmit,SubmitBy,SubmitTime)
    select a.oldID,a.EID,a.BID,a.EmergencyName,a.Relation,a.Telephone,a.address,a.email,a.PostCode,
    a.Remark,a.Initialized,a.IsSubmit,a.SubmitBy,a.SubmitTime
    from eBG_Emergency_Change a
    where EID=@EID and @leftid=4 and ISNULL(a.IsSubmit,0)=1
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    

    -- 删除
    ---- eBG_Education_Change
    delete from eBG_Education_Change where EID=@EID and @leftid=1
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Working_Change
    delete from eBG_Working_Change where EID=@EID and @leftid=2
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Family_Change
    delete from eBG_Family_Change where EID=@EID and @leftid=3
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM
    ---- eBG_Emergency_Change
    delete from eBG_Emergency_Change where EID=@EID and @leftid=4
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