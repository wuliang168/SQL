USE [HRLINK]
GO
/****** 对象:  StoredProcedure [dbo].[usp_Calculate_CreateAttenandceFinalPayTable]    脚本日期: 02/01/2019 20:27:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_Calculate_CreateAttenandceFinalPayTable]  
AS
begin   
declare @TableName varchar(100)    -- 表名称  
declare @leave_code varchar(36)    
declare @ot_code varchar(36)    
declare @att_code varchar(36)    
declare @StrSql varchar(4000)  
  
--生成表名  
set @TableName='monthly_attendance_audit_finalpay'
  
  

      --循环休假表  
   DECLARE @tmpleave CURSOR 
	SET   @tmpleave   =   CURSOR   SCROLL   DYNAMIC 
for   
   SELECT leave_type.leave_code  
   FROM leave_type where is_enable=1   
   OPEN @tmpleave  
   FETCH NEXT FROM @tmpleave INTO @leave_code  
   WHILE (@@fetch_status=0)  
   Begin  
         if  not  exists(select   1   from  INFORMATION_SCHEMA.COLUMNS where table_name=@TableName and column_name=@leave_code)  --判断列是否存在  
         begin   
              set @StrSql='ALTER TABLE '+@TableName+' ADD  ['+@leave_code+ '] Float  NULL'  
              exec (@StrSql)  
         end   
   FETCH NEXT FROM @tmpleave INTO @leave_code  
   END  
   CLOSE @tmpleave  
   DEALLOCATE @tmpleave  
     
  --循环加班表  
   DECLARE @tmpot CURSOR 
	SET   @tmpot   =   CURSOR   SCROLL   DYNAMIC 
	for   
   SELECT ot_type.ot_type_code  
   FROM ot_type where is_enable=1   
   OPEN @tmpot  
   FETCH NEXT FROM @tmpot INTO @ot_code  
   WHILE (@@fetch_status=0)  
   Begin  
         if  not  exists(select   1   from  INFORMATION_SCHEMA.COLUMNS where table_name=@TableName and column_name=@ot_code)  --判断列是否存在  
         begin   
              set @StrSql='ALTER TABLE '+@TableName+' ADD  ['+@ot_code+ '] Float  NULL'  
              exec (@StrSql)  
         end   
   FETCH NEXT FROM @tmpot INTO @ot_code  
   END  
   CLOSE @tmpot  
   DEALLOCATE @tmpot  
     
    
    
  --循环轮班表  
   DECLARE @tmpatt CURSOR 
	SET   @tmpatt   =   CURSOR   SCROLL   DYNAMIC 
	for   
   SELECT shift_class.attendance_class_code  
   FROM  shift_class where is_enable=1   
   OPEN @tmpatt  
   FETCH NEXT FROM @tmpatt INTO @att_code  
   WHILE (@@fetch_status=0)  
   Begin  
         if  not  exists(select   1   from  INFORMATION_SCHEMA.COLUMNS where table_name=@TableName and column_name=@att_code)  --判断列是否存在  
         begin   
              set @StrSql='ALTER TABLE '+@TableName+' ADD  ['+@att_code+ '] Float  NULL'  
              exec (@StrSql)  
         end   
   FETCH NEXT FROM @tmpatt INTO @att_code  
   END  
   CLOSE @tmpatt  
   DEALLOCATE @tmpatt  
     
        
   set @StrSql='insert into '+@TableName+' (emp_id) select emp_id from EMP_INFO_MASTER where  emp_id not in (select emp_id from '+ @TableName+')'  
   exec (@StrSql)  
     


end