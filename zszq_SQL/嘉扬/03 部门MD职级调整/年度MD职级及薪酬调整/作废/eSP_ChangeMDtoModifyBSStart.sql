USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_ChangeMDtoModifyBSStart]
-- skydatarefresh eSP_ChangeMDtoModifyBSStart
    @DepID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级及薪酬调整的递交程序
-- @URID 为部门负责人操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- MD职级晋升超过1级！
    If Exists(Select 1 From pMDtoModify_register 
    Where director=(Select EID from skysecuser where id=@URID) AND SupDepID=@DepID
    AND ISNULL(MDIDtoModify,0)<>0 AND MDID-ISNULL(MDIDtoModify,MDID)>1)
    Begin
        Set @RetVal = 930042
        Return @RetVal
    End

    -- MD职级晋升人数超过部门晋升人数上限！
    If Exists(Select 1 From pSalaryDepTotal 
    Where director=(Select EID from skysecuser where id=@URID) AND DepID=@DepID
    And (select COUNT(*) from pMDtoModify_register where director=(Select EID from skysecuser where id=@URID) AND SupDepID=@DepID
    and ISNULL(MDIDtoModify,0)<>0 AND MDID-MDIDtoModify=1) > ISNULL(MDDepTotal,0))
    Begin
        Set @RetVal = 930041
        Return @RetVal
    End

    -- 薪酬反馈建议存在薪酬为0.00！
    If Exists(Select 1 From pMDtoModify_register Where SalaryPerMMtoModify is not NULL AND SalaryPerMMtoModify=0 AND director=(Select EID from skysecuser where id=@URID))
    Begin
        Set @RetVal = 930045
        Return @RetVal
    End

    -- 薪酬反馈建议总额超过HR建议薪酬增额上限！
    If Exists(Select 1 From pSalaryDepTotal Where director=(Select EID from skysecuser where id=@URID) 
    And (select ISNULL(SUM(ISNULL(SalaryPerMMtoModify,ISNULL(HRSALARYPERMM,SalaryPerMM))-ISNULL(HRSALARYPERMM,SalaryPerMM))/NULLIF(SUM(ISNULL(HRSALARYPERMM,SalaryPerMM)-ISNULL(SalaryPerMM,0)),0),0)
    from pMDtoModify_register where director=(Select EID from skysecuser where id=@URID)) > 0.2
    AND DepID not in (695,356,652,402,383,629,441,388,394,350,623,438,393) -- (投资银行;存管部上限为50%;绍兴分公司;台州分公司;固定收益部;温州分公司;广州天河东路;宁波分公司;金融衍生品部;办公室上限为40%;天津分公司;北京广安门外大街;浙商资管)
    )
    Begin
        Set @RetVal = 930043
        Return @RetVal
    End

    -- 薪酬反馈建议总额超过HR建议薪酬增额上限！(存管部)
    If Exists(Select 1 From pSalaryDepTotal Where director=(Select EID from skysecuser where id=@URID) 
    And (select ISNULL(SUM(ISNULL(SalaryPerMMtoModify,ISNULL(HRSALARYPERMM,SalaryPerMM))-ISNULL(HRSALARYPERMM,SalaryPerMM))/NULLIF(SUM(ISNULL(HRSALARYPERMM,SalaryPerMM)-ISNULL(SalaryPerMM,0)),0),0)
    from pMDtoModify_register where director=(Select EID from skysecuser where id=@URID)) > 0.5
    AND DepID in (356)) -- (存管部上限为50%)
    Begin
        Set @RetVal = 930043
        Return @RetVal
    End

    -- 薪酬反馈建议总额超过HR建议薪酬增额上限！(办公室)
    If Exists(Select 1 From pSalaryDepTotal Where director=(Select EID from skysecuser where id=@URID) 
    And (select ISNULL(SUM(ISNULL(SalaryPerMMtoModify,ISNULL(HRSALARYPERMM,SalaryPerMM))-ISNULL(HRSALARYPERMM,SalaryPerMM))/NULLIF(SUM(ISNULL(HRSALARYPERMM,SalaryPerMM)-ISNULL(SalaryPerMM,0)),0),0)
    from pMDtoModify_register where director=(Select EID from skysecuser where id=@URID)) > 0.8
    AND DepID in (350)) -- (办公室上限为80%)
    Begin
        Set @RetVal = 930043
        Return @RetVal
    End

    -- MD职级调整原因为空！
    If Exists(Select 1 From pMDtoModify_register 
    Where director=(Select EID from skysecuser where id=@URID) AND SupDepID=@DepID
    AND (isnull(MDIDtoModify,0) <> 0 or (MDID-MDIDtoModify<>0 AND MDIDtoModify <> 0))
    AND isnull(LEN(MDRemark),0)=0)
    Begin
        Set @RetVal = 930044
        Return @RetVal
    End

    -- 薪酬考核调整原因为空！
    If Exists(Select 1 From pMDtoModify_register 
    Where director=(Select EID from skysecuser where id=@URID) AND SupDepID=@DepID
    AND (ISNULL(HRSALARYPERMM,SalaryPerMM)-SalaryPerMMtoModify<>0)
    AND (isnull(LEN(SalaryRemark),0)=0))
    Begin
        Set @RetVal = 930049
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新MD职级及薪酬调整表项pMDtoModify_register
    Update a
    Set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    From pMDtoModify_register a
    Where a.Director=(Select EID from skysecuser where id=@URID) AND a.SupDepID=@DepID
    AND ISNULL(a.Submit,0)=0
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM

    -- 更新MD职级及薪酬配额表项pSalaryDepTotal
    -- 更新MD职级及薪酬负责人递交状态
    Update a
    Set a.IsSubmit=1
    From pSalaryDepTotal a
    Where a.Director=(Select EID from skysecuser where id=@URID) AND a.DepID=@DepID
    -- 异常流程
    IF @@Error <> 0
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