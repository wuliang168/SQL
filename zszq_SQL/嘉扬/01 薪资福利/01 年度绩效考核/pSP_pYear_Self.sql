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
    -- pmb_gs：年度考核KPI模板
    -- 14-营业部合规风控专员；17-区域财务经理；
    insert into pYear_KPI (EID,pYear_ID,Xorder,Title,Initialized,Initializedby,InitializedTime)
    select a.EID,a.pYear_ID,b.Xorder,b.Title,1,@URID,GETDATE()
    from pYear_Score a,PMB_GS b
    where a.Score_Type1=b.[group] and a.SCORE_STATUS=0 and a.Score_Type1 in (14,17)
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM
    -- 16-总部兼职合规专员；15-营业部合规联系人
    insert into pYear_KPI (EID,pYear_ID,Xorder,Title,Initialized,Initializedby,InitializedTime)
    select a.EID,a.pYear_ID,b.Xorder,b.Title,1,@URID,GETDATE()
    from pYear_Score a,PMB_GS b
    where a.Score_Type2=b.[group] and a.SCORE_STATUS=0 and ISNULL(a.Score_Type2,0) in (16,15)
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM
    -- 1-总部部门负责人; 2-总部部门副职; 10-子公司部门行政负责人；24-分公司负责人; 25-分公司副职; 
    -- 5-一级营业部负责人; 6-一级营业部副职; 7-二级营业部经理室成员; 26-子公司班子成员
    insert into pYear_KPI (EID,pYear_ID,Xorder,Title,Initialized,Initializedby,InitializedTime)
    select a.EID,a.pYear_ID,b.Xorder,b.Title,1,@URID,GETDATE()
    from pYear_Score a,PMB_GS b
    where a.Score_Type1=b.[group] and a.SCORE_STATUS=0 and a.Score_Type1 in (1,2,10,24,25,5,6,7,26)
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