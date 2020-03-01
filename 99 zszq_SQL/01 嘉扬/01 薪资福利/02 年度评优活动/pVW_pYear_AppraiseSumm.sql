-- pVW_pYear_AppraiseSumm
---- EID
------ 非年度优秀员工
select a.pYear_ID as pYear_ID,a.AppraiseID as AppraiseID,b.Name as Name,a.EID as AppraiseEID,NULL as AppraiseIdentification,
b.CompID as CompID,b.DepID as DepID,c.Title as JobTitle,NULL as IsCRM,NULL as AppraiseDepID,NULL as AppraiseOrder,COUNT(a.EID) as AppraiseCount
from pYear_Appraise a,eEmployee b,oJob c
where a.EID is NOT NULL and a.EID=b.EID and b.JobID=c.JobID and a.AppraiseID<>11
group by a.pYear_ID,a.AppraiseID,a.EID,b.Name,b.CompID,b.DepID,c.Title
------ 年度优秀员工
UNION
select a.pYear_ID as pYear_ID,a.AppraiseID as AppraiseID,b.Name as Name,a.EID as AppraiseEID,NULL as AppraiseIdentification,
b.CompID as CompID,b.DepID as DepID,c.Title as JobTitle,NULL as IsCRM,NULL as AppraiseDepID,a.AppraiseOrder as AppraiseOrder,COUNT(a.EID) as AppraiseCount
from pYear_Appraise a,eEmployee b,oJob c
where a.EID is NOT NULL and a.EID=b.EID and b.JobID=c.JobID and a.AppraiseID=11
group by a.pYear_ID,a.AppraiseID,a.EID,b.Name,b.CompID,b.DepID,c.Title,a.AppraiseOrder

---- Identification
UNION
select a.pYear_ID as pYear_ID,a.AppraiseID as AppraiseID,b.Name as Name,NULL as AppraiseEID,a.Identification as AppraiseIdentification,
11 as CompID,b.DepID as DepID,b.JobTitle as JobTitle,1 as IsCRM,NULL as AppraiseDepID,NULL as AppraiseOrder,COUNT(a.Identification) as AppraiseCount
from pYear_Appraise a,pCRMStaff b
where a.Identification is NOT NULL and a.Identification=b.Identification
group by a.pYear_ID,a.AppraiseID,a.Identification,b.Name,b.DepID,b.JobTitle,a.AppraiseOrder

---- DepID
UNION
select a.pYear_ID as pYear_ID,a.AppraiseID as AppraiseID,NULL as Name,NULL as AppraiseEID,NULL as AppraiseIdentification,
b.CompID as CompID,NULL as DepID,NULL as JobTitle,NULL as IsCRM,a.DepID as AppraiseDepID,NULL as AppraiseOrder,COUNT(a.DepID) as AppraiseCount
from pYear_Appraise a,oDepartment b
where a.DepID is NOT NULL and a.DepID=b.DepID
group by a.pYear_ID,a.AppraiseID,a.DepID,b.CompID,a.AppraiseOrder