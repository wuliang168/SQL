-- pVW_pYear_ScoreEachSumL

-------- 总部部门负责人胜任素质 测评总分计算 --------
-- EachLType=1,           -- 总部部门负责人 总部部门分管领导测评
-- EachLType=2,           -- 总部部门负责人 总部部门负责人互评
-- EachLType=3,           -- 总部部门负责人 总部部门员工测评
--
select a.EID,
-- 总部部门分管领导测评
SUM(case when a.EachLType=1 then a.ScoreTotal end) AS EachLEqSUM,
COUNT(case when a.EachLType=1 then a.ScoreTotal end) as EachLEqCOUNT,
AVG(case when a.EachLType=1 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLEpAVG,
-- 总部部门负责人互评
SUM(case when a.EachLType=2 then a.ScoreTotal end) AS EachLSubSUM,
COUNT(case when a.EachLType=2 then a.ScoreTotal end) as EachLSubCOUNT,
AVG(case when a.EachLType=2 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSubAVG,
-- 总部部门员工测评
SUM(case when a.EachLType=3 then a.ScoreTotal end) AS EachLSupSUM,
COUNT(case when a.EachLType=3 then a.ScoreTotal end) as EachLSupCOUNT,
AVG(case when a.EachLType=3 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSupAVG,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=1 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1


-------- 总部部门副职胜任素质 测评总分计算 --------
-- EachLType=5,           -- 总部部门副职 总部部门分管领导测评
-- EachLType=6,           -- 总部部门副职 总部部门负责人测评
-- EachLType=7,           -- 总部部门副职 总部部门员工测评
--
union
select a.EID,
-- 总部部门分管领导测评
SUM(case when a.EachLType=5 then a.ScoreTotal end) AS EachLEqSUM,
COUNT(case when a.EachLType=5 then a.ScoreTotal end) as EachLEqCOUNT,
AVG(case when a.EachLType=5 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLEpAVG,
-- 总部部门负责人测评
SUM(case when a.EachLType=6 then a.ScoreTotal end) AS EachLSubSUM,
COUNT(case when a.EachLType=6 then a.ScoreTotal end) as EachLSubCOUNT,
AVG(case when a.EachLType=6 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSubAVG,
-- 总部部门员工测评
SUM(case when a.EachLType=7 then a.ScoreTotal end) AS EachLSupSUM,
COUNT(case when a.EachLType=7 then a.ScoreTotal end) as EachLSupCOUNT,
AVG(case when a.EachLType=7 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSupAVG,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=2 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1


-------- 子公司部门负责人胜任素质 测评总分计算 --------
-- EachLType=11,         -- 子公司部门负责人 子公司总经理评测
-- EachLType=12,         -- 子公司部门负责人 子公司部门负责人互评
-- EachLType=13,         -- 子公司部门负责人 子公司部门员工评测
--
union
select a.EID,
-- 子公司总经理评测
SUM(case when a.EachLType=11 then a.ScoreTotal end) AS EachLEqSUM,
COUNT(case when a.EachLType=11 then a.ScoreTotal end) as EachLEqCOUNT,
AVG(case when a.EachLType=11 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLEpAVG,
-- 子公司部门负责人互评
SUM(case when a.EachLType=12 then a.ScoreTotal end) AS EachLSubSUM,
COUNT(case when a.EachLType=12 then a.ScoreTotal end) as EachLSubCOUNT,
AVG(case when a.EachLType=12 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSubAVG,
-- 子公司部门员工评测
SUM(case when a.EachLType=13 then a.ScoreTotal end) AS EachLSupSUM,
COUNT(case when a.EachLType=13 then a.ScoreTotal end) as EachLSupCOUNT,
AVG(case when a.EachLType=13 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSupAVG,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=10 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1


-------- 子公司部门副职胜任素质 测评总分计算 --------
-- EachLType=5,           -- 子公司部门副职 子公司部门分管领导测评
-- EachLType=6,           -- 子公司部门副职 子公司部门负责人测评
-- EachLType=7,           -- 子公司部门副职 子公司部门员工测评
--
union
select a.EID,
-- 子公司部门分管领导测评
SUM(case when a.EachLType=15 then a.ScoreTotal end) AS EachLEqSUM,
COUNT(case when a.EachLType=15 then a.ScoreTotal end) as EachLEqCOUNT,
AVG(case when a.EachLType=15 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLEpAVG,
-- 子公司部门负责人测评
SUM(case when a.EachLType=16 then a.ScoreTotal end) AS EachLSubSUM,
COUNT(case when a.EachLType=16 then a.ScoreTotal end) as EachLSubCOUNT,
AVG(case when a.EachLType=16 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSubAVG,
-- 子公司部门员工测评
SUM(case when a.EachLType=17 then a.ScoreTotal end) AS EachLSupSUM,
COUNT(case when a.EachLType=17 then a.ScoreTotal end) as EachLSupCOUNT,
AVG(case when a.EachLType=17 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSupAVG,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=30 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1


-------- 分公司负责人胜任素质 测评总分计算 --------
-- EachLType=21,         -- 分公司负责人 分公司分管领导评测
-- EachLType=22,         -- 分公司负责人 分公司人员评测
--
union
select a.EID,
-- 分公司分管领导评测
SUM(case when a.EachLType=21 then a.ScoreTotal end) AS EachLEqSUM,
COUNT(case when a.EachLType=21 then a.ScoreTotal end) as EachLEqCOUNT,
AVG(case when a.EachLType=21 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLEpAVG,
0,0,0,
-- 分公司人员评测
SUM(case when a.EachLType=22 then a.ScoreTotal end) AS EachLSupSUM,
COUNT(case when a.EachLType=22 then a.ScoreTotal end) as EachLSupCOUNT,
AVG(case when a.EachLType=22 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSupAVG,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=24 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1


-------- 分公司副职胜任素质 测评总分计算 --------
-- EachLType=25,         -- 分公司副职 分公司负责人评测
-- EachLType=26,         -- 分公司副职 分公司人员评测
--
union
select a.EID,
-- 分公司负责人评测
SUM(case when a.EachLType=25 then a.ScoreTotal end) AS EachLEqSUM,
COUNT(case when a.EachLType=25 then a.ScoreTotal end) as EachLEqCOUNT,
AVG(case when a.EachLType=25 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLEpAVG,
0,0,0,
-- 分公司人员评测
SUM(case when a.EachLType=26 then a.ScoreTotal end) AS EachLSupSUM,
COUNT(case when a.EachLType=26 then a.ScoreTotal end) as EachLSupCOUNT,
AVG(case when a.EachLType=26 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSupAVG,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=25 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1


-------- 一级营业部负责人胜任素质 测评总分计算 --------
-- EachLType=31,         -- 一级营业部负责人 一级营业分管领导评测
-- EachLType=32,         -- 一级营业部负责人 一级营业部人员评测
--
union
select a.EID,
-- 一级营业分管领导评测
SUM(case when a.EachLType=31 then a.ScoreTotal end) AS EachLEqSUM,
COUNT(case when a.EachLType=31 then a.ScoreTotal end) as EachLEqCOUNT,
AVG(case when a.EachLType=31 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLEpAVG,
0,0,0,
-- 一级营业部人员评测
SUM(case when a.EachLType=32 then a.ScoreTotal end) AS EachLSupSUM,
COUNT(case when a.EachLType=32 then a.ScoreTotal end) as EachLSupCOUNT,
AVG(case when a.EachLType=32 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSupAVG,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=5 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1


-------- 一级营业部副职胜任素质 测评总分计算 --------
-- EachLType=35,         -- 一级营业部副职 一级营业负责人评测
-- EachLType=36,         -- 一级营业部副职 一级营业部人员评测
--
union
select a.EID,
-- 一级营业负责人评测
SUM(case when a.EachLType=35 then a.ScoreTotal end) AS EachLEqSUM,
COUNT(case when a.EachLType=35 then a.ScoreTotal end) as EachLEqCOUNT,
AVG(case when a.EachLType=35 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLEpAVG,
0,0,0,
-- 一级营业部人员评测
SUM(case when a.EachLType=36 then a.ScoreTotal end) AS EachLSupSUM,
COUNT(case when a.EachLType=36 then a.ScoreTotal end) as EachLSupCOUNT,
AVG(case when a.EachLType=36 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSupAVG,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=6 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1


-------- 二级营业部经理室成员胜任素质 测评总分计算 --------
-- EachLType=41,         -- 二级营业部经理室成员 一级营业部人员评测
-- EachLType=42          -- 二级营业部经理室成员 二级营业部人员评测
--
union
select a.EID,
-- 一级营业部人员评测
SUM(case when a.EachLType=41 then a.ScoreTotal end) AS EachLEqSUM,
COUNT(case when a.EachLType=41 then a.ScoreTotal end) as EachLEqCOUNT,
AVG(case when a.EachLType=41 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLEpAVG,
0,0,0,
-- 二级营业部人员评测
SUM(case when a.EachLType=42 then a.ScoreTotal end) AS EachLSupSUM,
COUNT(case when a.EachLType=42 then a.ScoreTotal end) as EachLSupCOUNT,
AVG(case when a.EachLType=42 then a.ScoreTotal*a.Modulus*1.0/100 end) AS EachLSupAVG,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=7 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1