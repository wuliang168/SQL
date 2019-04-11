select a.Name as 姓名,b.Title as 公司,c.DepAbbr as 一级部门,d.DepAbbr as 二级部门,e.DepAbbr as 三级部门,f.JobAbbr as 岗位,g.CertNo as 身份证编号,f.xorder as 排序
from zszq.dbo.eEmployee as a
inner join zszq.dbo.oCompany as b on a.CompID=b.CompID
left join zszq.dbo.oDepartment as c on zszq.dbo.eFN_getdepid1st(a.DepID)=c.DepID
left join zszq.dbo.oDepartment as d on zszq.dbo.eFN_getdepid2nd(a.DepID)=d.DepID
left join zszq.dbo.oDepartment as e on zszq.dbo.eFN_getdepid3th(a.DepID)=e.DepID
inner join zszq.dbo.oJob as f on a.JobID=f.JobID
inner join zszq.dbo.eDetails as g on a.EID=g.EID
where a.Status not in (4,5)