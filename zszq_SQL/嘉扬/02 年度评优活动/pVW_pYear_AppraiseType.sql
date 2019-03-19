-- pVW_pYear_AppraiseType
-- 浙商年度最高荣誉奖
---- 卓越团队   1
------ 公司领导(349)
SELECT a.EID as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM eEmployee a,oCD_AppraiseType b
WHERE b.ID=1 and a.DepID in (349) and a.Status not in (4,5) and a.EID not in (1022,5014,5587) -- 不包含公司一把手(董事长(1022)、总裁(5014)、书记(5587))
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715))
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=1
AND a.DepID not in (349,743,695,715) and ISNULL(a.AdminID,0) not in (743,695,715)
------ 总部部门(含信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743,695,715) and b.ID=1
------ 资管(393)、资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393,392) and b.ID=1
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=1

---- 浙商之星   2
------ 公司领导(349)
UNION
SELECT a.EID as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM eEmployee a,oCD_AppraiseType b
WHERE b.ID=2 and a.DepID in (349) and a.Status not in (4,5) and a.EID not in (1022,5014,5587) -- 不包含公司一把手(董事长(1022)、总裁(5014)、书记(5587))
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715))
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=2
AND a.DepID not in (349,743,695,715) and ISNULL(a.AdminID,0) not in (743,695,715)
------ 总部部门(含信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743,695,715) and b.ID=2
------ 资管(393)、资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393,392) and b.ID=2
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=2


-- 浙商年度专业团队奖
---- 转型创新先锋团队   3
------ 公司领导(349)
UNION
SELECT a.EID as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM eEmployee a,oCD_AppraiseType b
WHERE b.ID=3 and a.DepID in (349) and a.Status not in (4,5) and a.EID not in (1022,5014,5587) -- 不包含公司一把手(董事长(1022)、总裁(5014)、书记(5587))
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715))
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=3
AND a.DepID not in (349,743,695,715) and ISNULL(a.AdminID,0) not in (743,695,715)
------ 总部部门(含信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743,695,715) and b.ID=3
------ 资管(393)、资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393,392) and b.ID=3
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=3

---- 进步最快团队 4
------ 公司领导(349)
UNION
SELECT a.EID as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM eEmployee a,oCD_AppraiseType b
WHERE b.ID=4 and a.DepID in (349) and a.Status not in (4,5) and a.EID not in (1022,5014,5587) -- 不包含公司一把手(董事长(1022)、总裁(5014)、书记(5587))
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715))
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=4
AND a.DepID not in (349,743,695,715) and ISNULL(a.AdminID,0) not in (743,695,715)
------ 总部部门(含信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743,695,715) and b.ID=4
------ 资管(393)、资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393,392) and b.ID=4
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=4


-- 浙商年度专业标兵奖
---- 管理英才   5
------ 公司领导(349)
UNION
SELECT a.EID as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM eEmployee a,oCD_AppraiseType b
WHERE b.ID=5 and a.DepID in (349) and a.Status not in (4,5) and a.EID not in (1022,5014,5587) -- 不包含公司一把手(董事长(1022)、总裁(5014)、书记(5587))
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715))
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=5
AND a.DepID not in (349,743,695,715) and ISNULL(a.AdminID,0) not in (743,695,715)
------ 总部部门(含信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743,695,715) and b.ID=5
------ 资管(393)、资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393,392) and b.ID=5
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=5

---- 优秀经理人  6
------ 公司领导(349)
UNION
SELECT a.EID as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM eEmployee a,oCD_AppraiseType b
WHERE b.ID=6 and a.DepID in (349) and a.Status not in (4,5) and a.EID not in (1022,5014,5587) -- 不包含公司一把手(董事长(1022)、总裁(5014)、书记(5587))
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715))
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=6
AND a.DepID not in (349,743,695,715) and ISNULL(a.AdminID,0) not in (743,695,715)
------ 总部部门(含信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743,695,715) and b.ID=6
------ 资管(393)、资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393,392) and b.ID=6
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=6

