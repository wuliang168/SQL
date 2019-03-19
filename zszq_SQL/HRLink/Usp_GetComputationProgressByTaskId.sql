USE [HRLINK]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetComputationProgressByTaskId]    Script Date: 02/09/2018 10:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Procedure
-- Procedure
/********************************************************************************
	项目名称		ess_pay
	过程名称		Usp_GetComputationProgressByTaskId
	主要功能		获取当前薪资包计算进度
			
	参数值
	      
	      
	      
	
	作者		james
	编写日期		2007/5/8
********************************************************************************/
ALTER PROCEDURE [dbo].[Usp_GetComputationProgressByTaskId]

	(
		@paytask_id varchar(36), --薪资任务ID
		@culture varchar(36) --语言环境
	)

AS
begin


declare @plan_node_id varchar(36)
declare @plan_type_code varchar(36)

select @plan_node_id=node_id from cal_progress_info where paytask_id=@paytask_id  
select @plan_type_code=node_type from payplan_include_nodes where key_id=@plan_node_id

		if @plan_type_code='0006'
		begin


			SELECT dbo.cal_progress_info.key_id, dbo.cal_progress_info.paytask_id,   
			  dbo.cal_progress_info.node_index, dbo.cal_progress_info.node_id,   
			  dbo.cal_progress_info.role_index, dbo.cal_progress_info.role_code,   
			  dbo.cal_progress_info.emp_index, dbo.cal_progress_info.emp_id,   
			  dbo.cal_progress_info.emp_count, dbo.cal_progress_info.role_count,   
			  dbo.cal_progress_info.node_count, dbo.payplan_include_nodes.payitem_id,   
			  dbo.Macro.macro_code,  
			  dbo.emp_info_master.emp_code,  
			  dbo.fnGetCultureName(@culture,dbo.Macro.macro_name_cn,dbo.Macro.macro_name_en,dbo.Macro.macro_name_other) as payitem_name,  
			  dbo.fnGetCultureName(@culture,dbo.payrole.payrole_name_cn,dbo.payrole.payrole_name_en,dbo.payrole.payrole_name_other) as payrole_name,  
			  dbo.fnGetCultureName(@culture,dbo.emp_info_master.chn_name,dbo.emp_info_master.eng_name,dbo.emp_info_master.other_name) as emp_name  
			  FROM dbo.emp_info_master RIGHT OUTER JOIN  
			  dbo.cal_progress_info ON   
			  dbo.emp_info_master.emp_id = dbo.cal_progress_info.emp_id LEFT OUTER JOIN  
			  dbo.payrole ON   
			  dbo.cal_progress_info.role_code = dbo.payrole.payrole_code LEFT OUTER JOIN  
			  dbo.Macro RIGHT OUTER JOIN  
			  dbo.payplan_include_nodes ON   
			  dbo.Macro.key_id = dbo.payplan_include_nodes.payitem_id ON   
			  dbo.cal_progress_info.node_id = dbo.payplan_include_nodes.key_id  
		        
			  where dbo.cal_progress_info.paytask_id=@paytask_id  

		end
		else
		begin


				SELECT dbo.cal_progress_info.key_id, dbo.cal_progress_info.paytask_id,   
			  dbo.cal_progress_info.node_index, dbo.cal_progress_info.node_id,   
			  dbo.cal_progress_info.role_index, dbo.cal_progress_info.role_code,   
			  dbo.cal_progress_info.emp_index, dbo.cal_progress_info.emp_id,   
			  dbo.cal_progress_info.emp_count, dbo.cal_progress_info.role_count,   
			  dbo.cal_progress_info.node_count, dbo.payplan_include_nodes.payitem_id,   
			  dbo.payitem.payitem_code,  
			  dbo.emp_info_master.emp_code,  
			  dbo.fnGetCultureName(@culture,dbo.payitem.payitem_name_cn,dbo.payitem.payitem_name_en,dbo.payitem.payitem_name_other) as payitem_name,  
			  dbo.fnGetCultureName(@culture,dbo.payrole.payrole_name_cn,dbo.payrole.payrole_name_en,dbo.payrole.payrole_name_other) as payrole_name,  
			  dbo.fnGetCultureName(@culture,dbo.emp_info_master.chn_name,dbo.emp_info_master.eng_name,dbo.emp_info_master.other_name) as emp_name  
			  FROM dbo.emp_info_master RIGHT OUTER JOIN  
			  dbo.cal_progress_info ON   
			  dbo.emp_info_master.emp_id = dbo.cal_progress_info.emp_id LEFT OUTER JOIN  
			  dbo.payrole ON   
			  dbo.cal_progress_info.role_code = dbo.payrole.payrole_code LEFT OUTER JOIN  
			  dbo.payitem RIGHT OUTER JOIN  
			  dbo.payplan_include_nodes ON   
			  dbo.payitem.key_id = dbo.payplan_include_nodes.payitem_id ON   
			  dbo.cal_progress_info.node_id = dbo.payplan_include_nodes.key_id  
		        
			  where dbo.cal_progress_info.paytask_id=@paytask_id  


		end
end
