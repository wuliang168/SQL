USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[PSP_ProcessYearMutualStart]    Script Date: 12/15/2016 17:18:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- PSP_ProcessYearMutualStart 9,1
ALTER proc [dbo].[PSP_ProcessYearMutualStart]
@id int,
@URID int,
@RetVal int=0 output
as
/**          
*** 1. 参与年度普通员工互评的部门进度
*** PASSDEP_PROCESS
**** Initializedby：@URID
*** 2. 胜任素质测评
*** pscore_each：胜任素质评测表
**/          
begin
    -- 定义eachtype类型
    declare @eachtype1 int, @eachtype2 int, @eachtype3 int, @eachtype5 int, @eachtype6 int,@eachtype7 int,
    @eachtype11 int,@eachtype12 int, @eachtype13 int, @eachtype21 int, @eachtype22 int, @eachtype25 int,@eachtype26 int,
    @eachtype31 int, @eachtype32 int, @eachtype35 int, @eachtype36 int, @eachtype41 int, @eachtype42 int
    -- eachtype类型赋值
    select 
    @eachtype1=1,           -- 总部部门负责人 总部部门分管领导测评
    @eachtype2=2,           -- 总部部门负责人 总部部门负责人互评
    @eachtype3=3,           -- 总部部门负责人 总部部门员工测评
    @eachtype5=5,           -- 总部部门副职 总部部门分管领导测评
    @eachtype6=6,           -- 总部部门副职 总部部门负责人测评
    @eachtype7=7,           -- 总部部门副职 总部部门员工测评
    @eachtype11=11,         -- 子公司部门负责人 子公司总经理评测
    @eachtype12=12,         -- 子公司部门负责人 子公司部门负责人互评
    @eachtype13=13,         -- 子公司部门负责人 子公司部门员工评测
    @eachtype21=21,         -- 分公司负责人 分公司分管领导评测
    @eachtype22=22,         -- 分公司负责人 分公司人员评测
    @eachtype25=25,         -- 分公司副职 分公司负责人评测
    @eachtype26=26,         -- 分公司副职 分公司人员评测
    @eachtype31=31,         -- 一级营业部负责人 一级营业分管领导评测
    @eachtype32=32,         -- 一级营业部负责人 一级营业部人员评测
    @eachtype35=35,         -- 一级营业部副职 一级营业负责人评测
    @eachtype36=36,         -- 一级营业部副职 一级营业部人员评测
    @eachtype41=41,         -- 二级营业部经理室成员 一级营业部负责人评测
    @eachtype42=42          -- 二级营业部经理室成员 二级营业部人员评测

    -- 部门互评已开启，无法重新开启
    if exists(select 1 from  pEmpProcess_Year_Mutual where PPROCESSid=@id)
        begin
            set @RetVal=1100011
            return @RetVal
        end
    
    -- 胜任素质测评已开启，无法重新开启
    if exists(select 1 from  pscore_each where PPROCESSid=@id)
        begin
            set @RetVal=1100012                      
            return @RetVal                      
        end

    ---年度互评开启          
    begin TRANSACTION

    -------- PPROCESS --------
    -- 更新HPKQ
    update a              
    set a.HPKQ=1              
    from PPROCESS a              
    where id=@id              
    -- 异常处理
    IF @@Error <> 0                                       
    Goto ErrM


    -------- PASSDEP_PROCESS --------
    -- 添加互评的部门。二级营业部部门员工内部互评；总部一二级部门、子公司、分公司和一级营业部员工统一在一级部门框架内部互评
    -- 清空非本年度的PASSDEP_PROCESS信息
    delete PASSDEP_PROCESS where PPROCESSid=@id

    insert into PASSDEP_PROCESS (yearkpi,depid,Initialized,InitializedTime,PPROCESSid)
    select YEAR(GETDATE()),depid,1,GETDATE(),@id
    from odepartment
    where ((isnull(DepGrade,1)=2 and DepType=2) or isnull(DepGrade,1)=1)
    and ISNULL(isDisabled,0)=0
    and ISNULL(ISOU,0)=0 -- ISOU：部门是否虚拟
    and depid not in (481,563,349,695) -- depid：349-公司领导；481-内退；563-待定；695-投资银行
    -- 异常处理
    if @@ERROR<>0
    goto ErrM

    -------- pscore_each --------
    -- 清空非本年度的pscore_each信息
    delete pscore_each where PPROCESSid=@id

    -- 添加胜任素质测评内容
    insert into pscore_each(EID,name,scoreEID,ScoreName,Eachtype,KpiDep,SCore_Type,Weight,Initialized,InitializedTime,Initializedby,PPROCESSid)

    ---- 总部负责人 ----
    -- 总部部门负责人 分管领导测评 20%*40%
    select distinct a.eid,a.name,c.eid,c.name,@eachtype1,a.KpiDep,a.score_type,8,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b ,eemployee c 
    where a.eid=b.eid and b.kpieid1=c.eid
    and a.SCORE_TYPE in (1)
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)
    --总部部门负责人 总部部门负责人互评 20%*30%
    union
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype2,a.KpiDep,a.score_type,6,1,GETDATE(),@URID,@id
    from pscore a ,pscore b 
    where a.eid<>b.eid 
    and a.SCORE_TYPE in (1) and b.SCORE_TYPE in (1)
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)
    -- 总部部门负责人 总部部门内下属员工360度测评 20%*30%
    union
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype3,a.KpiDep,a.score_type,6,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b 
    where a.eid=b.kpieid1 
    and a.SCORE_TYPE in (1) and b.pstatus=1
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)

    ---- 总部部门副职 ----
    -- 总部部门副职 分管领导测评 30%*40%
    union
    select distinct a.eid,a.name,c.eid,c.name,@eachtype5,a.KpiDep,a.score_type,12,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b ,eemployee c
    where a.eid=b.eid and b.kpieid2=c.eid
    and a.SCORE_TYPE in (2) and b.pstatus=1 
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)
    -- 总部部门副职 总部部门负责人测评 30%*30%
    union
    select distinct a.eid,a.name,c.eid,c.name,@eachtype6,a.KpiDep,a.score_type,9,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b ,eemployee c
    where a.eid=b.eid and b.kpieid1=c.eid
    and a.SCORE_TYPE in (2) and b.pstatus=1
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)
    -- 总部部门副职 总部部门内下属员工(不包含总部部门副职)360度测评 30%*30%
    union
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype7,a.KpiDep,a.score_type,9,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b,pEmployee_register c 
    where a.KpiDep=b.kpidepid and a.eid=c.EID
    and a.SCORE_TYPE in (2) and b.pstatus=1
    and a.eid<>b.EID and c.kpieid1<>b.EID and b.perole not in (2)
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)

    ---- 子公司部门负责人 ----
    -- 子公司部门负责人 子公司总经理测评 20%*40%
    union
    select distinct a.eid,a.name,c.eid,c.name,@eachtype11,a.KpiDep,a.score_type,8,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b ,eemployee c 
    where a.eid=b.eid and b.kpieid1=c.eid
    and a.SCORE_TYPE in (10) and b.pstatus=1
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)
    -- 子公司部门负责人 子公司部门负责人互评 20%*30%
    union
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype12,a.KpiDep,a.score_type,6,1,GETDATE(),@URID,@id
    from pscore a ,pscore b 
    where a.eid<>b.eid
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)
    and a.SCORE_TYPE in (10) and b.SCORE_TYPE in (10)
    -- 子公司部门负责人 部门内下属员工360度测评 20%*30%
    union
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype13,a.KpiDep,a.score_type,6,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b 
    where a.eid=b.kpieid1 
    and a.SCORE_TYPE in (10) and b.pstatus=1
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)

    ---- 分公司负责人 ----
    -- 分公司负责人 分管领导评测 20%*60%
    union
    select distinct a.eid,a.name,c.eid,c.name,@eachtype21,a.KpiDep,a.score_type,12,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b ,eemployee c
    where a.eid=b.eid and b.kpieid1=c.eid
    and a.SCORE_TYPE in (24) and b.pstatus=1
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)
    -- 分公司负责人 分公司及二级营业部人员(包括二级营业部经理室)评测 20%*40%
    union
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype22,a.KpiDep,a.score_type,8,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b
    where dbo.eFN_getdepid1(a.KpiDep) = dbo.eFN_getdepid1(b.kpidepid)
    and a.SCORE_TYPE in (24) and b.pstatus=1 and a.eid<>b.EID
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)

    ---- 分公司副职 ----
    -- 分公司副职 分公司负责人评测 20%*60%
    union
    select distinct a.eid,a.name,c.eid,c.name,@eachtype25,a.KpiDep,a.score_type,12,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b ,eemployee c 
    where a.eid=b.eid and b.kpieid1=c.eid
    and a.SCORE_TYPE in (25) and b.pstatus=1 
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)
    -- 分公司副职 分公司(不包括分公司副职)及二级营业部人员(包括二级营业部经理室)评测 20%*40%
    union 
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype26,a.KpiDep,a.score_type,8,1,GETDATE(),@URID,@id
    from pscore a, pEmployee_register b, pEmployee_register c
    where dbo.eFN_getdepid1(a.KpiDep) = dbo.eFN_getdepid1(b.kpidepid)
    and a.SCORE_TYPE in (25) and a.eid=c.eid and b.pstatus=1 
    and a.eid<>b.EID and a.SCORE_TYPE<>b.perole and b.eid<>c.kpieid1
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)

    ---- 一级营业部负责人 ----
    -- 一级营业部负责人 分管领导评测 20%*60%
    union
    select distinct a.eid,a.name,c.eid,c.name,@eachtype31,a.KpiDep,a.score_type,12,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b ,eemployee c 
    where a.eid=b.eid and b.kpieid1=c.eid
    and a.SCORE_TYPE in (5) and b.pstatus=1 
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=c.EID)
    -- 一级营业部负责人 一级营业部人员及二级营业部人员(包括二级营业部经理室)评测 20%*40%
    union 
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype32,a.KpiDep,a.score_type,8,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b
    where dbo.eFN_getdepid1(a.KpiDep) = dbo.eFN_getdepid1(b.kpidepid)
    and a.SCORE_TYPE in (5) and b.pstatus=1 and a.eid<>b.EID
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)

    ---- 一级营业部副职 ----
    -- 一级营业部副职 一级营业部负责人评测 20%*60%
    union 
    select distinct a.eid,a.name,c.eid,c.name,@eachtype35,a.KpiDep,a.score_type,12,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b ,eemployee c
    where a.eid=b.eid and b.kpieid1=c.eid
    and a.SCORE_TYPE in (6) and b.pstatus=1 
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=c.EID)
    -- 一级营业部副职 一级营业部人员(不包括一级营业部副职)及二级营业部人员(包括二级营业部经理室)评测 20%*40%
    union 
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype36,a.KpiDep,a.score_type,8,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b,pEmployee_register c 
    where dbo.eFN_getdepid1(a.KpiDep) = dbo.eFN_getdepid1(b.kpidepid) 
    and a.SCORE_TYPE in (6) and a.eid=c.EID and b.pstatus=1 
    and a.eid<>b.EID and c.kpieid1<>b.EID and b.eid<>c.kpieid1
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)

    ---- 二级营业部经理室成员 ----
    -- 二级营业部经理室成员 一级营业部负责人评测 20%*60%
    union 
    select distinct a.eid,a.name,c.eid,c.name,@eachtype41,a.KpiDep,a.score_type,12,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b ,eemployee c 
    where a.eid=b.eid and b.kpieid1=c.eid
    and a.SCORE_TYPE in (7) and b.pstatus=1
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=c.EID)
    -- 二级营业部经理室成员 二级营业部人员(不包括二级营业部经理室)评测 20%*40%
    union
    select distinct a.eid,a.name,b.Eid,b.name,@eachtype42,a.KpiDep,a.score_type,8,1,GETDATE(),@URID,@id
    from pscore a ,pEmployee_register b,pEmployee_register c
    where dbo.eFN_getdepid1(a.KpiDep) = dbo.eFN_getdepid1(b.kpidepid)
    and a.SCORE_TYPE in (7) and a.eid=c.EID and b.pstatus=1
    and a.eid<>b.EID and c.kpieid1<>b.EID and b.perole not in (7)
    and a.KpiDep=b.kpidepid
    and not exists (select 1 from pscore_each where eid=a.eid and scoreeid=b.EID)

    -- 异常处理
    if @@ERROR<>0
    goto ErrM

    -- 正常处理流程
    COMMIT TRANSACTION
    Set @Retval = 0                                      
    Return @Retval                                     

    -- 异常处理流程
    ErrM:                                     
    ROLLBACK TRANSACTION                                       
    Set @Retval = -1                                    
    Return @Retval             
          
end 