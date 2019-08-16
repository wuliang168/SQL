USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_PensionAdmin_import_AF]--CSP_PensionAdmin_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 行政职级导入后
*/
Begin

    Begin TRANSACTION


    -- 拷贝pEmpAdmin_import的企业年金到pEmpPensionPerMM_register
    update b
    set b.LastYearAdminID=ISNULL((select ID from oCD_AdminType where Title=a.LastYearAdminID),b.LastYearAdminID),
    b.LastYearMDID=ISNULL((select ID from oCD_MDType where Title=a.LastYearMDID),b.LastYearMDID)
    from pEmpAdmin_import a,pEmployeeEmolu b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.Operator=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM

    -- 清除导入员工企业年金pEmpAdmin_import
    delete from pEmpAdmin_import where Operator=(select EID from SkySecUser where ID=@URID)
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