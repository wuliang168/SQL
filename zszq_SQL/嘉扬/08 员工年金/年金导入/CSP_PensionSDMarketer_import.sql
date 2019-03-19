USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PensionSDMarketer_import]--CSP_PensionSDMarketer_import()
    @URID int,
    @leftid int,
    @Identification varchar(20),
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
    If Exists(Select 1 From pEmpPensionSDMarketer_import a Where @Name<>(select Name from pSalesDepartMarketerEmolu where Identification=@Identification))
    Begin
        Set @RetVal = 930096
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pEmpPensionSDMarketer_import表项中
    insert into pEmpPensionSDMarketer_import (DepID,PensionContact,Identification,EmpPensionPerMMBTax,EmpPensionPerMMATax,Remark)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Identification,@EmpPensionPerMMBTax,@EmpPensionPerMMATax,@Remark
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