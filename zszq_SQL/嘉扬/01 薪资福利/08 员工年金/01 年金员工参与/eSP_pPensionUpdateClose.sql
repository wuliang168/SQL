USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionUpdateClose]
-- skydatarefresh eSP_pPensionUpdateClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金参与关闭程序
-- @ID 为年金参与对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 年金参与未开启!
    If Exists(Select 1 From pPensionUpdate Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930076
        Return @RetVal
    End

    -- 年金参与已关闭!
    If Exists(Select 1 From pPensionUpdate Where ID=@ID And Isnull(Closed,0)=1)
    Begin
        Set @RetVal = 930077
        Return @RetVal
    End


    Begin TRANSACTION

    -- 设置年金参与数据
    ---- 更新参与人员状态
    ------ 后台员工
    update a
    set a.IsClosed=1
    from pPensionUpdatePerEmp_register a,pPensionUpdate b
    where b.ID=@ID and a.pPensionUpdateID=b.ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ------ 分支机构
    update a
    set a.IsClosed=1
    from pPensionUpdatePerDep a,pPensionUpdate b
    where b.ID=@ID and a.pPensionUpdateID=b.ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入后台员工参与年金pPensionUpdatePerEmp
    ---- 在职
    ------ MD和AdminID为去年年度的
    insert into pPensionUpdatePerEmp(PensionYear,EID,AdminIDYY,MDIDYY,JoinDate,LeaDate,Status,IsPension)
    select CONVERT(smalldatetime,CONVERT(char(4), d.PerYY) + '-01-01'),a.EID,b.LastYearAdminID,b.LastYearMDID,a.JoinDate,a.LeaDate,1,1
    from pPensionUpdatePerEmp_register a,pEMPAdminIDMD b,pPensionUpdate c,(select distinct YEAR(Term) as PerYY from Lleave_Periods where YEAR(Term)<=YEAR(GETDATE())) as d 
    where c.ID=@ID and a.Status in (1,2,3) and a.EID is not NULL and a.EID=b.EID 
    and d.PerYY>=YEAR(c.PensionYearBegin) and d.PerYY<=YEAR(c.PensionYearEnd) and YEAR(a.JoinDate)<=d.PerYY
    and a.pPensionUpdateID=@ID and a.EID is not NULL and ISNULL(a.IsPension,0)=1
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 退休
    insert into pPensionUpdatePerEmp(PensionYear,EID,AdminIDYY,MDIDYY,JoinDate,LeaDate,Status,IsPension)
    select CONVERT(smalldatetime,CONVERT(char(4), d.PerYY) + '-01-01'),a.EID,b.LastYearAdminID,b.LastYearMDID,a.JoinDate,a.LeaDate,5,1
	from pPensionUpdatePerEmp_register a,pEMPAdminIDMD b,pPensionUpdate c,
    (select distinct YEAR(Term) as PerYY from Lleave_Periods where YEAR(Term)<=YEAR(GETDATE())) as d 
	where a.EID=b.EID and a.Status=5 and c.ID=@ID and DATEDIFF(YY,a.LeaDate,c.PensionYearBegin)<=0 
    and YEAR(a.LeaDate)>=d.PerYY and d.PerYY>=YEAR(c.PensionYearBegin) and d.PerYY<=YEAR(c.PensionYearEnd)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 前台员工
    -- 新增前台员工
    ---- 在职
    insert into pPensionUpdatePerEmp(PensionYear,BID,AdminIDYY,MDIDYY,JoinDate,LeaDate,Status,IsPension)
    select CONVERT(smalldatetime,CONVERT(char(4), d.PerYY) + '-01-01'),a.BID,30,NULL,a.JoinDate,a.LeaDate,a.Status,1
    from pPensionUpdatePerEmp_register a,pPensionUpdate c,(select distinct YEAR(Term) as PerYY from Lleave_Periods where YEAR(Term)<=YEAR(GETDATE())) as d
    where c.ID=@ID and a.BID is not NULL and d.PerYY>=YEAR(c.PensionYearBegin) and d.PerYY<=YEAR(c.PensionYearEnd) and YEAR(a.JoinDate)<=d.PerYY
    and a.pPensionUpdateID=@ID and a.BID is not NULL and ISNULL(a.IsPension,0)=1
    and a.Status=1
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 退休
    insert into pPensionUpdatePerEmp(PensionYear,BID,AdminIDYY,MDIDYY,JoinDate,LeaDate,Status,IsPension)
    select CONVERT(smalldatetime,CONVERT(char(4), d.PerYY) + '-01-01'),a.BID,30,NULL,a.JoinDate,a.LeaDate,5,1
    from pPensionUpdatePerEmp_register a,pPensionUpdate c,(select distinct YEAR(Term) as PerYY from Lleave_Periods where YEAR(Term)<=YEAR(GETDATE())) as d
    where c.ID=@ID and a.BID is not NULL and d.PerYY>=YEAR(c.PensionYearBegin) and d.PerYY<=YEAR(c.PensionYearEnd) and YEAR(a.LeaDate)>=d.PerYY
    and a.pPensionUpdateID=@ID and a.BID is not NULL and ISNULL(a.IsPension,0)=1
    and a.LeaDate is not NULL and a.Status=4
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    ---- 企业年金参与人员总人数
    update a
    set a.PensionTotalNum=(select COUNT(IsPension) from pPensionUpdatePerEmp_register where pPensionUpdateID=a.ID)
    from pPensionUpdate a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新年金月度表项pPensionUpdate
    Update a
    Set a.Closed=1,ClosedBy=@URID,ClosedTime=GETDATE()
    From pPensionUpdate a
    Where a.ID=@ID
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