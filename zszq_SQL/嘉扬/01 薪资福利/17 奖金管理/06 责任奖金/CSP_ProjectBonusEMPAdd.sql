USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[CSP_ProjectBonusEMPAdd]
    -- skydatarefresh CSP_ProjectBonusEMPAdd
    @EID int,
    @PJYEAR smalldatetime,
    @PJID int,
    @PJTYPE int,
    @PJDEPID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 责任奖金员工新增
-- ProjectBonusType:项目承揽奖金(1)、责任承做奖金(2)、综合支持奖金(3)、发行支持奖金(4)、持续督导奖金(5)、
-- 特殊贡献奖金(6)、其他包销奖金(7)
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
    insert into pProjectBonusPerEMP(ProjectBonusDISYear,ProjectBonusType,EID,ProjectTitleID,ProjectBonusDepID)
    values (@PJYEAR,@PJTYPE,@EID,@PJID,@PJDEPID)
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