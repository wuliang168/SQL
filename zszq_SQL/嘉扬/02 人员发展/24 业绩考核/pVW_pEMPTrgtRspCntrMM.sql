-- pVW_pEMPTrgtRspCntrMM

select a.TRCMonth as TRCMonth,a.ProcessID as ProcessID,a.EID as EID,b.Badge as Badge,b.Name as Name,a.KPIID as KPIID,b.CompID as CompID,b.DepID1st as DepID1st,b.DepID2nd as DepID2nd,b.JobTitle as JobTitle,a.TRCBeginDate,a.TRCEndDate,
c.TRCKPI,d.TRCKPIActual
from pEMPTrgtRspCntrMM a
inner join pVW_Employee b on a.EID=b.EID
-- 考核目标
left join (select EID,TRCKPI=(STUFF((select N'；'+Convert(VARCHAR(2),ROW_NUMBER() over(partition by EID order by ID))
+N'、 业绩目标：'+TRCKPI+(case when TRCTARGET is NULL then N'，财务目标：创收'+ISNULL(Convert(VARCHAR(10),FLOOR(TRCTargetValue)),'')+N'万元' else N'，非财务目标：'+TRCTARGET end)+N'，权重：'
+Convert(VARCHAR(3),FLOOR(TRCWeight*100))+'%' from pEMPTrgtRspCntrKPIMM where EID=a.EID for xml path('')),1,1,'')) from pEMPTrgtRspCntrKPIMM a group by EID) c on a.EID=c.EID
-- 考核结果
left join (select EID,TRCKPIActual=(STUFF((select N'；'+Convert(VARCHAR(2),ROW_NUMBER() over(partition by EID order by ID))
+(case when TRCTARGET is NULL then N'、实际完成财务目标：'+ISNULL(Convert(VARCHAR(10),TRCActualValue),0.00)+N'万元' else N'、实际完成非财务目标：'+ISNULL(TRCActualTarget,'') end)+N'，累计达成率：'+
ISNULL(Convert(VARCHAR(10),cast(ROUND(TRCAchRate*100,2) as numeric(5,2))),0.00)+'%' from pEMPTrgtRspCntrKPIMM 
where EID=a.EID for xml path('')),1,1,'')) from pEMPTrgtRspCntrKPIMM a group by EID) d on a.EID=d.EID