USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMInsSubmit]
-- skydatarefresh eSP_pSalaryPerMMInsSubmit
    @URID int,
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 社保缴费金额确认
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
-- @leftid，如果是非营业部员工则为SalaryPayID，如果是营业部员工则为DepID
*/
Begin


    -- 员工五险一金的社保发放地为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.InsuranceLoc is NULL)
    Begin
        Set @RetVal = 930112
        Return @RetVal
    End

    -- 员工五险一金的养老保险缴费金额(个人)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.EndowInsEMP is NULL)
    Begin
        Set @RetVal = 930132
        Return @RetVal
    End

    -- 员工五险一金的养老保险缴费金额(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.EndowInsGRP is NULL)
    Begin
        Set @RetVal = 930133
        Return @RetVal
    End

    -- 员工五险一金的医疗保险缴费金额(个人)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.MedicalInsEMP is NULL)
    Begin
        Set @RetVal = 930134
        Return @RetVal
    End

    -- 员工五险一金的医疗保险缴费金额(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.MedicalInsGRP is NULL)
    Begin
        Set @RetVal = 930135
        Return @RetVal
    End

    -- 员工五险一金的失业保险缴费金额(个人)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.UnemployInsEMP is NULL)
    Begin
        Set @RetVal = 930136
        Return @RetVal
    End

    -- 员工五险一金的失业保险缴费金额(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.UnemployInsGRP is NULL)
    Begin
        Set @RetVal = 930137
        Return @RetVal
    End

    -- 员工五险一金的生育保险缴费金额(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.MaternityInsGRP is NULL)
    Begin
        Set @RetVal = 930138
        Return @RetVal
    End

    -- 员工五险一金的工伤保险缴费金额(公司)为空！
    If Exists(Select 1 From pEmployeeEmolu a,pEmployeeEmoluFundIns b,pDepSalaryPerMonth c
    where a.EID=b.EID and DATEDIFF(mm,b.Date,c.Date)=0 and c.SalaryContact=(select EID from SkySecUser where ID=@URID)
    and ISNULL(c.IsSubmit,0)=0 and ((c.DepID is NULL and a.SalaryPayID=c.SalaryPayID and c.SalaryPayID=@leftid) or c.DepID=@leftid) 
    and a.InjuryInsGRP is NULL)
    Begin
        Set @RetVal = 930139
        Return @RetVal
    End


    Begin TRANSACTION


    -- 更新月度工资流程的五险一金表项pEmployeeEmoluFundIns
    update a
    set a.EndowInsEMP=ISNULL(b.EndowInsEMP,a.EndowInsEMP),a.EndowInsGRP=ISNULL(b.EndowInsGRP,a.EndowInsGRP),
    a.MedicalInsEMP=ISNULL(b.MedicalInsEMP,a.MedicalInsEMP),a.MedicalInsGRP=ISNULL(b.MedicalInsGRP,a.MedicalInsGRP),
    a.UnemployInsEMP=ISNULL(b.UnemployInsEMP,a.UnemployInsEMP),a.UnemployInsGRP=ISNULL(b.UnemployInsGRP,a.UnemployInsGRP),
    a.MaternityInsGRP=ISNULL(b.MaternityInsGRP,a.MaternityInsGRP),a.InjuryInsGRP=ISNULL(b.InjuryInsGRP,a.InjuryInsGRP),
    a.FundInsEMPTotal=ISNULL(ISNULL(b.EndowInsEMP,a.EndowInsEMP),0)+ISNULL(ISNULL(b.MedicalInsEMP,a.MedicalInsEMP),0)
    +ISNULL(ISNULL(b.UnemployInsEMP,a.UnemployInsEMP),0)+ISNULL(a.FundInsEMPTotal,0),
    a.FundInsGRPTotal=ISNULL(ISNULL(b.EndowInsGRP,a.EndowInsGRP),0)+ISNULL(ISNULL(b.MedicalInsGRP,a.MedicalInsGRP),0)
    +ISNULL(ISNULL(b.UnemployInsGRP,a.UnemployInsGRP),0)+ISNULL(ISNULL(b.MaternityInsGRP,a.MaternityInsGRP),0)
    +ISNULL(ISNULL(b.InjuryInsGRP,a.InjuryInsGRP),0)+ISNULL(a.FundInsGRPTotal,0)
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