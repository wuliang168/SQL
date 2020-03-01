USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pSDMSuppMedInsBSSubmit]
    @DepID int,
    @RetVal int=0 OutPut
as
/*
-- Create By wuliang E004205
-- 补充医疗保险前台员工递交
*/
Begin

    -- 员工身份证编号为空，无法确认递交！
    IF Exists (select 1 from pSDMSuppMedIns 
    where (case when DEPID=0 OR DepID IS NULL then SupDepID else DEPID end)=@DepID
    and Identification is NULL)
    Begin
        Set @RetVal=1004050
        Return @RetVal
    End

    -- 补充医疗理赔银行卡账号为空，无法确认递交！
    IF Exists (select 1 from pSDMSuppMedIns 
    where (case when DEPID=0 OR DepID IS NULL then SupDepID else DEPID end)=@DepID
    and SuppMedInsDebitCard is NULL)
    Begin
        Set @RetVal=1004010
        Return @RetVal
    End

    -- 子女出生日期为空，无法确认递交！
    IF Exists (select 1 from pSDMSuppMedIns 
    where (case when DEPID=0 OR DepID IS NULL then SupDepID else DEPID end)=@DepID
    and relation=6 and ChildBirth is NULL)
    Begin
        Set @RetVal=1004060
        Return @RetVal
    End

    -- 子女身份证编号为空，无法确认递交！
    IF Exists (select 1 from pSDMSuppMedIns 
    where (case when DEPID=0 OR DepID IS NULL then SupDepID else DEPID end)=@DepID
    and relation=6 and ChildCertID is NULL)
    Begin
        Set @RetVal=1004020
        Return @RetVal
    End

    -- 子女年龄超过18周岁，无法确认递交！
    IF Exists (select 1 from pSDMSuppMedIns 
    where (case when DEPID=0 OR DepID IS NULL then SupDepID else DEPID end)=@DepID
    and relation=6 and DATEDIFF(YY,ChildBirth,GETDATE())>17)
    Begin
        Set @RetVal=1004030
        Return @RetVal
    End


    Begin TRANSACTION

    -------- pEMPSuppMedIns --------
    -- 更新部门ID
    update a
    set a.DepID=NULL
    from pSDMSuppMedIns a
    where a.SupDepID=@DepID and a.DepID=0 
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM
    -- 更新补充医疗保险递交状态
    update a
    set a.IsConfirm=1,a.ConfirmTime=GETDATE(),a.IsChildSuppMedIns=1
    from pSDMSuppMedIns a
    where (case when a.DepID=0 OR a.DepID IS NULL then a.SupDepID else a.DepID end)=@DepID
    -- 异常处理
    IF @@Error <> 0
    Goto ErrM

    -- 备份补充医疗保险递交记录
    insert into pSDMSuppMedIns_all(Name,Gender,Identification,Status,CompID,SupDepID,DepID,JobID,JoinDate,IsSuppMedIns,SuppMedInsDebitCard,
    Relation,ChildName,ChildGender,ChildCertID,IsChildSuppMedIns,IsConfirm,ConfirmTime,Remark)
    select a.Name,a.Gender,a.Identification,a.Status,a.CompID,a.SupDepID,a.DepID,a.JobID,a.JoinDate,a.IsSuppMedIns,a.SuppMedInsDebitCard,
    a.Relation,a.ChildName,a.ChildGender,a.ChildCertID,a.IsChildSuppMedIns,a.IsConfirm,a.ConfirmTime,a.Remark
    from pSDMSuppMedIns a
    where (case when a.DepID=0 OR a.DepID IS NULL then a.SupDepID else a.DepID end)=@DepID

    -- 更新pSalesDepartMarketerEmolu数据表项
    ---- 新增投理顾未出现在pSalesDepartMarketerEmolu
    IF Exists (select 1 from pSDMSuppMedIns 
    where (case when DEPID=0 OR DepID IS NULL then SupDepID else DEPID end)=@DepID
    and Identification not in (select Identification from pSalesDepartMarketerEmolu where Status in (1)))
    Begin
        insert into pSalesDepartMarketerEmolu (Name,Gender,Identification,Status,CompID,SupDepID,DepID,JobID,AdminID,SalaryPayID,JoinDate)
        select a.Name,a.Gender,a.Identification,a.Status,a.CompID,a.SupDepID,(case when a.DepID=0 then NULL else a.DepID end),a.JobID,30,6,a.JoinDate
        from pSDMSuppMedIns a
        where (case when a.DepID=0 OR a.DepID IS NULL then a.SupDepID else a.DepID end)=@DepID
        and a.Identification not in (select Identification from pSalesDepartMarketerEmolu where Status in (1))
    End


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