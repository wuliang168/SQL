USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMonthStart]
-- skydatarefresh eSP_pSalaryPerMonthStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资流程开启程序
-- @ID 为月度工资流程月度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 月度工资流程中日期为空!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and ISNULL(Date,0)=1)
    Begin
        Set @RetVal = 930091
        Return @RetVal
    End

    -- 月度工资流程已开启!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930092
        Return @RetVal
    End

    -- 月度工资流程已关闭!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930093
        Return @RetVal
    End

    -- 上月度工资流程未关闭!
    If Exists(Select 1 From pSalaryPerMonth Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930099
        Return @RetVal
    End


    Begin TRANSACTION


    -- 插入月度工资流程的部门月度工资流程表项pDepSalaryPerMonth
    insert into pDepSalaryPerMonth(Date,SupDepID,DepID,Status,SalaryPayID,SalaryContact,IsSubmit)
    select b.Date,a.SupDepID,a.DepID,a.Status,a.SalaryPayID,a.SalaryContact,NULL
    from pVW_DepSalaryContact a,pSalaryPerMonth b
    where b.ID=@ID
    -- 营业部
    and ((a.DepID is not NULL and a.DepID not in (select DepID from pDepSalaryPerMonth where DATEDIFF(MM,b.Date,Date)=0))
    -- 非营业部
    or (a.DepID is NULL and a.SalaryPayID not in (select SalaryPayID from pDepSalaryPerMonth where DATEDIFF(MM,b.Date,Date)=0)))
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 通讯费
    ---- 总部人员(工资发放)
    insert into pEMPCommPerMM (EID,Date,CommAllowance,CommAllowanceType)
    select a.EID,b.Date,a.CommAllowance,a.CommAllowanceType
    from pEMPTrafficComm a,pSalaryPerMonth b,eEmployee c
    where b.ID=@ID and a.EID=c.EID and dbo.eFN_getdeptype(c.DepID) in (1,4) and c.Status in (1,2,3)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 过节费
    ---- 总部人员(工资发放)
    insert into pEMPFestivalFeePerMM(EID,Date,FestivalFeeType,FestivalFee)
    select a.EID,b.Date,c.ID,c.Fee*(case when Month(b.Date)=6 then (select COUNT(ID) from ebg_family where EID=a.EID and relation=6 and Datediff(yy,Birthday,b.Date)<=14) else 1 end)
    from eEmployee a,pSalaryPerMonth b,oCD_FestivalFeeType c
    where b.ID=@ID and dbo.eFN_getdeptype(a.DepID) in (1,4) and a.Status in (1,2,3)
    ---- 元旦
    and ((Month(b.Date)=1 and c.ID=1) 
    ---- 春节
    or (DATEDIFF(DD,dbo.lFN_CalendarGetLunar(DATEADD(DD,-DAY(b.Date)+1,b.Date)),CONVERT(varchar(4),YEAR(b.Date)-1)+'-12-30')>=0
    and DATEDIFF(DD,dbo.lFN_CalendarGetLunar(DATEADD(DD,-DAY(b.Date),DATEADD(MM,1,b.Date))),CONVERT(varchar(4),YEAR(b.Date)-1)+'-12-30')<=0 and c.ID=2)
    ---- 五一节
    or (Month(b.Date)=5 and c.ID=4)
    ---- 儿童节
    or (Month(b.Date)=6 and c.ID=9)
    ---- 高温费
    or (Month(b.Date)=8 and c.ID=5)
    ---- 国庆节
    or (Month(b.Date)=10 and c.ID=8))
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 税前税后费用
    ---- 税前扣款(事假:14)
    insert into pEMPBTATPayPerMM(EID,Date,BTATPayType,BTATPay,Remark)
    select a.EID,b.Date,14,ROUND((ISNULL(e.SalaryPerMM,0)+ISNULL(e.SponsorAllowance,0))*ISNULL(COUNT(d.Term),0)/21.75,0),
    CONVERT(nvarchar(5),COUNT(d.Term))+N'天'
    from pEmpOALeave a,pSalaryPerMonth b,eEmployee c,lCalendar d,pVW_pEMPEmolu e
    where b.ID=@ID and a.EID=c.EID and dbo.eFN_getdeptype(c.DepID) in (1,4) and c.Status in (1,2,3) and a.EID=e.EID 
    and DATEDIFF(dd,d.term,a.LeaveBeginDate)>=0 and DATEDIFF(DD,a.LeaveEndDate,d.Term)>=0 and ApprDep=N'绩效管理室' and d.xType=1
    and DATEDIFF(MM,a.ApprTime,b.Date)=1 and a.LeaveType=1
    group by a.EID,b.Date,e.SalaryPerMM,e.SponsorAllowance
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 税前扣款(病假:13)
    insert into pEMPBTATPayPerMM(EID,Date,BTATPayType,BTATPay,Remark)
    select a.EID,b.Date,13,ROUND(ISNULL(SalaryPerMM,0)*ISNULL(COUNT(d.Term),0)
    *(case when e.Cyear<2 then 0.4 when e.Cyear>=2 and e.Cyear<4 then 0.3 when e.Cyear>=4 and e.Cyear<6 then 0.2 when e.Cyear>=6 and e.Cyear<8 then 0.1 else 0 end)/21.75,0),
    CONVERT(nvarchar(5),COUNT(d.Term))+N'天'
    from pEmpOALeave a,pSalaryPerMonth b,eEmployee c,lCalendar d,pVW_pEMPEmolu e
    where b.ID=@ID and a.EID=c.EID and dbo.eFN_getdeptype(c.DepID) in (1,4) and c.Status in (1,2,3) and a.EID=e.EID
    and DATEDIFF(dd,d.term,a.LeaveBeginDate)>=0 and DATEDIFF(DD,a.LeaveEndDate,d.Term)>=0 and ApprDep=N'绩效管理室' and d.xType=1
    and DATEDIFF(MM,a.ApprTime,b.Date)=1 and a.LeaveType=2
    group by a.EID,b.Date,e.SalaryPerMM,e.SponsorAllowance,e.Cyear
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度工资流程状态
    update pSalaryPerMonth
    set Submit=1,SubmitBy=@URID,SubmitTime=GETDATE()
    where ID=@ID
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