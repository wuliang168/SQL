declare @calcdate smalldatetime
set @calcdate=GETDATE()

select DepType,DepID,SUM(JoinMM) AS JoinMMSum,SUM(JoinYY) AS JoinYYSum,SUM(LeaMM) AS LeaMMSum,SUM(LeaYY) AS LeaYYSum
from (select m.DepType,m.DepID,
(case when DATEDIFF(MM,o.JoinDate,@calcdate)=0 then COUNT(n.EID) end) as JoinMM,
(case when DATEDIFF(YY,o.JoinDate,@calcdate)=0 then COUNT(n.EID) end) as JoinYY,
(case when DATEDIFF(MM,o.LeaDate,@calcdate)=0 then COUNT(n.EID) end) as LeaMM,
(case when DATEDIFF(YY,o.LeaDate,@calcdate)=0 then COUNT(n.EID) end) as LeaYY
from eEmployee n,oDepartment m,eStatus o 
where dbo.eFN_getdepid1st(n.DepID)=m.DepID and n.EID=o.EID 
group by m.DepType,m.DepID,o.JoinDate,o.LeaDate) a
GROUP BY DepType, DepID