USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  proc [dbo].[pSP_pYear_ScoreLeader]
    @id int,
    @URID int,
    @RetVal int=0 output
as
/*
-- Create By wuliang E004205
-- 年度考核评分开启
*/
begin

    -- 申明
    declare @pYear_ID varchar(20)

    -- @pYear_ID(年度考核ID)
    select @pYear_ID=id
    from pYear_Process
    where id=@id

    -- 年度考核未开启，无法开启考核评分！
    if exists (select 1
    from pYear_Process
    where id=@id and isnull(Submit,0)=0)
    Begin
        Set @RetVal=1001100
        Return @RetVal
    End

    -- 年度考核评分已开启，无需重新开启！
    if exists (select 1
    from pYear_Score
    where Score_Status=9 and isnull(Initialized,0)=1)
    Begin
        Set @RetVal=1001110
        Return @RetVal
    End

    -- 年度考核已封帐，无法开启考核评分！
    if exists (select 1
    from pYear_Process
    where id=@id and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal=1001120
        Return @RetVal
    end


    BEGIN TRANSACTION

    -- 添加员工打分排名表字段
    ---- 更新SCORE_STATUS=99的Score_EID,Score_DepID,Weight1,Weight2,Weight3,Modulus
    update a
    set a.Score_EID=b.Score_EID,a.Score_DepID=b.Score_DepID,
    a.Weight1=b.Weight1,a.Weight2=b.Weight2,a.Weight3=b.Weight3,a.Modulus=b.Modulus
    from pYear_Score a,pVW_pYear_ScoreType b
    where a.EID=b.EID and a.Score_Status=b.Score_Status and a.Score_Status=99
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    ---- 更新SCORE_STATUS=99的排名状态标记
    update a
    set a.TotalNum=b.TotalNum,a.TotalRankNum=b.TotalRankNum
    from pYear_Score a,pVW_pYear_ScoreRanking b
    where a.EID=b.EID and a.Score_Status=99
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -- SCORE_STATUS初始值为大于等于2，且不等于99
    insert into pYear_Score
        (EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_EID,Score_DepID,Weight1,Weight2,Weight3,Modulus)
    select a.EID, @id, a.Score_Status, a.Score_Type1, a.Score_Type2, a.Score_EID, a.Score_DepID, a.Weight1, a.Weight2, a.Weight3, a.Modulus
    from pVW_pYear_ScoreType a, eEmployee b
    where a.EID=b.EID and b.Status in (1,2,3) and a.Score_Status>=2 and a.Score_Status<>99
        and a.EID not in (select EID
        from pYear_Score
        where Score_Status<>99 and Score_Status>=2)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_Score --------
    -- 更新Initialized
    ---- 设置所有的Initialized为1
    update a
    set a.Initialized=1,a.InitializedBy=@URID,a.Initializedtime=GETDATE()
    from pYear_Score a
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    ---- 考核人下属被考核人包含兼职合规管理
    ------ 设置考核人对应的被考人Initialized等为NULL
    update a
    set a.Initialized=NULL,a.InitializedBy=NULL,a.Initializedtime=NULL
    from pYear_Score a
        inner join (select EID, Score_EID, MAX(Score_Status) as Score_Status
        from pVW_pYear_ScoreType
        where Score_Type2=35 and Score_Status not in (0,1,7)
        group by EID,Score_EID) b
        on a.Score_EID=b.Score_EID and a.Score_Status=b.Score_Status
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    ---- Score_Status=99的考核人下属被考核人包含二级分支机构员工
    ------ 设置考核人对应的Score_Status=99被考人Initialized为NULL
    update a
    set a.Initialized=NULL,a.InitializedBy=NULL,a.Initializedtime=NULL
    from pYear_Score a
        inner join (select EID, Score_EID, MAX(Score_Status) as Score_Status
        from pVW_pYear_ScoreType
        where Score_Type1=33 and Score_Status not in (0,1,7) and ISNULL(Modulus,100)<>100
        group by EID,Score_EID) b 
        on a.Score_EID=b.Score_EID and a.Score_Status=b.Score_Status
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


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