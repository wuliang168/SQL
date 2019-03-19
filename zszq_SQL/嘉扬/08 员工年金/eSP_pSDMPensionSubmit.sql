USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSDMPensionSubmit]
-- skydatarefresh eSP_pSDMPensionSubmit
    @leftid int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金员工投理顾分配确认程序
-- @leftid 为年金联系人对应DepID
*/
Begin

    -- 新增投理顾员工姓名为空！
    if exists (select 1 from pSalesDepartMarketerEmolu where (case when DEPID=0 OR DepID IS NULL then SupDepID else DepID end)=@leftid and Name is NULL)
    Begin
        Set @RetVal=930086
        Return @RetVal
    End

    -- 新增投理顾员工性别为空！
    if exists (select 1 from pSalesDepartMarketerEmolu where (case when DEPID=0 OR DepID IS NULL then SupDepID else DepID end)=@leftid and Gender is NULL)
    Begin
        Set @RetVal=930087
        Return @RetVal
    End

    -- 新增投理顾员工身份证号码为空！
    if exists (select 1 from pSalesDepartMarketerEmolu where (case when DEPID=0 OR DepID IS NULL then SupDepID else DepID end)=@leftid and Identification is NULL)
    Begin
        Set @RetVal=930088
        Return @RetVal
    End

    -- 新增投理顾员工身份证号码非15或18位！
    if exists (select 1 from pSalesDepartMarketerEmolu where (case when DEPID=0 OR DepID IS NULL then SupDepID else DepID end)=@leftid and len(Identification) not in (15,18))
    Begin
        Set @RetVal=930089
        Return @RetVal
    End

    -- 新增投理顾员工入职时间为空！
    if exists (select 1 from pSalesDepartMarketerEmolu where (case when DEPID=0 OR DepID IS NULL then SupDepID else DepID end)=@leftid and JoinDate is NULL)
    Begin
        Set @RetVal=930090
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新员工年金部门DepID
    ---- 前台员工
    Update a
    Set a.DepID=NULL
    From pSalesDepartMarketerEmolu a
    Where a.DepID=0 and (case when DEPID=0 OR DepID IS NULL then SupDepID else DepID end)=@leftid
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新员工年金确认状态
    ---- 前台员工
    Update a
    Set a.IsSDMSubmit=1
    From pPensionUpdatePerDep a
    Where ISNULL(a.DepID,a.SupDepID)=@leftid
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 营业部递交状态
    IF EXISTS(select 1 from pPensionUpdatePerDEP where ISNULL(DepID,SupDepID)=@leftid and ISNULL(IsEmpSubmit,0)=1)
    Begin
        update a
        set a.IsSubmit=1
        from pPensionUpdatePerDEP a
        where ISNULL(a.DepID,a.SupDepID)=@leftid
        -- 异常流程
        If @@Error<>0
        Goto ErrM 
    End

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