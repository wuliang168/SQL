USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pYear_AppraiseBSSubmit]
    @EID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 年度考核个人自评递交
*/
Begin

    -- 年度评优候选单位/个人出现重复，无法递交年度评优！
    ---- 相同的团队
    IF Exists(select 1 from pYear_Appraise where AppraiseEID=@EID and DepID is not NULL
    group by AppraiseEID,DepID,AppraiseID having COUNT(DepID)>1)
    Begin
        Set @RetVal=1003105
        Return @RetVal
    End
    ---- 相同的个人
    ------ 后台
    IF Exists(select 1 from pYear_Appraise where AppraiseEID=@EID and EID is not NULL
    group by AppraiseEID,EID,AppraiseID having COUNT(EID)>1)
    Begin
        Set @RetVal=1003105
        Return @RetVal
    End
    ------ 前台
    IF Exists(select 1 from pYear_Appraise where AppraiseEID=@EID and Identification is not NULL
    group by AppraiseEID,Identification,AppraiseID having COUNT(Identification)>1)
    Begin
        Set @RetVal=1003105
        Return @RetVal
    End


    -- 年度评优候选单位/个人原因为空，无法递交年度评优！
    ---- 相同的团队
    IF Exists(select 1 from pYear_Appraise where AppraiseEID=@EID and Reason is NULL)
    Begin
        Set @RetVal=1003106
        Return @RetVal
    End


    -- 年度最高荣誉奖卓越团队候选单位超过名额范围，无法递交年度评优！
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=1 and AppraiseEID=@EID)
    >ISNULL(a.DepLimit,a.Limit) and AppraiseID=1 and AppraiseEID=@EID)
    Begin
        Set @RetVal=1003110
        Return @RetVal
    End

    -- 年度最高荣誉奖浙商之星候选个人超过名额范围，无法递交年度评优！
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=2 and AppraiseEID=@EID)
    >ISNULL(a.DepLimit,a.Limit) and AppraiseID=2 and AppraiseEID=@EID)
    Begin
        Set @RetVal=1003120
        Return @RetVal
    End

    -- 年度专业团队奖转型创新先锋团队候选单位超过名额范围，无法递交年度评优！
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=3 and AppraiseEID=@EID)
    >ISNULL(a.DepLimit,a.Limit) and AppraiseID=3 and AppraiseEID=@EID)
    Begin
        Set @RetVal=1003130
        Return @RetVal
    End

    -- 年度专业团队奖进步最快团队候选单位超过名额范围，无法递交年度评优！
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=4 and AppraiseEID=@EID)
    >ISNULL(a.DepLimit,a.Limit) and AppraiseID=4 and AppraiseEID=@EID)
    Begin
        Set @RetVal=1003140
        Return @RetVal
    End

    -- 年度专业标兵奖管理英才候选个人超过名额范围，无法递交年度评优！
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=5 and AppraiseEID=@EID)
    >ISNULL(a.DepLimit,a.Limit) and AppraiseID=5 and AppraiseEID=@EID)
    Begin
        Set @RetVal=1003150
        Return @RetVal
    End

    -- 年度专业标兵奖优秀经理人候选个人超过名额范围，无法递交年度评优！
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=6 and AppraiseEID=@EID)
    >ISNULL(a.DepLimit,a.Limit) and a.AppraiseID=6 and a.AppraiseEID=@EID)
    Begin
        Set @RetVal=1003160
        Return @RetVal
    End

    -- 年度专业标兵奖展业精英候选个人超过名额范围，无法递交年度评优！
    ---- 最大名额范围
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=7 and AppraiseEID=@EID)
    >a.Limit and AppraiseID=7 and AppraiseEID=@EID)
    Begin
        Set @RetVal=1003170
        Return @RetVal
    End
    ---- 最大部门名额范围
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where a.DepLimit is not NULL and (select COUNT(ID) from pYear_Appraise where AppraiseID=7 and AppraiseEID=@EID
    and (dbo.eFN_getdepid1(DepID)=(select DepID from eEmployee where EID=@EID) or dbo.eFN_getdepid1(DepID1)=(select DepID from eEmployee where EID=@EID)))
    >a.DepLimit and a.AppraiseID=7 and a.AppraiseEID=@EID)
    Begin
        Set @RetVal=1003170
        Return @RetVal
    End

    -- 年度专业标兵奖服务明星候选个人超过名额范围，无法递交年度评优！
    ---- 最大名额范围
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=8 and AppraiseEID=@EID)
    >a.Limit and AppraiseID=8 and AppraiseEID=@EID)
    Begin
        Set @RetVal=1003180
        Return @RetVal
    End
    ---- 最大部门名额范围
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where a.DepLimit is not NULL and (select COUNT(ID) from pYear_Appraise where AppraiseID=8 and AppraiseEID=@EID
    and (dbo.eFN_getdepid1(DepID)=(select DepID from eEmployee where EID=@EID) or dbo.eFN_getdepid1(DepID1)=(select DepID from eEmployee where EID=@EID)))
    >a.DepLimit and a.AppraiseID=8 and a.AppraiseEID=@EID)
    Begin
        Set @RetVal=1003180
        Return @RetVal
    End

    -- 年度专业标兵奖浙商卫士候选个人超过名额范围，无法递交年度评优！
    ---- 最大名额范围
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where a.DepLimit is not NULL and (select COUNT(ID) from pYear_Appraise where AppraiseID=9 and AppraiseEID=@EID)
    >a.Limit and AppraiseID=9 and AppraiseEID=@EID)
    Begin
        Set @RetVal=1003190
        Return @RetVal
    End
    ---- 最大部门名额范围
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=9 and AppraiseEID=@EID
    and (dbo.eFN_getdepid1(DepID)=(select DepID from eEmployee where EID=@EID) or dbo.eFN_getdepid1(DepID1)=(select DepID from eEmployee where EID=@EID)))
    >a.DepLimit and a.AppraiseID=9 and a.AppraiseEID=@EID)
    Begin
        Set @RetVal=1003190
        Return @RetVal
    End

    -- 年度专业团队奖运营标兵候选个人超过名额范围，无法递交年度评优！
    ---- 最大名额范围
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where a.DepLimit is not NULL and (select COUNT(ID) from pYear_Appraise where AppraiseID=10 and AppraiseEID=@EID)
    >a.Limit and a.AppraiseID=10 and a.AppraiseEID=@EID)
    Begin
        Set @RetVal=1003200
        Return @RetVal
    End
    ---- 最大部门名额范围
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise A where AppraiseID=10 and AppraiseEID=@EID
    and (dbo.eFN_getdepid1(DepID)=(select DepID from eEmployee where EID=@EID) or dbo.eFN_getdepid1(DepID1)=(select DepID from eEmployee where EID=@EID)))
    >a.DepLimit and a.AppraiseID=10 and a.AppraiseEID=@EID)
    Begin
        Set @RetVal=1003200
        Return @RetVal
    End
    
    -- 年度优秀员工候选个人超过名额范围，无法递交年度评优！
    IF Exists(select 1 from pVW_pYear_AppraiseType a
    where (select COUNT(ID) from pYear_Appraise where AppraiseID=11 and AppraiseEID=@EID)
    >ISNULL(a.DepLimit,a.Limit) and AppraiseID=11 and AppraiseEID=@EID)
    Begin
        Set @RetVal=1003210
        Return @RetVal
    End
    

    Begin TRANSACTION

    -------- pYear_Appraise --------
    -- 更新年度评优部门负责人递交时间
    update a
    set a.Submit=1,a.SubmitBy=(select ID from SkySecUser where EID=@EID),a.SubmitTime=GETDATE()
    from pYear_Appraise a,pYear_AppraiseProcess b
    where a.AppraiseEID=@EID
    AND a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -------- pYear_DepAppraise --------
    -- 更新年度评优部门负责人递交状态
    update a
    set a.IsSubmit=1
    from pYear_DepAppraise a,pYear_AppraiseProcess b
    where a.AppraiseEID=@EID AND ISNULL(a.IsSubmit,0)=0 
    AND a.pYear_ID=b.ID and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0
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