USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PensionDep_import]--CSP_PensionDep_import()
    @URID int,
    @leftid varchar(20),
    @EID int,
    @BID int,
    @EmpPensionPerMMBTax decimal(10,2),
    @EmpPensionPerMMATax decimal(10,2),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 企业年金导入
*/
Begin

    declare @DepID int,@SalaryPayID int
    set @DepID=convert(int,SUBSTRING(@leftid,0,CHARINDEX('-',@leftid)))
    set @SalaryPayID=convert(int,REVERSE(SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid)))))

    Begin TRANSACTION

    -- 将导入的文件插入到pEmpPensionDep_import表项中
    insert into pEmpPensionDep_import (DepID,PensionContact,EID,BID,EmpPensionPerMMBTax,EmpPensionPerMMATax,Remark)
    select @DepID,(select EID from SkySecUser where ID=@URID),@EID,@BID,@EmpPensionPerMMBTax,@EmpPensionPerMMATax,@Remark
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