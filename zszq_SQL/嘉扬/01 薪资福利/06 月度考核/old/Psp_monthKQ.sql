USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Psp_monthKQ]
  @id int,
  @URID int,
  @RetVal int=0 OutPut
as
begin

  declare @kpimonth smalldatetime,
         @pProcessid int
  select @kpimonth=kpimonth, @pProcessid=pProcessid
  from pProcess_month
  where id=@id

  --上月未关闭，不可开启本月！
  --If Exists(Select 1 From pProcess_month
  --   Where DATEDIFF(MM,kpimonth,DATEADD(MM,-1,@kpimonth))=0 And Isnull(Submit,0)=0
  --  )
  --Begin
  -- Set @RetVal = 1000011
  -- Return @RetVal
  --End

  --本月已开启，不用重复点击！
  If Exists(Select 1
  From pProcess_month
  Where ISNULL(Initialized,0)=1 and isnull(id,0)=@id and begindate is not null
   )
 Begin
    Set @RetVal = 1100043
    Return @RetVal
  End

  --本考核期间KPI制定未关闭，不能开启月度流程!
  /*If Exists(Select 1 From pProcess_month a,pProcess b where a.id=@id and a.pProcessID=b.id and b.kpienddate is null
   )
 Begin
  Set @RetVal = 1000049
  Return @RetVal
 End */

  Begin TRANSACTION

  update a
  set a.Initialized=1,a.InitializedTime=GETDATE(),begindate=GETDATE(),eid=@URID
  from pProcess_month a
  where a.id=@id

  IF @@Error <> 0
  Goto ErrM

  --插入员工  从pemployee插入才合理
  insert into pEmpProcess_Month
    (period,badge,name,depid,depid2,jobid,kpidepid,pegroup,pstatus
    ,kpiReportTo,monthID)
  select @kpimonth,a.badge,a.Name,b.DepID1st,b.DepID2nd,a.jobid,b.KPIDepID,NULL,2,b.KPIReportTo, @id
  from eEmployee a,pVW_pMonthKPIReportTo b
  where a.Status in (1,2,3) and a.EID=b.EID and ISNULL(b.pStatus,0)<>2
    and not exists (select 1
    from pEmpProcess_Month
    where badge=a.badge and monthID=@id)
  -- 异常流程
  IF @@Error <> 0
  Goto ErrM

  --年度KPI
  insert into pMonth_Kpi
    (kpimonth,kpiid,score,FJTarget,badge,monthid,xorder)
  select @kpimonth, b.kpiid, b.score, b.FJTarget, a.badge, @id, xorder
  from pEmpProcess_KPI a, pEmployee_KPI b
  where a.ID=b.PEMPPROCESSid and a.pProcessID=@pProcessid
  --and a.badge not in (select badge from eemployee where EID in (select DIRECTOR from ODEPARTMENT where DIRECTOR is not null))--0106

  IF @@Error <> 0
  Goto ErrM

  --更新上月累计
  update a
  set a.SUMKPIDATA=b.SUMKPIDATA,a.KPIRATE=b.KPIRATE,a.REMARK=b.REMARK
  from pMonth_Kpi a, pMonth_Kpi b
  where a.monthid=@id and a.badge=b.badge and a.kpiid=b.kpiid
    and b.monthid=(Select id
    From pProcess_month
    Where DATEDIFF(MM,kpimonth,DATEADD(MM,-1,@kpimonth))=0 And Isnull(Submit,0)=1)

  --年度重点工作任务
  insert into pMonth_GS
    (title,KPIGLZB,begindate,enddate,xorder,datemodulus,remark,badge,monthid)
  select b.title, b.KPIGLZB, b.begindate, b.enddate, b.xorder, b.datemodulus, b.remark, a.badge, @id
  from pEmpProcess_KPI a, pEmployee_GS b
  where a.ID=b.PEMPPROCESSid and a.pProcessID=@pProcessid
  --and a.badge not in (select badge from eemployee where EID in (select DIRECTOR from ODEPARTMENT where DIRECTOR is not null))--0106

  IF @@Error <> 0
  Goto ErrM

  --跨月份插入
  declare @SYID int

  select @SYID=id
  from pProcess_month
  where DATEDIFF(MM,kpimonth,DATEADD(MM,-1,@kpimonth))=0 and ISNULL(submit,0)=1

  insert into PMONTH_PLAN
    (monthtitle,pMonth_ASSID,begindate,enddate,xorder,datemodulus,remark,badge,monthid)
  select monthtitle, pMonth_ASSID, begindate, enddate, xorder, datemodulus, remark, badge, @id
  from PMONTH_PLAN
  where monthid=@SYID and DATEDIFF(MM,enddate,@kpimonth)<=0 and badge in (select badge
    from pEmpProcess_Month
    where monthID=@id)

  IF @@Error <> 0
  Goto ErrM

  -----生成月度考核树
  --declare @processid int
  --select @processid=pProcessID from pProcess_month where id=@id

  --insert into SkyPAFormConfig(xyear,PID,id,XID,xorder,title,xtype,URL,remark,Condition,beforeorafter)
  --select @processid,cast (c.EID as varchar),cast (@processid as varchar)+cast (EID as varchar)+cast (a.id as varchar),
  --case when xid <> 0 then cast (@processid as varchar)+cast (EID as varchar)+cast (XID as varchar) else 0 end,
  --a.xorder,a.title,a.xtype,a.URL,a.remark,'select {U_EID}',beforeorafter
  --from pAFormConfig a,pEmpProcess_Month b,pEmployee c,pAForm_Role d
  --where b.badge=c.Badge and a.xtype=4 and a.beforeorafter=1 and c.perole=d.Roleid and d.Formid=a.id
  --and d.isUsed=1 and b.monthID=@id
  --and cast (@processid as varchar)+cast (EID as varchar)+cast (a.id as varchar) not in (select id from SkyPAFormConfig)

  --IF @@Error <> 0
  --Goto ErrM


  COMMIT TRANSACTION
  Set @RetVal=0
  Return @RetVal

  ErrM:
  ROLLBACK TRANSACTION
  If isnull(@RetVal,0)=0
  Set @RetVal=-1
  Return @RetVal

end