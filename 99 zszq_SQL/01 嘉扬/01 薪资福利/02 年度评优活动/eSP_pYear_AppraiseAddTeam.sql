USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_pYear_AppraiseAddTeam]
    @DepID int,
    @AppraiseID int,
    @AppraiseEID int,
    @AppraiseDepID int,
    @RetVal int=0 Output
AS
/*
-- Create By wuliang
-- 年度评优部门添加
-- @AppraiseEID 为年度评优评选人，前台通过{U_EID}全局参数获取
*/
Begin

    -- 年度评优团队请勿重复添加!
    IF Exists(Select 1 From pYear_Appraise Where AppraiseEID=@AppraiseEID and AppraiseID=@AppraiseID 
    and DepID=@DepID and AppraiseDepID=@AppraiseDepID)
    Begin
        Set @RetVal=1003510
        Return @RetVal
    End


    Begin TRANSACTION

    -- 添加年度评优团队
    IF @DepID is NOT NULL
    Begin
        Insert Into pYear_Appraise(pYear_ID,AppraiseEID,AppraiseDepID,AppraiseID,AppraiseStatus,DepID,Limit,DepLimit)
        Values ((select ID from pYear_AppraiseProcess where ISNULL(Submit,0)=1 and ISNULL(Closed,0)=0),
        @AppraiseEID,@AppraiseDepID,@AppraiseID,1,@DepID,
        (select limit from pVW_pYear_AppraiseType where AppraiseEID=@AppraiseEID and AppraiseDepID=@AppraiseDepID and AppraiseID=@AppraiseID),
        (select deplimit from pVW_pYear_AppraiseType where AppraiseEID=@AppraiseEID and AppraiseDepID=@AppraiseDepID and AppraiseID=@AppraiseID))
        -- 异常处理
        IF @@Error <> 0
        Goto ErrM
    End


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