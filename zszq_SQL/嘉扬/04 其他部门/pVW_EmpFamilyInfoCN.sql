-- pVW_EmpFamilyInfoCN

SELECT e.xorder AS 排序,g.Account as OA账号,
a.Badge as 工号, a.Name as 姓名,b.Fname as 亲属姓名,b.CERTID as 亲属证件号码,b.relation as 亲属关系,b.tel as 亲属手机号码
FROM dbo.eEmployee AS a 
INNER JOIN ebg_family AS b on a.EID=b.EID
INNER JOIN dbo.oJob AS e ON a.JobID = e.JobID
INNER JOIN dbo.SkySecUser AS g on a.EID=g.EID
WHERE a.Status not in (5)