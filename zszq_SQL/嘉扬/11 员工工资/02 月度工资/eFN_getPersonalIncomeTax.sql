USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Function  [dbo].[eFN_getPersonalIncomeTax] (@salary decimal(10,2),@type int) 
    -- select dbo.eFN_getPersonalIncomeTax(5000,1)
	returns decimal(10,2)
As
/*
-- Create By wuliang E004205
-- 计算个人所得税
-- @salary 为 应纳税所得额
-- 新个人所得税
---- 本期应预扣预缴税额=（累计预扣预缴应纳税所得额×预扣率-速算扣除数)-累计减免税额-累计已预扣预缴税额
---- 累计预扣预缴应纳税所得额=累计收入-累计免税收入-累计减除费用-累计专项扣除-累计专项附加扣除-累计依法确定的其他扣除
-- 新一次性奖金税
---- 新一次性奖金税=全年一次性奖金收入×适用税率－速算扣除数
---- 其中适用税率和速算扣除数：由全年一次性奖金收入除以12个月得到的数额，按照本通知所附按月换算后的综合所得税率表（以下简称月度税率表）来确定
*/
Begin
	Declare @tax decimal(10,2)

	
	-- 新个人所得税(月)
	select @tax=ROUND(@salary*TaxRate,2)-QuickCalcDed
	from oCD_TaxRateType
	where TaxRangeLowerLimit<=@salary and @salary<=ISNULL(TaxRangeUpperLimit,99999999) and TaxRateType=@type and @type=1

	-- 新个人所得税(年)
	select @tax=ROUND(@salary*TaxRate,2)-QuickCalcDed
	from oCD_TaxRateType
	where TaxRangeLowerLimit<=@salary and @salary<=ISNULL(TaxRangeUpperLimit,99999999) and TaxRateType=@type and @type=2

	-- 新一次性奖金税
	select @tax=ROUND(@salary*TaxRate,2)-QuickCalcDed
	from oCD_TaxRateType
	where TaxRangeLowerLimit<=@salary/12 and @salary/12<=ISNULL(TaxRangeUpperLimit,99999999) and TaxRateType=@type and @type=3

	return @tax

end