-- usp_Calculate_CreatePayRemarkTable
USE [HRLINK]
GO
/****** Object:  StoredProcedure [dbo].[usp_Calculate_CreatePayRemarkTable]    Script Date: 02/08/2018 11:28:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Procedure
-- Procedure
/********************************************************************************
	项目名称		ess_pay
	过程名称		usp_Calculate_CreateMonthInputTable
	主要功能		创建月末输入表
			
	参数值

	作者		evan
	编写日期		2007/4/9
********************************************************************************/
ALTER PROCEDURE [dbo].[usp_Calculate_CreatePayRemarkTable]
	(
		@year varchar(36),        --薪资年
		@month  varchar(36)       --薪资月
	)
AS
begin 
declare @TableName varchar(100)    --薪资备注表名称
declare @payitem_code varchar(36)  --项目编码
declare @StrSql varchar(8000)
declare @accuracy int 
declare @payitem_name_cn varchar(200)
declare @payitem_name_en varchar(200)
declare @payitem_name_other varchar(200)
declare @max_order_by int

--生成表名
set @TableName=dbo.fnGetPayRemarkTableName(@year,@month)

--检测是否存在表
if exists (select * from dbo.sysobjects where id = object_id(@TableName) and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	begin 
	     --循环薪资项目(薪资备注项目) 
			DECLARE tempatt CURSOR for 
			SELECT v_payitem_info.payitem_code,v_payitem_info.accuracy,v_payitem_info.payitem_name_cn,v_payitem_info.payitem_name_en,v_payitem_info.payitem_name_other
			FROM dbo.v_payitem_info where is_enable=1 and is_use_remark=1
			OPEN tempatt
			FETCH NEXT FROM tempatt INTO @payitem_code,@accuracy,@payitem_name_cn,@payitem_name_en,@payitem_name_other
			WHILE (@@fetch_status=0)
			Begin
			      if  not  exists(select   1   from  INFORMATION_SCHEMA.COLUMNS where table_name=@TableName and column_name=@payitem_code+'_remark')  --判断列是否存在
			      begin 
			           set @StrSql='ALTER TABLE [dbo].['+@TableName+'] ADD  ['+@payitem_code+ '_remark] [nvarchar](200)  NULL'
			           exec (@StrSql)
			      end 


				  if not exists(select 1 from TABLE_FIELDS where object_code='monthly_emp_pay_input_remark' and field_code=@payitem_code+'_remark')
				  begin

						select @max_order_by=max(display_order) from TABLE_FIELDS where object_code='monthly_emp_pay_input_remark'
						
						set @max_order_by=isnull(@max_order_by,0)
						set @max_order_by=@max_order_by+1
						insert into TABLE_FIELDS(field_id,field_code,object_code,
						field_name_cn,field_name_en,field_name_other,
						field_type,field_length,
						is_encryption,display_order,
						is_display,is_para,is_show_para,is_primary_key,is_primary_emp_id,is_for_report,is_system)
						values 
						(newid(),@payitem_code+'_remark','monthly_emp_pay_input_remark',@payitem_name_cn,@payitem_name_en,@payitem_name_other,
						dbo.Fn_get_column_type_code('Nvarchar'),'8',0,@max_order_by,1,0,0,0,0,0,0)
				  end


			FETCH NEXT FROM tempatt INTO @payitem_code,@accuracy,@payitem_name_cn,@payitem_name_en,@payitem_name_other
			END
			CLOSE tempatt
			DEALLOCATE tempatt
			
			set @StrSql='insert into '+@TableName+' (emp_id) select emp_id from EMP_INFO_MASTER where  emp_id not in (select emp_id from '+ @TableName+')'
			exec (@StrSql)
			
			
	end 
else
	begin 
			--构造创建表语句
			set @StrSql ='CREATE TABLE [dbo].['+ @TableName +']([emp_id] [varchar] (36) ) ON [PRIMARY]'
			exec (@StrSql)
			DECLARE tempatt CURSOR for 
			SELECT v_payitem_info.payitem_code,v_payitem_info.accuracy,v_payitem_info.payitem_name_cn,v_payitem_info.payitem_name_en,v_payitem_info.payitem_name_other
			FROM dbo.v_payitem_info where is_enable=1 and is_use_remark=1
			OPEN tempatt
			FETCH NEXT FROM tempatt INTO @payitem_code,@accuracy,@payitem_name_cn,@payitem_name_en,@payitem_name_other
			WHILE (@@fetch_status=0)
			Begin


			  
				  set @StrSql='ALTER TABLE [dbo].['+@TableName+'] ADD ['+ @payitem_code +'_remark]  [nvarchar](200)   NULL'
				  exec (@StrSql)

				  if not exists(select 1 from TABLE_FIELDS where object_code='monthly_emp_pay_input_remark' and field_code=@payitem_code+'_remark')
				  begin

						select @max_order_by=max(display_order) from TABLE_FIELDS where object_code='monthly_emp_pay_input_remark'
						
						set @max_order_by=isnull(@max_order_by,0)
						set @max_order_by=@max_order_by+1
						insert into TABLE_FIELDS(field_id,field_code,object_code,
						field_name_cn,field_name_en,field_name_other,
						field_type,field_length,
						is_encryption,display_order,
						is_display,is_para,is_show_para,is_primary_key,is_primary_emp_id,is_for_report,is_system)
						values 
						(newid(),@payitem_code+'_remark','monthly_emp_pay_input_remark',@payitem_name_cn,@payitem_name_en,@payitem_name_other,
						dbo.Fn_get_column_type_code('Nvarchar'),'8',0,@max_order_by,1,0,0,0,0,0,0)
				  end


			FETCH NEXT FROM tempatt INTO @payitem_code,@accuracy,@payitem_name_cn,@payitem_name_en,@payitem_name_other
			END
			CLOSE tempatt
			DEALLOCATE tempatt
			


			
			set @StrSql='insert into '+@TableName+' (emp_id) select emp_id from EMP_INFO_MASTER '
			exec (@StrSql)




			
			
			--set @StrSql='CREATE UNIQUE INDEX [IX_'+@TableName+']  ON [dbo].['+@TableName+'] ([emp_id] ) ON [PRIMARY]'
			--exec (@StrSql)
	end 
end