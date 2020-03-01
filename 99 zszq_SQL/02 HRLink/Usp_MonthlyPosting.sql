USE [HRLINK]
GO
/****** Object:  StoredProcedure [dbo].[Usp_MonthlyPosting]    Script Date: 02/08/2018 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- Procedure
-- Procedure  
-- Procedure  
-- Procedure  


  
  
  
/********************************************************************************  
 项目名称  esspayroll  
 过程名称  Usp_MonthlyPosting  
 主要功能  月度过帐  
     
 参数值  
         
         
         
   
 作者  james  
 编写日期  2007/5/30  
********************************************************************************/  
ALTER PROCEDURE [dbo].[Usp_MonthlyPosting]  

  
 (  
  @pay_year int,--薪资年度  
  @pay_month int,--薪资月度  
  @operator_user_id varchar(36),--创建人  
  @job_name varchar(500)  
 )  
  
--set @pay_year=2007  
--set @pay_month=12  
--set @operator_user_id='admin'  

AS
begin  
declare @count int  
declare @IsSet int  
declare @year_start_month int  
declare @date_year int  
declare @pay_year_id varchar(36)  
declare @new_pay_year_id varchar(36)  
declare @emp_id varchar(36)  
declare @leave_code varchar(36)  
declare @emp_count int  
declare @tmp_table varchar(1000)  
declare @leave_value numeric(20,2)  
declare @sqlstr nvarchar(4000)  
declare @StrSql varchar(7500)
declare @tmp_payrole_id varchar(36)  

declare @YearSalary_end_date datetime  
declare @YearSalary_statr_date datetime  
declare @today datetime  

declare @key_id varchar(36)  


declare @field_code varchar(36)               --字段编码 
declare @field_type varchar(36)
declare @field_length varchar(36)
  


begin TRAN T1   
  
set @key_id=convert(varchar(10),@pay_year) +'_'+convert(varchar(10),@pay_month)  
  
insert into paytask_posting_process (key_id,task_id,pay_year,pay_month,cal_index,[user_id],job_name) values  
(newid(),@key_id,@pay_year,@pay_month,0,@operator_user_id,@job_name)  
  
set @tmp_table=dbo.fnGetMonthlyAttendanceAuditTableName(convert(varchar(36),@pay_year),convert(varchar(36),@pay_month))  
  
  
exec usp_Calculate_CreateAttenandceTable @pay_year,@pay_month  
exec usp_Calculate_CreateMonthInputTable @pay_year,@pay_month  
  
EXEC usp_Calculate_CreatePayRemarkTable @pay_year,@pay_month   
  
update paytask_posting_process set cal_index=5 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
  
  
  
 declare @para_value varchar(3000)  
