USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pYear_FDAppraiseBSSubmit2]
    @EID int,
    @leftid int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 职能部门考核递交
*/
Begin

    -- 职能部门考核-服务支持评分为空，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=3
    group by FDAppraiseEID,DepID,Status having COUNT(FDAppraiseEID)-COUNT(ScoreTotal)>0)
    Begin
        Set @RetVal=1005050
        Return @RetVal
    End

    -- 职能部门考核-服务支持评分超出范围，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=3
    AND (Score1 not between 3 and 5 or Score2 not between 3 and 5 or Score3 not between 3 and 5))
    Begin
        Set @RetVal=1005060
        Return @RetVal
    End

    -- 职能部门考核-服务支持评分为3分和5分未填写具体案例说明，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=3
    AND (Score1 in (3,5) or Score2 in (3,5) or Score3 in (3,5)) AND Remark is NULL)
    Begin
        Set @RetVal=1005070
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pFDAppraiseAssess --------
    -- 更新年度评优部门负责人评分说明的评分值
    update a
    set a.Score=b.ScoreTotal
    from pFDAppraiseAssess a,pFDAppraise b
    where a.FDAppraiseEID=b.FDAppraiseEID and a.FDAppraiseEID=@EID and a.Status=@leftid 
    and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

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