---- 展业精英   7
------ 投资银行、资产管理子公司
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,
1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,5 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (695,393) and b.ID=7
------ 财富管理中心（事业部）(715)、浙商证券研究所(361)
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (715,361) and b.ID=7
------ 网点运营管理总部(362)
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (362) and b.ID=7
------ 分公司、营业部
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,(select COUNT(DepID) from oDepartment where dbo.eFN_getdepid1st(DepID)=a.DepID)*2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=7

---- 服务明星   8
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=8
AND a.DepID not in (349,743,695,715) and ISNULL(a.AdminID,0) not in (743,695,715)
------ 总部部门(含信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743,695,715) and b.ID=8
------ 资管(393)、资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,b.AppraiseLimit as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393,392) and b.ID=8
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,(select COUNT(DepID) from oDepartment where dbo.eFN_getdepid1st(DepID)=a.DepID)*2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=8

---- 浙商卫士   9
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715))
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=9
AND a.DepID not in (349,743,695,715) and ISNULL(a.AdminID,0) not in (743,695,715)
------ 总部部门(含信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743,695,715) and b.ID=9
------ 资管(393)、资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,b.AppraiseLimit as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393,392) and b.ID=9
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,(select COUNT(DepID) from oDepartment where dbo.eFN_getdepid1st(DepID)=a.DepID)*2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=9

---- 运营标兵   10
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715))
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=10
AND a.DepID not in (349,743,695,715) and ISNULL(a.AdminID,0) not in (743,695,715)
------ 总部部门(含信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743,695,715) and b.ID=10
------ 资管(393)、资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,b.AppraiseLimit as Limit,NULL as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393,392) and b.ID=10
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,b.AppraiseLimit as Limit,(select COUNT(DepID) from oDepartment where dbo.eFN_getdepid1st(DepID)=a.DepID)*2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=10


-- 年度优秀员工   11
------ 总部部门(不含公司领导(349)、信息技术事业部(743)、投资银行(695)、财富管理中心（事业部）(715)、研究部(361)、FICC事业部(383)、网点运营管理总部(362)、经纪业务总部(738))
UNION
SELECT distinct a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,NULL as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (1) and a.DepGrade=1 and b.ID=11
AND a.DepID not in (349,743,695,715,361,383,362,738) and ISNULL(a.AdminID,0) not in (743,695)
------ 总部部门(经纪业务总部(738)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,NULL as Limit,4 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (738) and b.ID=11
------ 总部部门(网点运营管理总部(362)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,NULL as Limit,4 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (362) and b.ID=11
------ 总部部门(含财富管理中心（事业部）(715)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,NULL as Limit,4 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (715) and b.ID=11
------ 总部部门(含信息技术事业部(743)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,NULL as Limit,7 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (743) and b.ID=11
------ 总部部门(含研究部(361)、FICC事业部(383)) 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,NULL as Limit,4 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (361,383) and b.ID=11
------ 投资银行(695)
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,NULL as Limit,28 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (695) and b.ID=11
------ 资本(392)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,1 as AppraiseStatus,
b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,b.ID as AppraiseID,NULL as Limit,2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (392) and b.ID=11
------ 资产管理子公司(393)
UNION
SELECT (case when a.DepID=393 then (select Director from oDepartment where DepID in (544)) else a.Director END) as AppraiseEID,
1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,NULL as Limit,13 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepID in (393) and b.ID=11
------ 分公司、营业部 1
UNION
SELECT a.Director as AppraiseEID,1 as AppraiseStatus,b.AppraiseType as AppraiseType,b.AppraiseSubType as AppraiseSubType,
b.ID as AppraiseID,NULL as Limit,(select COUNT(DepID) from oDepartment where dbo.eFN_getdepid1st(DepID)=a.DepID)*2 as DepLimit
FROM oDepartment a,oCD_AppraiseType b
WHERE ISNULL(a.IsDisabled,0)=0 and a.Director is not NULL and a.DepType in (2,3) and a.DepGrade=1 and b.ID=11