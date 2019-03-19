USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[PSP_ProcessYearMutualStartByDep]    Script Date: 12/14/2016 10:07:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- example： PSP_ProcessYearMutualStartByDep 354,1,1
ALTER proc [dbo].[PSP_ProcessYearMutualStartByDep]                      
@depid int,                        
@URID int,                        
@RetVal int=0 output                        
as
/**                        
*** 年度部门普通员工互评，生成互评信息
**/
begin
    -- @year(年度考核的下一年，通常为下一年1月1日)
    declare @year smalldatetime
    select @year= convert(varchar(4),dateadd(yy,1,period),120)+'-01-01' from pProcess where ISNULL(yearclose,0)=0 and isnull(Initialized,0) =0         
    -- 该部门互评已开启，无法重新开启！                     
    if exists(select 1 from  pEmpProcess_Year_Mutual where byEvalDepid=@depid)                      
        begin
            set @RetVal=1100020                      
            return @RetVal                      
        end

    -- 本年度互评已关闭，不能开启部门互评！        
    if exists(select 1 from  PASSDEP_PROCESS a where a.depid=@depid and ISNULL(Closed,0)=1)                      
        begin                      
            set @RetVal=1100025
            return @RetVal                      
        end                     

 ---年度互评开启                        
 begin TRANSACTION

    -------- pEmpProcess_Year_Mutual --------
    -- 更新互评员工EID和部门DEPID
    -- perole(考核角色)：4-总部普通员工；11-子公司普通员工；29-分公司普通员工；12-一级营业部普通员工；13-二级营业部普通员工
    -- deptype(部门归属)：1-总部；2-营业部；3-分公司；4-子公司
    -- 清空非本年度的pEmpProcess_Year_Mutual信息
    delete pEmpProcess_Year_Mutual where PpROCESSID=(select id from pProcess where isnull(yearclose,0)=0) and kpidepid=@depid
    -- 异常处理
    if @@ERROR<>0
    goto ErrM

    -- 添加pEmpProcess_Year_Mutual
    -- 分公司、一级营业部部门和二级营业部部门员工内部互评；总部一二级部门、子公司员工统一在一级部门框架内部互评
    insert into pEmpProcess_Year_Mutual (evalEID,byEvalEid,eachdep,Initialized,InitializedTime,initializedby)                
    select b.EID,a.EID,@depid,1,GETDATE(),@URID
    from pEmployee a,pEmployee b
    where a.kpidepid=b.kpidepid
    and a.EID<>b.EID
    and isnull(a.pstatus,0)=1 and ISNULL(b.pstatus,0)=1
    and a.perole in(4,11,29,12,13) and b.perole in(4,11,29,12,13)
    and a.kpidepid In (select depid from odepartment where deptype in (1,2,3,4))
    and exists (select 1 from eStatus where eid=a.EID and JoinDate < @year)
    and exists (select 1 from eStatus where eid=b.EID and JoinDate < @year)
    and a.kpidepid=@depid
    
    -- 更新互评员工的byEvalName(被考核人姓名)、byEvalDepid(被考核人一级部门)、byEvalDepid2(被考核人二级部门)、byEvalJobid(被考核人岗位)和kpidepid(互评考核部门)
    update a
    set a.byEvalName=b.Name,
        a.byEvalDepid=dbo.eFN_getdepid1_xs(b.kpidepid),
        a.byEvalDepid2=dbo.eFN_getdepid2(b.DepID),
        a.byEvalJobid=b.JobID,
        a.kpidepid=b.kpidepid
    from pEmpProcess_Year_Mutual a,pEmployee b where a.byEvalEid=b.EID
    -- 异常处理
    if @@ERROR<>0
    goto ErrM

    -- 更新互评员工的考核权重
    update a
    set a.weight=b.modulus
    from pEmpProcess_Year_Mutual a,pvw_scoreEID b
    where a.byEvalEid=b.EID and b.sLevel=1
    -- 异常处理
    if @@ERROR<>0
    goto ErrM

    -- 更新互评员工的pPROCESSID(年度考核ID)
    update a
    set a.pPROCESSID=b.pPROCESSID
    from pEmpProcess_Year_Mutual a,PASSDEP_PROCESS b
    where b.depid=@depid and a.kpidepid=b.depid and ISNULL(a.pPROCESSID,0)=0
    -- 异常处理
    if @@ERROR<>0
    goto ErrM


    -------- PASSDEP_PROCESS --------
    -- 更新部门互评的regby(状态：@URID表示开启部门互评的人员URID)和regbydate(开启部门互评的时间)
    update PASSDEP_PROCESS
    set regby=@URID,regbydate=GETDATE()
    where depid=@depid
    -- 异常处理
    if @@ERROR<>0
    goto ErrM                        

    -- 正常处理返回
    COMMIT TRANSACTION
    Set @Retval = 0
    Return @Retval

    -- 异常处理返回
    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval
                        
end 