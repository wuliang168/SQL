USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadTraffic_import_AF]--CSP_HeadTraffic_import_AF()
    @URID int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室交通费导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pHeadTraffic_import的薪酬室交通费到pEmployeeEmolu
    update b
    set b.TrafficAllowance=ISNULL(a.TrafficAllowance,b.TrafficAllowance)
    from pHeadTraffic_import a,pEmployeeEmolu b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工薪酬室交通费pHeadTraffic_import
    delete from pHeadTraffic_import where HeadContact=(select EID from SkySecUser where ID=@URID)
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