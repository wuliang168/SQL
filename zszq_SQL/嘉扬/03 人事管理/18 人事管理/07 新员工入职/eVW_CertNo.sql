-- eVW_CertNo

---- 中国公民
SELECT a.ID, a.Badge, a.Name, a.CompID, a.DepID, a.JobID, a.emptype, a.status, a.JoinDate, a.certno, a.Gender, a.Birthday, N'中国公民身份证不能为空' AS Remark
FROM eStaff_Register a
WHERE a.country = '41' AND a.certno IS NULL
---- 长度判断
UNION ALL
SELECT a.ID, a.Badge, a.Name, a.CompID, a.DepID, a.JobID, a.emptype, a.status, a.JoinDate, a.certno, a.Gender, a.Birthday, N'身份证长度不合常理' AS Remark
FROM eStaff_Register a
WHERE a.country = '41' AND Len(a.certno) NOT IN (15, 18) AND a.certno IS NOT NULL
---- 身份证字符判断
UNION ALL
SELECT a.ID, a.Badge, a.Name, a.CompID, a.DepID, a.JobID, a.emptype, a.status, a.JoinDate, a.certno, a.Gender, a.Birthday, N'身份证具有无效字符' AS Remark
FROM eStaff_Register a
WHERE a.country = '41' AND a.certno IS NOT NULL AND Len(a.certno) IN (15, 18) AND Isnumeric(CASE Len(a.certno) WHEN 18 THEN Substring(a.certno, 1, 17) ELSE a.certno END) = 0
---- 身份证与性别判断
UNION ALL
SELECT a.ID, a.Badge, a.Name, a.CompID, a.DepID, a.JobID, a.emptype, a.status, a.JoinDate, a.certno, a.Gender, a.Birthday, N'身份证与性别不符' AS Remark
FROM eStaff_Register a
WHERE a.country = '41' AND a.certno IS NOT NULL AND Len(a.certno) IN (15, 18) AND (CASE (CASE WHEN Len(a.certno) = 15 THEN RIGHT(a.certno, 1) WHEN Len(a.certno) = 18 THEN LEFT(RIGHT(a.certno, 
2), 1) END) % 2 WHEN 1 THEN 1 WHEN 0 THEN 2 END) <> a.Gender
---- 身份证与出生日期判断
UNION ALL
SELECT a.ID, a.Badge, a.Name, a.CompID, a.DepID, a.JobID, a.emptype, a.status, a.JoinDate, a.certno, a.Gender, a.Birthday, N'身份证与出生日期不符' AS Remark
FROM eStaff_Register a
WHERE a.country = '41' AND a.certno IS NOT NULL AND Len(a.certno) IN (15, 18) AND IsDate(CASE WHEN Len(a.certno) = 15 THEN '19' + Substring(a.certno, 7, 2) + '-' + Substring(a.certno, 9, 2) 
+ '-' + Substring(a.certno, 11, 2) ELSE Substring(a.certno, 7, 4) + '-' + Substring(a.certno, 11, 2) + '-' + Substring(a.certno, 13, 2) END) = 1 AND Datediff(Day, a.Birthday, (CASE WHEN Len(a.certno) 
= 15 THEN '19' + Substring(a.certno, 7, 2) + '-' + Substring(a.certno, 9, 2) + '-' + Substring(a.certno, 11, 2) ELSE Substring(a.certno, 7, 4) + '-' + Substring(a.certno, 11, 2) + '-' + Substring(a.certno, 13, 2) 
END)) <> 0
---- 身份证校验码判断
UNION ALL
SELECT a.ID, a.Badge, a.Name, a.CompID, a.DepID, a.JobID, a.emptype, a.status, a.JoinDate, a.certno, a.Gender, a.Birthday, a.Name + N'的身份证校验码错误' AS Remark
FROM eStaff_Register a
WHERE a.certno <> dbo.eFN_CID18CheckSum(a.certno)
AND Len(a.certno) IN (18) AND a.certno IS NOT NULL
---- 身份证重复判断
UNION ALL
SELECT a.ID, a.Badge, a.Name, a.CompID, a.DepID, a.JobID, a.emptype, a.status, a.JoinDate, a.certno, a.Gender, a.Birthday, N'与员工:' + c.Badge + '-' + c.Name + N' 重复' AS Remark
FROM eStaff_Register a, eEmployee c, eDetails d
WHERE c.EID = d .EID AND LEFT((CASE WHEN Len(a.certno) = 15 THEN LEFT(a.certno, 6) + '19' + RIGHT(a.certno, 9) + 'X' ELSE a.certno END), 17) = LEFT((CASE WHEN Len(d.certno) 
= 15 THEN LEFT(d.certno, 6) + '19' + RIGHT(d.certno, 9) + 'X' ELSE d.certno END), 17) AND Len(a.certno) IN (15, 18) AND Len(d.certno) IN (15, 18) AND a.certno IS NOT NULL AND 
d.certno IS NOT NULL AND c.status NOT IN (4, 5)