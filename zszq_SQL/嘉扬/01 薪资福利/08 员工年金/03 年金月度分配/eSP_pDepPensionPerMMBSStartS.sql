USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pDepPensionPerMMBSStartS]
-- skydatarefresh eSP_pDepPensionPerMMBSStartS
    @leftid varchar(20),
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金计划分配月度开启程序
-- @leftid 为年金计划分配月度对应ID
-- @EID 为前台操作账号的EID，前台通过 {U_EID} 全局参数获取
*/
Begin

    declare @DepID int,@pProcessID int
    set @DepID=convert(int,SUBSTRING(@leftid,0,CHARINDEX('-',@leftid)))
    set @pProcessID=convert(int,REVERSE(SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid)))))


    -- 个人年金分配额超过个人年金分配剩余！
    ---- 营业部发薪员工
    If Exists(Select 1 From pEmpPensionPerMM_register a
    Where a.PensionContact=@EID AND a.pProcessID=@pProcessID And ISNULL(a.EmpPensionMonthRest,0)<0
    and (a.SalaryPayID=6 or a.BID is not NULL) and a.DepID=@DepID)
    Begin
        Set @RetVal = 930085
        Return @RetVal
    End


    Begin TRANSACTION

    
    -- 年金联系人添加年金分配员工金额
    update a
    set a.IsSubmit=1
    from pDepPensionPerMM a
    where (a.SalaryPayID=6 and ISNULL(a.DepID,a.SupDepID)=@DepID)
    AND ISNULL(a.IsSubmit,0)=0 AND ISNULL(a.IsClosed,0)=0 AND a.pProcessID=@pProcessID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新年度中途退出人员
    ---- pPensionUpdatePerEmp_register
    update a
    set a.IsWayside=1
    from pPensionUpdatePerEmpTrack a,pEmpPensionPerMM_register b
    where b.PensionContact=@EID and ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID) and ISNULL(b.IsWayside,0)=1 
    AND b.pProcessID=@pProcessID and a.pPensionUpdateID=(select pPensionUpdateID from pPensionPerMM where ID=@pProcessID)
    and (b.SalaryPayID=6 or b.BID is not NULL) and b.DepID=@DepID
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