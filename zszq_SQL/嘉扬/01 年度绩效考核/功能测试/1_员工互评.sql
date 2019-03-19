---------- 测试_员工互评 ----------
USE [zszqtest1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 定义通常参数
declare @pYear_ID int,@EachLType int
-- 定义测试人员
declare @HHQ int,@HHQ_URID int,@PSC int,@PSC_URID int,@Staff int,@Staff2 int,@Staff_URID int
-- 定义测试结果
declare @result int
declare @result_ScoreEachN decimal(5,2),@result_ScoreTotal decimal(5,2),
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
set @Staff2=4404
set @Staff_URID=(select ID from SkySecUser where EID=@Staff)

-- 开启考核
exec pSP_pYear_ScoreStart @pYear_ID,1
-- 开启互评
exec pSP_pYear_ScoreEach @pYear_ID,1


-------- 恢复素质测试状态
update a
set a.Submit=NULL,a.Closed=NULL
FROM pYear_ScoreEachL a, pYear_Score b
WHERE a.EID=b.EID AND b.Score_Type1 IN (4,11,29,12,13)
AND a.Score_EID=@Staff

-- 待办事项
---- 待办事项内容测试
------ 普通员工
IF Exists(SELECT 1
FROM pYear_ScoreEachN a,pYear_Score b,pYear_Process c
WHERE ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
AND b.Score_Type1 IN (4,11,29,12,13) AND ISNULL(a.Score_EID,5256)=b.EID
AND b.Score_Status=1 AND ISNULL(b.Initialized,0)=1
AND a.pYear_ID=c.ID and a.Score_EID=@Staff)
Begin
    print '=================================================='
    print N'^-员工互评测试-待办事项_总部部门内下属员工360度测评：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'^-员工互评测试-待办事项_总部部门内下属员工360度测评：测试失败'
    print '=================================================='
End

-- 互评得分为空
------ 设置互评得分为空
update a
set a.ScoreWorkPerf=NULL,a.ScoreWorkDiscip=5,a.ScoreAmbitious=5,a.ScoreInitiative=10,a.ScoreCommCoord=10,a.ScoreTeamWork=10,a.ScoreLearnDev=10
from pYear_ScoreEachN a
where a.Score_EID=@Staff
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreWorkPerf+a.ScoreWorkDiscip+a.ScoreAmbitious+a.ScoreInitiative+a.ScoreCommCoord+a.ScoreTeamWork+a.ScoreLearnDev
from pYear_ScoreEachN a
where a.Score_EID=@Staff
------ 执行自评递交
exec @result=pSP_pYear_ScoreEachNBS @Staff_URID
------ 测试结果
IF @result=1002080
Begin
    print '=================================================='
    print N'0-互评测试-互评得分为空：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-互评测试-互评得分为空：测试失败'
    print '=================================================='
End
------ 恢复自评分
update a
set a.ScoreWorkPerf=49,a.ScoreWorkDiscip=5,a.ScoreAmbitious=5,a.ScoreInitiative=10,a.ScoreCommCoord=10,a.ScoreTeamWork=10,a.ScoreLearnDev=10
from pYear_ScoreEachN a
where a.Score_EID=@Staff
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreWorkPerf+a.ScoreWorkDiscip+a.ScoreAmbitious+a.ScoreInitiative+a.ScoreCommCoord+a.ScoreTeamWork+a.ScoreLearnDev
from pYear_ScoreEachN a
where a.Score_EID=@Staff

-- 互评得分超过上限
------ 设置互评得分超过上限
update a
set a.ScoreWorkPerf=55,a.ScoreWorkDiscip=5,a.ScoreAmbitious=5,a.ScoreInitiative=10,
a.ScoreCommCoord=10,a.ScoreTeamWork=10,a.ScoreLearnDev=10
from pYear_ScoreEachN a
where a.Score_EID=@Staff
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreWorkPerf+a.ScoreWorkDiscip+a.ScoreAmbitious+a.ScoreInitiative+a.ScoreCommCoord+a.ScoreTeamWork+a.ScoreLearnDev
from pYear_ScoreEachN a
where a.Score_EID=@Staff
------ 执行自评递交
exec @result=pSP_pYear_ScoreEachNBS @Staff_URID
------ 测试结果
IF @result=1002090
Begin
    print '=================================================='
    print N'0-互评测试-互评得分超过上限：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-互评测试-互评得分超过上限：测试失败'
    print '=================================================='
End
------ 恢复自评分
update a
set a.ScoreWorkPerf=49,a.ScoreWorkDiscip=5,a.ScoreAmbitious=5,a.ScoreInitiative=10,
a.ScoreCommCoord=10,a.ScoreTeamWork=10,a.ScoreLearnDev=10
from pYear_ScoreEachN a
where a.Score_EID=@Staff
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreWorkPerf+a.ScoreWorkDiscip+a.ScoreAmbitious+a.ScoreInitiative+a.ScoreCommCoord+a.ScoreTeamWork+a.ScoreLearnDev
from pYear_ScoreEachN a
where a.Score_EID=@Staff

-- Score_Status=9时ScoreEach
------ 设置互评分
update a
set a.ScoreWorkPerf=49,a.ScoreWorkDiscip=5,a.ScoreAmbitious=5,a.ScoreInitiative=7,
a.ScoreCommCoord=10,a.ScoreTeamWork=9,a.ScoreLearnDev=8
from pYear_ScoreEachN a
where a.Score_EID=@Staff
-------- 更新ScoreTotal
update a
set a.ScoreTotal=a.ScoreWorkPerf+a.ScoreWorkDiscip+a.ScoreAmbitious+a.ScoreInitiative+a.ScoreCommCoord+a.ScoreTeamWork+a.ScoreLearnDev
from pYear_ScoreEachN a
where a.Score_EID=@Staff
------ 执行自评递交
exec pSP_pYear_ScoreEachNBS @Staff_URID
set @result_ScoreEachN=(select AVG(ScoreTotal) from pYear_ScoreEachN where EID=@Staff2)
set @result_ScoreTotal=(select ScoreTotal from pYear_Score where EID=@Staff2 and SCORE_STATUS=1)
set @result_ScoreTotalWeight=(select Weight1 from pYear_Score where EID=@Staff2 and SCORE_STATUS=1)
set @result_ScoreEach=(select AVG(ScoreEach) from pYear_Score where EID=@Staff2 and SCORE_STATUS=9)
------ 测试结果
IF @result_ScoreEachN=@result_ScoreTotal AND @result_ScoreTotal*@result_ScoreTotalWeight/100=@result_ScoreEach
Begin
    print '=================================================='
    print N'0-互评测试-ScoreEach值：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-互评测试-ScoreEach值：测试失败'
    print '=================================================='
End