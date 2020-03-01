USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMFundSubmit]
-- skydatarefresh eSP_pSalaryPerMMFundSubmit
    @URID int,
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 公积金缴费金额确认
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
-- @leftid，如果是非营业部员工则为SalaryPayID，如果是营业部员工则为DepID
*/
Begin


    -- 员工五险一金的公积金发放地为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.HousingFundLoc is NULL)
    Begin
        Set @RetVal = 930122
        Return @RetVal
    End

    -- 员工五险一金的公积金缴费金额(个人)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.HousingFundEMP is NULL)
    Begin
        Set @RetVal = 930125
        Return @RetVal
    End

    -- 员工五险一金的公积金缴费金额(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.HousingFundGRP is NULL)
    Begin
        Set @RetVal = 930126
        Return @RetVal
    End


    Begin TRANSACTION


    -- 更新月度工资流程的五险一金表项pEmployeeEmoluFundIns
    update a
    set a.HousingFundEMP=ISNULL(b.HousingFundEMP,a.HousingFundEMP),a.HousingFundGRP=ISNULL(b.HousingFundGRP,a.HousingFundGRP),
    a.FundInsEMPTotal=ISNULL(ISNULL(b.HousingFundEMP,a.HousingFundEMP),0)+ISNULL(a.FundInsEMPTotal,0),
    a.FundInsGRPTotal=ISNULL(ISNULL(b.HousingFundGRP,a.HousingFundGRP),0)+ISNULL(a.FundInsGRPTotal,0)
    from pEmployeeEmoluFundIns a,pEmployeeEmolu b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,a.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and b.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
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