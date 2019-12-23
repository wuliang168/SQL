-- 通过杀死进程的方式，强制将单用户切换到多用户

declare @kid varchar(8000)
set @kid=''
select @kid=@kid+' kill '+cast(spid as varchar(8))
from master..sysprocesses
where dbid=db_id('zszq')

Exec(@kid)


ALTER DATABASE zszq SET MULTI_USER