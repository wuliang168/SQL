-- pVW_EmpInfoCN

SELECT e.xorder AS 排序,g.Account as OA账号,
a.Badge as 工号, a.Name as 姓名,(select CompAbbr from oCompany where CompID=a.CompID) as 公司, 
(select DepAbbr from oDepartment where DepID=dbo.eFN_getdepid1st(a.DepID)) as 一级部门, (select DepAbbr from oDepartment where DepID=dbo.eFN_getdepid2nd(a.DepID)) as 二级部门, 
(select Title from oCD_DepType where ID=(select DepType from oDepartment where DepID=a.DepID)) as 部门归属,
(select JobAbbr from oJob where JobID=a.JobID) as 岗位, (select Title from eCD_EmpGrade where ID=a.EmpGrade) as 人事等级, (select Title from OCD_MDTYPE where ID=f.MDID) as MD职级,
(select Title from ECD_EMPSTATUS where ID=a.Status) as 在职状态, (select Title from eCD_Marriage where ID=c.Marriage) as 婚姻状态,
(select Title from eCD_Party where ID=c.party) as 政治面貌,c.Address as 联系地址,(select Title from eCD_Place where ID=c.Place) as 籍贯,
(select Title from eCD_City where ID=a.WorkCity) as 工作地, 
(select Title from eCD_Country where ID=c.Country) as 国籍, (select Title from eCD_CertType where ID=c.CertType) as 证件类型, c.CertNo as 证件编号, 
(select Title from eCD_Gender where ID=c.Gender) as 性别, c.BirthDay as 出生日期, DATEDIFF(yy, c.BirthDay, GETDATE()) AS 年龄, 
(select Title from eCD_EduType where ID=c.HighLevel) as 最高学历, (select Title from eCD_DegreeType where ID=c.HighDegree) as 最高学位, c.schoolname as 毕业院校,
b.JoinDate as 入职日期, ROUND(DATEDIFF(mm, b.JoinDate, GETDATE()) / 12.00 + ISNULL(b.Cyear_adjust, 0), 2) AS 司龄, 
b.JobBegindate as 从岗日期, ROUND(DATEDIFF(mm, b.JobBegindate, GETDATE())/12.00,2) AS 岗龄, 
c.WorkBeginDate as 开始工作日,ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) AS 工龄, 
b.isProb as 是否试用, b.ProbTerm as 试用期, b.ProbEndDate as 试用期结束日期, 
b.ConCount as 合同次数, (select Title from eCD_Contract where ID=b.contract) as 合同签约单位, (select Title from eCD_ConType where ID=b.ConType) as 合同类型, 
b.ConProperty as 合同属性, b.ConBeginDate as 合同开始日期, b.ConTerm as 合同期, b.ConEndDate as 合同结束日期,b.LeaDate as 离职日期
FROM dbo.eEmployee AS a 
INNER JOIN dbo.eStatus AS b ON a.EID = b.EID 
INNER JOIN dbo.eDetails AS c ON a.EID = c.EID 
INNER JOIN dbo.oDepartment AS d ON a.DepID = d.DepID 
INNER JOIN dbo.oJob AS e ON a.JobID = e.JobID
INNER JOIN dbo.pEmployeeEmolu AS f ON a.EID=f.EID
INNER JOIN dbo.SkySecUser AS g on a.EID=g.EID
where a.Status not in (5)