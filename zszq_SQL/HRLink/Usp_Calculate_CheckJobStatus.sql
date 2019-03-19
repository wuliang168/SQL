-- Usp_Calculate_CheckJobStatus
USE [HRLINK]
GO
/****** Object:  StoredProcedure [dbo].[Usp_Calculate_CheckJobStatus]    Script Date: 02/09/2018 10:07:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/********************************************************************************
项目名称		payroll
函数名称		Usp_Calculate_CheckJobStatus
主要功能		检测作业状态
		

返回值		
	    
	
作者		evan
编写日期		2008/2/13
********************************************************************************/
ALTER PROCEDURE [dbo].[Usp_Calculate_CheckJobStatus]
	@PayTaskID varchar(36),          --作业ID
	@RunStatus int,                  --(0计算，1检测)
	@ReturnValue varchar(100)
AS 
begin 
declare @jobname varchar(1000)
declare @error_desc varchar(4000)
declare @Paytask_no int
declare @nod_id varchar(36)
declare @nod_name varchar(200)
declare @nod_type_code varchar(36)
declare @payitem_id varchar(36)
declare @emp_id varchar(36)
declare @emp_name varchar(200)
declare @payplan_name varchar(200)

if @RunStatus=0
	begin 
		 if   @PayTaskID>''     
		  set   @jobname=@PayTaskID+'_'+N'计算处理_'+host_name()+'_'+suser_sname()  
		 else   
		  set   @jobname=N'计算处理_'+host_name()+'_'+suser_sname()
	end
else
	begin  
		  if   @PayTaskID>''     
		  set   @jobname=@PayTaskID+'_'+N'检测处理_'+host_name()+'_'+suser_sname()   
		 else   
		  set   @jobname=N'检测处理_'+host_name()+'_'+suser_sname()
	end 




		--判断是否存在异常记录
		if exists ( select   b.[name],b.[description],a.message   
				  from   
				  msdb.dbo.sysjobhistory   a   inner   join   msdb.dbo.sysjobs   b   
				  on   a.job_id=b.job_id   
				  where   run_status=0   and   b.[name]=@jobname)
		begin
                        --删除作业
			if   exists(select   1   from   msdb..sysjobs   where   name=@jobname)   


			--从进度表中过去进度信息
				select @nod_id=node_id,@emp_id=emp_id 
				from cal_progress_info where paytask_id=@PayTaskID 




				if @nod_id<>'macro_before' and @nod_id<>'macro_after'

				begin

						select @nod_type_code=node_type,@payitem_id=payitem_id 
						from payplan_include_nodes where key_id=@nod_id

				
						if @nod_type_code='0006'
						begin
							select @nod_name=macro_name_cn from macro where key_id=@payitem_id
						end
						else
						begin
							select @nod_name=payitem_name_cn from payitem where key_id=@payitem_id
						end
				end
				select @emp_name=emp_code +'-'+chn_name from emp_info_master where emp_id=@emp_id

				set @nod_name=isnull(@nod_name,'')
				set @emp_name=isnull(@emp_name,'')
			

  			
			--进度条还原
			delete from  cal_progress_info where paytask_id=@PayTaskID

			--返回错误内容，通知界面初始化
                                  select top 1  @error_desc=a.message   
				  from   
				  msdb.dbo.sysjobhistory   a   inner   join   msdb.dbo.sysjobs   b   
				  on   a.job_id=b.job_id   
				  where   run_status=0   and   b.[name]=@jobname and   a.sql_message_id>0
			--获取paytaskno
			select @Paytask_no=paytask_cal_no FROM dbo.paytask_log where paytask_id=@PayTaskID


			set @error_desc=isnull(@error_desc,'')
				

				if @nod_id<>'macro_before' and @nod_id<>'macro_after'

				begin

						if  @nod_type_code='0006'
						begin
						set @error_desc='@payplan_noded='+@nod_name+'^@payplan_node_type='+dbo.fnGetPara_Name('0000','1519',@nod_type_code)
							
						 exec dbo.usp_Calculate_Set_Log @PayTaskID,'E0074', @error_desc,'Error','', 'usp_Calculate_PayRoll','0001'   

						end
						else
						begin
						set @error_desc='@payplan_noded='+@nod_name+'^@payplan_node_type='+dbo.fnGetPara_Name('0000','1519',@nod_type_code)+'^@emp_name='+@emp_name
							
						 exec dbo.usp_Calculate_Set_Log @PayTaskID,'E0073', @error_desc,'Error','', 'usp_Calculate_PayRoll','0001'   


						end
				end


--			--记录错误信息到薪资计算错误表中
--			insert into paytask_cal_error_log(key_id,paytask_id,error_code,error_desc,create_dt,create_by,error_level,key_word,error_source,paytask_cal_no,error_type_code)
--			values(newid(),@PayTaskID,'',@error_desc,getdate(),'system',4,'','job',@Paytask_no,'0002')
	
			
			select top 1  b.[name],b.[description],a.message   
				  from   
				  msdb.dbo.sysjobhistory   a   inner   join   msdb.dbo.sysjobs   b   
				  on   a.job_id=b.job_id   
				  where  run_status=0   and   b.[name]=@jobname and   a.sql_message_id>0

update paytask set current_step_status_code ='0001' where key_id=@PayTaskID

			--清除错误的job
			exec   msdb..sp_delete_job   @job_name=@jobname   
	
		end
	else
		begin
			select top 1  b.[name],b.[description],a.message   
				  from   
				  msdb.dbo.sysjobhistory   a   inner   join   msdb.dbo.sysjobs   b   
				  on   a.job_id=b.job_id   
				  where  1=2
		end

end
