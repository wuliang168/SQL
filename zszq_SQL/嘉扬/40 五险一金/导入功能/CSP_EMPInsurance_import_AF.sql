USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EMPInsurance_import_AF]--CSP_EMPInsurance_import_AF()
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 社保信息导入后
*/
Begin

    Begin TRANSACTION

    -- 更新pEMPInsurance_import的社保信息到pEMPInsurance
    update b
    set b.EMPInsuranceBase=ISNULL(a.EMPInsuranceBase,b.EMPInsuranceBase),b.EMPEndowBase=ISNULL(a.EMPEndowBase,b.EMPEndowBase),
    b.EMPMedicalBase=ISNULL(a.EMPMedicalBase,b.EMPMedicalBase),b.EMPUnemployBase=ISNULL(a.EMPUnemployBase,b.EMPUnemployBase),
    b.EMPMaternityBase=ISNULL(a.EMPMaternityBase,b.EMPMaternityBase),b.EMPInjuryBase=ISNULL(a.EMPInjuryBase,b.EMPInjuryBase),
    b.EMPInsuranceDate=ISNULL(a.EMPInsuranceDate,b.EMPInsuranceDate),
    b.EMPMedicalDate=ISNULL(a.EMPMedicalDate,b.EMPMedicalDate),
    b.EMPInsuranceLoc=ISNULL(a.EMPInsuranceLoc,b.EMPInsuranceLoc),b.EMPInsuranceDepart=ISNULL(a.EMPInsuranceDepart,b.EMPInsuranceDepart)
    from pEMPInsurance_import a,pEMPInsurance b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.EMPInsuranceDepart=@leftid and b.EMPInsuranceDepart=@leftid
    -- 异常流程
    IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工税后补贴pEMPInsurance_import
    delete from pEMPInsurance_import where EMPInsuranceDepart=@leftid
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