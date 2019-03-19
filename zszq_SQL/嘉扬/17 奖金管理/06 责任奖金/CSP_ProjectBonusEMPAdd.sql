USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[CSP_ProjectBonusEMPAdd]
    -- skydatarefresh CSP_ProjectBonusEMPAdd
    @EID int,
    @PJDISYEAR smalldatetime,
    @PJID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 责任奖金员工新增
*/
Begin

    -- 员工已存在请勿重复添加
    --If Exists(Select 1
    --From pProjectBonusPerEMP
    --Where EID=@EID and ProjectTitleID=@PJID and ProjectBonusDISYear=@PJDISYEAR)
    --Begin
    --    Set @RetVal = 930395
    --    Return @RetVal
    --End

    Begin TRANSACTION

    -- pProjectBonusPerEMP
    insert into pProjectBonusPerEMP(ProjectBonusDISYear,)
    update a
    set a.IsConfirm=1,a.ConfirmURID=@URID,a.ConfirmDate=GETDATE()
    from pProjectBonusPerPJ a
    where a.ID=@ID and ISNULL(a.IsConfirm,0)=0
    -- 异常流程
    If @@Error<>0
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