-- pVW_pYear_ScoreSum

--------- 总部部门负责人 --------
-- 1-总部部门负责人
-- Score_Status=2：50%              战略企划部考核(部门年度工作计划)
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,
a.ScoreTotal*a.Weight1/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=1 and a.Score_Status=2
--------- 总部部门副职 --------
-- 2-总部部门副职
-- Score_Status=2：50%*50%          总部部门负责人考核(部门年度工作计划)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,
a.ScoreTotal*a.Weight1/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=2 and a.Score_Status=2
------ 一级分支机构负责人 ------
-- 31-一级分支机构负责人
-- Score_Status=2：60%              网点运营管理总部考核(经营业绩指标)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,
a.ScoreTotal*a.Weight1/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=31 and a.Score_Status=2
-- Score_Status=3：15%              法律合规部考核(合规管理有效性)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,
NULL as ScoreSTG1,a.ScoreTotal*a.Weight1/100*ISNULL(a.Modulus,100)/100 as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=31 and a.Score_Status=3
------ 一级分支机构副职及二级分支机构经理室成员 ------
-- 32-一级分支机构副职及二级分支机构经理室成员
-- Score_Status=2：(50%+10%)*50%    分公司负责人考核(工作任务目标50%、合规管理有效性10%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,
(a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=32 and a.Score_Status=2
--------- 二级分支机构普通员工 --------
-- 34-二级分支机构普通员工
-- Score_Status=2：70%*60%              二级分支机构负责人考核(工作业绩、工作态度、工作能力和合规风控性)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,
a.ScoreTotal*a.Weight1/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=34 and a.Score_Status=2
--------- 兼职合规管理 --------
-- 35-兼职合规管理
-- Score_Status=7：100%*51%               法律合规部负责人考核(兼合规管理)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,
a.ScoreTotal*a.Weight1/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type2=35 and a.Score_Status=7
--------- 分支机构区域财务经理 --------
-- 17-分支机构区域财务经理
-- Score_Status=2：(60%+40%)*30%        分支机构负责人考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,
(a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=17 and a.Score_Status=2
-- Score_Status=3：(60%+40%)*30%        计划财务部负责人考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,
NULL as ScoreSTG1,(a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=17 and a.Score_Status=3
--------- 综合会计 --------
-- 19-综合会计
-- Score_Status=2：(60%+40%)*20%        分支机构负责人考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,
(a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=19 and a.Score_Status=2
-- Score_Status=3：(60%+40%)*40%        区域财务经理考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,
NULL as ScoreSTG1,(a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG2,NULL as ScoreCompl
from pYear_Score a
WHERE a.Score_Type1=19 and a.Score_Status=3