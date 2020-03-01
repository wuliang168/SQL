USE [HRLINK]
GO
/****** 对象:  StoredProcedure [dbo].[usp_Calculate_CreateMonthInputFinalPayTable]    脚本日期: 02/01/2019 20:28:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_Calculate_CreateMonthInputFinalPayTable]
AS
begin 
declare @TableName varchar(100)    --月末输入表名称
declare @payitem_code varchar(36)  --月末输入项目编码
declare @StrSql varchar(8000)
declare @accuracy int 
declare @payitem_name_cn varchar(200)
declare @payitem_name_en varchar(200)
declare @payitem_name_other varchar(200)
declare @max_order_by int

SET @TableName='monthly_emp_pay_input_finalpay'
 
	     --循环薪资项目(月末输入薪资项目) 
			DECLARE tempatt CURSOR for 
			SELECT v_payitem_info.payitem_code,v_payitem_info.accuracy,v_payitem_info.payitem_name_cn,v_payitem_info.payitem_name_en,v_payitem_info.payitem_name_other
			FROM dbo.v_payitem_info where is_enable=1 
			OPEN tempatt
			FETCH NEXT FROM tempatt INTO @payitem_code,@accuracy,@payitem_name_cn,@payitem_name_en,@payitem_name_other
			WHILE (@@fetch_status=0)
			Begin
			      if  not  exists(select   1   from  INFORMATION_SCHEMA.COLUMNS where table_name=@TableName and column_name=@payitem_code)  --判断列是否存在
			      begin 
			           set @StrSql='ALTER TABLE [dbo].['+@TableName+'] ADD  ['+@payitem_code+ '] [numeric](30,'+ convert(varchar(36),@accuracy) +')  NULL'
			           exec (@StrSql)
			      end 


				  --if not exists(select 1 from TABLE_FIELDS where object_code='monthly_emp_pay_input' and field_code=@payitem_code)
				  --begin

						--select @max_order_by=max(display_order) from TABLE_FIELDS where object_code='monthly_emp_pay_input'
						
						--set @max_order_by=isnull(@max_order_by,0)
						--set @max_order_by=@max_order_by+1
						--insert into TABLE_FIELDS(field_id,field_code,object_code,
						--field_name_cn,field_name_en,field_name_other,
						--field_type,field_length,
						--is_encryption,display_order,
						--is_display,is_para,is_show_para,is_primary_key,is_primary_emp_id,is_for_report,is_system)
						--values 
						--(newid(),@payitem_code,'monthly_emp_pay_input',@payitem_name_cn,@payitem_name_en,@payitem_name_other,
						--dbo.Fn_get_column_type_code('float'),'8',0,@max_order_by,1,0,0,0,0,0,0)
				  --end


			FETCH NEXT FROM tempatt INTO @payitem_code,@accuracy,@payitem_name_cn,@payitem_name_en,@payitem_name_other
			END
			CLOSE tempatt
			DEALLOCATE tempatt
			
			set @StrSql='insert into '+@TableName+' (emp_id) select emp_id from EMP_INFO_MASTER where  emp_id not in (select emp_id from '+ @TableName+')'
			exec (@StrSql)
			 
			
			--sp_help Attachment
end