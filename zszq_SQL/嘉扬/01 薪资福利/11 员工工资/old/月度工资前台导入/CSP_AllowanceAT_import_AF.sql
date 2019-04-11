USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_AllowanceAT_import_AF]--CSP_AllowanceAT_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 税前补贴导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pAllowanceAT_import的补发工资到pEmployeeEmoluAllowanceAT
    update b
    set b.CommAllowanceAT=ISNULL(a.CommAllowance,b.CommAllowanceAT),b.CommAllowancePlus=ISNULL(a.CommAllowancePlus,b.CommAllowancePlus),
    b.AllowanceATOthers=ISNULL(a.AllowanceATOthers,b.AllowanceATOthers),
    b.AllowanceATTotal=ISNULL(a.CommAllowancePlus,ISNULL(b.CommAllowancePlus,0))+ISNULL(ISNULL(a.CommAllowance,b.CommAllowanceAT),0)
    +ISNULL(a.AllowanceATOthers,b.AllowanceATOthers),b.Remark=ISNULL(a.Remark,b.Remark)
    from pAllowanceAT_import a,pEmployeeEmoluAllowanceAT b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工税后补贴pAllowanceAT_import
    delete from pAllowanceAT_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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