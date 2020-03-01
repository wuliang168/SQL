-- pVW_EmpGradeSTATSum

select a.DepType,a.EmpGrade,SUM(a.EMP) as EMPSum,SUM(a.GenderM) as GenderMSum,SUM(a.GenderF) as GenderFSum,SUM(a.EMP*a.AVGAGE)/SUM(a.EMP) as AVGAGESum,
SUM(a.HighLev_ASSTT) as HighLev_ASSTTSum,SUM(a.HighLev_UGTT) as HighLev_UGTTSum,SUM(a.HighLev_MSTT) as HighLev_MSTTSum,SUM(a.HighLev_DTTT) as HighLev_DTTTSum,
SUM(a.WorkDate1YTT) as WorkDate1YTTSum,SUM(a.WorkDate1t5YTT) as WorkDate1t5YTTSum,SUM(a.WorkDate5t10YTT) as WorkDate5t10YTTSum,SUM(a.WorkDate10YTT) as WorkDate10YTTSum,
SUM(a.JoinDate1YTT) as JoinDate1YTTSum,SUM(a.JoinDate1t3YTT) as JoinDate1t3YTTSum,SUM(a.JoinDate3t5YTT) as JoinDate3t5YTTSum,SUM(a.JoinDate5t8YTT) as JoinDate5t8YTTSum,
SUM(a.JoinDate8YTT) as JoinDate8YTTSum
from pVW_EmpGradeSTAT a
group by a.DepType,a.EmpGrade