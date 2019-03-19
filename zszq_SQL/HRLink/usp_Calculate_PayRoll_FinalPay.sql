USE [HRLINK]
GO
/****** 对象:  StoredProcedure [dbo].[usp_Calculate_PayRoll_FinalPay]    脚本日期: 02/01/2019 20:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_Calculate_PayRoll_FinalPay]
@Calculate_ID varchar(36)                 --本次计算的ID

AS 

Begin   

declare @strSql as nvarchar(4000)  

declare @PayTableName as varchar(36)     --计算临时表名称  

declare @ElementTableName as varchar(36) --计算元素临时表  

declare @payplan_id as varchar(36)  

declare @year as varchar(36)             --薪资年  

declare @month as varchar(36)            --薪资月  

declare @payplan_code as varchar(36)     --计算方案编码  

declare @cal_cycle_start_dt as datetime  --计算周期开始  

declare @cal_cycle_end_dt as datetime    --计算周期结束  

declare @node_type varchar(36)           --节点类型   -项目  -元素 -宏  

declare @payitem_id varchar(36)          --项目id  

declare @element_name varchar(36)        --元素名称  

declare @cal_condition_query_id varchar(36)   --计算人员范围条件  

declare @PayRole_Code varchar(36)       --角色编码  

declare @emp_id varchar(36)             --计算员工id  

declare @payitem_code varchar(36)       --薪资项目编码  

declare @ReturnValue money   

declare @is_debug bit   

declare @PayRole_id varchar(36)         --角色ID  

declare @node_index int   

declare @role_index int   

declare @emp_index int   

declare @node_count int  

declare @role_count int  

declare @emp_count int   

declare @node_id varchar(36)  

declare @error_desc varchar(2000)       --日志内容  

declare @AttenandceTable varchar(200)  --考勤月末输入表  

declare @MonthInputTable varchar(200)  --薪资月末输入表  

declare @check_node bit  

declare @payrole_root_code varchar(36)  

declare @count int  

declare @return_basic bit  

declare @payitem_type_code varchar(36)  

 

declare @special_type_code varchar(36)  

declare @special_config_id varchar(36)  

declare @payrole_code_tmp varchar(36)  

declare @leave_code varchar(36)  

declare @leave_config_id varchar(36)  

declare @cal_type_code varchar(36)  --计算类型      

declare @strsql_att varchar(7500)   

  

declare @cal_ot_element varchar(36)      

declare @cal_ot_element_type_code varchar(36)      

declare @ot_type_code varchar(36)      

declare @ot_config_id varchar(36)    

  

  

declare @pay_price money    

declare @attendance_class_code varchar(36)    

declare @config_id varchar(36)    

declare @attendance_class_id  varchar(36) 

declare @payrole_code_cursor varchar(36)   



declare @tax_type_code varchar(36)

declare @effect_taxbase_type_code varchar(36)

declare @effect_taxbase_type_str varchar(10)

declare @accuracy int --薪资项目精度



declare @is_have_extend_paras bit 

declare @strsql_macro varchar(7500)

declare @default_value varchar(200)

declare @macro_code varchar(200)

declare @is_base_payitem bit

declare @cal_type_code_count int



declare @macro_before_syncdata varchar (200)

declare @macro_after_syncdata varchar(200)

declare @sqlst_macro_syncdata varchar(4000)

declare @is_auto_fill bit

--declare @payrole_id_cursor varchar(36)



declare @sp_name varchar(200) 

declare @Macro_name varchar(200)



declare @payitem_count int

declare @roundoff_type_code varchar(36)

declare @substring_count int

declare @str varchar(200)

 set @str='10000000000000000000000000000000000000000000000000'



 

--更新计算任务日志(更新一次计算序号)  

if exists(select * from paytask_log where paytask_id= @Calculate_ID)  

 begin   

       update paytask_log set paytask_cal_no=paytask_cal_no+1 where  paytask_id= @Calculate_ID  

 end   

else  

 begin   

    insert into paytask_log (key_id,paytask_id,paytask_cal_no)values(newid(),@Calculate_ID,1)  

 end   

  

  

--初始化进度值  

set @node_index=0  

set @role_index=0   

set @emp_index=0  

  


set @PayTableName=dbo.fnGetTmpTableName(@Calculate_ID)  

  

--获取薪资计算任务信息  

SELECT @year=pay_year,@month=pay_month,@cal_cycle_start_dt= cal_cycle_start_dt, @cal_cycle_end_dt=cal_cycle_end_dt,@payplan_code=payplan_code  

FROM dbo.paytask where key_id=@Calculate_ID  

select @payplan_id=key_id,@macro_before_syncdata=macro_before_syncdata,@macro_after_syncdata=macro_after_syncdata  from payplan where payplan_code=@payplan_code  

  

  

--判断月末输入表是否存在  
----finalpay注释 start 写死表名

set @AttenandceTable= 'monthly_attendance_audit_finalpay'

set @MonthInputTable= 'monthly_emp_pay_input_finalpay'
----------
  

--if not exists (select * from dbo.sysobjects where id = object_id(@AttenandceTable) and OBJECTPROPERTY(id, N'IsUserTable') = 1)  

--begin  
----finalpay注释 生成finalpay表
 exec dbo.usp_Calculate_CreateAttenandceFinalPayTable

--end  

  

--if not exists (select * from dbo.sysobjects where id = object_id(@MonthInputTable) and OBJECTPROPERTY(id, N'IsUserTable') = 1)  

--begin  
----finalpay注释 生成finalpay表
 exec dbo.usp_Calculate_CreateMonthInputFinalPayTable

--end  



  
  ----finalpay注释 生成finalpay表
 EXEC [usp_Calculate_CreatePayRemarkFinalpayTable]



--判断临时表是否存在(不存在则创建临时表)  

if  not exists (select * from dbo.sysobjects where id = object_id(@PayTableName) and OBJECTPROPERTY(id, N'IsUserTable') = 1)  

begin  

exec dbo.usp_Calculate_Create_EmpPay_TmpTable @Calculate_ID  

--将计算人员,角色插入计算临时表中  

set @strSql= 'insert into '+@PayTableName +'(emp_id,payrole_code,net) SELECT dbo.paytask_cal_include_emps.emp_id, dbo.fn_Cal_GetPayRoleID(dbo.paytask_cal_include_emps.emp_id),0   

FROM dbo.paytask_cal_include_emps   

where  dbo.paytask_cal_include_emps.paytask_id='''+@Calculate_ID+''''   

  

exec(@strSql)  
----finalpay注释 删除
    ----------------------------Error_log---------------------------  

    --    if @@error<>0  

    --    begin   

    --        set @error_desc='@strSql='+@strSql  

    --        exec dbo.usp_Calculate_Set_Log @Calculate_ID,'E0002', @error_desc,'Error','', 'usp_Calculate_PayRoll','0001'   

    --    end   

    ----------------------------Error_log---------------------------  
	----finalpay注释 
end   

else  

begin   

--清空需要计算的人员信息  

exec dbo.usp_Calculate_Create_EmpPay_TmpTable @Calculate_ID  

set @strSql ='DELETE FROM '+@PayTableName+' where  emp_id  in (select emp_id from paytask_cal_include_emps where paytask_id='''+@Calculate_ID+''')'  

exec (@strSql)  

set @strSql= 'insert into '+@PayTableName +'(emp_id,payrole_code) SELECT dbo.paytask_cal_include_emps.emp_id,dbo.fn_Cal_GetPayRoleID(dbo.paytask_cal_include_emps.emp_id)   

FROM dbo.paytask_cal_include_emps   

where  dbo.paytask_cal_include_emps.paytask_id='''+@Calculate_ID+''''   

exec (@strSql)  
----finalpay注释 删除
    ----------------------------Error_log---------------------------  

    --    if @@error<>0  

    --    begin   

    --        set @error_desc='@strSql='+@strSql  

    --        exec dbo.usp_Calculate_Set_Log @Calculate_ID,'E0003', @error_desc,'Error','', 'usp_Calculate_PayRoll','0001'   

    --    end   

    ----------------------------Error_log---------------------------  
	----finalpay注释 
end   

  

  

--判断元素临时表  

set @ElementTableName=dbo.fnGetTmpElementsTableName(@Calculate_ID)  

if  not exists (select * from dbo.sysobjects where id = object_id(@ElementTableName) and OBJECTPROPERTY(id, N'IsUserTable') = 1)  

begin   

 exec usp_Calculate_Create_Elements_TmpTable @ElementTableName  

end  

else  

begin  

  

  

exec usp_Calculate_Create_Elements_TmpTable @ElementTableName  

  

select @count=count(*) from PayTask_TempTable_Name where paytask_id=@Calculate_ID and temp_name=@ElementTableName    

if @count=0    

begin    

insert into PayTask_TempTable_Name (key_id,paytask_id,temp_name) values(newid(),@Calculate_ID,@ElementTableName)    

end    

  

  

  

--清除数据  

set @strsql='delete from '+@ElementTableName  

exec(@strsql)  
----finalpay注释 删除
    ----------------------------Error_log---------------------------  

    --    if @@error<>0  

    --    begin   

    --        set @error_desc='@strSql='+@strSql  

    --        exec dbo.usp_Calculate_Set_Log @Calculate_ID,'E0004', @error_desc,'Error','', 'usp_Calculate_PayRoll','0001'   

    --    end   

    ----------------------------Error_log---------------------------  
	----finalpay注释 删除
end  

  

  

--创建薪资计算临时表的视图(视图名:v_Payroll_Tmp)  

  

set @count =0  

  

--获取节点总数  

SELECT  @node_count=count(*)FROM dbo.payplan_include_nodes where payplan_id=@payplan_id   

--添加一条进度记录  

delete from cal_progress_info where paytask_id=@Calculate_ID  

insert into cal_progress_info(key_id,paytask_id,node_count)values(newid(),@Calculate_ID,@node_count+6)  

  

  

--插入计算节点关系信息  

insert into payplan_nodes_relation (key_id,payplan_node_id,paytask_id,paytask_cal_no)  

(SELECT  newid() as key_id  ,key_id as payplan_node_id,@Calculate_ID as paytask_id ,( select top 1 paytask_cal_no from paytask_log where paytask_id=@Calculate_ID ) as paytask_cal_no  

FROM dbo.payplan_include_nodes where payplan_id=@payplan_id )  

  

  

--批量导入基本薪资和月末输入值  

--exec dbo.Usp_Calculate_UpdateBaseAndMonthInputPayItem @Calculate_ID,@year,@month  

  

  

  

  

  

select @payrole_root_code=payrole_code from payrole where is_root_payrole=1  

  

  

--循环节点表  

declare @PayNodes cursor   

set @PayNodes = CURSOR   SCROLL   DYNAMIC  

for   

SELECT dbo.payplan_include_nodes.key_id, dbo.payplan_include_nodes.node_type,   

      dbo.payplan_include_nodes.payitem_id, dbo.payplan_include_nodes.element_name,   

      dbo.payplan_include_nodes.cal_condition_query_id,   

      dbo.payitem.payitem_code,dbo.payitem.payitem_type_code,

	  dbo.payitem.accuracy,dbo.payitem.is_base_payitem,dbo.payplan_include_nodes.is_auto_fill,

	  isnull(dbo.payitem.roundoff_type_code,'0000') as roundoff_type_code 

FROM dbo.payplan_include_nodes LEFT OUTER JOIN  

      dbo.payitem ON dbo.payplan_include_nodes.payitem_id = dbo.payitem.key_id  

      where dbo.payplan_include_nodes.payplan_id=@payplan_id  

   order by dbo.payplan_include_nodes.display_order  

open @PayNodes  

fetch next from @PayNodes into @node_id,@node_type,@payitem_id,@element_name,@cal_condition_query_id,@payitem_code,@payitem_type_code,@accuracy,@is_base_payitem,@is_auto_fill,@roundoff_type_code

while (@@fetch_status=0)  

begin    

  



update cal_progress_info set node_id=@node_id,node_index=@node_index where paytask_id=@Calculate_ID 



 set @check_node=1  

    

 exec Usp_Calculate_Check_payplan_nodes @node_id,'',@year,@month,@payrole_root_code,@ElementTableName,@check_node out  

  

 if @check_node=1  

 begin  







    

   --判断是否宏节点  

   if   @node_type='0006'     

   begin   

 

	set @strsql_macro=''

	set @macro_code=''

	set @sp_name=''

	 select @macro_code=macro_code,@sp_name=sp_name,@is_have_extend_paras=is_have_extend_paras from Macro where key_id=@payitem_id  

    set @sp_name= isnull(@sp_name,'')  

   if @is_have_extend_paras=1         --启用自定义参数     

   begin     

       

        

	DECLARE   @cursor_name_macro   CURSOR        

    SET   @cursor_name_macro   =   CURSOR   SCROLL   DYNAMIC       

    FOR     

		select default_value from Macro_Paras where macro_code=@macro_code order by display_order

    

    open @cursor_name_macro    

    fetch next from @cursor_name_macro into @default_value    

    while (@@fetch_status=0)    

    begin     

         set @strsql_macro=@strsql_macro+ ',''' +isnull(@default_value,'') +''''    

                                  

    fetch next from @cursor_name_macro into  @default_value    

    end      

    close @cursor_name_macro    

    deallocate @cursor_name_macro    

   end    



   exec( 'exec ' + @sp_name  +' ''' +@Calculate_ID +''''+@strsql_macro)  

   --------------------------Error_log---------------------------  

--   if @@error<>0  

--   begin   

--    set @error_desc='@strSql='+@strsql_macro  

--    exec dbo.usp_Calculate_Set_Log @Calculate_ID,'E0006', @error_desc,'Error','', 'usp_Calculate_PayRoll','0001'  

--   end   

   --------------------------Error_log---------------------------  

   end  

         

     if not  @node_type='0006'                            

      begin   

  

  

  



  

       if @is_base_payitem=1

		begin

			exec Usp_Calculate_UpdateBasePayItem @payitem_code,@is_auto_fill,@cal_condition_query_id,@year,@month,@payrole_root_code,@ElementTableName,@PayTableName  

		end 

		else

       begin  

         

  

       --创建计算人员临时表  

       CREATE TABLE #Emp_tmp_table  

         ( [emp_id] [varchar] (36) COLLATE database_default ,[is_cal] bit, [payrole_code] varchar(36) COLLATE database_default )  

                    



		PRINT '  --将计算人员插入临时表  '
                   

         --将计算人员插入临时表  

       set @StrSql='insert into #Emp_tmp_table (emp_id,is_cal,payrole_code)  

       select a.emp_id,1,dbo.payrole.payrole_code from  (SELECT dbo.paytask_cal_include_emps.emp_id,dbo.fn_Cal_GetPayRoleID(emp_id) as payrole_id   

        FROM dbo.paytask_cal_include_emps   

       where  dbo.paytask_cal_include_emps.paytask_id='''+@Calculate_ID+'''  and  dbo.paytask_cal_include_emps.emp_id in ('+dbo.fnGetCalConditionQueryByQueryID(@cal_condition_query_id)+')) a left outer join dbo.payrole on a.payrole_id=dbo.payrole.key_id '




        exec(@StrSql)  





		   





		



        select @emp_count =count(*) from #Emp_tmp_table  

  

       if @emp_count>0  

       begin  

  

  



				select @payitem_count=count(*) from payitem_config where payitem_code=@payitem_code and is_allow_month_input=1

				and payrole_code in(select dbo.fn_Cal_GetFatherRole(@payitem_code,payrole_code) as payrole_code from #Emp_tmp_table)

				

				set @payitem_count=isnull(@payitem_count,0)



				





        

		  
		 ----finalpay注释 需确认
				--判断是加班，休假，还是轮班  

		  

				 if @payitem_type_code in('0007','0008','0009')  

				 begin  



								create table #table_col ([code] [varchar] (200) COLLATE database_default)



								 set @strsql_att=''  







									  -- 循环薪资角色  

									  declare @cursor_payrole_code cursor   

									  set @cursor_payrole_code = CURSOR   SCROLL   DYNAMIC   

									  for  

									   select distinct payrole_code from #Emp_tmp_table order by payrole_code  

									  open @cursor_payrole_code   

									   fetch next from @cursor_payrole_code into @payrole_code  

									   while (@@fetch_status=0)  

									   begin  

										set @payrole_code_tmp=''  

										set @payrole_code_tmp= dbo.fn_Cal_GetFatherRole(@payitem_code,@payrole_code)               

																  

																			 --休假  

																			 if @payitem_type_code='0007'  

																			 begin  

																  

																			  DECLARE   @cursor_name_leave   CURSOR               

																				SET   @cursor_name_leave   =   CURSOR   SCROLL   DYNAMIC             

																				FOR           

																				select special_config_id from payitem_config_special_relation where payitem_config_key_id in (  

																				select key_id from dbo.payitem_config    

																				where payitem_code=@payitem_code and payrole_code=@payrole_code_tmp )             

																			  open @cursor_name_leave          

																			  fetch next from @cursor_name_leave into @special_config_id          

																			  while (@@fetch_status=0)          

																			  begin    

																  

																  

																			   set @leave_code=null          

																			   set @leave_config_id=null          

																                        

																				 SELECT  @leave_code=dbo.leave_type.leave_code,@leave_config_id=dbo.leave_config.key_id          

																				 FROM dbo.leave_config LEFT OUTER JOIN          

																			   dbo.leave_type ON dbo.leave_config.leave_type_info_id = dbo.leave_type.key_id          

																			   where leave_config.key_id=@special_config_id and dbo.leave_config.is_deduction=1 and dbo.leave_type.is_enable=1   

																  

																                  

																				--判断是否存在角色对应的配置信息        

																				  if exists(SELECT  dbo.leave_type.leave_code,dbo.leave_config.key_id        

																				  FROM dbo.leave_config LEFT OUTER JOIN        

																				dbo.leave_type ON dbo.leave_config.leave_type_info_id = dbo.leave_type.key_id        

																				where  leave_config.payrole_code= @PayRole_code  and dbo.leave_type.leave_code=@leave_code and dbo.leave_config.is_deduction=1 and dbo.leave_type.is_enable=1)        

																				  begin         

																				SELECT top 1 @leave_code=dbo.leave_type.leave_code, @leave_config_id=dbo.leave_config.key_id        

																				  FROM dbo.leave_config LEFT OUTER JOIN        

																				dbo.leave_type ON dbo.leave_config.leave_type_info_id = dbo.leave_type.key_id        

																				  where  leave_config.payrole_code= @PayRole_code  and dbo.leave_type.leave_code=@leave_code and dbo.leave_config.is_deduction=1 and dbo.leave_type.is_enable=1        

																				  end         

																    

																				if @leave_code is not null  

																				begin  

																  

																				 --检测是否存在该列  

																				  if not exists (select  top 1 * from #table_col where code=@leave_code )  

																				  begin   

																				  set @StrSql='ALTER TABLE #Emp_tmp_table ADD  ['+@leave_code+ '] [float] (36)  NULL'  

																					exec (@StrSql)

																					insert into #table_col (code) values (@leave_code)

																                   

																				  end   

																  

																				 if @strsql_att<>''  

																				 begin  

																				  set @strsql_att=@strsql_att+' and isnull(['+@leave_code+'],0)=0'  

																				 end  

																				 else  

																				 begin  

																				  set @strsql_att=@strsql_att+' where isnull(['+@leave_code+'],0)=0'  

																				 end  





																					

																					set @cal_type_code_count=0

																					SELECT  @cal_type_code_count=count(*) FROM 

																					dbo.leave_deduction_relation where leave_config_id=@leave_config_id   and cal_type_code='0002'

																					

																					if @cal_type_code_count>0

																					begin



																						 --检测是否存在该列  

																						 if not exists (select  top 1 * from #table_col where code=@leave_code+'_records_count' )  

																						  begin   

																						  set @StrSql='ALTER TABLE #Emp_tmp_table ADD  ['+@leave_code+ '_records_count] [float] (36)  NULL'  

																						  exec (@StrSql) 

																							insert into #table_col (code) values (@leave_code+'_records_count') 

																						  end  



																							if @strsql_att<>''  

																							 begin  

																							  set @strsql_att=@strsql_att+' and isnull(['+@leave_code+'_records_count],0)=0'  

																							 end  

																							 else  

																							 begin  

																							  set @strsql_att=@strsql_att+' where isnull(['+@leave_code+'_records_count],0)=0'  

																							 end  





																					  set @StrSql=' update #Emp_tmp_table set #Emp_tmp_table.['+@leave_code+'_records_count]=a.records from #Emp_tmp_table join   

																					 (select emp_id,isnull(count(*),0) as records   from leave_records         

																					 where emp_id in (select emp_id from #Emp_tmp_table where payrole_code='''+@payrole_code+''' ) and leave_type_code='''+@leave_code+''' and is_post=1         

																					 and post_year='+convert(varchar(36),@year)+' and post_month='+convert(varchar(36),@month)+' group by emp_id) a on #Emp_tmp_table.emp_id=a.emp_id'  

																					exec(@StrSql)  



																					end



																					set @cal_type_code_count=0

																					SELECT  @cal_type_code_count=count(*) FROM 

																					dbo.leave_deduction_relation where leave_config_id=@leave_config_id   and (cal_type_code is null or cal_type_code='' or cal_type_code='0001')

																					



																					if 	@cal_type_code_count>0

																					begin

																					 set @StrSql='update #Emp_tmp_table set #Emp_tmp_table.['+@leave_code+']='+@AttenandceTable+'.['+@leave_code+']    

																					 from #Emp_tmp_table join '+@AttenandceTable+' on #Emp_tmp_table.emp_id='+@AttenandceTable+'.emp_id   

																					 where #Emp_tmp_table.payrole_code='''+@payrole_code+''''  

																					exec(@StrSql)  

																					end				

																                  

																				end  

																             

																				fetch next from @cursor_name_leave into @special_config_id          

																			  end            

																			  close @cursor_name_leave          

																			  deallocate @cursor_name_leave    

												  

															 end  

												               

															 --加班  

															 if @payitem_type_code='0008'  

															 begin  

												                 

												  

																			   ---按照薪资项目编码获取对应的加班编码信息      

																			   DECLARE   @cursor_name_ot   CURSOR           

																				 SET   @cursor_name_ot   =   CURSOR   SCROLL   DYNAMIC         

																				 FOR       

																			   select special_config_id from payitem_config_special_relation where payitem_config_key_id in (  

																				select key_id from dbo.payitem_config    

																				where payitem_code=@payitem_code and payrole_code=@payrole_code_tmp )                

																			   open @cursor_name_ot      

																			   fetch next from @cursor_name_ot into @special_config_id      

																			   while (@@fetch_status=0)      

																			   begin       

																				set @cal_ot_element =null      

																				set @cal_ot_element_type_code=null      

																				set @ot_type_code=null      

																				set @ot_config_id=null      

																                     

																			   SELECT @cal_ot_element=dbo.ot_config.cal_ot_element,      

																			   @cal_ot_element_type_code=dbo.ot_config.cal_ot_element_type_code,      

																			   @ot_type_code=dbo.ot_type.ot_type_code,      

																			   @ot_config_id=dbo.ot_config.key_id,@cal_type_code=dbo.ot_config.cal_type_code       

																			   FROM dbo.ot_type INNER JOIN      

																				  dbo.ot_config ON dbo.ot_type.key_id = dbo.ot_config.ot_type_id      

																				  where dbo.ot_config.key_id=@special_config_id and dbo.ot_config.is_payment=1 and  dbo.ot_type.is_enable=1      

																                     

																  

																  

																				 --检测是否存在该列  

																				 if not exists (select  top 1 * from #table_col where code=@ot_type_code )  

																				  begin   

																					 set @StrSql='ALTER TABLE #Emp_tmp_table ADD  ['+@ot_type_code+ '] [float] (36)  NULL'  

																					 exec (@StrSql) 

																					 insert into #table_col (code) values (@ot_type_code) 

																				  end   

																  

																				 if @strsql_att<>''  

																				 begin  

																				  set @strsql_att=@strsql_att+' and isnull(['+@ot_type_code+'],0)=0'  

																				 end  

																				 else  

																				 begin  

																				  set @strsql_att=@strsql_att+' where isnull(['+@ot_type_code+'],0)=0'  

																				 end  

																  

																			   --判断是否存在角色对应的配置信息      

																			   if exists(select * from ot_config where cal_ot_element=@cal_ot_element      

																			   and payrole_code=@payrole_code_tmp and dbo.ot_config.is_payment=1 )      

																			   begin       

																				SELECT top 1 @cal_ot_element=dbo.ot_config.cal_ot_element,      

																				@cal_ot_element_type_code=dbo.ot_config.cal_ot_element_type_code,      

																				@ot_type_code=dbo.ot_type.ot_type_code,      

																				@ot_config_id=dbo.ot_config.key_id,@cal_type_code=dbo.ot_config.cal_type_code       

																				FROM dbo.ot_type INNER JOIN      

																				 dbo.ot_config ON dbo.ot_type.key_id = dbo.ot_config.ot_type_id      

																				 where dbo.ot_config.payrole_code=@payrole_code_tmp and dbo.ot_config.cal_ot_element=@cal_ot_element and dbo.ot_config.is_payment=1 and  dbo.ot_type.is_enable=1      

																			   end       

																      

																			   if @cal_type_code is not null and @cal_type_code='0002'      

																			   begin     



																					 --检测是否存在该列  

																					 if not exists (select  top 1 * from #table_col where code=@ot_type_code+'_records_count')  

																					  begin   

																					  set @StrSql='ALTER TABLE #Emp_tmp_table ADD  ['+@ot_type_code+ '_records_count] [float] (36)  NULL'  

																					  exec (@StrSql)  

																						insert into #table_col (code) values (@ot_type_code+'_records_count') 

																					  end   

																	  

																					 if @strsql_att<>''  

																					 begin  

																					  set @strsql_att=@strsql_att+' and isnull(['+@ot_type_code+'_records_count],0)=0'  

																					 end  

																					 else  

																					 begin  

																					  set @strsql_att=@strsql_att+' where isnull(['+@ot_type_code+'_records_count],0)=0'  

																					 end 





																 

																				 set @StrSql=' update #Emp_tmp_table set #Emp_tmp_table.['+@ot_type_code+'_records_count]=a.records from #Emp_tmp_table join   

																					 ( select emp_id,isnull(count(*),0) as records from OT_RECORDS where   

																				  ot_type_code='''+@ot_type_code+''' and emp_id in (select emp_id from #Emp_tmp_table where payrole_code='''+@payrole_code+''' ) and is_post=1   

																				 and post_year='''+convert(varchar(36),@year)+''' and post_month='''+convert(varchar(36),@month)+'''  group by emp_id) a on #Emp_tmp_table.emp_id=a.emp_id'  

																   

																				exec(@StrSql)  

																  

																  

																			   end      

																			   else      

																			   begin      

																					set @StrSql='update #Emp_tmp_table set #Emp_tmp_table.['+@ot_type_code+']='+@AttenandceTable+'.['+@ot_type_code+']    

																				  from #Emp_tmp_table join '+@AttenandceTable+' on #Emp_tmp_table.emp_id='+@AttenandceTable+'.emp_id   

																				  where #Emp_tmp_table.payrole_code='''+@payrole_code+''''  

																				 exec(@StrSql)  

																                     

																			   end      

																  

																				 fetch next from @cursor_name_ot into @special_config_id      

																			   end        

																			   close @cursor_name_ot      

																			   deallocate @cursor_name_ot   

												   

															 end  

												               

												  

															 --轮班  

															 if @payitem_type_code='0009'  

															 begin  





																				---按照薪资项目编码获取对应的轮班编码信息

																				DECLARE   @cursor_name   CURSOR     

																				  SET   @cursor_name   =   CURSOR   SCROLL   DYNAMIC   

																				  FOR 

																				select special_config_id from payitem_config_special_relation where payitem_config_key_id in (  

																				select key_id from dbo.payitem_config    

																				where payitem_code=@payitem_code and payrole_code=@payrole_code_tmp ) 

																				open @cursor_name

																				fetch next from @cursor_name into @special_config_id

																				while (@@fetch_status=0)

																				begin 

																							   set @attendance_class_id=''    

																				    

																							   select @pay_price=pay_price,@attendance_class_id=attendance_class_id from shift_class_config where key_id=@special_config_id    

																				                   

																							   --判断是否存在角色对应的配置信息    

																							   if exists(select * from shift_class_config where attendance_class_id=@attendance_class_id    

																							   and payrole_code=@payrole_code_tmp)    

																							   begin     

																								select  @pay_price=pay_price from shift_class_config where attendance_class_id=@attendance_class_id    

																								and payrole_code=@payrole_code_tmp    

																							   end     

																				                   

																							   select @attendance_class_code= attendance_class_code from shift_class where key_id=@attendance_class_id     

																					





																								--检测是否存在该列  

																							 if not exists (select  top 1 * from #table_col where code=@attendance_class_code)  

																							  begin   

																							  set @StrSql='ALTER TABLE #Emp_tmp_table ADD  ['+@attendance_class_code+ '] [float] (36)  NULL'  

																							  exec (@StrSql)  

																								insert into #table_col (code) values (@attendance_class_code) 

																							  end   

																			  

																							 if @strsql_att<>''  

																							 begin  

																							  set @strsql_att=@strsql_att+' and isnull(['+@attendance_class_code+'],0)=0'  

																							 end  

																							 else  

																							 begin  

																							  set @strsql_att=@strsql_att+' where isnull(['+@attendance_class_code+'],0)=0'  

																							 end  

																			  

																			  

																						   if @attendance_class_code is not null    

																							begin     

																			                    

																							 set @StrSql='update #Emp_tmp_table set #Emp_tmp_table.['+@attendance_class_code+']='+@AttenandceTable+'.['+@attendance_class_code+']   

																							  from #Emp_tmp_table join '+@AttenandceTable+' on #Emp_tmp_table.emp_id='+@AttenandceTable+'.emp_id   

																							  where #Emp_tmp_table.payrole_code='''+@payrole_code+''''  

																							 exec(@StrSql)  

																			                  

																			  

																							end    

																			  

																				  fetch next from @cursor_name into @special_config_id

																				end  

																				close @cursor_name

																				deallocate @cursor_name

															 end  

					               

					  

								 fetch next from @cursor_payrole_code into @payrole_code  

							  end   

							  close @cursor_payrole_code  

							  deallocate @cursor_payrole_code  

		 
							  if @strsql_att<>''  

							  begin  

								

										set @StrSql='insert into '+@ElementTableName+' (emp_id,element_code,element_type,element_value) 

										select emp_id,'''+@payitem_code+''',''0003'',''0'' from #Emp_tmp_table '+@strsql_att

										exec(@StrSql)





								--更新实际计算员工(是否计算状态)  

									set @StrSql='update paytask_include_emps set is_cal=1 where emp_id in (select emp_id from #Emp_tmp_table '+@strsql_att+' )  and paytask_id='''+@Calculate_ID+ ''''

									exec(@StrSql)



									--	print 'delete from #Emp_tmp_table '+@strsql_att

									exec('delete from #Emp_tmp_table '+@strsql_att)  

								end   

								drop table #table_col

				 end  

				 else

				 begin

						--判断该薪资项目中有月末输入类型且不是福利类型的

						if @payitem_count>0 and @payitem_type_code<>'0002'

						begin



								set @accuracy=10

								select @accuracy=accuracy from payitem where payitem_code=@payitem_code

								set @accuracy=isnull(@accuracy,10)			

								set @substring_count=@accuracy+1

								if @roundoff_type_code='0000'

								begin

									set @StrSql='insert into '+@ElementTableName+' (emp_id,element_code,element_type,element_value) 

												select emp_id,'''+@payitem_code+''',''0003'',convert(varchar(200),round(convert(numeric(30,'+convert(varchar(10),@accuracy+2)+'),isnull(['+@payitem_code+'],''0'')),'+convert(varchar(10),@accuracy)+')) from '+@MonthInputTable 



									set @StrSql=@StrSql +' where emp_id in(select emp_id from 

									(select emp_id,dbo.fn_Cal_GetFatherRole('''+@payitem_code+''',payrole_code) as payrole_code from #Emp_tmp_table) b 

									where payrole_code in (select payrole_code from payitem_config where payitem_code='''+@payitem_code+''' and is_allow_month_input=1) and 

									emp_id not in (select emp_id from '+@ElementTableName+' where element_code='''+@payitem_code+'''  and element_type=''0003''))'



								end	



								if @roundoff_type_code='0001'

								begin

										set @StrSql='insert into '+@ElementTableName+' (emp_id,element_code,element_type,element_value) 

										select emp_id,'''+@payitem_code+''',''0003'',convert(varchar(200),convert(numeric(30,'+convert(varchar(10),@accuracy)+'),convert(numeric(30,'+convert(varchar(10),@accuracy)+'),floor(isnull(['+@payitem_code+'],''0'')*'+substring(@str,1,@substring_count)+'))/'+substring(@str,1,@substring_count)+')) from '+@MonthInputTable 



									set @StrSql=@StrSql +' where emp_id in(select emp_id from 

									(select emp_id,dbo.fn_Cal_GetFatherRole('''+@payitem_code+''',payrole_code) as payrole_code from #Emp_tmp_table) b 

									where payrole_code in (select payrole_code from payitem_config where payitem_code='''+@payitem_code+''' and is_allow_month_input=1) and 

									 emp_id not in (select emp_id from '+@ElementTableName+' where element_code='''+@payitem_code+'''  and element_type=''0003''))'



								end				







							exec(@StrSql)



							update #Emp_tmp_table set is_cal=0 where emp_id in (

							select emp_id from (

							select emp_id,dbo.fn_Cal_GetFatherRole(@payitem_code,payrole_code) as payrole_code from #Emp_tmp_table) b 

							where payrole_code in (select payrole_code from payitem_config where payitem_code=@payitem_code and is_allow_month_input=1))





			  				--更新实际计算员工(是否计算状态)  

							update paytask_include_emps set is_cal=1 where emp_id in (

							select emp_id from (

							select emp_id,dbo.fn_Cal_GetFatherRole(@payitem_code,payrole_code) as payrole_code from #Emp_tmp_table) b 

							where payrole_code in (select payrole_code from payitem_config where payitem_code=@payitem_code and is_allow_month_input=1)) and paytask_id=@Calculate_ID  



						end

			

				 end 

		----finalpay注释 需确认

       end  

	
	 	PRINT '加班,休假,轮班处理结束'

  

        set @emp_index=0  











		declare @pay_payrole cursor

		set @pay_payrole = CURSOR   SCROLL   DYNAMIC

		for

		select distinct payrole_code from #Emp_tmp_table order by payrole_code

		open @pay_payrole 

		fetch next from @pay_payrole into @payrole_code_cursor

		while (@@fetch_status=0)

		begin  

				

					set @tax_type_code=''

					set @effect_taxbase_type_code=''

					set @effect_taxbase_type_str=''







					--循环员工计算所有员工对应的薪资项目值  

					declare PayEmp cursor   

					for 

					select emp_id  from #Emp_tmp_table  where payrole_code=@payrole_code_cursor and is_cal=1

					open PayEmp  

					fetch next from PayEmp into @Emp_id  

					while (@@fetch_status=0)  

					begin  

					set @ReturnValue=null  

			       

					--更新员工进度  

					set @emp_index=@emp_index+1  

					update cal_progress_info set emp_id=@emp_id,emp_index=@emp_index ,emp_count=@emp_count where paytask_id=@Calculate_ID  

			                 

					set @PayRole_id=dbo.fn_Cal_GetPayRoleID(@emp_id)   

				   set @PayRole_Code=''  

					select @PayRole_Code=PayRole_Code from payrole where key_id=@PayRole_id  

			          

			                

					  set @PayRole_Code=isnull(@PayRole_Code,'')  

					  exec dbo.Usp_Calculate_GetElementSalaryValue @emp_id,@payitem_code,@ElementTableName,@PayRole_Code,@year,@month,@ReturnValue out  

			                    

			  

					--更新实际计算员工(是否计算状态)  

					 update paytask_include_emps set is_cal=1 where emp_id=@emp_id and paytask_id=@Calculate_ID  

					fetch next from PayEmp into @Emp_id  

					end    

					close PayEmp  

					deallocate PayEmp 





					--更新计算结果表中字段

					  if  not  exists(select   1   from  INFORMATION_SCHEMA.COLUMNS where table_name=@PayTableName and column_name=@payitem_code)  --判断列是否存在  

					  begin   

					  set @StrSql='ALTER TABLE '+@PayTableName+' ADD  ['+@payitem_code+ '] Float  NULL'  

					  exec (@StrSql)  

					  end 








					  	PRINT '批量插入计算结果表'
					--批量插入计算结果表

					set @StrSql='update '+@PayTableName+' set '+@PayTableName+'.['+@payitem_code+']=convert(varchar(200),convert(numeric(30,'+convert(varchar(10),@accuracy)+'),dbo.'+@ElementTableName+'.element_value)) from '+@ElementTableName+'

					join '+@PayTableName+' 

					on '+@PayTableName+'.emp_id =dbo.'+@ElementTableName+'.emp_id and element_type=''0003'' and element_code='''+@payitem_code+''' where dbo.'+@ElementTableName+'.emp_id in (select emp_id from #Emp_tmp_table where payrole_code='''+@payrole_code_cursor+''')'

				print @StrSql







					exec(@StrSql)

					print '批量插入计算结果表完成'

				--获取对应的薪资项目配置

				select @tax_type_code=tax_type_code,@effect_taxbase_type_code=effect_taxbase_type_code 

				from payitem_config where payitem_code=@payitem_code and payrole_code=dbo.fn_Cal_GetFatherRole(@payitem_code,@payrole_code_cursor)   

				PRINT '循环变量初始化'

				--循环变量初始化

				set @StrSql=''

				set @effect_taxbase_type_str=''

			

				--判断该配置中对于睡基数是累加还是扣除

				if @effect_taxbase_type_code='0000'  

				begin  

					 set @effect_taxbase_type_str='+'  

			    end  



				if @effect_taxbase_type_code='0001'  

				begin  

					set @effect_taxbase_type_str='-'  

			    end  







			--判断计税类型(用于扣除或者累加到3种不同的税前基数上)

			if @tax_type_code='0000'

			begin
			PRINT '@tax_type_code'+@tax_type_code


				set @StrSql='update '+@PayTableName+' set '+@PayTableName+'.standard_tax_base=convert(numeric(30,10),isnull(standard_tax_base,0)) '+@effect_taxbase_type_str+' convert(numeric(30,10),dbo.'+@ElementTableName+'.element_value) from '+@ElementTableName+'

				join '+@PayTableName+' 

				on '+@PayTableName+'.emp_id =dbo.'+@ElementTableName+'.emp_id and element_type=''0003'' and element_code='''+@payitem_code+''''

				set @StrSql=@StrSql+ ' and '+@PayTableName+'.emp_id in(select emp_id from #Emp_tmp_table where payrole_code='''+@payrole_code_cursor+''')'

			end

			

			if @tax_type_code='0001'

			begin

				PRINT '@tax_type_code'+@tax_type_code

				set @StrSql='update '+@PayTableName+' set '+@PayTableName+'.bonus_tax_base=convert(numeric(30,10),isnull(bonus_tax_base,0)) '+@effect_taxbase_type_str+' convert(numeric(30,10),dbo.'+@ElementTableName+'.element_value) from '+@ElementTableName+'

				join '+@PayTableName+' 

				on '+@PayTableName+'.emp_id =dbo.'+@ElementTableName+'.emp_id and element_type=''0003'' and element_code='''+@payitem_code+''''

				set @StrSql=@StrSql+ ' and '+@PayTableName+'.emp_id in(select emp_id from #Emp_tmp_table where payrole_code='''+@payrole_code_cursor+''')'



			end



			if @tax_type_code='0002'

			begin

				PRINT '@tax_type_code'+@tax_type_code

				set @StrSql='update '+@PayTableName+' set '+@PayTableName+'.severance_tax_base=convert(numeric(30,10),isnull(severance_tax_base,0)) '+@effect_taxbase_type_str+' convert(numeric(30,10),dbo.'+@ElementTableName+'.element_value) from '+@ElementTableName+'


				join '+@PayTableName+' 

				on '+@PayTableName+'.emp_id =dbo.'+@ElementTableName+'.emp_id and element_type=''0003'' and element_code='''+@payitem_code+''''

				set @StrSql=@StrSql+ ' and '+@PayTableName+'.emp_id in(select emp_id from #Emp_tmp_table where payrole_code='''+@payrole_code_cursor+''')'

			end

			

			if @StrSql<>''

			begin
				PRINT @StrSql
				exec(@StrSql)

			end



		fetch next from @pay_payrole into @payrole_code_cursor

		end  

		close @pay_payrole

		deallocate @pay_payrole 





			if @is_auto_fill is null or @is_auto_fill=1

			begin



				set @StrSql=''

				



				set @StrSql='delete from '+@ElementTableName+' where element_code='''+@payitem_code+''' and element_type=''0003'' and emp_id in (select emp_id from paytask_cal_include_emps where paytask_id='''+@Calculate_ID+''' and emp_id not in(select emp_id from #Emp_tmp_table))'


				exec(@StrSql)



				set @StrSql='insert into '+@ElementTableName+' (emp_id,element_code,element_type,element_value) 

				select emp_id,'''+@payitem_code+''',''0003'',0 from 

				 paytask_cal_include_emps where paytask_id='''+@Calculate_ID+''' and emp_id not in(select emp_id from #Emp_tmp_table)'

				--print @StrSql

				exec(@StrSql)



			end







			                      

			--删除临时表  

			drop table #Emp_tmp_table  

   

       end  

      end  

             

   select @is_debug= isnull(is_save_temp,0) from paytask where key_id=@Calculate_ID  

  

   set @count=@count+1  
    ----finalpay注释 删除
   --if @is_debug=1    --判断是否生成快照  

   --begin   

   -- exec Usp_Calculate_CreateQuickPhoto @Calculate_ID,@node_id  

   --end  
     ----finalpay注释 删除
  

 end  

  

set @node_index=@node_index+1  

 

    

  

fetch next from @PayNodes into @node_id,@node_type,@payitem_id,@element_name,@cal_condition_query_id,@payitem_code,@payitem_type_code,@accuracy,@is_base_payitem,@is_auto_fill,@roundoff_type_code 

end    

close @PayNodes  

deallocate @PayNodes  









  --计算净收入  
  print '计算净收入'  

 exec  dbo.Usp_Calculate_Effect @Calculate_ID  

   print '计算净收入结束'  








set @node_index=@node_index+1  

update cal_progress_info set node_id='macro_before',node_index=@node_index where paytask_id=@Calculate_ID  





if @macro_before_syncdata is not null and @macro_before_syncdata<>''

begin



	set @sp_name=''

	set @strsql_macro=''

	set @is_have_extend_paras=0



	 select @Macro_name=isnull(macro_code,'')+' - '+isnull(macro_name_cn,''),@sp_name=sp_name,@is_have_extend_paras=is_have_extend_paras from Macro where macro_code=@macro_before_syncdata  



   if @is_have_extend_paras=1         --启用自定义参数     

   begin     

    

	DECLARE   @macro_before_syncdata_cursor   CURSOR        

    SET   @macro_before_syncdata_cursor   =   CURSOR   SCROLL   DYNAMIC       

    FOR     

		select default_value from Macro_Paras where macro_code=@macro_before_syncdata order by display_order

    

    open @macro_before_syncdata_cursor    

    fetch next from @macro_before_syncdata_cursor into @default_value    

    while (@@fetch_status=0)    

    begin     

         set @strsql_macro=@strsql_macro+ ',''' +isnull(@default_value,'') +''''    

                                  

    fetch next from @macro_before_syncdata_cursor into  @default_value    

    end      

    close @macro_before_syncdata_cursor    

    deallocate @macro_before_syncdata_cursor    

   end    



   exec( 'exec ' + @sp_name  +' ''' +@Calculate_ID +''''+@strsql_macro)  


   --finalpay注释 删除
   ------------------------Error_log---------------------------  

   --if @@error<>0  

   --begin   



   -- set @error_desc='@action=前^@Macro_name='+@Macro_name  

   -- exec dbo.usp_Calculate_Set_Log @Calculate_ID,'E0075', @error_desc,'Error','', 'usp_Calculate_PayRoll','0001'  

   --end   

   ------------------------Error_log---------------------------  

   --finalpay注释 删除

end



   

  

  set @node_index=@node_index+1  

update cal_progress_info set node_index=@node_index where paytask_id=@Calculate_ID   









   

  

--将计算结果同步到月度表,和员工总表中  
print '将计算结果同步到月度表,和员工总表中usp_Calculate_Copy_To_FinalPayTable'

exec usp_Calculate_Copy_To_FinalPayTable @Calculate_ID

print 'usp_Calculate_Copy_To_FinalPayTable结束'

--将薪资备注动态表数据同步到月度表，并更新备注总表字段
print '将薪资备注动态表数据同步到月度表，并更新备注总表字段'
EXEC usp_Calculate_Copy_To_finalPayRemarkTable @Calculate_ID



  set @node_index=@node_index+1  

update cal_progress_info set node_index=@node_index where paytask_id=@Calculate_ID   

--finalpay注释 不需要
--将计算中需要的报表元素同步到月表中  

--exec usp_Calculate_Elements_Copy_To_MonthTable @Calculate_ID,@ElementTableName  

--finalpay注释 不需要













  set @node_index=@node_index+1  

update cal_progress_info set node_id='macro_after',node_index=@node_index where paytask_id=@Calculate_ID   



if @macro_after_syncdata is not null and @macro_after_syncdata<>''

begin

		set @sp_name=''

		set @strsql_macro=''

	set @is_have_extend_paras=0



	 select @Macro_name=isnull(macro_code,'')+' - '+isnull(macro_name_cn,''),@sp_name=sp_name,@is_have_extend_paras=is_have_extend_paras from Macro where macro_code=@macro_after_syncdata  



   if @is_have_extend_paras=1         --启用自定义参数     

   begin     

    

	DECLARE   @macro_after_syncdata_cursor   CURSOR        

    SET   @macro_after_syncdata_cursor   =   CURSOR   SCROLL   DYNAMIC       

    FOR     

		select default_value from Macro_Paras where macro_code=@macro_after_syncdata order by display_order

    

    open @macro_after_syncdata_cursor    

    fetch next from @macro_after_syncdata_cursor into @default_value    

    while (@@fetch_status=0)    

    begin     

         set @strsql_macro=@strsql_macro+ ',''' +isnull(@default_value,'') +''''    

                                  

    fetch next from @macro_after_syncdata_cursor into  @default_value    

    end      

    close @macro_after_syncdata_cursor    

    deallocate @macro_after_syncdata_cursor    

   end    



   exec( 'exec ' + @sp_name  +' ''' +@Calculate_ID +''''+@strsql_macro)  



   ------------------------Error_log---------------------------  

   if @@error<>0  

   begin   



    set @error_desc='@action=后^@Macro_name='+@Macro_name  

    exec dbo.usp_Calculate_Set_Log @Calculate_ID,'E0075', @error_desc,'Error','', 'usp_Calculate_PayRoll','0001'  

   end   

   ------------------------Error_log---------------------------  



end







  

  

set @node_index=@node_index+1  

update cal_progress_info set node_index=@node_index where paytask_id=@Calculate_ID  


--finalpay注释 跳过成本中心计算
--计算成本中心

   --exec usp_Calculate_CostCenter @Calculate_ID

   --------------------------Error_log---------------------------  

   --if @@error<>0  

   --begin   



   -- set @error_desc='usp_Calculate_CostCenter'  

   -- exec dbo.usp_Calculate_Set_Log @Calculate_ID,'E0075', @error_desc,'Error','', 'usp_Calculate_PayRoll','0001'  

   --end   

   --------------------------Error_log---------------------------  
   --finalpay注释 跳过成本中心计算
set @node_index=@node_index+1  

update cal_progress_info set node_index=@node_index where paytask_id=@Calculate_ID  

  

End