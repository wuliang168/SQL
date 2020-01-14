USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pYear_FDAppraiseBSSubmit3]
    @EID int,
    @leftid int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 职能部门考核递交
*/
Begin

    -- 职能部门考核-专业管理(共性指标)评分为空，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=1
    group by FDAppraiseEID,DepID,Status having COUNT(FDAppraiseEID)-COUNT(ScoreTotal)>0)
    Begin
        Set @RetVal=1005010
        Return @RetVal
    End

    -- 职能部门考核-专业管理(共性指标)评分超出范围，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=1
    and (Score1 not between 0 and 10 or Score2 not between 0 and 5 or Score3 not between 0 and 5
    or Score4 not between 0 and 5 or Score5 not between 0 and 10 or Score6 not between 0 and 5
    or Score7 not between 0 and 10 or Score8 not between 0 and 10))
    Begin
        Set @RetVal=1005020
        Return @RetVal
    End

    -- 职能部门考核-专业管理(共性指标)评分未填写评分原因，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=1
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)
    or (b.xOrder=7 and b.assess is NULL) or (ISNULL(Score8,0)>0 and b.xOrder=8 and b.assess is NULL)))
    Begin
        Set @RetVal=1005021
        Return @RetVal
    End

    -- 职能部门考核-专业管理(个性指标)评分为空，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2
    group by FDAppraiseEID,DepID,Status having COUNT(FDAppraiseEID)-COUNT(ScoreTotal)>0)
    Begin
        Set @RetVal=1005030
        Return @RetVal
    End

    -- 职能部门考核-专业管理(个性指标)评分超出范围，无法递交职能部门考核！
    ---- 办公室(350)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (350) 
    AND (Score1 not between 0 and 15 or Score2 not between 0 and 10 or Score3 not between 0 and 5
    or Score4 not between 0 and 5 or Score5 not between 0 and 5 or Score6 not between 0 and 5
    or Score7 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 董事会办公室(351)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (351) 
    AND (Score1 not between 0 and 10 or Score2 not between 0 and 10 or Score3 not between 0 and 10
    or Score4 not between 0 and 5 or Score5 not between 0 and 5 or Score6 not between 0 and 10))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 行政管理总部(352)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (352) 
    AND (Score1 not between 0 and 5 or Score2 not between 0 and 20 or Score3 not between 0 and 10
    or Score4 not between 0 and 10 or Score5 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 党群部(353)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (353) 
    AND (Score1 not between 0 and 20 or Score2 not between 0 and 10 or Score3 not between 0 and 5
    or Score4 not between 0 and 10 or Score5 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 人力资源部(354)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (354) 
    AND (Score1 not between 0 and 10 or Score2 not between 0 and 10 or Score3 not between 0 and 5
    or Score4 not between 0 and 10 or Score5 not between 0 and 5 or Score6 not between 0 and 10))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 计划财务部(355)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (355) 
    AND (Score1 not between 0 and 10 or Score2 not between 0 and 10 or Score3 not between 0 and 10
    or Score4 not between 0 and 10 or Score5 not between 0 and 5 or Score6 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 客户资产存管部(356)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (356) 
    AND (Score1 not between 0 and 15 or Score2 not between 0 and 15 or Score3 not between 0 and 5
    or Score4 not between 0 and 5 or Score5 not between 0 and 5 or Score6 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 审计部(358)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (358) 
    AND (Score1 not between 0 and 15 or Score2 not between 0 and 15 or Score3 not between 0 and 10
    or Score4 not between 0 and 10))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 风险管理部(359)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (359) 
    AND (Score1 not between 0 and 10 or Score2 not between 0 and 10 or Score3 not between 0 and 5
    or Score4 not between 0 and 5 or Score5 not between 0 and 5 or Score6 not between 0 and 5
    or Score7 not between 0 and 5 or Score8 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 培训中心(360)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (360) 
    AND (Score1 not between 0 and 10 or Score2 not between 0 and 5 or Score3 not between 0 and 5
    or Score4 not between 0 and 10 or Score5 not between 0 and 10 or Score6 not between 0 and 10))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 基建办(669)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (669) 
    AND (Score1 not between 0 and 15 or Score2 not between 0 and 10 or Score3 not between 0 and 10
    or Score4 not between 0 and 15))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 战略企划部(702)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (702) 
    AND (Score1 not between 0 and 10 or Score2 not between 0 and 10 or Score3 not between 0 and 10
    or Score4 not between 0 and 10 or Score5 not between 0 and 5 or Score6 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 法律合规部(737)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (737) 
    AND (Score1 not between 0 and 10 or Score2 not between 0 and 10 or Score3 not between 0 and 10
    or Score4 not between 0 and 5 or Score5 not between 0 and 5 or Score6 not between 0 and 5
    or Score7 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 信息技术运保部(744)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (744) 
    AND (Score1 not between 0 and 20 or Score2 not between 0 and 10 or Score3 not between 0 and 10
    or Score4 not between 0 and 5 or Score5 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End
    ---- 信息技术开发部(745)
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=2 AND DepID in (745) 
    AND (Score1 not between 0 and 10 or Score2 not between 0 and 10 or Score3 not between 0 and 10
    or Score4 not between 0 and 15 or Score5 not between 0 and 5))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End

    -- 职能部门考核-专业管理(共性指标)评分未填写评分原因，无法递交职能部门考核！
    ---- 办公室(350)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (350) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)
    or (b.xOrder=7 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 董事会办公室(351)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (351) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 行政管理总部(352)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (352) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 党群部(353)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (353) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 人力资源部(354)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (354) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 计划财务部(355)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (355) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 客户资产存管部(356)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (356) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 审计部(358)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (358) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 风险管理部(359)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (359) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)
    or (b.xOrder=7 and b.assess is NULL) or (b.xOrder=8 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 培训中心(360)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (360) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 基建办(669)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (669) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 战略企划部(702)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (702) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 法律合规部(737)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (737) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL) or (b.xOrder=6 and b.assess is NULL)
    or (b.xOrder=7 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 信息技术运保部(744)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (744) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End
    ---- 信息技术开发部(745)
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b where a.FDAppraiseEID=@EID and a.Status=@leftid and a.FDAppraiseType=2 AND a.DepID in (745) 
    and a.FDAppraiseEID=b.FDAppraiseEID and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    and ((b.xOrder=1 and b.assess is NULL) or (b.xOrder=2 and b.assess is NULL) 
    or (b.xOrder=3 and b.assess is NULL) or (b.xOrder=4 and b.assess is NULL)
    or (b.xOrder=5 and b.assess is NULL)))
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pFDAppraise --------
    -- 更新年度评优部门负责人递交时间
    update a
    set a.Submit=1,a.SubmitBy=(select ID from SkySecUser where EID=@EID),a.SubmitTime=GETDATE()
    from pFDAppraise a
    where a.FDAppraiseEID=@EID and a.Status=@leftid
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -------- pYear_FDDepAppraise --------
    -- 更新年度评优部门负责人递交状态
    update a
    set a.IsSubmit=1
    from pYear_FDDepAppraise a
    where a.FDAppraiseEID=@EID AND ISNULL(a.IsSubmit,0)=0 AND a.Status=@leftid
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