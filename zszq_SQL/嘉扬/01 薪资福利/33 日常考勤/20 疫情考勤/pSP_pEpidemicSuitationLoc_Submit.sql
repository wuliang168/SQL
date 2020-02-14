USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[pSP_pEpidemicSuitationLoc_Submit]
    @ReportTo int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 疫情现场办公新增员工确认
*/
Begin

    -- 如果人员姓名为空，无法递交！
    IF Exists(select 1 from pEpidemicSuitationLoc a
    where ((case when dbo.eFN_getdeptype(a.DepID) in (2,3) then A.DEPID else dbo.eFN_getdepid1st(A.DEPID) end) 
    in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo) 
    or A.EID in (select ISNULL(Director,Director2) from oDepartment where DepID in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo)) or a.ReportTo=@ReportTo)
	and a.Name is NULL)
    Begin
        Set @RetVal=1100064
        Return @RetVal
    End

	-- 如果人员类别未选择，无法递交！
    IF Exists(select 1 from pEpidemicSuitationLoc a
    where ((case when dbo.eFN_getdeptype(a.DepID) in (2,3) then A.DEPID else dbo.eFN_getdepid1st(A.DEPID) end) 
    in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo) 
    or A.EID in (select ISNULL(Director,Director2) from oDepartment where DepID in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo)) or a.ReportTo=@ReportTo)
	and a.EpidemicType is NULL)
    Begin
        Set @RetVal=1100063
        Return @RetVal
    End

    -- 是否返回工作地为否或者人员类型(未返回工作地)为5，则目前所在地、预计返回时间和预计上班时间必填，否则无法递交！
    IF Exists(select 1 from pEpidemicSuitationLoc a
    where ((case when dbo.eFN_getdeptype(a.DepID) in (2,3) then A.DEPID else dbo.eFN_getdepid1st(A.DEPID) end) 
    in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo) 
    or A.EID in (select ISNULL(Director,Director2) from oDepartment where DepID in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo)) or a.ReportTo=@ReportTo)
	and (ISNULL(a.IsReturn,0)=0 or a.EpidemicType=5) and (Position is NULL or ESTReturnDate is NULL or ESTWorkDate is NULL))
    Begin
        Set @RetVal=1100061
        Return @RetVal
    End

    -- 人员类型(已返回工作地且隔离期间)为3、4时，则返程是否自驾、隔离起始时间和隔离结束时间必填，否则无法递交！
    IF Exists(select 1 from pEpidemicSuitationLoc a
    where ((case when dbo.eFN_getdeptype(a.DepID) in (2,3) then A.DEPID else dbo.eFN_getdepid1st(A.DEPID) end) 
    in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo) 
    or A.EID in (select ISNULL(Director,Director2) from oDepartment where DepID in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo)) or a.ReportTo=@ReportTo)
	and a.EpidemicType in (3,4) and (GLBDate is NULL or GLEDate is NULL))
    Begin
        Set @RetVal=1100062
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pEpidemicSuitation --------
    -- 删除历史数据
    delete from pEpidemicSuitationLoc_all
    where ReportTo=@ReportTo and DATEDIFF(dd,ESTDate,GETDATE())=0
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -- 新增历史
    insert into pEpidemicSuitationLoc_all(EID,BID,Name,ESTDate,CompID,DepID,DepID1st,DepID2nd,ReportTo,IsReturn,EpidemicType,IsDS,IsDSC,GLBDate,GLEDate,
    Position,ESTReturnDate,ESTWorkDate,Submit,SubmitBy,SubmitTime)
    select EID,BID,Name,GETDATE(),CompID,DepID,DepID1st,DepID2nd,@ReportTo,IsReturn,EpidemicType,IsDS,IsDSC,GLBDate,GLEDate,
    Position,ESTReturnDate,ESTWorkDate,1,@ReportTo,GETDATE()
    from pEpidemicSuitationLoc a
    where ((case when dbo.eFN_getdeptype(a.DepID) in (2,3) then A.DEPID else dbo.eFN_getdepid1st(A.DEPID) end) 
    in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo) 
    or A.EID in (select ISNULL(Director,Director2) from oDepartment where DepID in (select DepID from pEpidemicSuitation_Dep where approverID=@ReportTo))
    or a.ReportTo=@ReportTo)
	and ISNULL(BID,EID) not in (select ISNULL(BID,EID) from pEpidemicSuitationLoc_all where DATEDIFF(dd,GETDATE(),ESTDATE)=0 and ISNULL(BID,EID) is not NULL)
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM


    -- 正常处理流程
    COMMIT TRANSACTION
    Set @RetVal=0
    Return @RetVal

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    If isnull(@RetVal,0)=0
        Set @RetVal=-1
    Return @RetVal
end