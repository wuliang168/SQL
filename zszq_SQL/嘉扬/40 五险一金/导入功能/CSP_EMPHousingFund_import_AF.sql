USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EMPHousingFund_import_AF]--CSP_EMPHousingFund_import_AF()
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 公积金信息导入后
*/
Begin

    Begin TRANSACTION

    -- 更新pEMPHousingFund_import的公积金信息到pEMPHousingFund
    update b
    set b.EMPHousingFundBase=ISNULL(a.EMPHousingFundBase,b.EMPHousingFundBase),b.EMPHousingFundDate=ISNULL(a.EMPHousingFundDate,b.EMPHousingFundDate),
    b.EMPHousingFundLoc=ISNULL(a.EMPHousingFundLoc,b.EMPHousingFundLoc),b.EMPHousingFundDepart=ISNULL(a.EMPHousingFundDepart,b.EMPHousingFundDepart)
    from pEMPHousingFund_import a,pEMPHousingFund b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.EMPHousingFundDepart=@leftid and b.EMPHousingFundDepart=@leftid
    -- 异常流程
    IF @@Error <> 0
	Goto ErrM


    -- 清除导入公积金信息pEMPHousingFund_import
    delete from pEMPHousingFund_import where EMPHousingFundDepart=@leftid
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