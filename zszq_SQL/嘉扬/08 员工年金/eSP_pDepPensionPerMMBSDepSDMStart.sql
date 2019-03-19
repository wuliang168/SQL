USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionPerMMBSDepSDMStart]
-- skydatarefresh eSP_pDepPensionPerMMBSDepSDMStart
    @leftid int,
    @EID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配月度开启程序
-- @leftid 为年金计划月度分配对应ID
-- @EID 为前台操作账号的EID，前台通过{U_EID}全局参数获取
*/
Begin

    declare @PensionMonth smalldatetime
    select @PensionMonth=a.PensionMonth from PDEPPENSIONPERMM a where ISNULL(a.DepID,a.SupDepID)=@leftid and ISNULL(IsSubmit,0)=0


    -- 企业年金分配额为空！
    ---- 投理顾员工(退休)
    --If Exists(Select 1 From pSDMarketerPensionPerMM_register
    --Where PensionContact=@EID AND ISNULL(GrpPensionPerMM,0)=0 AND ISNULL(DepID,SupDepID)=@leftid AND Status=5 AND ISNULL(GrpPensionPerMM,0)=0)
    --Begin
        --Set @RetVal = 930082
        --Return @RetVal
    --End

    -- 个人年金分配额为超过个人年金分配剩余！
    ---- 投理顾员工
    If Exists(Select 1 From pSDMarketerPensionPerMM_register
    Where PensionContact=@EID AND ISNULL(EmpPensionMonthRest,0)<0 AND ISNULL(DepID,SupDepID)=@leftid)
    Begin
        Set @RetVal = 930085
        Return @RetVal
    End

    -- 企业缴费超过企业分配剩余！
    ---- 投理顾员工(退休)
    If Exists(Select 1 From pSDMarketerPensionPerMM_register
    Where PensionContact=@EID AND ISNULL(GrpPensionMonthRest,0)<0 AND ISNULL(DepID,SupDepID)=@leftid AND Status=5)
    Begin
        Set @RetVal = 930083
        Return @RetVal
    End
    

    Begin TRANSACTION


    -- 更新月度年金部门的投理顾递交状态pDepPensionPerMM
    update a
    set a.IsSDMSubmit=1
    from pDepPensionPerMM a
    where ISNULL(a.DepID,a.SupDepID)=@leftid AND a.PensionMonth=@PensionMonth
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 更新月度年金部门的递交状态pDepPensionPerMM
    IF EXISTS(select 1 from pDepPensionPerMM where ISNULL(DepID,SupDepID)=@leftid AND ISNULL(IsEmpSubmit,0)=1 AND PensionMonth=@PensionMonth)
    Begin
        update a
        set a.IsSubmit=1
        from pDepPensionPerMM a
        where ISNULL(a.DepID,a.SupDepID)=@leftid AND a.PensionMonth=@PensionMonth
        -- 异常流程
        If @@Error<>0
        Goto ErrM 
    End

    -- 更新月度年金员工的递交状态
    ---- 投理顾员工
    update b
    set b.Submit=1,b.SubmitBy=(select id from skysecuser where eid=@EID),b.Submittime=getdate()
    from pSalesDepartMarketerEmolu a,pSDMarketerPensionPerMM_register b
    where a.Identification=b.Identification AND b.PensionContact=@EID AND ISNULL(a.DepID,a.SupDepID)=@leftid
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