USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPInsuranceHousingFundBSSubmit]
-- skydatarefresh eSP_pEMPInsuranceHousingFundBSSubmit
    @leftid int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 五险一金月度确认递交程序
-- @leftid 表示待确认递交部门的DepID
*/
Begin


    Begin TRANSACTION

    -- 更新pEMPInsuranceHousingFundDep
    update pEMPInsuranceHousingFundDep
    set IsSubmit=1,SubmitTime=GETDATE()
    where ISNULL(DepID2nd,DepID1st)=@leftid and ISNULL(IsClosed,0)=0 and ISNULL(IsSubmit,0)=0
    -- 异常流程
    If @@Error<>0
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