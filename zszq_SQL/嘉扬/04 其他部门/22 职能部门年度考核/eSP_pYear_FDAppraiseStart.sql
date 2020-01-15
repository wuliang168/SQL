USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pYear_FDAppraiseStart]
-- skydatarefresh eSP_pYear_FDAppraiseStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 职能部门考核开启程序
-- @ID 为职能部门考核对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
    
    -- 职能部门考核已开启!
    If Exists(Select 1 From pYear_FDAppraiseProcess Where ID=@ID And Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930073
        Return @RetVal
    End

    -- 职能部门考核未选择年份!
    If Exists(Select 1 From pYear_FDAppraiseProcess Where ID=@ID And Date is NULL)
    Begin
        Set @RetVal = 930074
        Return @RetVal
    End

    -- 上次职能部门考核未关闭!
    If Exists(Select 1 From pYear_FDAppraiseProcess Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930075
        Return @RetVal
    End


    Begin TRANSACTION


    -- 插入职能部门考核打分表项pFDAppraise(被考核部门)
    insert into pFDAppraise(pYear_ID,DepID,Director,FDAppraiseEID,FDAppraiseType,Status)
    select distinct b.ID,a.DepID,a.Director,a.FDAppraiseEID,a.FDAppraiseType,a.Status
    from pVW_pFDAppraise a,pYear_FDAppraiseProcess b
    where b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入职能部门考核说明表项pFDAppraiseAssess(被考核部门)
    --insert into pFDAppraiseAssess(pYear_ID,DepID,Director,FDAppraiseEID,FDAppraiseType,Status,xOrder,AppraiseIndex)
    --select b.ID,a.DepID,a.Director,a.FDAppraiseEID,a.FDAppraiseType,a.Status,a.xOrder,a.AppraiseIndex
    --from pVW_pFDAppraiseAssess a,pYear_FDAppraiseProcess b
    --where b.ID=@ID
    ---- 异常流程
    --If @@Error<>0
    --Goto ErrM

    -- 插入职能部门考核表项pYear_FDDepAppraise(考核人)
    insert into pYear_FDDepAppraise(pYear_ID,FDAppraiseEID,Status)
    select distinct b.ID,a.FDAppraiseEID,a.Status
    from pVW_pFDDepAppraise a,pYear_FDAppraiseProcess b
    where b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新职能部门考核表项pYear_FDAppraiseProcess
    Update a
    Set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
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