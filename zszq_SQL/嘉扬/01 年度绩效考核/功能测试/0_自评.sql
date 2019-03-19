---------- 测试_自评 ----------
USE [zszqtest1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 定义通常参数
declare @pYear_ID int,@char101 varchar(200),@char151 varchar(200),@char1601 varchar(2000)
-- 定义测试人员
declare @HHQ int,@HHQ_URID int,@PSC int,@PSC_URID int,@Staff int,@Staff_URID int
-- 定义测试结果
declare @result int


-- 赋值
-- 通用参数
set @pYear_ID=(select ID from pYear_Process where ISNULL(Closed,0)=0)
exec xGetRandStr 101,@char101 output
exec xGetRandStr 151,@char151 output
exec xGetRandStr 1601,@char1601 output
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
-- 开启自评
exec pSP_pYear_Self @pYear_ID,1


-- 待办事项
---- 待办事项内容测试
------ 总部负责人
IF Exists(SELECT 1
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (1,2,10,25,6,7,26) AND a.Score_Status=0 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
and a.pYear_ID=b.ID and a.Score_EID=@HHQ)
Begin
    print '=================================================='
    print N'^-自评测试-待办事项_总部负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'^-自评测试-待办事项_总部负责人：测试失败'
    print '=================================================='
End
------ 分公司负责人
IF Exists(SELECT 1
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (24,5) AND a.Score_Status=0 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
and a.pYear_ID=b.ID and a.Score_EID=@PSC)
Begin
    print '=================================================='
    print N'0-自评测试-待办事项_分公司负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-待办事项_分公司负责人：测试失败'
    print '=================================================='
End
------ 普通员工
IF Exists(SELECT 1
FROM pYear_Score a,pYear_Process b
WHERE a.Score_Type1 IN (4,11,29,12,13,14,17,19,20) AND a.Score_Status=0 AND ISNULL(a.Initialized,0)=1 AND ISNULL(a.Submit,0)=0 AND ISNULL(a.Closed,0)=0
and a.pYear_ID=b.ID and a.Score_EID=@Staff)
Begin
    print '=================================================='
    print N'0-自评测试-待办事项_普通员工：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-待办事项_普通员工：测试失败'
    print '=================================================='
End


-- 总部负责人
---- 自评分为空
------ 设置自评分为空
update a
set a.Score1=NULL,a.Score2=95
from pYear_Score a
where a.EID=@HHQ and a.Score_Status=0
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @HHQ_URID
------ 测试结果
IF @result=1002010
Begin
    print '=================================================='
    print N'0-自评测试-自评分为空_总部负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-自评分为空_总部负责人：测试失败'
    print '=================================================='
End
------ 恢复自评分
update a
set a.Score1=100,a.Score2=95
from pYear_Score a
where a.EID=@HHQ and a.Score_Status=0

---- 自评分超过上限
------ 设置自评分超上限
update a
set a.Score1=105,a.Score2=95
from pYear_Score a
where a.EID=@HHQ and a.Score_Status=0
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @HHQ_URID
------ 测试结果
if @result=1002020
Begin
    print '=================================================='
    print N'0-自评测试-自评分超过上限_总部负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-自评分超过上限_总部负责人：测试失败'
    print '=================================================='
End
------ 恢复自评分
update a
set a.Score1=100,a.Score2=95
from pYear_Score a
where a.EID=@HHQ and a.Score_Status=0


-- 分公司负责人
---- 自评分为空
------ 设置自评分为空
update a
set a.Score2=NULL
from pYear_Score a
where a.EID=@PSC and a.Score_Status=0
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @PSC_URID
------ 测试结果
IF @result=1002010
Begin
    print '=================================================='
    print N'0-自评测试-自评分为空_分公司负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-自评分为空_分公司负责人：测试失败'
    print '=================================================='
End
------ 恢复自评分
update a
set a.Score2=90
from pYear_Score a
where a.EID=@PSC and a.Score_Status=0

---- 自评分超过上限
------ 设置自评分超上限
update a
set a.Score2=195
from pYear_Score a
where a.EID=@PSC and a.Score_Status=0
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @PSC_URID
------ 测试结果
if @result=1002020
Begin
    print '=================================================='
    print N'0-自评测试-自评分超过上限_分公司负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-自评分超过上限_分公司负责人：测试失败'
    print '=================================================='
End
------ 恢复自评分
update a
set a.Score2=90
from pYear_Score a
where a.EID=@PSC and a.Score_Status=0


-- 总部负责人
---- 业绩指标/重点工作：合规风控管理有效性评估不存在
------ 删除合规风控管理有效性评估
delete from pYear_KPI where EID=@HHQ and Title=N'合规风控管理有效性评估'
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @HHQ_URID
------ 测试结果
IF @result=1002030
Begin
    print '=================================================='
    print N'0-自评测试-合规风控管理有效性评估不存在_总部负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-合规风控管理有效性评估不存在_总部负责人：测试失败'
    print '=================================================='
End
------ 恢复合规风控管理有效性评估
insert into pYear_KPI (EID,pYear_ID,Xorder,Title,Initialized,Initializedby,InitializedTime)
values (@HHQ,@pYear_ID,1,N'合规风控管理有效性评估',1,1,GETDATE())

---- 实际完成情况：合规风控管理有效性评估为空
------ 设置合规风控管理有效性评估为空
update a
set a.KPI=NULL
from pYear_KPI a
where EID=@HHQ and Title=N'合规风控管理有效性评估'
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @HHQ_URID
------ 测试结果
IF @result=1002040
Begin
    print '=================================================='
    print N'0-自评测试-合规风控管理有效性评估为空_总部负责人：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-合规风控管理有效性评估为空_总部负责人：测试失败'
    print '=================================================='
End
------ 恢复合规风控管理有效性评估
update a
set a.KPI=N'测试1'
from pYear_KPI a
where EID=@HHQ and Title=N'合规风控管理有效性评估'


-- 普通员工
---- 业绩指标/重点工作为空
------ 设置为无标题
delete from pYear_KPI where EID=@Staff
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @Staff_URID
------ 测试结果
IF @result=1002045
Begin
    print '=================================================='
    print N'0-自评测试-业绩指标/重点工作为空_无标题_普通员工：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-业绩指标/重点工作为空_无标题_普通员工：测试失败'
    print '=================================================='
End

---- 标题内容为空
------ 设置标题内容为空
insert into pYear_KPI (EID,pYear_ID,Xorder,Title,Initialized,Initializedby,InitializedTime)
values(@Staff,@pYear_ID,1,NULL,1,1,GETDATE())
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @Staff_URID
------ 测试结果
IF @result=1002045
Begin
    print '=================================================='
    print N'0-自评测试-业绩指标/重点工作为空_标题内容为空_普通员工：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-业绩指标/重点工作为空_标题内容为空_普通员工：测试失败'
    print '=================================================='
End
------ 恢复标题为非空
update a
set a.Title=N'测试'
from pYear_KPI a
where a.EID=@Staff and a.Xorder=1

---- 实际完成情况为空
------ 设置实际完成情况为空
update a
set a.KPI=NULL
from pYear_KPI a
where a.EID=@Staff and a.Xorder=1
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @Staff_URID
------ 测试结果
IF @result=1002046
Begin
    print '=================================================='
    print N'0-自评测试-实际完成情况为空_普通员工：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-实际完成情况为空_普通员工：测试失败'
    print '=================================================='
End
------ 恢复实际完成情况为非空
update a
set a.KPI=N'测试'
from pYear_KPI a
where a.EID=@Staff and a.Xorder=1

---- 履职情况/个人总结内容为空
------ 设置个人总结内容为空
update a
set a.Summary=NULL
from pYear_Summary a
where a.EID=@Staff
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @Staff_URID
------ 测试结果
IF @result=1002051
Begin
    print '=================================================='
    print N'0-自评测试-个人总结内容为空_普通员工：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-个人总结内容为空_普通员工：测试失败'
    print '=================================================='
End
------ 恢复实际完成情况为非空
update a
set a.Summary=N'测试'
from pYear_Summary a
where a.EID=@Staff

---- 业绩指标/重点工作超过100字
------ 设置重点工作超过100字
update a
set a.Title=@char101
from pYear_KPI a
where a.EID=@Staff and a.Xorder=1
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @Staff_URID
------ 测试结果
IF @result=1002060
Begin
    print '=================================================='
    print N'0-自评测试-重点工作超过100字_普通员工：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-重点工作超过100字_普通员工：测试失败'
    print '=================================================='
End
------ 恢复实际完成情况为非空
update a
set a.Title=N'测试'
from pYear_KPI a
where a.EID=@Staff and a.Xorder=1

---- 实际完成情况内容超过150字
------ 设置实际完成情况超过150字
update a
set a.KPI=@char151
from pYear_KPI a
where a.EID=@Staff and a.Xorder=1
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @Staff_URID
------ 测试结果
IF @result=1002065
Begin
    print '=================================================='
    print N'0-自评测试-实际完成情况内容超过150字_普通员工：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-实际完成情况内容超过150字_普通员工：测试失败'
    print '=================================================='
End
------ 恢复实际完成情况为非空
update a
set a.KPI=N'测试'
from pYear_KPI a
where a.EID=@Staff and a.Xorder=1

---- 履职情况/个人总结内容超过1600字
------ 设置个人总结内容超过1600字
update a
set a.Summary=@char1601
from pYear_Summary a
where a.EID=@Staff
------ 执行自评递交
exec @result=pSP_pYear_SelfBS @Staff_URID
------ 测试结果
IF @result=1002071
Begin
    print '=================================================='
    print N'0-自评测试-个人总结内容超过1600字_普通员工：测试成功'
    print '=================================================='
End
ELSE
Begin
    print '=================================================='
    print N'0-自评测试-个人总结内容超过1600字_普通员工：测试失败'
    print '=================================================='
End
------ 恢复实际完成情况为非空
update a
set a.Summary=N'测试'
from pYear_Summary a
where a.EID=@Staff