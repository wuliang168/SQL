-- pVW_OAProcess
---- ZSZQ.VM_HR20151204
------ EmpType is NULL
select a.OAID as OAID,b.ID as OAType,a.标题 as OATitle,a.内容 as OAContent,CONVERT(datetime,a.创建日期,110)+a.创建时间 as CreateDate,
CONVERT(datetime,a.完成日期,110)+a.完成时间 as FinishDate,a.发起人 as Name, NULL as EID,
(case when a.请假开始时间 like N'%年%' then CONVERT(datetime,replace(replace(replace(a.请假开始时间,N'年',N'-'),N'月',N'-'),N'日',N''),110) 
else CONVERT(datetime,a.请假开始时间,110) end) as LeaveBeginDate,
(case when a.请假结束时间=N'29' then CONVERT(datetime,'201507'+CONVERT(nvarchar(2),a.请假结束时间),110) 
when a.请假结束时间 like N'%年%' then CONVERT(datetime,replace(replace(replace(a.请假结束时间,N'年',N'-'),N'月',N'-'),N'日',N''),110) 
else CONVERT(datetime,a.请假结束时间,110) end) as LeaveEndDate,NULL as LeaveDays,
(select ID from oCD_LeaveType where Title=a.假别) as LeaveType,NULL as EmpType,a.审批意见 as ApprOpinion,a.审批部门 as ApprDep,a.审批人 as ApprDirector,
a.审批人ID as ApprDirectorID,CONVERT(datetime,a.审批日期,110)+a.审批时间 as ApprTime
from pEmpOALeave_all a,oCD_OAProcessType b
where ltrim(rtrim(a.流程名称))= b.Title and 请假天数 is NULL

---- ZSZQ.VM_HR20171130
------ EmpType is not NULL
UNION
select a.OAID as OAID,NULL as OAType,a.标题 as OATitle,a.内容 as OAContent,CONVERT(datetime,a.创建日期,110)+a.创建时间 as CreateDate,
CONVERT(datetime,a.完成日期,110)+a.完成时间 as FinishDate,a.发起人 as Name,(select EID from skySecUser where Account=登录名) as EID,
(case when ISDATE(a.请假开始时间)=1 then CONVERT(datetime,a.请假开始时间,110) else NULL end) as LeaveBeginDate,
(case when ISDATE(a.请假结束时间)=1 then CONVERT(datetime,a.请假结束时间,110) else NULL end) as LeaveEndDate,a.请假天数 as LeaveDays,a.请假种类 as LeaveType,a.人员类型 as EmpType,
a.审批意见 as ApprOpinion,a.审批部门 as ApprDep,a.审批人 as ApprDirector,a.审批人ID as ApprDirectorID,CONVERT(datetime,a.审批日期,110)+a.审批时间 as ApprTime
from pEmpOALeave_all a
where a.流程名称 is NULL