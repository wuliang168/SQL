USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PensionDep_import]--CSP_PensionDep_import()
    @URID int,
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @EmpPensionPerMMBTax decimal(10,2),
    @EmpPensionPerMMATax decimal(10,2),
    @Remark nvarchar(100),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 企业年金导入
*/
Begin

    -- 检查工号与姓名是否一致
    If Exists(Select 1 From pEmpPensionDep_import a Where @Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930096
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pEmpPensionDep_import表项中
    insert into pEmpPensionDep_import (DepID,PensionContact,Badge,EmpPensionPerMMBTax,EmpPensionPerMMATax,Remark)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@EmpPensionPerMMBTax,@EmpPensionPerMMATax,@Remark
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