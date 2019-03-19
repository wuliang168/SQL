---------- 测试_胜任素质 ----------
USE [zszqtest1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 定义通常参数
declare @pYear_ID int,@EachLType int
-- 定义测试人员
declare @HHQ int,@HHQ_URID int,@PSC int,@PSC_URID int,@Staff int,@Staff_URID int
-- 定义测试结果
declare @result int
declare @result_ScoreEachL decimal(5,2),@result_ScoreEachLModulus decimal(5,2),@result_ScoreTotal decimal(5,2),
@result_ScoreTotalWeight decimal(5,2),@result_ScoreEach decimal(5,2)

-- 赋值
-- 通用参数
set @pYear_ID=(select ID from pYear_Process where ISNULL(Closed,0)=0)
set @EachLType=3
-- 总部负责人
set @HHQ=1297
set @HHQ_URID=(select ID from SkySecUser where EID=@HHQ)
-- 分公司负责人
set @PSC=1445
set @PSC_URID=(select ID from SkySecUser where EID=@PSC)
-- 普通员工
set @Staff=5256
set @Staff_URID=(select ID from SkySecUser where EID=@Staff)

-- 开启考核
exec pSP_pYear_ScoreStart @pYear_ID,1
-- 开启互评
exec pSP_pYear_ScoreEach @pYear_ID,1


-------- 恢复素质测试状态
update a
set a.Submit=NULL,a.Closed=NULL
FROM pYear_ScoreEachL a, pYear_Score b
WHERE a.EID=b.EID AND b.Score_Type1=1
AND a.EachLType = 3 and a.Score_EID=@Staff

-- 待办事项
---- 待办事项内容测试
------ 总部负责人
IF Exists(SELECT 1
FROM pYear_ScoreEachL a, pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND a.EID=b.EID AND b.Score_Type1=1 AND ISNULL(b.Initialized,0)=1
AND b.pYear_ID=c.ID and a.EachLType = 3 and a.Score_EID=@Staff)
Begin
    print '=================================================='
    print N'^-胜任素质测试-待办事项_总部部门内下属员工360度测评：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'^-胜任素质测试-待办事项_总部部门内下属员工360度测评：测试失败'
    print '=================================================='
End

-- 胜任素质评测得分为空
------ 设置胜任素质评测得分为空
update a
set a.ScoreTeamLead=NULL,a.ScoreTargetExec=20,a.ScoreSysThinking=20,a.ScoreInnovation=20,a.ScoreTraining=20
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreTeamLead+a.ScoreTargetExec+a.ScoreSysThinking+a.ScoreInnovation+a.ScoreTraining
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType
------ 执行自评递交
exec @result=pSP_pYear_ScoreEachLBS @EachLType,@Staff_URID
------ 测试结果
IF @result=1002100
Begin
    print '=================================================='
    print N'0-胜任素质测试-胜任素质评测得分为空_总部部门内下属员工360度测评：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-胜任素质测试-胜任素质评测得分为空_总部部门内下属员工360度测评：测试失败'
    print '=================================================='
End
------ 恢复自评分
update a
set a.ScoreTeamLead=20,a.ScoreTargetExec=20,a.ScoreSysThinking=20,a.ScoreInnovation=20,a.ScoreTraining=20
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreTeamLead+a.ScoreTargetExec+a.ScoreSysThinking+a.ScoreInnovation+a.ScoreTraining
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType


-- 胜任素质评测得分超过上限
------ 设置胜任素质评测得分超过上限
update a
set a.ScoreTeamLead=25,a.ScoreTargetExec=20,a.ScoreSysThinking=20,a.ScoreInnovation=20,a.ScoreTraining=20
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreTeamLead+a.ScoreTargetExec+a.ScoreSysThinking+a.ScoreInnovation+a.ScoreTraining
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType
------ 执行自评递交
exec @result=pSP_pYear_ScoreEachLBS @EachLType,@Staff_URID
------ 测试结果
IF @result=1002110
Begin
    print '=================================================='
    print N'0-胜任素质测试-胜任素质评测得分超过上限_总部负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-胜任素质测试-胜任素质评测得分超过上限_总部负责人：测试失败'
    print '=================================================='
End
------ 恢复自评分
update a
set a.ScoreTeamLead=20,a.ScoreTargetExec=20,a.ScoreSysThinking=20,a.ScoreInnovation=20,a.ScoreTraining=20
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreTeamLead+a.ScoreTargetExec+a.ScoreSysThinking+a.ScoreInnovation+a.ScoreTraining
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType


-- Score_Status=9时ScoreEach
------ 设置胜任素质评分
update a
set a.ScoreTeamLead=17,a.ScoreTargetExec=16,a.ScoreSysThinking=18,a.ScoreInnovation=20,a.ScoreTraining=19
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreTeamLead+a.ScoreTargetExec+a.ScoreSysThinking+a.ScoreInnovation+a.ScoreTraining
from pYear_ScoreEachL a
where a.Score_EID=@Staff and a.EachLType=@EachLType
------ 执行自评递交
exec pSP_pYear_ScoreEachLBS @EachLType,@Staff_URID
set @result_ScoreEachL=(select AVG(ScoreTotal) from pYear_ScoreEachL where EID=@HHQ)
set @result_ScoreEachLModulus=(select AVG(Modulus) from pYear_ScoreEachL where EID=@HHQ and Score_EID=@Staff)
set @result_ScoreTotal=(select ScoreTotal from pYear_Score where EID=@HHQ and SCORE_STATUS=1)
set @result_ScoreTotalWeight=(select Weight1 from pYear_Score where EID=@HHQ and SCORE_STATUS=1)
set @result_ScoreEach=(select AVG(ScoreEach) from pYear_Score where EID=@HHQ and SCORE_STATUS=9)
------ 测试结果
IF @result_ScoreEachL*@result_ScoreEachLModulus/100=@result_ScoreTotal AND @result_ScoreTotal*@result_ScoreTotalWeight/100=@result_ScoreEach
Begin
    print '=================================================='
    print N'0-胜任素质测试-ScoreEach值_总部负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-胜任素质测试-ScoreEach值_总部负责人：测试失败'
    print '=================================================='
End