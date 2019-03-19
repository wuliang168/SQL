-- 分公司和营业部快速添加岗位
---- 岗位名称
declare @newjobtitle nvarchar(50)
set @newnewjobtitlejob=N'机构顾问'
---- 岗位排序
declare @newjobxorder varchar(4)
set @newjobxorder='3140'

declare @jobcodemax int
select @jobcodemax=MAX(right(jobcode,4)) from oJob
declare @depidcount int
select @depidcount=COUNT(depid) from odepartment where ISNULL(isDisabled,0)=0 and DepType in (2,3)
insert into oJob(CompID,DepID1st,DepID2nd,JobCode,Title,JobAbbr,JobGrade,JobProperty,EffectDate,EZID,xorder)
select 11,dbo.eFN_getdepid1st(a.DepID),dbo.eFN_getdepid2nd(a.DepID),'J999999',@newjobtitle,@newjobtitle,9,1,GETDATE(),100,CONVERT(varchar(10),a.xorder)+@newjobxorder
from odepartment a
where ISNULL(a.isDisabled,0)=0 and a.DepType in (2,3)
and a.DepID not in (select ISNULL(DepID2nd,DepID1st) from oJob where Title=@newjobtitle);

with tabs as 
(
select JobID,Row_Number() OVER (partition by jobcode order by jobcode) rank1 from oJob where JobCode='J999999'
)
update a 
set a.JobCode= 'J00'+CONVERT(varchar(4),@jobcodemax+b.rank1) 
from oJob a,tabs b 
where a.JobID=b.jobid
