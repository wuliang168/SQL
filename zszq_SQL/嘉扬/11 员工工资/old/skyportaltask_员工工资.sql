------------- 月度工资 ------------
-- 薪酬类型非营业部;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550010'',''leftid^' + cast(a.SalaryPayID AS nvarchar(15)) + 
N''',''月度工资分配反馈'')">请您完成' + cast(datepart(yy, GETDATE()) AS varchar(10)) + 
N'年' + cast(datepart(mm, a.Date) AS varchar(10)) + N'月' + b.Title + N'员工月度工资分配</a>' AS url, 
a.SalaryContact AS approver, 1 AS id
FROM pDepSalaryPerMonth a,oCD_SalaryPayType b
WHERE a.SalaryPayID=b.ID AND a.SalaryPayID not in (6,8) AND ISNULL(IsSubmit,0)=0 AND a.SalaryContact is not NULL
and a.SalaryContact in (5256,4404,1621)

---- 测试用
-- 薪酬类型为营业部;
UNION
SELECT DISTINCT
N'<a href="#" onclick="moveTo(''1.0.550020'',''leftid^' + cast(b.DepID AS nvarchar(15)) + 
N''',''月度工资分配反馈'')">请您完成' + cast(datepart(yy, GETDATE()) AS varchar(10)) + 
N'年' + cast(datepart(mm, a.Date) AS varchar(10)) + N'月' + b.DepAbbr + N'员工月度工资分配</a>' AS url, 
a.SalaryContact AS approver, 1 AS id
FROM pDepSalaryPerMonth a,odepartment b
WHERE a.DepID=b.DepID AND a.SalaryPayID in (6) AND ISNULL(IsSubmit,0)=0 AND a.SalaryContact is not NULL
and a.SalaryContact in (5256,4404,1621)