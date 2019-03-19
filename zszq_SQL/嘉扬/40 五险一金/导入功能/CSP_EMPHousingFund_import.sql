USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EMPHousingFund_import]--CSP_EMPHousingFund_import()
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @EMPHousingFundBase decimal(10,2),
    @EMPHousingFundDate varchar(50),
    @EMPHousingFundLoc nvarchar(50),
    @EMPHousingFundDepart nvarchar(50),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 社保信息导入
-- leftid 为 社保缴纳归属部门DepID
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    -- 导入文件日期格式错误！
    If (select ISDATE(@EMPHousingFundDate+'-01 0:0:0'))<>1 and @EMPHousingFundDate is not NULL
    Begin
        Set @RetVal = 931010
        Return @RetVal
    End

    -- 导入文件缴纳地错误！
    If not Exists(select 1 from oCD_HousingFundRatioLoc where Title=@EMPHousingFundLoc and ISNULL(IsDisabled,0)=0 and @EMPHousingFundLoc is not NULL)
    Begin
        Set @RetVal = 931020
        Return @RetVal
    End

    -- 导入文件归属部门错误！
    If not Exists(select 1 from oDepartment where DepAbbr=@EMPHousingFundDepart and ISNULL(IsDisabled,0)=0 and xOrder <> 9999999999999 and @EMPHousingFundDepart is not NULL)
    Begin
        Set @RetVal = 931030
        Return @RetVal
    End


    Begin TRANSACTION

    -- 将导入的文件插入到pEMPHousingFund_import表项中
    insert into pEMPHousingFund_import (Badge,Name,EMPHousingFundBase,EMPHousingFundDate,EMPHousingFundLoc,EMPHousingFundDepart,Remark)
    select @Badge,@Name,@EMPHousingFundBase,@EMPHousingFundDate+'-01 0:0:0',
    (select Place from oCD_HousingFundRatioLoc where Title=@EMPHousingFundLoc and ISNULL(IsDisabled,0)=0),
    (select DepID from oDepartment where DepAbbr=@EMPHousingFundDepart and ISNULL(IsDisabled,0)=0 and xOrder <> 9999999999999),@Remark
    -- 异常流程
	IF @@Error <> 0
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