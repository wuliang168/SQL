USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_DeductionBT_import]--CSP_DeductionBT_import()
    @URID int,
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @SickDeductionDays decimal(5,3),
    @CompassDeductionDays decimal(5,3),
    @PunishDeductionBT decimal(10,2),
    @OthersDeductionBT decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 税前扣款导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pDeductionBT_import表项中
    insert into pDeductionBT_import (SalaryPayID,SalaryContact,Badge,SickDeductionDays,CompassDeductionDays,
    PunishDeductionBT,OthersDeductionBT,Remark)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@SickDeductionDays,@CompassDeductionDays,@PunishDeductionBT,
    @OthersDeductionBT,@Remark
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