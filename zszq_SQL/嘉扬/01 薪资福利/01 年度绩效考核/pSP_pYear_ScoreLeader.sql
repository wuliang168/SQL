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
    select @pYear_ID=id from pYear_Process where id=@id

    -- 年度考核未开启，无法开启考核评分！
    if exists (select 1 from pYear_Process where id=@id and isnull(Submit,0)=0)
    Begin
        Set @RetVal=1001100
        Return @RetVal
    End

    -- 年度考核评分已开启，无需重新开启！
    if exists (select 1 from pYear_Score where Score_Status=9 and isnull(Initialized,0)=1)
    Begin
        Set @RetVal=1001110
        Return @RetVal
    End

    -- 年度考核已封帐，无法开启考核评分！
    if exists (select 1 from pYear_Process where id=@id and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal=1001120
        Return @RetVal
    end


    BEGIN TRANSACTION

    -- 添加员工打分排名表字段
    -- SCORE_STATUS初始值为大于等于2，且不等于99
    insert into pYear_Score (EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_EID,Score_DepID,Weight1,Weight2,Weight3,Modulus)
    select a.EID,@id,a.Score_Status,a.Score_Type1,a.Score_Type2,a.Score_EID,a.Score_DepID,a.Weight1,a.Weight2,a.Weight3,a.Modulus
    from pVW_pYear_ScoreType a,eEmployee b
    where a.EID=b.EID and b.Status in (1,2,3) and a.Score_Status>=2 and a.Score_Status<>99
    and a.EID not in (select EID from pYear_Score where Score_Status<>99 and Score_Status>=2)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_Score --------
    -- 更新Initialized
    ---- 如果Score_Status包含2，设置Score_Status=2的Initialized为1
    update a
    set a.Initialized=1,a.InitializedBy=@URID,a.Initializedtime=GETDATE()
    from pYear_Score a
    where a.Score_Status=2
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    ---- 如果Score_Status不包含2，设置Score_Status=99的Initialized为1
    update a
    set a.Initialized=1,a.InitializedBy=@URID,a.Initializedtime=GETDATE()
    from pYear_Score a
    where a.Score_Status=99 and 2 not in (select Score_Status from pYear_Score where EID=a.EID)
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