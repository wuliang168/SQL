USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[CSP_pEMPPhyExamBSSubmit](
    @EID int,
    @RetVal int=0 output 
)
As
Begin

    -- 年度体检报名日期为空，无法确认递交!
    If Exists(Select 1 From pEMPPhyExam_register Where EID=@EID 
    And PEDate is NULL)
    Begin
        Set @RetVal = 950310
        Return @RetVal
    End
    
    -- 年度体检报名日期未在体检日期范围内，无法确认递交!
    If Exists(Select 1 From pEMPPhyExam_register Where EID=@EID 
    And (DATEDIFF(dd,PEDate,'2019-6-17')>0 or (DATEDIFF(dd,PEDate,'2019-6-21')<0
    and DATEDIFF(dd,PEDate,'2019-6-24')>0) or DATEDIFF(dd,PEDate,'2019-6-28')<0))
    Begin
        Set @RetVal = 950320
        Return @RetVal
    End

    -- 年度体检报名日期申请超过1次，无法确认递交!
    If (Select COUNT(EID) From pEMPPhyExam_register Where EID=@EID)>1
    Begin
        Set @RetVal = 950330
        Return @RetVal
    End

    -- 年度体检报名婚姻状况信息为空，无法确认递交!
    If Exists(Select 1 From pEMPPhyExam_register Where EID=@EID And Marriage is NULL)
    Begin
        Set @RetVal = 950340
        Return @RetVal
    End

    -- 年度体检报名日期人数超过日限额，无法确认递交!
    If Exists(Select 1 From pVW_pEMPPhyExam_register Where PESumm>54 and EID=@EID)
    Begin
        Set @RetVal = 950350
        Return @RetVal
    End


    Begin TRANSACTION

    -- pEMPPhyExam_register
    ---- 更新递交状态
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pEMPPhyExam_register a
    where a.EID=@EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- pEMPPhyExam
    ---- 新添加
    insert into pEMPPhyExam(PEYear,EID,Gender,Marriage,PEDate)
    select PEYear,EID,Gender,Marriage,PEDate
    from pEMPPhyExam_register
    where EID=@EID and YEAR(PEYear) not in (select YEAR(PEYear) from pEMPPhyExam where EID=@EID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 更新
    update a
    set a.PEDate=b.PEDate,a.Marriage=b.Marriage
    from pEMPPhyExam a,pEMPPhyExam_register b
    where YEAR(a.PEYear)=YEAR(b.PEYear) and a.EID=@EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- pEMPPhyExam_all
    ---- 添加历史
    insert into pEMPPhyExam_all(PEYear,EID,Gender,Marriage,PEDate,IsSubmit,SubmitTime)
    select PEYear,EID,Gender,Marriage,PEDate,IsSubmit,SubmitTime
    from pEMPPhyExam_register
    where EID=@EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- pEMPPhyExam_register
    delete from pEMPPhyExam_register
    where EID=@EID
    -- 异常流程
    If @@Error<>0
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

End