USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_DeductionBT_import_AF]--CSP_DeductionBT_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 税前扣款导入后
*/
Begin

    Begin TRANSACTION

    -- 拷贝pDeductionBT_import的补发工资到pEmployeeEmoluDeductionBT
    update b
    set b.SickDeductionDays=ISNULL(a.SickDeductionDays,b.SickDeductionDays),
    b.SickDeductionBT=ROUND((select (ISNULL(SalaryPerMM,0)+ISNULL(SponsorAllowance,0))*ISNULL(a.SickDeductionDays,ISNULL(b.SickDeductionDays,0))*
    (case when Cyear<2 then 0.4 when Cyear>=2 and Cyear<4 then 0.3 when Cyear>=4 and Cyear<6 then 0.2 when Cyear>=6 and Cyear<8 then 0.1 else 0 end)/21.75 
    from pVW_pEMPEmolu where EID=b.EID),2),
    b.CompassDeductionDays=ISNULL(a.CompassDeductionDays,b.CompassDeductionDays),
    b.CompassDeductionBT=ROUND((select (ISNULL(SalaryPerMM,0)+ISNULL(SponsorAllowance,0))*ISNULL(a.CompassDeductionDays,ISNULL(b.CompassDeductionDays,0))/21.75 
    from pVW_pEMPEmolu where EID=b.EID),2),
    b.PunishDeductionBT=ISNULL(a.PunishDeductionBT,b.PunishDeductionBT),b.OthersDeductionBT=ISNULL(a.OthersDeductionBT,b.OthersDeductionBT),
    b.DeductionBTTotal=ROUND((select (ISNULL(SalaryPerMM,0)+ISNULL(SponsorAllowance,0))*ISNULL(a.SickDeductionDays,ISNULL(b.SickDeductionDays,0))*
    (case when Cyear<2 then 0.4 when Cyear>=2 and Cyear<4 then 0.3 when Cyear>=4 and Cyear<6 then 0.2 when Cyear>=6 and Cyear<8 then 0.1 else 0 end)/21.75 
    from pVW_pEMPEmolu where EID=b.EID),2)
    +ROUND((select (ISNULL(SalaryPerMM,0)+ISNULL(SponsorAllowance,0))*ISNULL(a.CompassDeductionDays,ISNULL(b.CompassDeductionDays,0))/21.75 
    from pVW_pEMPEmolu where EID=b.EID),2)+
    ISNULL(a.PunishDeductionBT,ISNULL(b.PunishDeductionBT,0))+ISNULL(a.OthersDeductionBT,ISNULL(b.OthersDeductionBT,0)),b.Remark=ISNULL(a.Remark,b.Remark)
    from pDeductionBT_import a,pEmployeeEmoluDeductionBT b
    where (select EID from eEmployee where Badge=a.Badge)=b.EID and a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工税前扣款pDeductionBT_import
    delete from pDeductionBT_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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