-- v_emp_pay_info_all
SELECT     '2018' AS pay_year, '2' AS pay_month, isnull([SA_02], 0) [SA_02], isnull([SB_C10], 0) [SB_C10], isnull([SB_07], 0) [SB_07], isnull([TX_IIT], 0) [TX_IIT], isnull([OTHER_03], 0) [OTHER_03], 
                      isnull([SB_C7], 0) [SB_C7], isnull([SB_02], 0) [SB_02], isnull([SB_CC], 0) [SB_CC], isnull([SA_28], 0) [SA_28], isnull([SA_33], 0) [SA_33], isnull([SB_C2], 0) [SB_C2], isnull([SA_27], 0) [SA_27], 
                      isnull([SA_11], 0) [SA_11], isnull([SA_26], 0) [SA_26], isnull([SA_15], 0) [SA_15], isnull([SA_32], 0) [SA_32], isnull([SA_29], 0) [SA_29], isnull([SB_CD], 0) [SB_CD], isnull([SA_35], 0) [SA_35], 
                      isnull([TX_bit], 0) [TX_bit], isnull([SA_13], 0) [SA_13], isnull([SA_22], 0) [SA_22], isnull([SB_03], 0) [SB_03], isnull([SA_17], 0) [SA_17], isnull([SA_34], 0) [SA_34], isnull([SA_06], 0) [SA_06], 
                      isnull([SA_08], 0) [SA_08], isnull([SB_10], 0) [SB_10], isnull([SA_18], 0) [SA_18], isnull([SB_C12], 0) [SB_C12], isnull([SA_03], 0) [SA_03], isnull([AC_02], 0) [AC_02], isnull([SA_31], 0) [SA_31], 
                      isnull([SA_20], 0) [SA_20], isnull([SB_04], 0) [SB_04], isnull([SA_23], 0) [SA_23], isnull([SB_01], 0) [SB_01], isnull([SB_C11], 0) [SB_C11], isnull([SB_C9], 0) [SB_C9], isnull([SA_04], 0) [SA_04], 
                      isnull([OTHER_01], 0) [OTHER_01], isnull([SB_C3], 0) [SB_C3], isnull([SA_09], 0) [SA_09], isnull([SB_05], 0) [SB_05], isnull([SB_09], 0) [SB_09], isnull([SA_07], 0) [SA_07], isnull([tax_deduction], 0) 
                      [tax_deduction], isnull([SB_06], 0) [SB_06], isnull([SB_C13], 0) [SB_C13], isnull([SB_CA], 0) [SB_CA], isnull([SA_25], 0) [SA_25], isnull([AC_01], 0) [AC_01], isnull([SB_C5], 0) [SB_C5], isnull([SB_CB], 0) 
                      [SB_CB], isnull([SB_C4], 0) [SB_C4], isnull([SB_C8], 0) [SB_C8], isnull([SA_14], 0) [SA_14], isnull([SA_01], 0) [SA_01], isnull([SA_12], 0) [SA_12], isnull([SA_30], 0) [SA_30], isnull([OTHER_02], 0) 
                      [OTHER_02], isnull([SB_08], 0) [SB_08], isnull([SA_21], 0) [SA_21], isnull([SA_19], 0) [SA_19], isnull([SA_16], 0) [SA_16], isnull([emp_id], 0) [emp_id], isnull([house_fund_base], 0) [house_fund_base], 
                      isnull([net], 0) [net], isnull([payrole_code], 0) [payrole_code], isnull([pension_base], 0) [pension_base], isnull([standard_tax_base], 0) [standard_tax_base], isnull([standard_quick], 0) 
                      [standard_quick], isnull([standard_tax_rate], 0) [standard_tax_rate], isnull([bonus_tax_base], 0) [bonus_tax_base], isnull([bonus_quick], 0) [bonus_quick], isnull([bonus_tax_rate], 0) [bonus_tax_rate],
                       isnull([severance_tax_base], 0) [severance_tax_base], isnull([severance_quick], 0) [severance_quick], isnull([severance_tax_rate], 0) [severance_tax_rate], isnull([SA_24], 0) [SA_24], 
                      isnull([SB_C1], 0) [SB_C1], isnull([SA_05], 0) [SA_05], isnull([SB_C6], 0) [SB_C6]
