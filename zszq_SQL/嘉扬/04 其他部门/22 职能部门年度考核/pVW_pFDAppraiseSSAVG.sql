-- pVW_pFDAppraiseSSAVG
select pYear_ID as pYear_ID,DepID as DepID,Director as Director,FDAppraiseType as FDAppraiseType,Status as Status,
ROUND(AVG(Score1),2) as Score1AVG,ROUND(AVG(Score2),2) as Score2AVG,ROUND(AVG(Score3),2) as Score3AVG,
ROUND(AVG(Score1),2)+ROUND(AVG(Score2),2)+ROUND(AVG(Score3),2) as SSAVG
from pFDAppraise 
where Status=1 and FDAppraiseType=3
group by pYear_ID,DepID,Director,FDAppraiseType,Status