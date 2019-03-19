
declare @SCORE_Eid int
set @SCORE_Eid=1032

-- 分公司、一级营业部及二级营业部普通员工
-- 计算scoretotal分数
update a
set a.scoretotal=isnull(a.score9,0)*isnull(a.weight,0)/100+isnull(b.score13,0)
from pscore as a,pscore as b
where a.SCORE_EID=@SCORE_Eid AND a.EID=b.EID AND b.SCORE_STATUS=1 AND a.SCORE_STATUS=2 
AND a.SCORE_TYPE in (29,12,13) AND a.WEIGHT=70 AND isnull(a.compliance,0)=0
update a
set a.scoretotal=(isnull(a.score9,0)*isnull(a.weight,0)/100+isnull(b.score13,0))*(100-isnull(c.weight,0))/100+isnull(c.score9,0)*isnull(c.weight,0)/100
from pscore as a,pscore as b,pscore as c
where a.SCORE_EID=@SCORE_Eid AND a.EID=b.EID AND a.EID=c.EID AND b.SCORE_STATUS=1 AND a.SCORE_STATUS=2 
AND a.SCORE_TYPE in (29,12,13) AND a.WEIGHT=70 AND isnull(a.compliance,0)=15 AND c.SCORE_STATUS=7 AND ISNULL(c.SUBMIT,0)=1
update a
set a.scoretotal=isnull(a.score9,0)*isnull(a.weight,0)/100+isnull(b.score13,0)+isnull(c.score9,0)*isnull(c.weight,0)/100
from pscore as a,pscore as b,pscore as c
where a.SCORE_EID=@SCORE_Eid AND a.EID=b.EID AND a.EID=c.EID AND b.SCORE_STATUS=1 AND a.SCORE_STATUS=3
AND a.SCORE_TYPE=13 AND a.WEIGHT=40 AND isnull(a.compliance,0)=0 AND c.SCORE_STATUS=2 AND ISNULL(c.SUBMIT,0)=1
update a
set a.scoretotal=(isnull(a.score9,0)*isnull(a.weight,0)/100+isnull(b.score13,0)+isnull(c.score9,0)*isnull(c.weight,0)/100)*(100-d.weight)/100+d.score9*d.weight/100
from pscore as a,pscore as b,pscore as c,pscore as d
where a.SCORE_EID=@SCORE_Eid AND a.EID=b.EID AND a.EID=c.EID AND a.eid=d.eid AND b.SCORE_STATUS=1 AND a.SCORE_STATUS=3
AND a.SCORE_TYPE=13 AND a.WEIGHT=40 AND isnull(a.compliance,0)=15 AND ISNULL(c.SUBMIT,0)=1 AND c.SCORE_STATUS=2 AND ISNULL(c.SUBMIT,0)=1
AND isnull(a.compliance,0)=15 AND d.SCORE_STATUS=7 AND ISNULL(d.SUBMIT,0)=1
-- 刷新递交状态
update c
set c.submit=1
from pscore as c
where c.SCORE_EID=@SCORE_Eid AND c.SCORE_TYPE in (29,12,13) AND ISNULL(c.Submitby,0)<>0 AND ISNULL(c.Submit,0)=0
-- 刷新员工排名
update b
set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
from pscore as b
where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND ISNULL(b.isRanking,0)=1
AND ((b.SCORE_STATUS in (2) AND b.SCORE_TYPE in (29,12,13) AND WEIGHT=70)
OR (b.SCORE_STATUS in (3) AND b.SCORE_TYPE=13 AND b.WEIGHT=40))

-- 营业部合规风控专员 分公司/营业部负责人
-- 刷新递交状态
update a
set a.submit=1,a.submitby=(select id from skySecUser where EID=@SCORE_Eid),a.submittime=GETDATE()
from pscore as a
where isnull(a.SCORE9,0)<>0 and a.SCORE_EID=@SCORE_Eid and a.SCORE_TYPE=14 and ISNULL(a.submit,0)=0

