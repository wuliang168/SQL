USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- pSP_pYear_ScoreStart 9,1
ALTER  proc [dbo].[pSP_pYear_ScoreStart]
    @id int,
    @URID int,
    @RetVal int=0 output
as
/*
-- Create By wuliang E004205
-- 年度考核开启
*/
begin

    -- 上年度考核未关闭，无法再次开启
    if exists (select 1 from pYear_Process where id=@id-1 and isnull(Closed,0)=0)
    Begin
        Set @RetVal=1001010
        Return @RetVal
    End

    -- 年度考核已开启，无需重新开启！
    if exists (select 1 from pYear_Process where id=@id and isnull(Submit,0)=1)
    Begin
        Set @RetVal=1001020
        Return @RetVal
    End

    -- 年度考核已封帐，无法重新开启！
    if exists (select 1 from pYear_Process where id=@id and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal=1001030
        Return @RetVal
    end


    BEGIN TRANSACTION

    -------- pYear_Score --------
    -- 添加员工打分排名表字段
    -- SCORE_STATUS初始值为99
    -- isranking：1-参加排名
    ---- 总部、资本，试用期员工不参加考核
    insert into pYear_Score (EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,isranking)
    select a.EID,@id,a.Score_Status,a.Score_Type1,a.Score_Type2,1
    from pVW_pYear_ScoreType a,eEmployee b,eStatus c,oDepartment d
    where a.EID=b.EID and b.Status in (1,2,3) and a.Score_Status=99
    and a.EID not in (select EID from pYear_Score where Score_Status=99)
    and a.EID=c.EID and DateDiff(dd,c.JoinDate,convert(varchar(4),(select Date from pYear_Process where ID=@ID) ,120)+'-7-01')>=0
    and a.Score_DepID=d.DepID and d.CompID<>13
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    ---- 资管，10-1后入职员工不参加考核
    insert into pYear_Score (EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,isranking)
    select a.EID,@id,a.Score_Status,a.Score_Type1,a.Score_Type2,1
    from pVW_pYear_ScoreType a,eEmployee b,eStatus c,oDepartment d
    where a.EID=b.EID and b.Status in (1,2,3) and a.Score_Status=99
    and a.EID not in (select EID from pYear_Score where Score_Status=99)
    and a.EID=c.EID and DateDiff(dd,c.JoinDate,convert(varchar(4),(select Date from pYear_Process where ID=@ID) ,120)+'-10-01')>=0
    and a.Score_DepID=d.DepID and d.CompID=13
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -------- pYear_Process --------
    -- 更新流程信息为开启
    update pYear_Process
    set Submit=1,Submitby=@URID,SubmitTime=GETDATE()
    where id=@id
    -- 异常处理
    if @@ERROR<>0
    goto ErrM


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