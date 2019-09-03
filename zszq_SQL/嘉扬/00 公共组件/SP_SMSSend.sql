USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   Procedure [dbo].[SP_SMSSend](
    @EID int,
    @ID int,
    @RetVal int=0 output 
)
As
Begin

    -- 申明邮件发送内容
    declare @Mobile varchar(30),@SMS nvarchar(200)

    -- 定义短信发送手机号码
    IF @EID is not NULL
    Begin
        select @Mobile=Mobile
        from eDetails
        where EID=@EID
        -- 定义短信发送内容
        select @SMS=a.SMS
        from pSMSInfo a
        where a.ID=@ID

        -- 短信内容发送
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End

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