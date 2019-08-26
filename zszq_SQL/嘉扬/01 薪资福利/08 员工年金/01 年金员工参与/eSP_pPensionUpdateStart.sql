USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionUpdateStart]
-- skydatarefresh eSP_pPensionUpdateStart
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金参与开启程序
-- @ID 为年金参与对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
    
    -- 年金参与已开启!
    If Exists(Select 1 From pPensionUpdate Where ID=@ID And Isnull(Submit,0)=1)
    Begin
        Set @RetVal = 930073
        Return @RetVal
    End

    -- 年金参与未选择年份!
    ---- 起始年度
    If Exists(Select 1 From pPensionUpdate Where ID=@ID And PensionYearBegin is NULL)
    Begin
        Set @RetVal = 930074
        Return @RetVal
    End
    ---- 结束年度
    If Exists(Select 1 From pPensionUpdate Where ID=@ID And PensionYearEnd is NULL)
    Begin
        Set @RetVal = 930074
        Return @RetVal
    End

    -- 上次年金参与未关闭!
    If Exists(Select 1 From pPensionUpdate Where @ID>1 and ID=@ID-1 And Isnull(Closed,0)=0)
    Begin
        Set @RetVal = 930075
        Return @RetVal
    End


    Begin TRANSACTION


    -- 插入后台员工报名表
    ----在职后台员工报名表pPensionUpdatePerEmp_register
    insert into pPensionUpdatePerEmp_register(pPensionUpdateID,EID)
    select a.ID,b.EID
    from pPensionUpdate a,pVW_Employee b,eStatus c
    where a.ID=@ID and b.Status in (1,2,3) and b.EID=c.EID and b.EID is not NULL 
    and DATEDIFF(yy,c.JoinDate,a.PensionYearEnd)>=0
    and b.EID not in (select EID from pPensionUpdatePerEmp_register where pPensionUpdateID=a.ID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ------ 根据年金分配上年度更新员工报名状态
    update b
    set b.IsPension=1
    from pPensionUpdate a,pPensionUpdatePerEmp_register b
    where a.ID=@ID and a.ID=b.pPensionUpdateID
    AND b.EID in (select EID from pPensionUpdatePerEmp
	where DATEDIFF(yy,PensionYear,(select MAX(PensionYearEnd) from pPensionUpdate where ISNULL(Closed,0)=1))=0
    and EID is not NULL and ISNULL(IsPension,0)=1)
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ------ 总部、子公司员工为参加的，默认递交
    update b
    set b.IsSubmit=1
    from pPensionUpdate a,pPensionUpdatePerEmp_register b,pVW_employee c
    where a.ID=@ID and a.ID=b.pPensionUpdateID and ISNULL(b.IsPension,0)=1
    and b.EID=c.EID and c.DepType in (1,4)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 插入分支机构参与年金pPensionUpdatePerDep
    insert into pPensionUpdatePerDep(pPensionUpdateID,SupDepID,DepID,PensionContact)
    select a.ID,b.SupDepID,b.DepID,b.PensionContact
    from pPensionUpdate a,pVW_DepPensionContact b
    where a.ID=@ID and b.SupDepID is not NULL and b.PensionContact is not NULL
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    

    -- 更新年金月度表项pPensionUpdate
    Update a
    Set a.Submit=1,a.SubmitBy=@URID,a.SubmitTime=GETDATE()
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