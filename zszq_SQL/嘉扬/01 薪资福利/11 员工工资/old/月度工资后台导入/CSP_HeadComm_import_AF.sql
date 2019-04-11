USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadComm_import_AF]--CSP_HeadComm_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室通讯费导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pHeadComm_import的薪酬室通讯费到pEmployeeEmolu
    update b
    set b.CommAllowance=ISNULL(a.CommAllowance,b.CommAllowance),
    b.CommAllowanceType=ISNULL(ISNULL((select ID from oCD_CommAllowanceType where Title=a.CommAllowanceType),b.CommAllowanceType),1)
    from pHeadComm_import a,pEmployeeEmolu b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工薪酬室通讯费pHeadComm_import
    delete from pHeadComm_import where HeadContact=(select EID from SkySecUser where ID=@URID)
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