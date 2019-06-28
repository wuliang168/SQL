-- VJT_employee

SELECT a.EID, b.证件编号 AS CARDID, 
CASE WHEN 归属 = N'总部' THEN N'浙商证券本部(05B0901)' 
WHEN 归属 = N'营业部' THEN N'浙商证券网点(05B0902)' 
WHEN 归属 = N'分公司' THEN N'浙商证券分公司(05B0903)' 
WHEN 归属 = N'子公司' and a.COMPID=12 THEN N'浙江浙商资本管理有限公司(05B090402)' 
WHEN 归属 = N'子公司' and a.COMPID=13 THEN N'浙江浙商证券资产管理有限公司(05B090401)' 
WHEN 归属 = N'子公司' and a.COMPID=14 THEN N'浙商期货有限公司(05B090403)'
END AS company, a1.JTID, NULL AS position, b.工号 AS badge, 
b.姓名 AS name, '' AS oldname, b.性别 AS sex, ISNULL(c1.Title, N'汉族') AS mingzu, b.出生日期 AS csrq, b.年龄 AS age, c4.Title AS jiguan, 
c.BirthPlace AS csd, ISNULL(b.政治面貌, N'群众') AS zzmb, c2.Title AS hyzk, b.开始工作日期 AS ksgzrq, OA_Mail AS email,c.Mobile as Mobile, 
b.入职日期 AS joindate, (CASE WHEN c.RESIDENT = '02' THEN N'农业户口' ELSE N'非农业户口' END) AS hukou, c.residentAddress, b.最高学历 AS maxxueli, 
b.最高学位 AS maxxuewei, N'社会招聘' AS rzly, N'技术岗位' AS gwlb, N'合同制' AS rylb, N'否' AS isjtzc, b.国籍 AS nation, N'是' AS sfnrgongzi
FROM dbo.eVW_employee AS a 
LEFT OUTER JOIN dbo.ZS_employee AS b ON b.工号 = a.Badge 
LEFT OUTER JOIN dbo.eDetails AS c ON a.EID = c.EID 
LEFT OUTER JOIN dbo.eCD_Nation AS c1 ON c.Nation = c1.Code 
LEFT OUTER JOIN dbo.eCD_Marriage AS c2 ON c.Marriage = c2.Code 
LEFT OUTER JOIN dbo.eCD_Resident AS c3 ON c.Resident = c3.Code 
LEFT OUTER JOIN dbo.eCD_Place AS c4 ON c.place = c4.ID 
LEFT OUTER JOIN dbo.oDepartment AS a1 ON a.depid1 = a1.DepID 
LEFT OUTER JOIN dbo.oJob as a2 ON a.JobID=a2.JobID
WHERE (a.Status IN (1, 2, 3))