FROM         emp_pay_info_currentmonth
UNION ALL
SELECT     pay_year, pay_month, isnull([SA_02], 0) [SA_02], isnull([SB_C10], 0) [SB_C10], isnull([SB_07], 0) [SB_07], isnull([TX_IIT], 0) [TX_IIT], isnull([OTHER_03], 0) [OTHER_03], isnull([SB_C7], 0) [SB_C7], 
                      isnull([SB_02], 0) [SB_02], isnull([SB_CC], 0) [SB_CC], isnull([SA_28], 0) [SA_28], isnull([SA_33], 0) [SA_33], isnull([SB_C2], 0) [SB_C2], isnull([SA_27], 0) [SA_27], isnull([SA_11], 0) [SA_11], 
                      isnull([SA_26], 0) [SA_26], isnull([SA_15], 0) [SA_15], isnull([SA_32], 0) [SA_32], isnull([SA_29], 0) [SA_29], isnull([SB_CD], 0) [SB_CD], isnull([SA_35], 0) [SA_35], isnull([TX_bit], 0) [TX_bit], 
                      isnull([SA_13], 0) [SA_13], isnull([SA_22], 0) [SA_22], isnull([SB_03], 0) [SB_03], isnull([SA_17], 0) [SA_17], isnull([SA_34], 0) [SA_34], isnull([SA_06], 0) [SA_06], isnull([SA_08], 0) [SA_08], 
                      isnull([SB_10], 0) [SB_10], isnull([SA_18], 0) [SA_18], isnull([SB_C12], 0) [SB_C12], isnull([SA_03], 0) [SA_03], isnull([AC_02], 0) [AC_02], isnull([SA_31], 0) [SA_31], isnull([SA_20], 0) [SA_20], 
                      isnull([SB_04], 0) [SB_04], isnull([SA_23], 0) [SA_23], isnull([SB_01], 0) [SB_01], isnull([SB_C11], 0) [SB_C11], isnull([SB_C9], 0) [SB_C9], isnull([SA_04], 0) [SA_04], isnull([OTHER_01], 0) 
                      [OTHER_01], isnull([SB_C3], 0) [SB_C3], isnull([SA_09], 0) [SA_09], isnull([SB_05], 0) [SB_05], isnull([SB_09], 0) [SB_09], isnull([SA_07], 0) [SA_07], isnull([tax_deduction], 0) [tax_deduction], 
                      isnull([SB_06], 0) [SB_06], isnull([SB_C13], 0) [SB_C13], isnull([SB_CA], 0) [SB_CA], isnull([SA_25], 0) [SA_25], isnull([AC_01], 0) [AC_01], isnull([SB_C5], 0) [SB_C5], isnull([SB_CB], 0) [SB_CB], 
                      isnull([SB_C4], 0) [SB_C4], isnull([SB_C8], 0) [SB_C8], isnull([SA_14], 0) [SA_14], isnull([SA_01], 0) [SA_01], isnull([SA_12], 0) [SA_12], isnull([SA_30], 0) [SA_30], isnull([OTHER_02], 0) [OTHER_02], 
                      isnull([SB_08], 0) [SB_08], isnull([SA_21], 0) [SA_21], isnull([SA_19], 0) [SA_19], isnull([SA_16], 0) [SA_16], isnull([emp_id], 0) [emp_id], isnull([house_fund_base], 0) [house_fund_base], isnull([net], 0) 
                      [net], isnull([payrole_code], 0) [payrole_code], isnull([pension_base], 0) [pension_base], isnull([standard_tax_base], 0) [standard_tax_base], isnull([standard_quick], 0) [standard_quick], 
                      isnull([standard_tax_rate], 0) [standard_tax_rate], isnull([bonus_tax_base], 0) [bonus_tax_base], isnull([bonus_quick], 0) [bonus_quick], isnull([bonus_tax_rate], 0) [bonus_tax_rate], 
                      isnull([severance_tax_base], 0) [severance_tax_base], isnull([severance_quick], 0) [severance_quick], isnull([severance_tax_rate], 0) [severance_tax_rate], isnull([SA_24], 0) [SA_24], isnull([SB_C1], 
                      0) [SB_C1], isnull([SA_05], 0) [SA_05], isnull([SB_C6], 0) [SB_C6]
FROM         emp_pay_info_all