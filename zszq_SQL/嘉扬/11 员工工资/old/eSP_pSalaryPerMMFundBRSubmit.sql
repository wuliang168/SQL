USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMFundBRSubmit]
-- skydatarefresh eSP_pSalaryPerMMFundBRSubmit
    @URID int,
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 公积金基数及缴费比例确认
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
-- @leftid，如果是非营业部员工则为SalaryPayID，如果是营业部员工则为DepID
*/
Begin

    -- 员工五险一金的公积金基数为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.HousingFundBase is NULL)
    Begin
        Set @RetVal = 930121
        Return @RetVal
    End

    -- 员工五险一金的公积金发放地为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.HousingFundLoc is NULL)
    Begin
        Set @RetVal = 930122
        Return @RetVal
    End

    -- 员工五险一金的公积金缴费比例(个人)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.HousingFundRatioEMP is NULL)
    Begin
        Set @RetVal = 930123
        Return @RetVal
    End

    -- 员工五险一金的公积金缴费比例(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.HousingFundRatioGRP is NULL)
    Begin
        Set @RetVal = 930124
        Return @RetVal
    End


    Begin TRANSACTION


    -- 更新月度工资流程的五险一金表项pEmployeeEmoluFundIns
    update a
    set a.HousingFundEMP=ROUND(b.HousingFundBase*b.HousingFundRatioEMP,2),a.HousingFundGRP=ROUND(b.HousingFundBase*b.HousingFundRatioGRP,2),
    a.FundInsEMPTotal=ROUND(ISNULL(b.HousingFundBase,0)*ISNULL(b.HousingFundRatioEMP,0),2)+ISNULL(a.FundInsEMPTotal,0),
    a.FundInsGRPTotal=ROUND(ISNULL(b.HousingFundBase,0)*ISNULL(b.HousingFundRatioGRP,0),2)+ISNULL(a.FundInsGRPTotal,0)
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