-- pVW_pYear_ScoreResultHHQ
---- pYear_Score
------ 分管领导考核
select a.EID,(ISNULL(b.Score2,0)+ISNULL(e.Score2,0)+ISNULL(f.Score2,0))*ISNULL(b.Weight2,100)/100*ISNULL(b.Modulus,100)/100 as ScoreSTG2,
ISNULL(c.Score2AVG,0)*ISNULL(c.Weight2,100)/100*ISNULL(c.Modulus,100)/100 as ScoreSTG3,
ISNULL(d.Score2AVG,0)*ISNULL(d.Weight2,100)/100*ISNULL(d.Modulus,100)/100 as ScoreSTG4,
(ISNULL(b.Score2,0)+ISNULL(e.Score2,0)+ISNULL(f.Score2,0))*ISNULL(b.Weight2,100)/100*ISNULL(b.Modulus,100)/100
+ISNULL(c.Score2AVG,0)*ISNULL(c.Weight2,100)/100*ISNULL(c.Modulus,100)/100
+ISNULL(d.Score2AVG,0)*ISNULL(d.Weight2,100)/100*ISNULL(d.Modulus,100)/100 as ScoreYear
from pYear_Score a
LEFT JOIN (select EID,Score_EID,Score2,Weight2,Modulus from pYear_Score where SCORE_TYPE1=1 and SCORE_STATUS=3) as b on a.EID=b.EID
LEFT JOIN (select EID,Score_EID,AVG(Score2) as Score2AVG,Weight2,Modulus from pYear_Score where SCORE_TYPE1=1 and SCORE_STATUS=4 group by EID,Score_EID,Weight2,Modulus) as c on a.EID=c.EID
LEFT JOIN (select EID,Score_EID,AVG(Score2) as Score2AVG,Weight2,Modulus from pYear_Score where SCORE_TYPE1=1 and SCORE_STATUS=9 group by EID,Score_EID,Weight2,Modulus) as d on a.EID=d.EID
LEFT JOIN (select EID,Score_EID,Score2,Weight2,Modulus from pYear_Score where SCORE_TYPE1=1 and SCORE_STATUS=10) as e on a.EID=e.EID and e.Score_EID=c.Score_EID
LEFT JOIN (select EID,Score_EID,Score2,Weight2,Modulus from pYear_Score where SCORE_TYPE1=1 and SCORE_STATUS=10) as f on a.EID=f.EID and f.Score_EID=d.Score_EID
where a.Score_Status=9 AND a.Score_Type1=1 AND ISNULL(a.isRanking,0)=1