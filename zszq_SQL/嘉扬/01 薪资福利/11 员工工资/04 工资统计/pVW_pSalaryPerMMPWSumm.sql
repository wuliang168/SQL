-- pVW_pSalaryPerMMPWSumm

select distinct a.ProcessID as ProcessID,a.DepID as DepID,a.SalaryContact as SalaryContact,a.PerMMSummType as PerMMSummType,a.EMPType as EMPType,a.EMPSalary,
b.EMPPerfSumm as EMPPerfSumm,c.EMPWelfareSumm as EMPWelfareSumm,ISNULL(a.EMPSalary,0)+ISNULL(b.EMPPerfSumm,0)+ISNULL(c.EMPWelfareSumm,0) as EMPSUMMTotalSumm
from pSalaryPerMMSumm_register a
left join (select ProcessID,DepID,EMPType,SUM(EMPPerfWelSumm) as EMPPerfSumm from pSalaryPerMMPWSumm 
where EMPPerfWelType in (select ID from oCD_MonthExpenseType where Title in (N'营销费用',N'项目奖金',N'CRM提成',N'服务支持绩效',N'年度奖金')) group by ProcessID,DepID,EMPType) 
as b on a.ProcessID=b.ProcessID and a.DepID=b.DepID and a.EMPType=b.EMPType
left join (select ProcessID,DepID,EMPType,SUM(EMPPerfWelSumm) as EMPWelfareSumm from pSalaryPerMMPWSumm 
where EMPPerfWelType in (select ID from oCD_MonthExpenseType where Title in (N'过节费',N'高温\取暖费',N'通讯费')) group by ProcessID,DepID,EMPType) 
as c on a.ProcessID=c.ProcessID and a.DepID=c.DepID and a.EMPType=c.EMPType
where a.PerMMSummType=1