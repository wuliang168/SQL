USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_pYear_Self]
    @id int,
    @URID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 年度考核个人自评开启
*/
Begin

    -- 年度考核未开启，无法开启自评！
    if exists (select 1 from pYear_Process where id=@id and isnull(Submit,0)=0)
    Begin
        Set @RetVal=1001040
        Return @RetVal
    End

    -- 年度考核已封帐，无法开启自评！
    if exists (select 1 from pYear_Process where id=@id and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal=1001050
        Return @RetVal
    End

    -- 自评考核已开启，无法重新开启自评！
    if exists (select 1 from pYear_Score where pYear_ID=@id and ISNULL(Initialized,0)=1)
    Begin
        Set @RetVal=1001060
        Return @RetVal
    End

    Begin TRANSACTION

    -------- pYear_KPI --------
    -- 添加员工自评字段
    -- SCORE_STATUS初始值为0
    insert into pYear_Score (EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_EID,Score_DepID)
    select a.EID,@id,a.Score_Status,a.Score_Type1,a.Score_Type2,a.Score_EID,a.Score_DepID
    from pVW_pYear_ScoreType a,eEmployee b
    where a.EID=b.EID and b.Status in (1,2,3) and a.Score_Status=0
    and a.EID not in (select EID from pYear_Score where Score_Status=0)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -- pmb_gs：年度考核KPI模板
    -- 14-分支机构合规风控专员；17-分支机构区域财务经理；
    insert into pYear_KPI (EID,pYear_ID,Xorder,Title,Initialized,Initializedby,InitializedTime)
    select a.EID,a.pYear_ID,b.Xorder,b.Title,1,@URID,GETDATE()
    from pYear_Score a,PMB_GS b
    where a.Score_Type1=b.[group] and a.SCORE_STATUS=0 and a.Score_Type1 in (14,17)
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM
    -- 35-兼职合规管理
    insert into pYear_KPI (EID,pYear_ID,Xorder,Title,Initialized,Initializedby,InitializedTime)
    select a.EID,a.pYear_ID,b.Xorder,b.Title,1,@URID,GETDATE()
    from pYear_Score a,PMB_GS b
    where a.Score_Type2=b.[group] and a.SCORE_STATUS=0 and ISNULL(a.Score_Type2,0)=35
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM
    ---- 1-总部部门负责人; 2-总部部门副职; 36-总部部门助理
    ---- 31-一级分支机构负责人; 32-二级分支机构副职及二级分支机构经理室成员
    ---- 10-子公司部门行政负责人；30-子公司部门副职
    insert into pYear_KPI (EID,pYear_ID,Xorder,Title,Initialized,Initializedby,InitializedTime)
    select a.EID,a.pYear_ID,b.Xorder,b.Title,1,@URID,GETDATE()
    from pYear_Score a,PMB_GS b
    where a.Score_Type1=b.[group] and a.SCORE_STATUS=0 and a.Score_Type1 in (1,2,36,31,32,10,30)
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM


    -------- pYear_Summary --------
    -- 本年度的pYear_Summary信息
    ---- 设置Initialized=1
    insert into pYear_Summary (EID,pYear_ID,Initialized,Initializedby,InitializedTime)
    select a.EID,a.pYear_ID,1,@URID,GETDATE()
    from pYear_Score a
    where a.SCORE_STATUS=0
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM


    -------- pYear_Score --------
    -- 更新SCORE_STATUS=0时pYear_Score状态
    ---- 设置Initialized=1
    update a
    set a.Initialized=1,a.Initializedby=@URID,a.InitializedTime=GETDATE()
    from pYear_Score a
    where a.SCORE_STATUS=0
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM
    
    
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