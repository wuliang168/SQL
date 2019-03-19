USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   Procedure [dbo].[SP_RecruitResultSMSSend](
    @ID int,
    @URID int,
    @RetVal int=0 output 
)
As
Begin

    -- 申明邮件发送内容
    declare @Mobile varchar(30),@RecruitType int,@RPeople nvarchar(10),@RecruitYear int,
    @RecruitScore int,@RecruitDate smalldatetime,@RecruitLoc nvarchar(100),@SMS nvarchar(500)


    -- 定义短信发送手机号码
    select @Mobile=a.Mobile from pRecruitNotice a where a.ID=@ID
    -- 定义招聘年度
    select @RecruitType=a.RecruitType from pRecruitNotice a where a.ID=@ID
    -- 定义招聘姓名
    select @RPeople=a.Name from pRecruitNotice a where a.ID=@ID
    -- 定义招聘年度
    select @RecruitYear=YEAR(a.RecruitYear) from pRecruitNotice a where a.ID=@ID
    -- 定义笔试分数
    select @RecruitScore=a.RecruitScore from pRecruitNotice a where a.ID=@ID
    -- 定义笔试/面试日期
    select @RecruitDate=a.RecruitDate from pRecruitNotice a where a.ID=@ID
    -- 定义笔试/面试地点
    select @RecruitLoc=a.RecruitLoc from pRecruitNotice a where a.ID=@ID


    -- 短信内容检查
    -- 短信通知内容存在缺失，短信发送失败！
    ---- 校园招聘：笔试通知、笔试结果(通过)告知及面试通知
    IF Exists(select 1 from pRecruitNotice where RecruitType in (1,3) and ID=@ID
    and (RecruitYear is NULL or RecruitDate is NULL or RecruitLoc is NULL or Mobile is NULL))
    Begin
        Set @RetVal=1300010
        Return @RetVal
    End
    ---- 校园招聘：面试结果(未通过)告知、面试结果(通过)告知
    IF Exists(select 1 from pRecruitNotice where RecruitType in (4,5) and ID=@ID
    and (Name is NULL or RecruitYear is NULL or Mobile is NULL))
    Begin
        Set @RetVal=1300010
        Return @RetVal
    End
    ---- 校园招聘：笔试结果(未通过)告知
    IF Exists(select 1 from pRecruitNotice where RecruitType in (2) and ID=@ID
    and (Name is NULL or RecruitYear is NULL or Mobile is NULL or RecruitScore is NULL))
    Begin
        Set @RetVal=1300010
        Return @RetVal
    End
    ---- 社会招聘：面试通知
    IF Exists(select 1 from pRecruitNotice where RecruitType in (6) and ID=@ID
    and (RecruitDate is NULL or RecruitLoc is NULL))
    Begin
        Set @RetVal=1300010
        Return @RetVal
    End
    ---- 社会招聘：心理测试通知
    IF Exists(select 1 from pRecruitNotice where RecruitType in (7) and ID=@ID
    and RecruitDate is NULL)
    Begin
        Set @RetVal=1300010
        Return @RetVal
    End


    -- 短信内容发送
    ---- 校园招聘：笔试通知
    IF @RecruitType=1
    Begin
        -- 定义短信发送内容
        select @SMS=REPLACE(REPLACE(REPLACE(SMS,N'**年',convert(varchar(4),@RecruitYear)+N'年'),N'**时间',convert(varchar(16),@RecruitDate,121)), N'**地点',convert(nvarchar(100),@RecruitLoc))
        from pRecruitSMSInfo a where a.ID=1
        -- 发送短信
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End

    ---- 校园招聘：笔试结果(未通过)告知
    IF @RecruitType=2
    Begin
        -- 定义短信发送内容
        select @SMS=REPLACE(REPLACE((REPLACE(SMS,N'**同学',@RPeople+N'同学')),N'**年',convert(varchar(4),@RecruitYear)+N'年'),N'**分',convert(varchar(3),@RecruitScore)+N'分')
        from pRecruitSMSInfo a where a.ID=2
        -- 发送短信
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End

    ---- 校园招聘：笔试结果(通过)告知及面试通知
    IF @RecruitType=3
    Begin
        -- 定义短信发送内容
        select @SMS=REPLACE(REPLACE(REPLACE(SMS,N'**年',convert(varchar(4),@RecruitYear)+N'年'),N'**时间',convert(varchar(16),@RecruitDate,121)), N'**地点',convert(nvarchar(100),@RecruitLoc)) 
        from pRecruitSMSInfo a where a.ID=3
        -- 发送短信
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End

    ---- 校园招聘：面试结果(未通过)告知
    IF @RecruitType=4
    Begin
        -- 定义短信发送内容
        select @SMS=REPLACE((REPLACE(SMS,N'**同学',@RPeople+N'同学')),N'**年',convert(varchar(4),@RecruitYear)+N'年')
        from pRecruitSMSInfo a where a.ID=4
        -- 发送短信
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End

    ---- 校园招聘：面试结果(通过)告知
    IF @RecruitType=5
    Begin
        -- 定义短信发送内容
        select @SMS=REPLACE((REPLACE(SMS,N'**同学',@RPeople+N'同学')),N'**年',convert(varchar(4),@RecruitYear)+N'年')
        from pRecruitSMSInfo a where a.ID=5
        -- 发送短信
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End

    ---- 社会招聘：面试通知
    IF @RecruitType=6
    Begin
        -- 定义短信发送内容
        select @SMS=REPLACE((REPLACE(SMS,N'**时间',convert(varchar(16),@RecruitDate,121))),N'**地点',convert(nvarchar(100),@RecruitLoc))
        from pRecruitSMSInfo a where a.ID=6
        -- 发送短信
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End

    ---- 社会招聘：心理测试通知
    IF @RecruitType=7
    Begin
        -- 定义短信发送内容
        select @SMS=REPLACE(SMS,N'**时间',convert(varchar(10),@RecruitDate,121))
        from pRecruitSMSInfo a where a.ID=7
        -- 发送短信
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End

    ---- 社会招聘：入职审批材料通知
    IF @RecruitType=8
    Begin
        -- 定义短信发送内容
        select @SMS=SMS
        from pRecruitSMSInfo a where a.ID=8
        -- 发送短信
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End

    ---- 社会招聘：录用意向
    IF @RecruitType=9
    Begin
        -- 定义短信发送内容
        select @SMS=SMS
        from pRecruitSMSInfo a where a.ID=9
        -- 发送短信
        INSERT OPENQUERY(ORCL, 'SELECT MOBILE, CONTENT FROM HRIS.QUEUES') VALUES(@Mobile,@SMS)
    End


    Begin TRANSACTION

    -- 拷贝已发送短信人员到历史
    insert into pRecruitNotice_all(RecruitYear,Name,Mobile,RecruitScore,RecruitDate,RecruitLoc,RecruitType,SubmitBy,SubmitTime)
    select a.RecruitYear,a.Name,a.Mobile,a.RecruitScore,a.RecruitDate,a.RecruitLoc,a.RecruitType,@URID,GETDATE()
    from pRecruitNotice a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除已经发送短信人员
    delete from pRecruitNotice where ID=@ID
    -- 异常流程
    If @@Error<>0
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