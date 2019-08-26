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
    -- 插入后台员工参与年金pPensionUpdatePerEmp
    ---- 在职
    ------ MD和AdminID为去年年度的
    insert into pPensionUpdatePerEmp(PensionYear,EID,AdminIDYY,MDIDYY,JoinDate,LeaDate,Status,IsPension)
    select a.PensionYear,b.EID,d.LastYearAdminID,d.LastYearMDID,b.JoinDate,b.LeaDate,1,1
    from pPensionPerYY a,pVW_Employee b,pEMPAdminIDMD d
    where a.ID=@ID and b.Status in (1,2,3) and b.EID is not NULL 
    and DATEDIFF(yy,b.JoinDate,a.PensionYear)>=0
    and b.EID in (select EID from pPensionUpdatePerEmp_register 
    where pPensionUpdateID=(select ID from pPensionUpdate where 
    DATEDIFF(YY,a.PensionYear,PensionYearBegin)<=0 and DATEDIFF(YY,a.PensionYear,PensionYearEnd)>=0 and ISNULL(IsClosed,0)=1) 
    and EID is not NULL and ISNULL(IsPension,0)=1)
    and b.EID=d.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 退休
    insert into pPensionUpdatePerEmp(PensionYear,EID,AdminIDYY,MDIDYY,JoinDate,LeaDate,Status,IsPension)
    select a.PensionYear,b.EID,d.LastYearAdminID,d.LastYearMDID,b.JoinDate,b.LeaDate,5,1
    from pPensionPerYY a,pVW_Employee b,pEMPAdminIDMD d
    where a.ID=@ID and b.Status=5 and DateDiff(yy,b.LeaDate,a.PensionYear)<=0
    and b.EID=d.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 前台员工
    -- 新增前台员工
    insert into pPensionUpdatePerEmp(PensionYear,BID,AdminIDYY,MDIDYY,JoinDate,LeaDate,Status,IsPension)
    select a.PensionYear,b.BID,30,NULL,b.JoinDate,b.LeaDate,b.Status,1
    from pPensionPerYY a,pVW_Employee b
    where a.ID=@ID and b.Status in (1,2,3) and b.BID is not NULL
    and DATEDIFF(yy,b.JoinDate,a.PensionYear)>=0
    and b.BID in (select BID from pPensionUpdatePerEmp_register 
    where pPensionUpdateID=(select ID from pPensionUpdate where 
    DATEDIFF(YY,a.PensionYear,PensionYearBegin)<=0 and DATEDIFF(YY,a.PensionYear,PensionYearEnd)>=0 and ISNULL(IsClosed,0)=1) 
    and BID is not NULL and ISNULL(IsPension,0)=1)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


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