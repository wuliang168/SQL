USE [zszq]
GO
/****** Object:  StoredProcedure [dbo].[SP_EmpEmoluMailSend] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   Procedure [dbo].[SP_EmpEmoluMailSend](
    @ID int,
    @RetVal int=0 output 
)
As
Begin

    -- 申明邮件发送内容
    declare @EID int,
    @Name nvarchar(50),
    @Date smalldatetime,
    @SalaryPerMM decimal(10, 2),
    @AllowanceBackPayTotal decimal(10, 2),
    @FestivalFeeTotal decimal(10, 2),
    @GeneralBonus decimal(10, 2),
    @DeductionBTTotal decimal(10, 2),
    @TotalPayAmount decimal(10, 2),
    @OneTimeAnnualBonus decimal(10, 2),
    @HousingFundEMP decimal(10, 2),
    @EndowInsEMP decimal(10, 2),
    @MedicalInsEMP decimal(10, 2),
    @UnemployInsEMP decimal(10, 2),
    @FundInsEMPPlusTotal decimal(10, 2),
    @PersonalIncomeTax decimal(10, 2),
    @OneTimeAnnualBonusTax decimal(10, 2),
    @CommAllowanceAT decimal(10, 2),
    @DeductionATTotal decimal(10, 2),
    @PensionEMP decimal(10, 2),
    @FinalPayingAmount decimal(10, 2),
    @MailAddr varchar(50)

    -- 定义邮件发送内容项
    select @EID=EID,@Date=Date,@SalaryPerMM=SalaryPerMM,@AllowanceBackPayTotal=AllowanceBackPayTotal,@FestivalFeeTotal=FestivalFeeTotal,@GeneralBonus=GeneralBonus,
    @DeductionBTTotal=DeductionBTTotal,@TotalPayAmount=TotalPayAmount,@OneTimeAnnualBonus=OneTimeAnnualBonus,@HousingFundEMP=HousingFundEMP,
    @EndowInsEMP=EndowInsEMP,@MedicalInsEMP=MedicalInsEMP,@UnemployInsEMP=UnemployInsEMP,@FundInsEMPPlusTotal=FundInsEMPPlusTotal,
    @PersonalIncomeTax=PersonalIncomeTax,@OneTimeAnnualBonusTax=OneTimeAnnualBonusTax,@CommAllowanceAT=CommAllowanceAT,
    @DeductionATTotal=DeductionATTotal,@PensionEMP=PensionEMP,@FinalPayingAmount=FinalPayingAmount
    from pEmployeeEmolu_all
    where id=@ID

    -- 定义邮件地址
    select @MailAddr=OA_mail
    from eDetails
    where EID=@EID

    -- 定义姓名
    select @Name=Name
    from eEmployee
    where EID=@EID


    Begin TRANSACTION
    
    -- 工资单内容发送
    -- 向主任务表 skyJobQueueSMTP 插入内容
    insert Into skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax)   
    values(@MailAddr,CONVERT(varchar(4),YEAR(@Date))+N'年'+CONVERT(varchar(2),MONTH(@Date))+N'月'+N'工资单',
    -- 邮件正文标题内容
    '<p>'+@Name+N'您好！'+'<br>'+N'本月工资单如下：'+'<br></p>'
    -- 邮件正文工资单内容
    --- 表格开始
    +'<DIV><TABLE cellSpacing="1" cellpadding="4" border="1">'
    --- 表格行开始
    +'<TR>'
    ---- 固定工资
    +'<TD>'+N'固定工资'+'</FONT></TD>'
    ---- 补贴&补发
    +'<TD>'+N'补贴&补发'+'</FONT></TD>'
    ---- 过节费
    +'<TD>'+N'过节费'+'</FONT></TD>'
    ---- 奖金
    +'<TD>'+N'奖金'+'</FONT></TD>'
    ---- 考核扣款
    +'<TD>'+N'考核扣款'+'</FONT></TD>'
    ---- 应发工资
    +'<TD><STRONG>'+N'应发工资'+'</STRONG></TD>'
    ---- 一次性奖金
    +'<TD><B>'+N'一次性奖金'+'</FONT></B></TD>'
    --- 表格行结束
    +'</TR>'
    --- 表格行开始
    +'<TR>'
    ---- 固定工资数值
    +'<TD>'+convert(varchar(12),@SalaryPerMM)+'</FONT></TD>'
    ---- 补贴&补发数值
    +'<TD>'+convert(varchar(12),@AllowanceBackPayTotal)+'</FONT></TD>'
    ---- 过节费数值
    +'<TD>'+convert(varchar(12),@FestivalFeeTotal)+'</FONT></TD>'
    ---- 奖金数值
    +'<TD>'+convert(varchar(12),@GeneralBonus)+'</FONT></TD>'
    ---- 考核扣款数值
    +'<TD>'+convert(varchar(12),@DeductionBTTotal)+'</FONT></TD>'
    ---- 应发工资数值
    +'<TD><B><STRONG><FONT>'+convert(varchar(12),@TotalPayAmount)+'</FONT></STRONG></B></FONT></TD>'
    ---- 一次性奖金数值
    +'<TD><B><FONT>'+convert(varchar(12),@OneTimeAnnualBonus)+'</FONT></B></FONT></TD>'
    --- 表格行结束
    +'</TR>'
    --- 表格结束
    +'</TABLE></DIV><br>'
    --- 表格开始
    +'<DIV><TABLE cellSpacing="1" cellpadding="4" border="1">'
    --- 表格行开始
    +'<TR>'
    ---- 公积金
    +'<TD>'+N'公积金'+'</FONT></TD>'
    ---- 养老金
    +'<TD>'+N'养老金'+'</FONT></TD>'
    ---- 医疗
    +'<TD>'+N'医疗'+'</FONT></TD>'
    ---- 失业
    +'<TD>'+N'失业'+'</FONT></TD>'
    ---- 社保公积金补交
    +'<TD>'+N'社保公积金补交'+'</FONT></TD>'
    ---- 个税（普通）
    +'<TD>'+N'个税（普通）'+'</FONT></TD>'
    ---- 一次性奖金税
    +'<TD>'+N'一次性奖金税'+'</FONT></TD>'
    ---- 通讯费
    +'<TD>'+N'通讯费'+'</FONT></TD>'
    ---- 税后扣款
    +'<TD>'+N'税后扣款'+'</FONT></TD>'
    ---- 年金个人缴费
    +'<TD><FONT><STRONG>'+N'年金个人缴费'+'</FONT></STRONG></FONT></TD>'
    ---- 实发工资
    +'<TD><STRONG>'+N'实发工资'+'</STRONG></TD>'
    --- 表格行结束
    +'</TR>'
    --- 表格行开始
    +'<TR>'
    ---- 公积金数值
    +'<TD>'+convert(varchar(12),@HousingFundEMP)+'</FONT></TD>'
    ---- 养老金数值
    +'<TD>'+convert(varchar(12),@EndowInsEMP)+'</FONT></TD>'
    ---- 医疗数值
    +'<TD>'+convert(varchar(12),@MedicalInsEMP)+'</FONT></TD>'
    ---- 失业数值
    +'<TD>'+convert(varchar(12),@UnemployInsEMP)+'</FONT></TD>'
    ---- 社保公积金补交数值
    +'<TD>'+convert(varchar(12),@FundInsEMPPlusTotal)+'</FONT></TD>'
    ---- 个税（普通）数值
    +'<TD>'+convert(varchar(12),@PersonalIncomeTax)+'</FONT></TD>'
    ---- 一次性奖金税数值
    +'<TD>'+convert(varchar(12),@OneTimeAnnualBonusTax)+'</FONT></TD>'
    ---- 通讯费数值
    +'<TD>'+convert(varchar(12),@CommAllowanceAT)+'</FONT></TD>'
    ---- 税后扣款数值
    +'<TD>'+convert(varchar(12),@DeductionATTotal)+'</FONT></TD>'
    ---- 年金个人缴费数值
    +'<TD><FONT><STRONG>'+convert(varchar(12),@PensionEMP)+'</FONT></STRONG></FONT></TD>'
    ---- 实发工资数值
    +'<TD><STRONG>'+convert(varchar(12),@FinalPayingAmount)+'</FONT></STRONG></TD>'
    --- 表格行结束
    +'</TR>'
    --- 表格结束
    +'</TABLE></DIV><BR><BR>'
    --- 第二行内容
    -- 邮件正文人力资源页脚
    +'<HR style="HEIGHT: 2px; WIDTH: 122px" align="left" SIZE="2"><FONT color="#c0c0c0" size="2" face="Verdana">'+N'浙商证券人力资源部'+'</FONT>'
    ,0,GETDATE(),DATEADD(DD,1,GETDATE()),0,1)
    -- 异常处理 
    IF @@Error <> 0
    Goto ErrM


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

End
