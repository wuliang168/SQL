USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pYear_ScoreEach]
    @id int,
    @URID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 年度考核员工互评和胜任素质评测开启
*/         
Begin

    -- 年度考核未开启，无法开启互评和胜任素质评测！
    if exists (select 1 from pYear_Process where id=@id and isnull(Submit,0)=0)
    Begin
        Set @RetVal=1001070
        Return @RetVal
    end

    -- 年度考核已封帐，无法开启互评和胜任素质评测！
    if exists (select 1 from pYear_Process where id=@id and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal=1001080
        Return @RetVal
    end

    -- 互评和胜任素质评测已开启，无法重新开启！
    IF Exists(select 1 from pYear_ScoreEachN a,pYear_ScoreEachL b where ISNULL(a.Initialized,0)=1 or ISNULL(b.Initialized,0)=1)
    Begin
        Set @RetVal=1001090
        Return @RetVal
    End


    BEGIN TRANSACTION

    -- 添加员工互评字段
    -- SCORE_STATUS初始值为1
    insert into pYear_Score (EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_EID,Score_DepID,Weight1,Weight2,Weight3,Modulus)
    select a.EID,@id,a.Score_Status,a.Score_Type1,a.Score_Type2,a.Score_EID,a.Score_DepID,a.Weight1,a.Weight2,a.Weight3,a.Modulus
    from pVW_pYear_ScoreType a,eEmployee b
    where a.EID=b.EID and b.Status in (1,2,3) and a.Score_Status=1
    and a.EID not in (select EID from pYear_Score where Score_Status=1)
    and a.EID in (select EID from pYear_Score where Score_Status=99)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_ScoreEachN --------
    -- 二级营业部部门员工内部互评；总部一二级部门、子公司、分公司和一级营业部员工统一在一级部门框架内部互评
    insert into pYear_ScoreEachN (EID,pYear_ID,Score_Type1,Score_EID,Initialized,Initializedby,InitializedTime)
    select a.EID,b.pYear_ID,a.Score_Type1,a.Score_EID,1,@URID,GETDATE()
    from pVW_pYear_ScoreEachN a,pYear_Score b
    where a.EID=b.EID and b.Score_Status=1 
    and a.EID not in (select EID from pYear_ScoreEachN where Score_EID=a.Score_EID)
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM

    -------- pYear_ScoreEachL --------
    -- 员工胜任素质测评
    insert into pYear_ScoreEachL (EID,pYear_ID,Score_Type1,Score_EID,EachLType,Modulus,Initialized,Initializedby,InitializedTime)
    select a.EID,b.pYear_ID,a.Score_Type1,a.Score_EID,a.EachLType,a.Modulus,1,@URID,GETDATE()
    from pVW_pYear_ScoreEachL a,pYear_Score b
    where a.EID=b.EID and b.Score_Status=1 
    and a.EID not in (select EID from pYear_ScoreEachL where EachLType=a.EachLType and Score_EID=a.Score_EID)
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM


    -------- pYear_Score --------
    -- 更新SCORE_STATUS=1时pYear_Score状态
    ---- Initialized=1
    update a
    set a.Initialized=1,a.Initializedby=@URID,a.InitializedTime=GETDATE()
    from pYear_Score a
    where a.SCORE_STATUS=1
    -- 异常处理
    if @@ERROR<>0
    GOTO ErrM


    -- 正常处理流程
    COMMIT TRANSACTION
    Set @Retval = 0
    Return @Retval

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval

end 