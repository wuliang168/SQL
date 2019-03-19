USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_ChangeSalaryPerMMStart]  --eSP_ChangeSalaryPerMMStart 2301,1
-- skydatarefresh eSP_ChangeSalaryPerMMStart
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度薪酬递交登记表的处理程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 数据还未确认!
    If Exists(Select 1 From pSalaryPerMM_register Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 910020
        Return @RetVal
    End
    -- 异常流程
    if @RetVal<>0
    return @RetVal

    Begin TRANSACTION

    -- 更新月度薪酬表项pSalaryPerMM
    Update a
    Set a.SalaryPerMM=b.SalaryPerMMtoModify
    From pEmployeeEmolu a,pSalaryPerMM_register b
    Where a.EID=b.EID and b.ID=@ID

    -- 插入月度薪酬历史表pSalaryPerMM_all
    insert into pSalaryPerMM_all (EID,Badge,Name,CompID,SupDepID,DepID,JobID,SalaryPerMM,SalaryPerMMtoModify,SalaryToModifyReason,Submit,SubmitBy,SubmitTime)
    select a.EID,b.Badge,b.Name,b.CompID,dbo.eFN_getdepid1(b.DepID),b.DepID,b.JobID,a.SalaryPerMM,a.SalaryPerMMtoModify,a.SalaryToModifyReason,a.Submit,a.SubmitBy,a.SubmitTime
    from pSalaryPerMM_register a,eemployee b
    where id=@id and a.EID=b.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除登记表
    delete from pSalaryPerMM_register where id=@id
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