-- pVW_pEMPTrgtRspCntrMM

select a.TRCMonth as TRCMonth,a.ProcessID as ProcessID,a.EID as EID,b.Badge as Badge,b.Name as Name,b.CompID as CompID,b.DepID1st as DepID1st,b.DepID2nd as DepID2nd,b.JobTitle as JobTitle,a.TRCBeginDate,a.TRCEndDate,
c.TRCKPI,d.TRCKPIActual,e.CommRT,f.CommHR
from pEMPTrgtRspCntrMM a
inner join pVW_Employee b on a.EID=b.EID
-- 考核目标
left join (select EID,TRCKPI=(STUFF((select N'；'+Convert(VARCHAR(2),ROW_NUMBER() over(partition by EID order by ID))
+N'、 '+TRCKPI+N'，目标'+(case when TRCTARGET is NULL then N'创收'+ISNULL(Convert(VARCHAR(10),FLOOR(TRCTargetValue)),'')+N'万元' else TRCTARGET end)+N'，权重'
+Convert(VARCHAR(3),FLOOR(TRCWeight*100))+'%' from pEMPTrgtRspCntrKPIMM where EID=a.EID for xml path('')),1,1,'')) from pEMPTrgtRspCntrKPIMM a group by EID) c on a.EID=c.EID
-- 考核结果
left join (select EID,TRCKPIActual=(STUFF((select N'；'+Convert(VARCHAR(2),ROW_NUMBER() over(partition by EID order by ID))+N'、 实际完成'
+(case when TRCTARGET is NULL then ISNULL(Convert(VARCHAR(10),TRCActualValue),0.00)+N'万元' else ISNULL(TRCActualTarget,'') end)+N'，达成率'+
ISNULL(Convert(VARCHAR(10),cast(ROUND(TRCAchRate*100,2) as numeric(5,2))),0.00)+'%' from pEMPTrgtRspCntrKPIMM 
where EID=a.EID for xml path('')),1,1,'')) from pEMPTrgtRspCntrKPIMM a group by EID) d on a.EID=d.EID
-- 部门意见反馈
left join (select EID,CommRT=(STUFF((select N'；'+Convert(VARCHAR(2),ROW_NUMBER() over(partition by EID order by ID))+N'、 '+CommRT from pEMPTrgtRspCntrKPIMM 
where EID=a.EID for xml path('')),1,1,'')) from pEMPTrgtRspCntrKPIMM a group by EID) e on a.EID=e.EID
-- 人力资源部意见反馈
left join (select EID,CommHR=(STUFF((select N'；'+Convert(VARCHAR(2),ROW_NUMBER() over(partition by EID order by ID))+N'、 '+CommHR from pEMPTrgtRspCntrKPIMM 
where EID=a.EID for xml path('')),1,1,'')) from pEMPTrgtRspCntrKPIMM a group by EID) f on a.EID=f.EID