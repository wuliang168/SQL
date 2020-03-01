USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pYear_SelfBS]
    @URID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 年度考核个人自评递交
*/
Begin

    -- 业绩指标/重点工作：合规风控管理有效性评估不存在，无法递交个人自评！
    IF Exists(select 1 from pYear_Score a where a.Score_Type1 in (1,2,31,32,10)
    and a.EID=(select EID from SkySecUser where ID=@URID) and a.Score_Status=0
    and N'合规风控管理有效性评估' not in (select Title from pYear_KPI where EID=(select EID from SkySecUser where ID=@URID)))
    Begin
        Set @RetVal=1002030
        Return @RetVal
    End

    -- 实际完成情况：合规风控管理有效性评估为空，无法递交个人自评！
    IF Exists(select 1 from pYear_KPI a,pYear_Score b where a.EID=b.EID and b.Score_Type1 in (1,2,10,25,6,7,24,5,26)
    and a.EID=(select EID from SkySecUser where ID=@URID) and a.Title like N'%合规风控管理有效性评估%' and LEN(ISNULL(a.KPI,''))=0
    and b.Score_Status=0)
    Begin
        Set @RetVal=1002040
        Return @RetVal
    End

    -- 业绩指标/重点工作为空，无法递交个人自评！
    ---- 无标题
    IF not Exists(select EID from pYear_KPI where EID=(select EID from SkySecUser where ID=@URID))
    Begin
        Set @RetVal=1002045
        Return @RetVal
    End
    ---- 标题内容为空
    IF Exists(select 1 from pYear_KPI where EID=(select EID from SkySecUser where ID=@URID) and LEN(ISNULL(Title,''))=0)
    Begin
        Set @RetVal=1002045
        Return @RetVal
    End

    -- 实际完成情况为空，无法递交个人自评！
    IF Exists(select 1 from pYear_KPI where EID=(select EID from SkySecUser where ID=@URID) and LEN(ISNULL(KPI,''))=0)
    Begin
        Set @RetVal=1002046
        Return @RetVal
    End

    -- 个人总结内容为空，无法递交个人自评！-- 总部普通员工、子公司普通员工、分公司普通员工、一级营业部普通员工、二级营业部普通员工、营业部合规风控专员、营业部区域财务经理、综合会计（集中）、综合会计（非集中）
    IF Exists(select 1 from pYear_Summary a,pYear_Score b
    where a.EID=b.EID and b.Score_Status=0
    and a.EID=(select EID from SkySecUser where ID=@URID) and LEN(ISNULL(a.Summary,''))=0
    and b.Score_Status=0)
    Begin
        Set @RetVal=1002051
        Return @RetVal
    End

    -- 业绩指标/重点工作超过100字，请精简文字简要概述！
    IF Exists(select 1 from pYear_KPI where EID=(select EID from SkySecUser where ID=@URID) and LEN(Title)>100)
    Begin
        Set @RetVal=1002060
        Return @RetVal
    End

    -- 实际完成情况内容超过200字，请精简文字简要概述！
    IF Exists(select 1 from pYear_KPI
    where EID=(select EID from SkySecUser where ID=@URID) and LEN(KPI)>250)
    Begin
        Set @RetVal=1002065
        Return @RetVal
    End

    -- 个人总结内容超过1600字，请精简文字简要概述！-- 总部普通员工、子公司普通员工、分公司普通员工、一级营业部普通员工、二级营业部普通员工、营业部合规风控专员、营业部区域财务经理、综合会计（集中）、综合会计（非集中）
    IF Exists(select 1 from pYear_Summary a,pYear_Score b 
    where a.EID=b.EID and b.Score_Status=0
    and a.EID=(select EID from SkySecUser where ID=@URID) and LEN(a.Summary)>1600
    and b.Score_Status=0)
    Begin
        Set @RetVal=1002071
        Return @RetVal
    End
    

    Begin TRANSACTION

    -------- pYear_KPI --------
    -- 更新员工年度工作内容
    update a
    set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    from pYear_KPI a                            
    where a.EID=(select EID from SkySecUser where ID=@URID)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -------- pYear_Summary --------
    -- 更新员工年度个人总结
    update a
    set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    from pYear_Summary a
    where a.EID=(select EID from SkySecUser where ID=@URID)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -------- pYear_Score --------
    -- 更新员工考核评分表
    -- Score_Status=0
    update a
    set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    from pYear_Score a
    where a.EID=(select EID from SkySecUser where ID=@URID) and a.Score_Status=0
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
    If ISNULL(@RetVal,0)=0
        Set @RetVal=-1
    Return @RetVal
end