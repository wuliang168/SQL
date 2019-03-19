USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   Procedure [dbo].[SP_EMAILSend](
    @EID int,
    @ID int,
    @RetVal int=0 output 
)
As
Begin

    -- 申明邮件发送内容
    declare @Email varchar(50),@Subject nvarchar(200),@Message nvarchar(500)

    -- 定义邮件发送邮箱地址
    select @Email=OA_mail
    from eDetails
    where EID=@EID
    -- 定义邮件发送内容
    select @Subject=a.Subject,@Message=a.Message
    from pEMAILInfo a
    where a.ID=@ID

    -- 邮件内容发送
    INSERT INTO skyJobQueueSMTP(MailTo,Subject,Message,Status,starttime,endtime,Times,Timesmax) 
    VALUES(@Email,@Subject,@Message,0,GETDATE(),DATEADD(DD,1,GETDATE()),0,3)


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