USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pYear_FDAppraiseBSSubmit]
    @EID int,
    @leftid int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 职能部门考核递交
*/
Begin

    -- 职能部门考核-基本职责评分为空，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise 
    where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=4 and ScoreTotal is NULL)
    Begin
        Set @RetVal=1005010
        Return @RetVal
    End

    -- 职能部门考核-基本职责评分超出范围，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise 
    where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=4 and (ScoreTotal not between 0 and 50))
    Begin
        Set @RetVal=1005020
        Return @RetVal
    End

    -- 职能部门考核-基本职责评分未填写评分原因，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b 
    where a.FDAppraiseEID=@EID and a.Status=@leftid and a.Status=1 and a.FDAppraiseType=4 and a.FDAppraiseEID=b.FDAppraiseEID 
    and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID and b.assess is NULL)
    Begin
        Set @RetVal=1005021
        Return @RetVal
    End

    -- 职能部门考核-年度重点评分为空，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise 
    where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=5 and ScoreTotal is NULL)
    Begin
        Set @RetVal=1005030
        Return @RetVal
    End

    -- 职能部门考核-年度重点评分超出范围，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise 
    where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=5 AND (ScoreTotal not between 0 and 50))
    Begin
        Set @RetVal=1005040
        Return @RetVal
    End

    -- 职能部门考核-年度重点评分未填写评分原因，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b 
    where a.FDAppraiseEID=@EID and a.Status=@leftid and a.Status=1 and a.FDAppraiseType=5 and a.FDAppraiseEID=b.FDAppraiseEID 
    and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID and b.assess is NULL)
    Begin
        Set @RetVal=1005041
        Return @RetVal
    End

    ---- 职能部门考核-创新加分评分为空，无法递交职能部门考核！
    --IF Exists(select 1 from pFDAppraise 
    --where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=7 and ScoreTotal is NULL)
    --Begin
    --    Set @RetVal=1005045
    --    Return @RetVal
    --End

    -- 职能部门考核-创新加分评分超出范围，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise 
    where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=7 AND (ScoreTotal not between 0 and 10))
    Begin
        Set @RetVal=1005046
        Return @RetVal
    End

    -- 职能部门考核-创新加分评分未填写具体案例说明，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise a,pFDAppraiseAssess b 
    where a.FDAppraiseEID=@EID and a.Status=@leftid and a.Status=1 and a.FDAppraiseType=7 and a.FDAppraiseEID=b.FDAppraiseEID 
    and a.Status=b.Status and a.FDAppraiseType=b.FDAppraiseType and a.DepID=b.DepID and a.ScoreTotal is not NULL and b.assess is NULL)
    Begin
        Set @RetVal=1005047
        Return @RetVal
    End

    -- 职能部门考核-服务支持评分为空，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise 
    where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=3
    group by FDAppraiseEID,DepID,Status having COUNT(FDAppraiseEID)-COUNT(ScoreTotal)>0)
    Begin
        Set @RetVal=1005050
        Return @RetVal
    End

    -- 职能部门考核-服务支持评分超出范围，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise 
    where FDAppraiseEID=@EID and Status=@leftid and FDAppraiseType=3
    AND (Score1 not between 0 and 5 or Score2 not between 0 and 5 or Score3 not between 0 and 5))
    Begin
        Set @RetVal=1005060
        Return @RetVal
    End

    -- 职能部门考核-服务支持评分未填写具体案例说明，无法递交职能部门考核！
    IF Exists(select 1 from pFDAppraise 
    where FDAppraiseEID=@EID and Status=@leftid and Status=1 and FDAppraiseType=3
    AND (Score1 between 0 and 3 or Score1=5 or Score2 between 0 and 3 or Score2=5 or Score3 between 0 and 3 or Score3=5) AND Remark is NULL)
    Begin
        Set @RetVal=1005070
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