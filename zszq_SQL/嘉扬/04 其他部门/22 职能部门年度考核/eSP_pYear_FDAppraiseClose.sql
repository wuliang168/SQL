USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pYear_FDAppraiseClose]
-- skydatarefresh eSP_pYear_FDAppraiseClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 职能部门考核关闭程序
-- @ID 为职能部门考核对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 职能部门考核未开启!
    If Exists(Select 1 From pYear_FDAppraiseProcess Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930076
        Return @RetVal
    End

    -- 职能部门考核已关闭!
    If Exists(Select 1 From pYear_FDAppraiseProcess Where ID=@ID And Isnull(Closed,0)=1)
    Begin
        Set @RetVal = 930077
        Return @RetVal
    End


    Begin TRANSACTION

    -- 拷贝pFDAppraise到pFDAppraise_all
    insert into pFDAppraise_all(pYear_ID,DepID,Director,FDAppraiseEID,FDAppraiseType,Status,
    Score1,Score2,Score3,Score4,Score5,Score6,Score7,Score8,Score9,Score10,ScoreTotal,Remark,Submit,SubmitBy,SubmitTime)
    select pYear_ID,DepID,Director,FDAppraiseEID,FDAppraiseType,Status,
    Score1,Score2,Score3,Score4,Score5,Score6,Score7,Score8,Score9,Score10,ScoreTotal,Remark,Submit,SubmitBy,SubmitTime
    from pFDAppraise
    where pYear_ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 拷贝pFDAppraiseAssess到pFDAppraiseAssess_all
    --insert into pFDAppraiseAssess_all(pYear_ID,DepID,Director,FDAppraiseEID,FDAppraiseType,Status,xOrder,AppraiseIndex,Assess)
    --select pYear_ID,DepID,Director,FDAppraiseEID,FDAppraiseType,Status,xOrder,AppraiseIndex,Assess
    --from pFDAppraiseAssess

    -- 删除pFDAppraise
    delete from pFDAppraise
    where pYear_ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pFDAppraiseAssess
    --delete from pFDAppraiseAssess

    -- 更新职能部门考核表项pYear_FDAppraiseProcess
    Update a
    Set a.Closed=1,ClosedBy=@URID,ClosedTime=GETDATE()
    From pYear_FDAppraiseProcess a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 递交
    COMMIT TRANSACTION

    -- 正常处理流程
    Set @Retval = 0
    Return @Retval

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval

End