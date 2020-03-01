-- pVW_pEMPTrgtRspCntr

select a.EID as EID,b.Badge as Badge,b.Name as Name,a.KPIID as KPIID,b.CompID as CompID,b.DepID1st as DepID1st,b.DepID2nd as DepID2nd,b.JobTitle as JobTitle,a.TRCBeginDate,a.TRCEndDate,
c.TRCKPI as TRCKPIComb
from pEMPTrgtRspCntr a
inner join pVW_Employee b on a.EID=b.EID
-- 考核目标
left join (select EID,TRCKPI=(STUFF((select N'；'+Convert(VARCHAR(2),ROW_NUMBER() over(partition by EID order by ID))
+N'、 业绩目标：'+TRCKPI+(case when TRCTARGET is NULL then N'，财务目标：创收'+ISNULL(Convert(VARCHAR(10),FLOOR(TRCTargetValue)),'')+N'万元' else N'，非财务目标：'+TRCTARGET end)+N'，权重：'
+Convert(VARCHAR(3),FLOOR(TRCWeight*100))+'%' from pEMPTrgtRspCntr_KPI where EID=a.EID for xml path('')),1,1,'')) from pEMPTrgtRspCntr_KPI a group by EID) c on a.EID=c.EID