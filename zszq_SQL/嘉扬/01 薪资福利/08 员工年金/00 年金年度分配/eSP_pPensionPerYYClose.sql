USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionPerYYClose]
-- skydatarefresh eSP_pPensionPerYYClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配年度关闭程序
-- @ID 为年金计划分配年度对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 申明
    declare @PensionYear smalldatetime
    select @PensionYear=PensionYear from pPensionPerYY where ID=@ID

    -- 年度年金计划分配未开启!
    If Exists(Select 1 From pPensionPerYY Where ID=@ID and ISNULL(Submit,0)=0)
    Begin
        Set @RetVal = 930064
        Return @RetVal
    End
    
    -- 年度年金计划分配已关闭!
    If Exists(Select 1 From pPensionPerYY Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930063
        Return @RetVal
    End
    

    Begin TRANSACTION

    -- 插入员工年金年度分配详细数据表项
    ---- 后台员工年金年度分配详细数据表项
    insert into pEMPPensionPerYY(PensionYear,EID,BID,Badge,Name,CertNo,IsPension,JoinDate,LeaDate,Status,
    PostModulusPerYY,PostMonthPerYY,PostModulusPerMM,GrpPensionPerYY,EmpPensionPerYY,JobXorder)
    select PensionYear,EID,BID,Badge,Name,CertNo,IsPension,JoinDate,LeaDate,Status,
    PostModulusPerYY,PostMonthPerYY,PostModulusPerMM,GrpPensionPerYY,EmpPensionPerYY,JobXorder
    from pVW_pEMPPensionPerYY
    where Year(PensionYear)=(select Year(PensionYear) from pPensionPerYY where ID=@ID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    
    ---- 更新实际分配总额
    Update a
    Set a.PensionYearCalcTotal=(select SUM(GrpPensionPerYY) from pEMPPensionPerYY where Year(PensionYear)=YEAR(a.PensionYear))
    From pPensionPerYY a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 更新分配差值
    Update a
    Set a.PensionYearDiff=a.PensionYearCalcTotal-a.PensionYearTotal
    From pPensionPerYY a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新年度年金计划分配表项pPensionPerYY
    Update a
    Set a.Closed=1,a.ClosedBy=@URID,a.ClosedTime=GETDATE()
    From pPensionPerYY a
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