set @para_value=convert(varchar(10),@pay_year)+','+convert(varchar(10),@pay_month)+','''+@operator_user_id+''''  
  
exec dbo.usp_Procedure_Event_Action 'Usp_MonthlyPosting','0000',@para_value  
if @@error>0  goto roll  
update paytask_posting_process set cal_index=20 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
  
exec usp_MonthlyPosting_monthly_attendance_audit_all @pay_year,@pay_month  
if @@error>0  goto roll  
  
update paytask_posting_process set cal_index=30 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
  
 declare @cursor_emp_id cursor   
 set @cursor_emp_id=CURSOR   SCROLL   DYNAMIC   
 for  
 select emp_id from paytask_include_emps where paytask_id in(select key_id from paytask where (pay_year=@pay_year and pay_month=@pay_month) and current_task_status_code='0005')  
 open @cursor_emp_id   
      fetch next from @cursor_emp_id into @emp_id  
      while (@@fetch_status=0)  
      begin   
     declare @cursor_leave_code cursor   
     set @cursor_leave_code=CURSOR   SCROLL   DYNAMIC   
     for  
     select leave_code from leave_type where is_enable='1' order by display_order  
     open @cursor_leave_code   
     fetch next from @cursor_leave_code into @leave_code  
     while (@@fetch_status=0)  
     begin   
      select @emp_count=count(*) from attendance_history_info where emp_id=@emp_id and pay_year=@pay_year and leave_code=@leave_code  
        
      set @sqlstr='select @leave_value='+@leave_code+' from '+rtrim(@tmp_table)+' where emp_id='''+@emp_id+''''  
      exec sp_executesql @sqlstr,N'@leave_value numeric(20,2) out',@leave_value output  
      set @leave_value=isnull(@leave_value,0)  
        
      if @emp_count=0  
      begin  
       if @leave_value!=0  
       begin  
       insert into attendance_history_info (key_id,emp_id,pay_year,leave_code,leave_value) values(newid(),@emp_id,@pay_year,@leave_code,@leave_value)  
       if @@error>0  goto roll  
       end  
      end  
      else  
      begin  
       if @leave_value!=0  
       begin  
       update attendance_history_info set leave_value=isnull(leave_value,0)+@leave_value where emp_id=@emp_id and pay_year=@pay_year and leave_code=@leave_code   
       if @@error>0  goto roll  
       end  
      end  
      fetch next from @cursor_leave_code into @leave_code  
     end  
     close @cursor_leave_code  
    deallocate @cursor_leave_code  
   
       fetch next from @cursor_emp_id into @emp_id  
      end  
      close @cursor_emp_id  
deallocate @cursor_emp_id  
  
update paytask_posting_process set cal_index=45 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
  
  
--元素表清零   
update pay_emp_element_value set element_value='0'   
where emp_id in (select emp_id from paytask_include_emps where paytask_id in(select key_id from paytask where (pay_year=@pay_year and pay_month=@pay_month) and current_task_status_code='0005'))   
and element_id in(select key_id from element where element_type_code='0001' and is_clear=1)  
  
--更新离职员工和先职员工 不发薪的标示位  
update EMP_INFO_MASTER  set is_salary_pay=0 where (emp_status_code='0001' or emp_status_code='0002')  and emp_id   
IN
(
select emp_id from paytask_include_emps 
where paytask_id in(select key_id from paytask where pay_year=@pay_year and pay_month=@pay_month and current_task_status_code='0005' AND quit_date<= cal_cycle_end_dt )
) 
  
update paytask_posting_process set cal_index=55 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
   
update emp_addition_info set is_new_employee='0' where emp_id in(select emp_id from paytask_include_emps where paytask_id in( select key_id from paytask where (pay_year=@pay_year and pay_month=@pay_month) and current_task_status_code='0005')) and is_new_employee='1'   
  
update paytask_posting_process set cal_index=60 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
  
  
update paytask set month_post_dt=getdate(),current_task_status_code='0006' where (pay_year=@pay_year and pay_month=@pay_month) and current_task_status_code='0005'  
if @@error>0  goto roll  
  
update paytask_posting_process set cal_index=65 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
  
update pay_month set posting_type_code='0002' where is_current_month='1'  
if @@error>0  goto roll  
  
update paytask_posting_process set cal_index=68 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
  
declare @year_start_year int   

select @pay_year_id=pay_year_id from pay_month where act_year=@pay_year and pay_month=@pay_month  
select @year_start_year=pay_year,@year_start_month=year_start_month from pay_year where key_id=@pay_year_id  


declare @date_start_year int  
declare @date_start_month int  
declare @date_end_year int  
declare @date_end_month int  
  
select top 1 @date_year=act_year,@date_start_month=pay_month from pay_month where pay_year_id=@pay_year_id order by act_year,pay_month  

  
if @@error>0  goto roll  
  
delete from monthly_attendance_audit_currentmonth  
if @@error>0  goto roll  
  
update paytask_posting_process set cal_index=74 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  




	




--删除员工总表中将要插入的重复数据(当前薪资月需要更新的人员薪资信息)
delete from emp_pay_info_all where pay_year=@pay_year and pay_month=@pay_month and  emp_id in (select emp_id from emp_pay_info_currentmonth) 
--将月度表中的(员工id,,年月,月信息插入到计算结果总表中)
insert into emp_pay_info_all (key_id,emp_id,pay_year,pay_month)(select newid(),emp_id,@pay_year,@pay_month from emp_pay_info_currentmonth)


DECLARE @cursor_update_emp_pay_info_all CURSOR

SET   @cursor_update_emp_pay_info_all   =   CURSOR   SCROLL   DYNAMIC   
FOR 
select field_code,field_type,field_length from TABLE_FIELDS where object_code='emp_pay_info_currentmonth' 
OPEN @cursor_update_emp_pay_info_all
FETCH NEXT FROM @cursor_update_emp_pay_info_all INTO @field_code,@field_type,@field_length
WHILE (@@fetch_status=0)
Begin


     --月结果表的数据插入到员工总结果表中
     set @StrSql='update emp_pay_info_all set emp_pay_info_all.['+@field_code+']=emp_pay_info_currentmonth.['+@field_code+']
     FROM emp_pay_info_all INNER JOIN emp_pay_info_currentmonth ON emp_pay_info_all.emp_id = emp_pay_info_currentmonth.emp_id
     and emp_pay_info_all.[pay_year]='''+convert(varchar(36),@pay_year)+''' and emp_pay_info_all.[pay_month]='''+convert(varchar(36),@pay_month)+''''
     exec(@StrSql)
        
FETCH NEXT FROM @cursor_update_emp_pay_info_all INTO @field_code,@field_type,@field_length
END
CLOSE @cursor_update_emp_pay_info_all
DEALLOCATE @cursor_update_emp_pay_info_all


exec Usp_setEmployess_PayInfoInEmp_History_Payinfo null,@pay_year,@pay_month   
if @@error>0  goto roll  


--删除员工薪资备注总表中将要插入的重复数据(当前薪资备注月需要更新的人员薪资备注信息)
delete from emp_pay_info_remark_all where pay_year=@pay_year and pay_month=@pay_month and  emp_id in (select emp_id from emp_pay_info_remark_currentmonth) 
--将月度表中的(员工id,,年月,月信息插入到计算结果总表中)
insert into emp_pay_info_remark_all (key_id,emp_id,pay_year,pay_month)(select newid(),emp_id,@pay_year,@pay_month from emp_pay_info_remark_currentmonth)


DECLARE @cursor_update_emp_pay_info_remark_all CURSOR

SET   @cursor_update_emp_pay_info_remark_all   =   CURSOR   SCROLL   DYNAMIC   
FOR 
select field_code,field_type,field_length from TABLE_FIELDS where object_code='emp_pay_info_remark_currentmonth' 
OPEN @cursor_update_emp_pay_info_remark_all
FETCH NEXT FROM @cursor_update_emp_pay_info_remark_all INTO @field_code,@field_type,@field_length
WHILE (@@fetch_status=0)
Begin


     --备注月结果表的数据插入到员工备注总结果表中
     set @StrSql='update a set a.['+@field_code+']=b.['+@field_code+']
     FROM emp_pay_info_remark_all a INNER JOIN emp_pay_info_remark_currentmonth b ON a.emp_id = b.emp_id
     and a.[pay_year]='''+convert(varchar(36),@pay_year)+''' and a.[pay_month]='''+convert(varchar(36),@pay_month)+''''
     exec(@StrSql)
        
FETCH NEXT FROM @cursor_update_emp_pay_info_remark_all INTO @field_code,@field_type,@field_length
END
CLOSE @cursor_update_emp_pay_info_remark_all
DEALLOCATE @cursor_update_emp_pay_info_remark_all


delete from emp_pay_info_currentmonth  
if @@error>0  goto roll  
--根据薪资年月，删除成本中心历史表数据
DELETE FROM payroll_costcenter_History WHERE pay_year=@pay_year AND pay_month=@pay_month
if @@error>0  goto roll
--将当前成本中心数据插入历史表
INSERT INTO payroll_costcenter_History (key_id,emp_id,pay_year,pay_month,payitem_code,costcenter_code,value,LOG,cal_order) 
select key_id,emp_id,@pay_year,@pay_month,payitem_code,costcenter_code,value,LOG,cal_order FROM  payroll_costcenter_Current_Month 
if @@error>0  goto roll
--清空成本中心当月表
DELETE FROM payroll_costcenter_Current_Month
if @@error>0  goto roll

--删除薪资备注当月表数据
delete from emp_pay_info_remark_currentmonth  
if @@error>0  goto roll  
  
update paytask_posting_process set cal_index=83 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
  
set @YearSalary_statr_date=convert(datetime,convert(varchar(10),@date_year)+'-'+convert(varchar(10),@date_start_month)+'-1') 




declare @pay_year_id_cursor varchar(36)
declare @act_year_cursor int
declare @pay_month_cursor int
declare @count_cursor int
declare @count_date int
declare @tmp_date datetime


create table #pay_month 
(

   pay_year_id          varchar(36)  collate Chinese_PRC_CI_AS    null,
   act_year             int                  null,
   pay_month            int                  null,
   is_check             bit                      

)

set @count_date=0
WHILE @count_date<12  
begin
	set @tmp_date=convert(datetime,convert(varchar(50),@year_start_year)+'-'+convert(varchar(50),@year_start_month)+'-1')
	set	@tmp_date=dateadd(month,@count_date,@tmp_date)
	insert into #pay_month(pay_year_id,act_year,pay_month,is_check) values (@pay_year_id,year(@tmp_date),month(@tmp_date),0)
	set @count_date=@count_date+1  
end


 declare @cursor_tmp_table cursor     
    set @cursor_tmp_table=CURSOR   SCROLL   DYNAMIC     
    for    
    select pay_year_id,act_year,pay_month from #pay_month where is_check=0
    open @cursor_tmp_table     
     fetch next from @cursor_tmp_table into @pay_year_id_cursor,@act_year_cursor,@pay_month_cursor
     while (@@fetch_status=0)    
     begin  
			


				select @count_cursor=count(*) from pay_month where act_year=@act_year_cursor and pay_month=@pay_month_cursor

			if @count_cursor=0
			begin
			insert into pay_month (key_id,pay_year_id,act_year,pay_month,is_current_month,posting_type_code,last_update_dt,create_dt,create_by)
			values (newid(),@pay_year_id_cursor,@act_year_cursor,@pay_month_cursor,0,'0003',getdate(),getdate(),'aaa')
			end
			
			if @count_cursor>0
			begin
			  update pay_month set pay_year_id =@pay_year_id_cursor from pay_month where act_year=@act_year_cursor and pay_month=@pay_month_cursor
			end

     fetch next from @cursor_tmp_table into @pay_year_id_cursor,@act_year_cursor,@pay_month_cursor
     end     
    close @cursor_tmp_table    
    deallocate @cursor_tmp_table 







 select top 1 @date_end_year=act_year,@date_end_month=pay_month from pay_month where pay_year_id=@pay_year_id order by act_year desc,pay_month desc  
set @YearSalary_end_date=convert(datetime,convert(varchar(10),@date_end_year)+'-'+convert(varchar(10),@date_end_month)+'-1')  
set @today=convert(datetime,convert(varchar(10),@pay_year)+'-'+convert(varchar(10),@pay_month)+'-1')  
  
  
update paytask_posting_process set cal_index=88 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  
  
if datediff(month,@YearSalary_statr_date,@today)>=0 and datediff(month,@YearSalary_end_date,@today)<=0  
begin  
 if datediff(month,@YearSalary_end_date,@today)=0  
  begin  
    declare @tmp_today datetime  
    set @tmp_today=getdate()  
    exec Usp_PostingYearSalary @pay_year_id,@operator_user_id,@tmp_today  
     if @@error>0  goto roll  
  
     if @year_start_month=1  
     begin  
     update pay_month set is_current_month='1' where act_year=@date_end_year+1 and pay_month=@year_start_month  
     end  
     else  
     begin  
     update pay_month set is_current_month='1' where act_year=@date_end_year and pay_month=@year_start_month  
     end  
  end  
  else  
  begin  
   if @pay_month=12  
    begin  
     update pay_month set is_current_month='1' where act_year=@pay_year+1 and pay_month=1  
    end  
    else  
    begin  
     update pay_month set is_current_month='1' where act_year=@pay_year and pay_month=@pay_month+1  
    end  
  end  
end  
   if @@error>0  goto roll  
  
update pay_month set is_current_month='0' where act_year=@pay_year and pay_month=@pay_month  

  
update paytask_posting_process set cal_index=91 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  



declare @current_year varchar(20)
declare @current_month varchar(20)
declare @payitem_code varchar(36)
declare @befor_input_month_table_name varchar(200)
declare @current_input_month_table_name varchar(200)
declare @query_id_takento_nextmonth varchar(36)
declare @payrole_code varchar(36)
select @current_year=convert(varchar(20),act_year),@current_month=convert(varchar(20),pay_month) from pay_month where is_current_month='1'

if exists (select top 1  1 from payitem_config  a  join payitem b on a.payitem_code=b.payitem_code 
	where a.is_allow_month_input=1 and b.is_enable=1 and a.Is_allow_takento_nextmonth=1 )
begin
	exec usp_Calculate_CreateMonthInputTable @current_year,@current_month  

	set @befor_input_month_table_name=dbo.fnGetMonthEndTableName(@pay_year,@pay_month)
	set @current_input_month_table_name=dbo.fnGetMonthEndTableName(@current_year,@current_month)


	create table #emp_table (emp_id varchar(36)  collate Chinese_PRC_CI_AS ,payrole_code varchar(36)  collate Chinese_PRC_CI_AS ,change_payrole_code varchar(36)  collate Chinese_PRC_CI_AS ,is_update bit)
	set @StrSql=' insert into #emp_table (emp_id,payrole_code,is_update) 
	select a.emp_id,b.payrole_code,0  from (select emp_id,dbo.fn_Cal_GetPayRoleID(emp_id) as payrole_id  
	from '+@befor_input_month_table_name+') a left outer join dbo.payrole b on a.payrole_id=b.key_id  '

	exec(@StrSql)

	 declare @cursor_payitem cursor     
    set @cursor_payitem=CURSOR   SCROLL   DYNAMIC     
    for    
    select  a.payitem_code from payitem_config  a  join payitem b on a.payitem_code=b.payitem_code 
	where a.is_allow_month_input=1 and b.is_enable=1 and a.Is_allow_takento_nextmonth=1
    open @cursor_payitem     
     fetch next from @cursor_payitem into @payitem_code
     while (@@fetch_status=0)    
     begin  
			set @StrSql=''
	
			update #emp_table set change_payrole_code=dbo.fn_Cal_GetFatherRole(@payitem_code,payrole_code)



			   declare @cursor_payrole_code cursor     
				set @cursor_payrole_code=CURSOR   SCROLL   DYNAMIC     
				for    
				select payrole_code,query_id_takento_nextmonth from payitem_config where payitem_code=@payitem_code and 
				is_allow_month_input=1 and Is_allow_takento_nextmonth=1
				open @cursor_payrole_code     
				 fetch next from @cursor_payrole_code into @payrole_code,@query_id_takento_nextmonth
				 while (@@fetch_status=0)    
				 begin 


		 
					set @StrSql='insert into '+@current_input_month_table_name+' (emp_id) select emp_id from #emp_table where emp_id not in (select emp_id from '+@current_input_month_table_name+') and change_payrole_code='''+@payrole_code+''' and emp_id in('+dbo.fnGetCalConditionQueryByQueryID(@query_id_takento_nextmonth)+')'
					exec(@StrSql)

					set @StrSql='update '+@current_input_month_table_name+' set '+@current_input_month_table_name+'.'+@payitem_code+'='
					set @StrSql=@StrSql+@befor_input_month_table_name+'.'+@payitem_code+' from '+@current_input_month_table_name
					set @StrSql=@StrSql+' join '+@befor_input_month_table_name+' on '+@current_input_month_table_name+'.emp_id='
					set @StrSql=@StrSql+@befor_input_month_table_name+'.emp_id where '+@befor_input_month_table_name
					set @StrSql=@StrSql+'.emp_id in(select emp_id from #emp_table where change_payrole_code='''+@payrole_code+''' and emp_id in('+dbo.fnGetCalConditionQueryByQueryID(@query_id_takento_nextmonth)+') )'

					exec(@StrSql)			


					 fetch next from @cursor_payrole_code into @payrole_code,@query_id_takento_nextmonth
				 end     
				close @cursor_payrole_code    
				deallocate @cursor_payrole_code 


	     fetch next from @cursor_payitem into @payitem_code
     end     
    close @cursor_payitem    
    deallocate @cursor_payitem 

end  


update paytask_posting_process set cal_index=95 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month  




exec dbo.usp_Procedure_Event_Action 'Usp_MonthlyPosting','0001',@para_value  
if @@error>0  goto roll  
  
update paytask_posting_process set cal_index=100 where task_id=@key_id and [user_id]=@operator_user_id and pay_year=@pay_year and pay_month=@pay_month   
if @@error>0  goto roll    
  if @@error=0    
  set @IsSet=1  
 
  
COMMIT TRAN T1   
return @IsSet  
  
ROLL:  
begin  
set @IsSet=0  
rollback TRAN T1   
return @IsSet  
  
end  


  
end