-- usp_Calculate_CreateAttenandceTable
USE [HRLINK]
GO
/****** Object:  StoredProcedure [dbo].[usp_Calculate_CreateAttenandceTable]    Script Date: 02/08/2018 11:27:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--------------------------------------
------------------------------------------

-- Procedure
-- Procedure
/********************************************************************************  
 项目名称  ess_pay  
 过程名称  usp_Calculate_CreateAttenandceTable
 主要功能  保存考勤月末输入数据
     
 参数值  
  
 作者  james  
 编写日期  2008/6/16  
********************************************************************************/  
ALTER PROCEDURE [dbo].[usp_Calculate_CreateAttenandceTable]  
 (  
  @year varchar(36),        --薪资年  
  @month  varchar(36)       --薪资月  
 )  
AS
begin   
declare @TableName varchar(100)    -- 表名称  
declare @leave_code varchar(36)    
declare @ot_code varchar(36)    
declare @att_code varchar(36)    
declare @StrSql varchar(4000)  
  
--生成表名  
set @TableName=dbo.fnGetMonthlyAttendanceAuditTableName(@year,@month)  
  
  
--检测是否存在表  
if exists (select * from dbo.sysobjects where id = object_id(@TableName) and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 begin   
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
else  
 begin   
        set @StrSql='CREATE TABLE '+ @TableName +'([emp_id] [varchar] (36) ) ON [PRIMARY]'    
        exec (@StrSql) 
  --循环休假表  
   DECLARE @tmpleave1 CURSOR 
	SET   @tmpleave1   =   CURSOR   SCROLL   DYNAMIC 
	for   
   SELECT leave_type.leave_code  
   FROM leave_type where is_enable=1   
   OPEN @tmpleave1  
   FETCH NEXT FROM @tmpleave1 INTO @leave_code  
   WHILE (@@fetch_status=0)  
   Begin  
        
      set @StrSql='ALTER TABLE '+@TableName+' ADD ['+ @leave_code +'] [float] (36)  NULL' 
      exec (@StrSql)  
        
   FETCH NEXT FROM @tmpleave1 INTO @leave_code  
   END  
   CLOSE @tmpleave1  
   DEALLOCATE @tmpleave1  
     
  --循环加班表  
   DECLARE @tmpot1 CURSOR 
	SET   @tmpot1   =   CURSOR   SCROLL   DYNAMIC 	
for   
   SELECT ot_type.ot_type_code  
   FROM ot_type where is_enable=1   
   OPEN @tmpot1  
   FETCH NEXT FROM @tmpot1 INTO @ot_code  
   WHILE (@@fetch_status=0)  
   Begin  
          set @StrSql='ALTER TABLE '+@TableName+' ADD ['+ @ot_code +'] [float] (36)  NULL '  
           exec (@StrSql)  
   FETCH NEXT FROM @tmpot1 INTO @ot_code  
   END  
   CLOSE @tmpot1  
   DEALLOCATE @tmpot1  
     
    
    
  --循环轮班表  
   DECLARE @tmpatt1 CURSOR
	SET   @tmpatt1   =   CURSOR   SCROLL   DYNAMIC 	
for   
   SELECT shift_class.attendance_class_code  
   FROM  shift_class where is_enable=1   
   OPEN @tmpatt1  
   FETCH NEXT FROM @tmpatt1 INTO @att_code  
   WHILE (@@fetch_status=0)  
   Begin  
          set @StrSql='ALTER TABLE '+@TableName+' ADD ['+ @att_code +'] [float] (36)  NULL  '  
          exec (@StrSql)  
           
   FETCH NEXT FROM @tmpatt1 INTO @att_code  
   END  
   CLOSE @tmpatt1  
   DEALLOCATE @tmpatt1  
                 
      

     
        
   set @StrSql='insert into '+@TableName+' (emp_id) select emp_id from EMP_INFO_MASTER '  
   exec (@StrSql)  
     
     
   --if exists (select * from dbo.sysobjects where id = object_id('IX_'+@TableName) and OBJECTPROPERTY(id, N'TableHasNonclustIndex') = 1)  
  -- begin  
 -- --  set @strsql='drop index IX_'+@TableName  
 --   exec(@strsql)  
 --  end  
 -- set @StrSql='create UNIQUE INDEX [IX_'+@TableName+'] on [dbo].['+@TableName+'] ([emp_id]) ON [PRIMARY]'  
 -- exec (@StrSql)  
  end   
   
end