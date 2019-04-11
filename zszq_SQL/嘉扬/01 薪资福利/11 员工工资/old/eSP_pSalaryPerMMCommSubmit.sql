USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[eSP_pSalaryPerMMCommSubmit]--eSP_pSalaryPerMMCommSubmit()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 员工通讯费确认
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
-- @leftid，如果是非营业部员工则为SalaryPayID，如果是营业部员工则为DepID
*/
Begin

    -- 员工通讯费的通讯费类型为空！
    If Exists(Select 1 from pEmployeeEmolu a,pEmployeeEmoluAllowanceAT b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and (a.CommAllowance is not NULL and a.CommAllowanceType is NULL))
    Begin
        Set @RetVal = 930131
        Return @RetVal
    End

    Begin TRANSACTION

    -- 拷贝pEmployeeEmolu的通讯费到pEmployeeEmoluAllowanceAT的通讯费
    update b
    set b.CommAllowanceAT=a.CommAllowance
    from pEmployeeEmolu a,pEmployeeEmoluAllowanceAT b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid)
    -- 异常流程
	IF @@Error <> 0
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