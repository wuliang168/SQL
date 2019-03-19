USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMonthClose]
-- skydatarefresh eSP_pSalaryPerMonthClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资流程关闭程序
-- @ID 为月度工资流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    Declare @Date smalldatetime,@strSql nvarchar(4000)
    select @Date=Date from pSalaryPerMonth where ID=@ID

    -- 月度工资流程未开启!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930094
        Return @RetVal
    End

    -- 月度工资流程已关闭!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930093
        Return @RetVal
    End

    Begin TRANSACTION


    -- 创建工资历史表项pEMPHRLINKPerMM_YYYYMM
    ---- 创建动态SQL语句@strsql
    set @strSql='CREATE TABLE dbo.pEMPHRLINKPerMM_'+CONVERT(VARCHAR(4),YEAR(@Date))+RIGHT('0'+ltrim(MONTH(@Date)),2)+'(emp_code varchar(20),
    house_fund_base float,pension_base float,tax_deduction float,net float,standard_tax_base float,standard_quick float,standard_tax_rate float,bonus_tax_base float,
    bonus_quick float,bonus_tax_rate float,severance_tax_base float,severance_quick float,severance_tax_rate float,SA_01 float,SA_02 float,SA_03 float,SA_04 float,SA_05 float,
    SA_06 float,OTHER_01 float,OTHER_02 float,SA_07 float,SA_22 float,SA_11 float,SA_12 float,SA_13 float,SA_14 float,SA_15 float,SA_16 float,SA_17 float,SA_18 float,SA_19 float,
    SA_20 float,SA_21 float,SA_26 float,SA_28 float,SA_23 float,SA_24 float,SA_25 float,SA_08 float,SB_04 float,SB_01 float,SB_02 float,SB_03 float,SB_05 float,SB_06 float,
    SB_07 float,SB_08 float,SB_09 float,SB_10 float,SB_C1 float,SB_C2 float,SB_C3 float,SB_C4 float,SB_C5 float,SB_C6 float,SB_C7 float,SB_C8 float,SB_C9 float,
    SB_CA float,SB_CB float,SB_CC float,SB_CD float,SB_C10 float,SB_C11 float,SB_C12 float,SB_C13 float,SA_30 float,SA_31 float,AC_01 float,AC_02 float,TX_IIT float,TX_bit float,
    SA_29 float,SA_09 float,OTHER_03 float,SA_27 float,SA_32 float,SA_33 float,SA_34 float,SA_35 float,
    OTHER_10001 float,OTHER_10002 float,OTHER_10003 float,OTHER_10004 float,OTHER_10005 float,OTHER_10006 float,PRIMARY KEY (emp_code))'
    ---- 执行动态SQL语句@strsql
    exec(@strSql)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新月度部门工资流程状态
    update a
    set a.IsSubmit=1
    from pDepSalaryPerMonth a,pSalaryPerMonth b
    where a.Date=b.Date and b.ID=@ID
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