-- 区域财务经理 营业部负责人考核评分
-- 刷新递交状态
update a
set a.submit=1,a.submitby=(select id from skySecUser where EID=@SCORE_Eid),a.submittime=GETDATE()
from pscore as a
where isnull(a.SCORE9,0)<>0 and a.SCORE_EID=@SCORE_Eid and a.SCORE_TYPE=17 and ISNULL(a.submit,0)=0


-- 总部普通员工
update a
set a.scoretotal=(isnull(a.score0,0)*isnull(a.weight,0)/100+isnull(b.score13,0))*(100-isnull(c.weight,0))/100+isnull(c.score9,0)*isnull(c.weight,0)/100
from pscore as a,pscore as b,pscore as c
where a.SCORE_EID=@SCORE_Eid AND a.EID=b.EID AND a.EID=c.EID AND b.SCORE_STATUS=1 AND a.SCORE_STATUS=2 
AND a.SCORE_TYPE in (4) 
AND isnull(a.compliance,0)=16 AND isnull(c.SCORE_STATUS,0)=7 AND ISNULL(c.SUBMIT,0)=1
update a
set a.scoretotal=isnull(a.score0,0)*isnull(a.weight,0)/100+isnull(b.score13,0)
from pscore as a,pscore as b
where a.SCORE_EID=@SCORE_Eid AND a.EID=b.EID AND b.SCORE_STATUS=1 AND a.SCORE_STATUS=2 
AND a.SCORE_TYPE in (4) 
AND isnull(a.compliance,0)=0
-- 刷新递交状态
update c
set c.submit=1,c.submittime=GETDATE(),Submitby=(select id from skySecUser where eid=@SCORE_Eid)
from pscore as c
where c.SCORE_EID=@SCORE_Eid AND c.SCORE_TYPE in (4)
-- 刷新员工排名
update b
set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
from pscore as b
where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND ISNULL(b.isRanking,0)=1
AND b.SCORE_STATUS in (2) AND b.SCORE_TYPE=4

-- 分公司副职|一级营业部副职|二级营业部经理室成员
update a
set a.scoretotal=(isnull(a.score9,0)*isnull(a.weight,0)/100+isnull(b.score8,0)+isnull(c.score9,0)*isnull(c.weight,0)/100)*(100-isnull(d.weight,0))/100+isnull(d.score9,0)*isnull(d.weight,0)/100
from pscore as a,pscore as b,pscore as c,pscore as d
where a.SCORE_EID=@SCORE_Eid AND a.EID=b.EID AND a.EID=d.EID AND b.SCORE_STATUS=1 AND a.SCORE_STATUS=3 
AND a.SCORE_TYPE in (25,6,7) AND a.eid=c.eid and c.SCORE_STATUS=2
AND isnull(a.compliance,0)=15 AND isnull(d.SCORE_STATUS,0)=7 AND ISNULL(d.SUBMIT,0)=1
update a
set a.scoretotal=isnull(a.score9,0)*isnull(a.weight,0)/100+isnull(b.score8,0)+isnull(c.score9,0)*isnull(c.weight,0)/100
from pscore as a,pscore as b,pscore as c
where a.SCORE_EID=@SCORE_Eid AND a.EID=b.EID AND b.SCORE_STATUS=1 AND a.SCORE_STATUS=3 
AND a.SCORE_TYPE in (25,6,7) AND a.eid=c.eid and c.SCORE_STATUS=2
AND isnull(a.compliance,0)=0
-- 刷新递交状态
update c
set c.submit=1,c.submittime=GETDATE(),Submitby=(select id from skySecUser where eid=@SCORE_Eid)
from pscore as c
where c.SCORE_EID=@SCORE_Eid AND c.SCORE_TYPE in (25,6,7)
-- 刷新员工排名
update b
set b.ranking=(select ranking1 from pvw_ranking where eid=b.eid)
from pscore as b
where b.SCORE_EID=@SCORE_Eid AND ISNULL(b.Submit,0)=1 AND ISNULL(b.isRanking,0)=1
AND b.SCORE_STATUS in (3) AND b.SCORE_TYPE in (25,6,7)