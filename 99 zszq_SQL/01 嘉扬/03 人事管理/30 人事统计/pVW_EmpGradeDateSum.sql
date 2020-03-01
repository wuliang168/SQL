-- pVW_EmpGradeDateSum

SELECT DepType,EmpGrade,SUM(JoinMM) AS JoinMMSum,SUM(JoinYY) AS JoinYYSum,SUM(LeaMM) AS LeaMMSum,SUM(LeaYY) AS LeaYYSum
FROM dbo.pVW_EmpGradeDate AS a
GROUP BY DepType, EmpGrade