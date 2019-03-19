-- HRL_EMP_PAY_INFO_ALL

select a.key_id,a.pay_year,a.pay_month,a.emp_id,b.emp_code,b.chn_name,a.payrole_code,a.house_fund_base,a.pension_base,a.net,a.standard_tax_base,
a.standard_quick,a.standard_tax_rate,a.bonus_tax_base,a.bonus_quick,a.bonus_tax_rate,a.severance_tax_base,a.severance_quick,a.severance_tax_rate,
a.SB_C8,a.OTHER_06,a.OTHER_03,a.SB_CA,a.OTHER_09,a.OTHER_04,a.OTHER_01,a.SB_CC,a.SB_C9,a.LP_02,a.SA_02,a.SB_C5,a.SB_07,a.SB_04,a.SB_02,a.OP_01,a.SB_CB,
a.SB_C3,a.SB_C1,a.AC_01,a.OTHER_07,a.SB_03,a.TX_IIT,a.SB_06,a.SB_08,a.SB_01,a.LP_01,a.OTHER_05,a.SA_06,a.OTHER_02,a.SA_05,a.SB_C7,a.SB_C6,
a.SA_01,a.SB_05,a.SA_03,a.SB_C4,a.SA_04,a.SB_C2,a.OTHER_08,a.SA_22,a.SA_12,a.SA_20,a.SA_15,a.SA_13,a.SA_18,a.SA_19,a.SA_11,a.SA_07,a.SA_08,a.SA_14,a.SA_21,a.SA_10,
a.TX_bit,a.SA_17,a.LP_03,a.SA_16,a.SA_26,a.SA_23,a.AC_02,a.SA_27,a.SA_28,a.SA_25,a.SA_24,a.SA_30,a.SA_09,a.SA_29,a.SB_10,a.SB_09,a.SB_CD,
a.SA_31,a.SB_C10,a.SB_C12,a.SB_C13,a.SB_C11,a.SA_32,a.SA_34,a.SA_33,a.SA_35,a.tax_deduction,a.OTHER_10004,a.OTHER_10002,a.OTHER_10005,a.OTHER_10006,a.OTHER_10003,a.OTHER_10001
from OPENQUERY(HRLINK, 'SELECT * FROM DBO.emp_pay_info_all') as a
inner join OPENQUERY(HRLINK, 'SELECT * FROM DBO.EMP_INFO_MASTER') as b on a.emp_id=b.emp_id