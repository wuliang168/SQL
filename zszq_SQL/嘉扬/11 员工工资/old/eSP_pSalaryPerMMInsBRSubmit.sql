USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMInsBRSubmit]
-- skydatarefresh eSP_pSalaryPerMMInsBRSubmit
    @URID int,
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 社保基数及缴费比例确认
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
-- @leftid，如果是非营业部员工则为SalaryPayID，如果是营业部员工则为DepID
*/
Begin

    -- 员工五险一金的社保基数为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.InsuranceBase is NULL)
    Begin
        Set @RetVal = 930111
        Return @RetVal
    End

    -- 员工五险一金的社保发放地为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.InsuranceLoc is NULL)
    Begin
        Set @RetVal = 930112
        Return @RetVal
    End

    -- 员工五险一金的养老保险缴费比例(个人)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.EndowInsRatioEMP is NULL)
    Begin
        Set @RetVal = 930113
        Return @RetVal
    End

    -- 员工五险一金的养老保险缴费比例(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.EndowInsRatioGRP is NULL)
    Begin
        Set @RetVal = 930114
        Return @RetVal
    End

    -- 员工五险一金的医疗保险缴费比例(个人)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.MedicalInsRatioEMP is NULL)
    Begin
        Set @RetVal = 930115
        Return @RetVal
    End

    -- 员工五险一金的医疗保险缴费比例(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.MedicalInsRatioGRP is NULL)
    Begin
        Set @RetVal = 930116
        Return @RetVal
    End

    -- 员工五险一金的失业保险缴费比例(个人)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.UnemployInsRatioEMP is NULL)
    Begin
        Set @RetVal = 930117
        Return @RetVal
    End

    -- 员工五险一金的失业保险缴费比例(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.UnemployInsRatioGRP is NULL)
    Begin
        Set @RetVal = 930118
        Return @RetVal
    End

    -- 员工五险一金的生育保险缴费比例(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.MaternityInsRatioGRP is NULL)
    Begin
        Set @RetVal = 930119
        Return @RetVal
    End

    -- 员工五险一金的工伤保险缴费比例(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.InjuryInsRatioGRP is NULL)
    Begin
        Set @RetVal = 930120
        Return @RetVal
    End


    Begin TRANSACTION


    -- 更新月度工资流程的五险一金表项pEmployeeEmoluFundIns
    update a
    set a.EndowInsEMP=ROUND(b.InsuranceBase*b.EndowInsRatioEMP,2),a.EndowInsGRP=ROUND(b.InsuranceBase*b.EndowInsRatioGRP,2),
    a.MedicalInsEMP=ROUND(b.InsuranceBase*b.MedicalInsRatioEMP,2),a.MedicalInsGRP=ROUND(b.InsuranceBase*b.MedicalInsRatioGRP,2),
    a.UnemployInsEMP=ROUND(b.InsuranceBase*b.UnemployInsRatioEMP,2),a.UnemployInsGRP=ROUND(b.InsuranceBase*b.UnemployInsRatioGRP,2),
    a.MaternityInsGRP=ROUND(b.InsuranceBase*b.MaternityInsRatioGRP,2),a.InjuryInsGRP=ROUND(b.InsuranceBase*b.InjuryInsRatioGRP,2),
    a.FundInsEMPTotal=ROUND(ISNULL(b.InsuranceBase,0)*ISNULL(b.EndowInsRatioEMP,0),2)+ROUND(ISNULL(b.InsuranceBase,0)*ISNULL(b.MedicalInsRatioEMP,0),2)
    +ROUND(ISNULL(b.InsuranceBase,0)*ISNULL(b.UnemployInsRatioEMP,0),2)+ISNULL(a.FundInsEMPTotal,0),
    a.FundInsGRPTotal=ROUND(ISNULL(b.InsuranceBase,0)*ISNULL(b.EndowInsRatioGRP,0),2)+ROUND(ISNULL(b.InsuranceBase,0)*ISNULL(b.MedicalInsRatioGRP,0),2)
    +ROUND(ISNULL(b.InsuranceBase,0)*ISNULL(b.UnemployInsRatioGRP,0),2)+ROUND(ISNULL(b.InsuranceBase,0)*ISNULL(b.MaternityInsRatioGRP,0),2)
    +ROUND(ISNULL(b.InsuranceBase,0)*ISNULL(b.InjuryInsRatioGRP,0),2)+ISNULL(a.FundInsGRPTotal,0)
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