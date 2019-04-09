USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPPayRollHRLMM_Update]
-- skydatarefresh eSP_pEMPPayRollHRLMM_Update
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资更新HRLink(2019以后工资数据)
*/
Begin


    Begin TRANSACTION

    -- 添加到pEMPPayRollHRLPerMM_all
    insert into pEMPPayRollHRLPerMM_all(emp_code,pay_date,house_fund_base,pension_base,tax_deduction,net,
    standard_tax_base,standard_quick,standard_tax_rate,bonus_tax_base,bonus_quick,bonus_tax_rate,
    severance_tax_base,severance_quick,severance_tax_rate,SA_01,SA_02,SA_03,SA_04,SA_05,SA_06,
    OTHER_01,OTHER_02,SA_07,SA_22,SA_11,SA_12,SA_13,SA_14,SA_15,SA_16,SA_17,SA_18,SA_19,
    SA_20,SA_21,SA_26,SA_28,SA_23,SA_24,SA_25,SA_08,SB_04,SB_01,SB_02,SB_03,SB_05,SB_06,
    SB_07,SB_08,SB_09,SB_10,SB_C1,SB_C2,SB_C3,SB_C4,SB_C5,SB_C6,SB_C7,SB_C8,SB_C9,
    SB_CA,SB_CB,SB_CC,SB_CD,SB_C10,SB_C11,SB_C12,SB_C13,SA_30,SA_31,AC_01,AC_02,TX_IIT,TX_bit,
    SA_29,SA_09,OTHER_03,SA_27,SA_32,SA_33,SA_34,SA_35,
    OTHER_10001,OTHER_10002,OTHER_10003,OTHER_10004,OTHER_10005,OTHER_10006)
    select a.emp_code,
    CONVERT(datetime,CONVERT(varchar(4),pay_year)+'-'+CONVERT(varchar(2),pay_month)+'-1 0:0:0',101) as pay_date,
    a.house_fund_base,a.pension_base,a.tax_deduction,a.net,
    a.standard_tax_base,a.standard_quick,a.standard_tax_rate,a.bonus_tax_base,a.bonus_quick,a.bonus_tax_rate,
    a.severance_tax_base,a.severance_quick,a.severance_tax_rate,a.SA_01,a.SA_02,a.SA_03,a.SA_04,a.SA_05,a.SA_06,
    a.OTHER_01,a.OTHER_02,a.SA_07,a.SA_22,a.SA_11,a.SA_12,a.SA_13,a.SA_14,a.SA_15,a.SA_16,a.SA_17,a.SA_18,a.SA_19,
    a.SA_20,a.SA_21,a.SA_26,a.SA_28,a.SA_23,a.SA_24,a.SA_25,a.SA_08,a.SB_04,a.SB_01,a.SB_02,a.SB_03,a.SB_05,a.SB_06,
    a.SB_07,a.SB_08,a.SB_09,a.SB_10,a.SB_C1,a.SB_C2,a.SB_C3,a.SB_C4,a.SB_C5,a.SB_C6,a.SB_C7,a.SB_C8,a.SB_C9,
    a.SB_CA,a.SB_CB,a.SB_CC,a.SB_CD,a.SB_C10,a.SB_C11,a.SB_C12,a.SB_C13,a.SA_30,a.SA_31,a.AC_01,a.AC_02,a.TX_IIT,a.TX_bit,
    a.SA_29,a.SA_09,a.OTHER_03,a.SA_27,a.SA_32,a.SA_33,a.SA_34,a.SA_35,
    a.OTHER_10001,a.OTHER_10002,a.OTHER_10003,a.OTHER_10004,a.OTHER_10005,a.OTHER_10006
    from HRL_V_PAYROLLHISINFO a
    where a.pay_year>=2019 and a.pay_month not in (select MONTH(pay_date) from pEMPPayRollHRLPerMM_all where YEAR(pay_date)=a.pay_year)
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