-- pVW_EmpDepSTATSum

select a.DepType,a.DepID,SUM(a.EMP) as EMPSum,SUM(a.GenderM) as GenderMSum,SUM(a.GenderF) as GenderFSum,SUM(a.EMP*a.AVGAGE)/SUM(a.EMP) as AVGAGESum,
SUM(a.HighLev_ASSTT) as HighLev_ASSTTSum,SUM(a.HighLev_UGTT) as HighLev_UGTTSum,SUM(a.HighLev_MSTT) as HighLev_MSTTSum,SUM(a.HighLev_DTTT) as HighLev_DTTTSum,
SUM(a.WorkDate1t5YTT) as WorkDate1t5YTTSum,SUM(a.WorkDate5t10YTT) as WorkDate5t10YTTSum,SUM(a.WorkDate10YTT) as WorkDate10YTTSum,SUM(a.JoinDate3YTT) as JoinDate3YTTSum
from pVW_EmpDepSTAT a
group by a.DepType,a.DepID