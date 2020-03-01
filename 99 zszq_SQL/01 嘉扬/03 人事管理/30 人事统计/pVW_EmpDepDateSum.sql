-- pVW_EmpDepDateSum

SELECT DepType,DepID,SUM(JoinMM) AS JoinMMSum,SUM(JoinYY) AS JoinYYSum,SUM(LeaMM) AS LeaMMSum,SUM(LeaYY) AS LeaYYSum
FROM dbo.pVW_EmpDepDate AS a
GROUP BY DepType, DepID