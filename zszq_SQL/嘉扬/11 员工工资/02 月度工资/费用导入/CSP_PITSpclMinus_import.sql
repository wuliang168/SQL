USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PITSpclMinus_import]--CSP_PITSpclMinus_import()
    @URID int,
    @CertNo varchar(100),
    @Name nvarchar(50),
    @ChildEdu decimal(10,2),
    @ContEdu decimal(10,2),
    @CritiIll decimal(10,2),
    @HousLoanInte decimal(10,2),
    @HousRent decimal(10,2),
    @SuppElder decimal(10,2),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 专项附加扣除导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If @Name<>(select Name from eEmployee where EID in (select EID from eDetails where CertNo=@CertNo) and Status in (1,2,3))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pPITSpclMinus_import表项中
    insert into pPITSpclMinus_import (HeadContact,CertNo,Name,ChildEdu,ContEdu,CritiIll,HousLoanInte,HousRent,SuppElder)
    select (select EID from SkySecUser where ID=@URID),@CertNo,@Name,@ChildEdu,@ContEdu,@CritiIll,@HousLoanInte,@HousRent,@SuppElder
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