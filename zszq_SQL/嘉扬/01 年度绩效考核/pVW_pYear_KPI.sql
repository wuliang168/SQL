-- pVW_pYear_KPI
---- pYear_KPI_all
select ID,EID,pYear_ID,Xorder,Title,KPI
from pYear_KPI_all

---- pYear_KPI
UNION
select ID,EID,pYear_ID,Xorder,Title,KPI
from pYear_KPI