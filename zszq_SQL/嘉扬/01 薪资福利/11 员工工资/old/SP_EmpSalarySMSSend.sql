USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   Procedure [dbo].[SP_EmpSalarySMSSend](
    @ID int,
    @RetVal int=0 output 
)
As
Begin

    -- 申明邮件发送内容
    declare @Mobile varchar(30),@SMS nvarchar(200)

    -- 定义短信发送手机号码
    select @Mobile=b.Mobile
    from pDepSalaryPerMonth a,eDetails b
    where a.ID=@ID and a.SalaryContact=b.EID
    -- 定义短信发送内容
    select @SMS=a.SMS
    from pSalaryInfo a
    where a.ID=1

    -- 短信内容发送
    INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)

    Begin TRANSACTION


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