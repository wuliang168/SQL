USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_ChangeSalaryDepTotalStart]  --eSP_ChangeSalaryDepTotalStart 2301,1
-- skydatarefresh eSP_ChangeSalaryDepTotalStart
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 部门加薪总包的取消确认程序
-- @ID 为部门加薪添加的ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 数据还未确认!
    If Exists(Select 1 From pSalaryDepTotal_register Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 910020
        Return @RetVal
    End

    Begin TRANSACTION

    -- 插入部门加薪总包表项pSalaryDepTotal
    insert into pSalaryDepTotal (Date,DepID,SupDepID,Director,MDDepTotal,SalaryDepTotal,Remark)
    select Date,DepID,SupDepID,Director,MDDepTotal,SalaryDepTotal,Remark
    from pSalaryDepTotal_register
    where id=@id
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 添加部门MD职级调整说明
    --update pSalaryDepTotal set Remark=N'MD职级调整原因中需详细说明调整人员的业绩、工作成果等' 
    --where Date=(select Date from pSalaryDepTotal_register where id=@id) 
    --and Director=(select Director from pSalaryDepTotal_register where id=@id)

    -- 插入部门加薪总包历史表pSalaryDepTotal_all
    insert into pSalaryDepTotal_all (Date,DepID,SupDepID,Director,MDDepTotal,SalaryDepTotal,Submit,SubmitBy,SubmitTime,Remark)                            
    select Date,DepID,SupDepID,Director,MDDepTotal,SalaryDepTotal,Submit,SubmitBy,SubmitTime,Remark
    from pSalaryDepTotal_register
    where id=@id
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 合规专员(虚拟部门)(DepID:732)
    -- 营业部合规风控专员(SCORE_TYPE: 14)
    -- 插入MD职级及薪酬调整表项PMDTOMODIFY_REGISTER
    IF Exists(Select 1 From pSalaryDepTotal_register Where DepID=732)
    BEGIN
        insert into PMDTOMODIFY_REGISTER (Date,EID,Badge,Name,DepID,SupDepID,JobID,Director,Education,Degree,ServingAge,Seniority,pYear,pYearScore,pYearRanking,pYearLevel,
        MDID,MDIDtoModify,SalaryPerMM,SalaryPerMMtoModify,Initialized,Initializedby,Initilizedtime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)                            
        select a.Date,b.EID,b.Badge,b.Name,b.DepID,a.DepID,b.JobID,a.Director,c.HighLevel,c.HighDegree,
        ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2),
        ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2),
        YEAR(getdate())-1,e.scoretotal,e.ranking,e.pYearLevel,b.MDID,NULL,f.SalaryPerMM,NULL,a.Submit,a.SubmitBy,a.SubmitTime,NULL,NULL,NULL,NULL,NULL,NULL
        from pSalaryDepTotal_register a,eemployee b,eDetails c,eStatus d,pscore_all e,pEmployeeEmolu f
        where a.id=@id  and b.EID=c.EID and b.EID=d.EID and b.EID=e.eid and b.EID=f.EID
        and e.PPROCESSid=(select id from pprocess where year(period)=YEAR(getdate())-1)
        and e.SCORE_TYPE in (14) and b.Status not in (4,5)
        and e.PPROCESSid=(select id from pprocess where year(period)=YEAR(getdate())-1)
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    END

    -- 区域财务(虚拟部门)(DepID:733)
    -- 区域财务经理(SCORE_TYPE: 17)
    -- 插入MD职级及薪酬调整表项PMDTOMODIFY_REGISTER
    IF Exists(Select 1 From pSalaryDepTotal_register Where DepID=733)
    BEGIN
        insert into PMDTOMODIFY_REGISTER (Date,EID,Badge,Name,DepID,SupDepID,JobID,Director,Education,Degree,ServingAge,Seniority,pYear,pYearScore,pYearRanking,pYearLevel,
        MDID,MDIDtoModify,SalaryPerMM,SalaryPerMMtoModify,Initialized,Initializedby,Initilizedtime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)                            
        select a.Date,b.EID,b.Badge,b.Name,b.DepID,a.DepID,b.JobID,a.Director,c.HighLevel,c.HighDegree,
        ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2),
        ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2),
        YEAR(getdate())-1,e.scoretotal,e.ranking,e.pYearLevel,b.MDID,NULL,f.SalaryPerMM,NULL,a.Submit,a.SubmitBy,a.SubmitTime,NULL,NULL,NULL,NULL,NULL,NULL
        from pSalaryDepTotal_register a,eemployee b,eDetails c,eStatus d,pscore_all e,pEmployeeEmolu f
        where a.id=@id  and b.EID=c.EID and b.EID=d.EID and b.EID=e.eid and b.EID=f.EID
        and e.PPROCESSid=(select id from pprocess where year(period)=YEAR(getdate())-1)
        and e.SCORE_TYPE in (17) and b.Status not in (4,5)
        and e.PPROCESSid=(select id from pprocess where year(period)=YEAR(getdate())-1)
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    END

    -- 综合会计(虚拟部门)(DepID:735)
    -- 综合会计(集中)(SCORE_TYPE: 19)、综合会计(非集中)(SCORE_TYPE: 20)
    -- 插入MD职级及薪酬调整表项PMDTOMODIFY_REGISTER
    IF Exists(Select 1 From pSalaryDepTotal_register Where DepID=735)
    BEGIN
        insert into PMDTOMODIFY_REGISTER (Date,EID,Badge,Name,DepID,SupDepID,JobID,Director,Education,Degree,ServingAge,Seniority,pYear,pYearScore,pYearRanking,pYearLevel,
        MDID,MDIDtoModify,SalaryPerMM,SalaryPerMMtoModify,Initialized,Initializedby,Initilizedtime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)                            
        select a.Date,b.EID,b.Badge,b.Name,b.DepID,a.DepID,b.JobID,a.Director,c.HighLevel,c.HighDegree,
        ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2),
        ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2),
        YEAR(getdate())-1,e.scoretotal,e.ranking,e.pYearLevel,b.MDID,NULL,f.SalaryPerMM,NULL,a.Submit,a.SubmitBy,a.SubmitTime,NULL,NULL,NULL,NULL,NULL,NULL
        from pSalaryDepTotal_register a,eemployee b,eDetails c,eStatus d,pscore_all e,pEmployeeEmolu f
        where a.id=@id and b.EID=c.EID and b.EID=d.EID and b.EID=e.eid and b.EID=f.EID
        and e.PPROCESSid=(select id from pprocess where year(period)=YEAR(getdate())-1)
        and e.SCORE_TYPE in (19,20) and b.Status not in (4,5)
        and e.PPROCESSid=(select id from pprocess where year(period)=YEAR(getdate())-1)
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    END

    -- 非合规专员、区域财务和综合会计
    -- 插入MD职级及薪酬调整表项PMDTOMODIFY_REGISTER
    IF Exists(Select 1 From pSalaryDepTotal_register Where DepID not in (732,733,735,736))
    BEGIN
        insert into PMDTOMODIFY_REGISTER (Date,EID,Badge,Name,DepID,SupDepID,JobID,Director,Education,Degree,ServingAge,Seniority,pYear,pYearScore,pYearRanking,pYearLevel,
        MDID,MDIDtoModify,SalaryPerMM,SalaryPerMMtoModify,Initialized,Initializedby,Initilizedtime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)                            
        select a.Date,b.EID,b.Badge,b.Name,b.DepID,a.DepID,b.JobID,a.Director,c.HighLevel,c.HighDegree,
        ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2),
        ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2),
        YEAR(getdate())-1,e.scoretotal,e.ranking,e.pYearLevel,b.MDID,NULL,f.SalaryPerMM,NULL,a.Submit,a.SubmitBy,a.SubmitTime,NULL,NULL,NULL,NULL,NULL,NULL
        from pSalaryDepTotal_register a,eemployee b,eDetails c,eStatus d,pscore_all e,pEmployeeEmolu f,odepartment g
        where a.id=@id and b.DepID in (select depid from odepartment where depid=a.DepID or AdminID=a.DepID) 
        and b.EID=c.EID and b.EID=d.EID and b.EID=e.eid and b.EID=f.EID and b.DepID=g.DepID
        and e.SCORE_TYPE not in (14,17,19,20) and b.Status not in (4,5)
        and e.PPROCESSid=(select id from pprocess where year(period)=YEAR(getdate())-1) 
        -- 排除考核负责人
        and (b.EID <> a.Director and g.DepType in (2,3))
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    END

    -- 添加分公司和营业部负责人
    -- 插入分公司和营业部负责人到营业部经理(虚拟部门)
    IF Exists(Select 1 From pSalaryDepTotal_register Where DepID not in (732,733,735,736))
    BEGIN
        insert into PMDTOMODIFY_REGISTER (Date,EID,Badge,Name,DepID,SupDepID,JobID,Director,Education,Degree,ServingAge,Seniority,pYear,pYearScore,pYearRanking,pYearLevel,
        MDID,MDIDtoModify,SalaryPerMM,SalaryPerMMtoModify,Initialized,Initializedby,Initilizedtime,Submit,SubmitBy,SubmitTime,Closed,ClosedBy,ClosedTime)                            
        select a.Date,b.EID,b.Badge,b.Name,b.DepID,a.DepID,(select depid from odepartment where depid=736),
        (select director from odepartment where depid=736),c.HighLevel,c.HighDegree,
        ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2),
        ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2),
        YEAR(getdate())-1,e.scoretotal,e.ranking,e.pYearLevel,b.MDID,NULL,f.SalaryPerMM,NULL,a.Submit,a.SubmitBy,a.SubmitTime,NULL,NULL,NULL,NULL,NULL,NULL
        from pSalaryDepTotal_register a,eemployee b,eDetails c,eStatus d,pscore_all e,pEmployeeEmolu f,odepartment g
        where a.id=@id and b.DepID in (select depid from odepartment where depid=a.DepID or AdminID=a.DepID) 
        and b.EID=c.EID and b.EID=d.EID and b.EID=e.eid and b.EID=f.EID and b.DepID=g.DepID
        and e.SCORE_TYPE not in (14,17,19,20) and b.Status not in (4,5)
        and e.PPROCESSid=(select id from pprocess where year(period)=YEAR(getdate())-1) 
        -- 添加考核负责人
        and (b.EID = a.Director and g.DepType in (2,3))
        -- 异常流程
        If @@Error<>0
        Goto ErrM
    END

    -- 更新MD职级及薪酬调整表项pMDtoModify_register
    Update a
    Set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
    From PMDTOMODIFY_REGISTER a, eemployee b
    Where a.EID=b.EID AND (a.pYearLevel in ('D') or (a.pYearLevel is NULL AND b.EmpGrade NOT in (2,9,5,15,16)))
    AND a.SupDepID=(select depid from pSalaryDepTotal_register where id=@id)
    -- 异常流程
    IF @@Error <> 0
    Goto ErrM


    -- 删除登记表
    delete from pSalaryDepTotal_register where id=@id
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 递交
    COMMIT TRANSACTION

    -- 正常处理流程
    Set @Retval = 0
    Return @Retval

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval

End