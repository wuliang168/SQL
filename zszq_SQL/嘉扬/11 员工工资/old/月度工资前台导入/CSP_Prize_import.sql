USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_Prize_import]--CSP_Prize_import()
    @URID int,
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @BonusYear int,
    @BonusType nvarchar(100),
    @BonusAmount decimal(10,2),
    @BonusDepID nvarchar(100),
    @BonusMonth1 varchar(20),
    @BonusAmount1 decimal(10,2),
    @BonusMonth2 varchar(20),
    @BonusAmount2 decimal(10,2),
    @BonusMonth3 varchar(20),
    @BonusAmount3 decimal(10,2),
    @BonusMonth4 varchar(20),
    @BonusAmount4 decimal(10,2),
    @BonusMonth5 varchar(20),
    @BonusAmount5 decimal(10,2),
    @BonusMonth6 varchar(20),
    @BonusAmount6 decimal(10,2),
    @BonusMonth7 varchar(20),
    @BonusAmount7 decimal(10,2),
    @BonusMonth8 varchar(20),
    @BonusAmount8 decimal(10,2),
    @BonusMonth9 varchar(20),
    @BonusAmount9 decimal(10,2),
    @BonusMonth10 varchar(20),
    @BonusAmount10 decimal(10,2),
    @BonusMonth11 varchar(20),
    @BonusAmount11 decimal(10,2),
    @BonusMonth12 varchar(20),
    @BonusAmount12 decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 奖项导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pEmpEmoluBonus_import表项中
    insert into  pPrize_import (SalaryPayID,SalaryContact,Badge,BonusYear,BonusType,BonusAmount,BonusDepID,
    BonusMonth1,BonusAmount1,BonusMonth2,BonusAmount2,BonusMonth3,BonusAmount3,BonusMonth4,BonusAmount4,BonusMonth5,
    BonusAmount5,BonusMonth6,BonusAmount6,BonusMonth7,BonusAmount7,BonusMonth8,BonusAmount8,BonusMonth9,BonusAmount9,
    BonusMonth10,BonusAmount10,BonusMonth11,BonusAmount11,BonusMonth12,BonusAmount12,Remark)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@BonusYear,@BonusType,@BonusAmount,@BonusDepID,
    @BonusMonth1,@BonusAmount1,@BonusMonth2,@BonusAmount2,@BonusMonth3,@BonusAmount3,@BonusMonth4,@BonusAmount4,@BonusMonth5,
    @BonusAmount5,@BonusMonth6,@BonusAmount6,@BonusMonth7,@BonusAmount7,@BonusMonth8,@BonusAmount8,@BonusMonth9,@BonusAmount9,
    @BonusMonth10,@BonusAmount10,@BonusMonth11,@BonusAmount11,@BonusMonth12,@BonusAmount12,@Remark
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