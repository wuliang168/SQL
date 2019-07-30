-- pVW_EmpFamilyInfoEN

SELECT e.xorder AS xOrder,g.Account as OAAccount,
a.Badge as Badge, a.Name as Name,b.Fname as Fname,b.CERTID as FCertID,
(select Title from eCD_Relation where ID=b.relation) as FRelation,b.tel as FMobile
FROM dbo.eEmployee AS a 
INNER JOIN ebg_family AS b on a.EID=b.EID
INNER JOIN dbo.oJob AS e ON a.JobID = e.JobID
INNER JOIN dbo.SkySecUser AS g on a.EID=g.EID
WHERE a.Status not in (5)