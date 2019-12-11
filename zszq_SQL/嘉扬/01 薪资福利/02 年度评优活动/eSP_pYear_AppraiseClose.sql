USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pYear_AppraiseClose]
    @id int,
    @URID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 年度考核关闭
*/
Begin

    -- 本年度评优未开启，无法执行封账！
    if exists (select 1 from pYear_AppraiseProcess where id=@id and isnull(Submit,0)=0)
    Begin
        Set @RetVal=1003040
        Return @RetVal
    End

    -- 本年度评优已封帐，无法重复封账！
    if exists (select 1 from pYear_AppraiseProcess where id=@id and isnull(Closed,0)=1)
    Begin
        Set @RetVal=1003050
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pYear_Appraise_all --------
    -- 拷贝pYear_Appraise到pYear_Appraise_all
    insert into pYear_Appraise_all (pYear_ID,AppraiseEID,AppraiseDepID,AppraiseStatus,AppraiseID,EID,Identification,DepID,Reason,
    Limit,DepLimit,Submit,SubmitBy,SubmitTime)
    select pYear_ID,AppraiseEID,AppraiseDepID,AppraiseStatus,AppraiseID,EID,Identification,DepID,Reason,Limit,DepLimit,
    Submit,SubmitBy,SubmitTime
    from pYear_Appraise
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_Appraise --------
    -- 删除pYear_Appraise
    delete from pYear_Appraise where pYear_ID=@ID
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -------- pYear_AppraiseProcess --------
    -- 更新
    update a
    set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    from pYear_AppraiseProcess a
    where id=@id
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