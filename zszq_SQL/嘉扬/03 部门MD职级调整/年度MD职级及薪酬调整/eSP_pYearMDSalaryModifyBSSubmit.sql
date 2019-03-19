USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pYearMDSalaryModifyBSSubmit]
-- skydatarefresh eSP_pYearMDSalaryModifyBSSubmit
    @DepID int,
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级及薪酬调整的递交程序
-- @EID 为部门负责人操作账号的ID
*/
Begin

    -- MD职级晋升超过1级，无法递交！
    ---- 仅限于部门MD职级和薪酬调整阶段
    If Exists(Select 1 From pYear_MDSalaryModify_register a,pYear_MDSalaryModifyDep b
    Where a.director=@EID AND a.SupDepID=@DepID
    AND ISNULL(a.MDIDtoModify,0)<>0 AND ISNULL(a.MDID,0)-ISNULL(a.MDIDtoModify,a.MDID)>1
    AND a.Date=b.Date AND b.DepID=@DepID AND ISNULL(b.IsDepSubmit,0)=0 AND ISNULL(b.IsClosed,0)=0)
    Begin
        Set @RetVal = 960242
        Return @RetVal
    End

    -- MD职级调整后薪酬未做调整，无法递交！
    ---- 仅限于部门MD职级和薪酬调整阶段
    If Exists(Select 1 From pYear_MDSalaryModify_register a,pYear_MDSalaryModifyDep b
    Where a.director=@EID AND a.SupDepID=@DepID
    AND (isnull(a.MDIDtoModify,a.MDID)-ISNULL(a.MDID,0)<>0 AND ISNULL(a.MDIDtoModify,0) <> 0) 
    AND (ISNULL(a.SalaryPerMMtoModify,a.SalaryPerMM)-a.SalaryPerMM=0 or ISNULL(a.SalaryPerMMtoModify,0)=0)
    AND a.Date=b.Date AND b.DepID=@DepID AND ISNULL(b.IsDepSubmit,0)=0 AND ISNULL(b.IsClosed,0)=0)
    Begin
        Set @RetVal = 960248
        Return @RetVal
    End

    -- 晋升MD职级员工年度考核未达到C及以上，无法递交！
    ---- 仅限于部门MD职级和薪酬调整阶段
    If Exists(Select 1 From pYear_MDSalaryModify_register a,pYear_MDSalaryModifyDep b
    Where a.director=@EID AND a.SupDepID=@DepID
    AND a.MDID-isnull(a.MDIDtoModify,a.MDID)=1 AND a.pYearLevel='D'
    AND a.Date=b.Date AND b.DepID=@DepID AND ISNULL(b.IsDepSubmit,0)=0 AND ISNULL(b.IsClosed,0)=0)
    Begin
        Set @RetVal = 960249
        Return @RetVal
    End
    
    -- MD职级及薪酬调整原因为空，无法递交！
    ---- 仅限于部门MD职级和薪酬调整阶段
    If Exists(Select 1 From pYear_MDSalaryModify_register a,pYear_MDSalaryModifyDep b
    Where a.director=@EID AND a.SupDepID=@DepID
    AND ((isnull(a.MDIDtoModify,a.MDID)-a.MDID<>0 AND ISNULL(a.MDIDtoModify,0) <> 0) or (ISNULL(a.SalaryPerMMtoModify,a.SalaryPerMM)-a.SalaryPerMM<>0 AND a.SalaryPerMMtoModify<>0))
    AND isnull(LEN(a.MDSalaryRemark),0)=0
    AND a.Date=b.Date AND b.DepID=@DepID AND ISNULL(b.IsDepSubmit,0)=0 AND ISNULL(b.IsClosed,0)=0)
    Begin
        Set @RetVal = 960244
        Return @RetVal
    End

    -- MD职级晋升人数超过部门晋升人数上限，无法递交！
    ---- 如果出现MD职级调低，调低的人数将会增加可晋升MD职级的人数上限
    ---- 仅限于部门MD职级和薪酬调整阶段
    If Exists(Select 1 From pYear_MDSalaryModifyDep 
    Where director=@EID AND DepID=@DepID AND ISNULL(IsClosed,0)=0 AND ISNULL(IsDepSubmit,0)=0
    And (select COUNT(MDID-isnull(MDIDtoModify,MDID)) from pYear_MDSalaryModify_register where director=@EID AND SupDepID=@DepID
    and MDID-isnull(MDIDtoModify,MDID)=1 AND MDID<8)
    -(select COUNT(EID) from pYear_MDSalaryModify_register where director=@EID AND SupDepID=@DepID
    and (MDID-isnull(MDIDtoModify,MDID)<=-1 AND ISNULL(MDIDtoModify,0) <> 0)) > ISNULL(MDDepTotal,0)
    )
    Begin
        Set @RetVal = 960241
        Return @RetVal
    End

    -- 薪酬反馈建议总额超过增额上限，无法递交！
    ---- 如果出现薪酬调低，调低的金额将会增加可增加薪酬的增额上限
    ---- 仅限于部门MD职级和薪酬调整阶段
    If Exists(Select 1 From pYear_MDSalaryModifyDep 
    Where director=@EID AND DepID=@DepID AND ISNULL(IsClosed,0)=0 AND ISNULL(IsDepSubmit,0)=0
    And (select SUM(ISNULL(SalaryPerMMtoModify,SalaryPerMM)-SalaryPerMM)
    from pYear_MDSalaryModify_register where director=@EID AND SupDepID=@DepID AND ISNULL(SalaryPerMMtoModify,0)<>0) > SalaryDepTotal
    )
    Begin
        Set @RetVal = 960243
        Return @RetVal
    End

    -- 晋升MD职级为AN I或AN II员工工龄未满2年，无法递交！
    ---- 仅限于部门MD职级和薪酬调整阶段
    If Exists(Select 1 From pYear_MDSalaryModify_register a,pYear_MDSalaryModifyDep b
    Where a.director=@EID AND a.SupDepID=@DepID
    And a.MDID > 7 AND a.Seniority < 2
    AND ISNULL(a.MDID,0)-isnull(a.MDIDtoModify,a.MDID)=1
    AND a.Date=b.Date AND b.DepID=@DepID AND ISNULL(b.IsDepSubmit,0)=0 AND ISNULL(b.IsClosed,0)=0)
    Begin
        Set @RetVal = 960245
        Return @RetVal
    End

    -- 晋升“MD”职级员工年度考核未达到A，无法递交！
    ---- 仅限于部门MD职级和薪酬调整阶段
    If Exists(Select 1 From pYear_MDSalaryModify_register a,pYear_MDSalaryModifyDep b
    Where a.director=@EID AND a.SupDepID=@DepID
    And ISNULL(a.MDIDtoModify,0)=1 AND isnull(a.MDIDtoModify,a.MDID)-a.MDID<>0 AND ISNULL(a.MDIDtoModify,0) <> 0 AND a.pYearLevel<>'A'
    AND a.Date=b.Date AND b.DepID=@DepID AND ISNULL(b.IsDepSubmit,0)=0 AND ISNULL(b.IsClosed,0)=0)
    Begin
        Set @RetVal = 960246
        Return @RetVal
    End

    -- 晋升“VP”及以上职级员工年度考核未达到B及以上，无法递交！
    ---- 仅限于部门MD职级和薪酬调整阶段
    If Exists(Select 1 From pYear_MDSalaryModify_register a,pYear_MDSalaryModifyDep b
    Where a.director=@EID AND a.SupDepID=@DepID
    And ISNULL(a.MDIDtoModify,0)<=5 AND ISNULL(a.MDIDtoModify,0)<>1 AND a.MDID-isnull(a.MDIDtoModify,a.MDID)=1 AND a.pYearLevel<>'B' AND a.pYearLevel<>'A'
    AND a.Date=b.Date AND b.DepID=@DepID AND ISNULL(b.IsDepSubmit,0)=0 AND ISNULL(b.IsClosed,0)=0)
    Begin
        Set @RetVal = 960247
        Return @RetVal
    End

    -- 薪酬反馈建议总额不能超过“建议薪酬”栏总额！
    ---- 如果出现薪酬反馈调低，调低的金额将会增加可增加薪酬的总额上限
    ---- 仅限于薪酬反馈建议阶段
    If Exists(Select 1 From pYear_MDSalaryModifyDep 
    Where director=@EID AND DepID=@DepID AND ISNULL(IsClosed,0)=0 AND ISNULL(IsDepSubmit,0)=1 AND ISNULL(IsHRSubmit,0)=1 AND ISNULL(IsDepReSubmit,0)=0
    And (select SUM(ISNULL(ISNULL(SalaryPerMMtoReModify,HRSalaryPerMM),SalaryPerMM))-SUM(ISNULL(HRSalaryPerMM,SalaryPerMM))
    from pYear_MDSalaryModify_register where director=@EID AND SupDepID=@DepID AND ISNULL(SalaryPerMMtoReModify,0)<>0) > 0)
    Begin
        Set @RetVal = 960250
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新薪酬值0.00的数值为NULL
    update a 
    set a.SalaryPerMMtoModify=NULL
    from pYear_MDSalaryModify_register a,pYear_MDSalaryModifyDep b
    Where a.SalaryPerMMtoModify is not NULL AND a.SalaryPerMMtoModify=0 AND a.director=@EID AND a.SupDepID=@DepID
    AND a.Date=b.Date AND b.DepID=@DepID AND ISNULL(b.IsDepSubmit,0)=0 AND ISNULL(b.IsClosed,0)=0
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM

    -- 更新MDID值0的数值为NULL
    update a
    set a.MDIDtoModify=NULL
    from pYear_MDSalaryModify_register a,pYear_MDSalaryModifyDep b
    Where a.MDIDtoModify is not NULL AND a.MDIDtoModify=0 AND a.director=@EID AND a.SupDepID=@DepID
    AND a.Date=b.Date AND b.DepID=@DepID AND ISNULL(b.IsDepSubmit,0)=0 AND ISNULL(b.IsClosed,0)=0
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM

    -- 更新MD职级及薪酬配额表项pYear_MDSalaryModifyDep
    -- 更新MD职级及薪酬负责人递交状态IsDepSubmit
    Update a
    Set a.IsDepSubmit=1
    From pYear_MDSalaryModifyDep a
    Where a.Director=@EID AND a.DepID=@DepID AND ISNULL(a.IsDepSubmit,0)=0
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM
    -- 更新MD职级及薪酬负责人递交状态IsDepReSubmit
    Update a
    Set a.IsDepReSubmit=1
    From pYear_MDSalaryModifyDep a
    Where a.Director=@EID AND a.DepID=@DepID AND ISNULL(a.IsDepSubmit,0)=1 AND ISNULL(a.IsHRSubmit,0)=1
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