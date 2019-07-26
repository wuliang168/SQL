-- pVW_pAnnualBonusDep

SELECT ID,ProcessID ,Year, Date, a.AnnualBonusDepID, Director,AnnualBonusType,
-- 一级分支机构部门金额
AnnualBonusDep1stTotal,
-- 二级分支机构部门金额
a.AnnualBonusDep2ndTotal,
-- 二级分支机构部门分配剩余金额
---- 扣除已分配二级分支机构部门总金额；扣除已经分配一级分支机构员工总金额
(select AnnualBonusDep1stTotal from pYear_AnnualBonusDep where ISNULL(IsClosed,0)=0 and dbo.eFN_getdepid1st(a.AnnualBonusDepID)=AnnualBonusDepID and ProcessID=a.ProcessID)
-(select SUM(AnnualBonusDep2ndTotal) from pYear_AnnualBonusDep where ISNULL(IsClosed,0)=0 and dbo.eFN_getdepid1st(a.AnnualBonusDepID)=dbo.eFN_getdepid1st(AnnualBonusDepID) and ProcessID=a.ProcessID) 
- (SELECT ISNULL(SUM(AnnualBonus), 0) FROM dbo.pYear_AnnualBonus WHERE AnnualBonusDepID=dbo.eFN_getdepid1st(a.AnnualBonusDepID) and ProcessID=a.ProcessID) 
as AnnualBonusDEP2ndRest,
-- 二级分支机构部门员工分配金额
(SELECT ISNULL(SUM(AnnualBonus), 0) FROM pYear_AnnualBonus WHERE dbo.eFN_getdepid2nd(AnnualBonusDepID)=a.AnnualBonusDepID and ProcessID=a.ProcessID) AS AnnualBonusDEP2ndEMPTotal,
-- 二级分支机构部门员工分配剩余金额
AnnualBonusDep2ndTotal - (SELECT ISNULL(SUM(AnnualBonus), 0) FROM pYear_AnnualBonus WHERE dbo.eFN_getdepid2nd(AnnualBonusDepID)=a.AnnualBonusDepID and ProcessID=a.ProcessID) AS AnnualBonusDEP2ndEMPRest,
-- 一级分支机构部门员工分配金额
(SELECT ISNULL(SUM(AnnualBonus), 0) FROM dbo.pYear_AnnualBonus WHERE dbo.eFN_getdepid1st(AnnualBonusDepID) = a.AnnualBonusDepID and ProcessID=a.ProcessID) AS AnnualBonusDEP1stEMPTotal, 
-- 一级分支机构部门员工分配剩余金额
AnnualBonusDep1stTotal - (SELECT ISNULL(SUM(AnnualBonus), 0) FROM dbo.pYear_AnnualBonus WHERE dbo.eFN_getdepid1st(AnnualBonusDepID) = a.AnnualBonusDepID and ProcessID=a.ProcessID) AS AnnualBonusDEP1stEMPRest, 
Remark,IsSubmit,IsClosed
FROM dbo.pYear_AnnualBonusDep AS a
WHERE ISNULL(IsClosed,0)=0