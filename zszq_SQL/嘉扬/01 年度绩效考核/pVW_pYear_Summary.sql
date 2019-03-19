-- pVW_pYear_Summary
---- pYear_Summary_all
select ID,EID,pYear_ID,Summary,WordsCount
from pYear_Summary_all

---- pYear_Summary
UNION
select ID,EID,pYear_ID,Summary,WordsCount
from pYear_Summary