USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadEMPFundInsBase_import]--CSP_HeadEMPFundInsBase_import()
    @URID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @EndowInsEMP decimal(10,2),
    @MedicalInsEMP decimal(10,2),
    @UnemployInsEMP decimal(10,2),
    @HousingFundEMP decimal(10,2),
    @HousingFundOverEMP decimal(10,2),
    @InsuranceLoc nvarchar(100),
    @HousingFundLoc nvarchar(100),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 个人社保公积金缴费基数金额导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pHeadEMPFundInsBase_import表项中
    insert into pHeadEMPFundInsBase_import (HeadContact,Badge,EndowInsEMP,MedicalInsEMP,
    UnemployInsEMP,HousingFundEMP,HousingFundOverEMP,InsuranceLoc,HousingFundLoc)
    select (select EID from SkySecUser where ID=@URID),@Badge,@EndowInsEMP,@MedicalInsEMP,
    @UnemployInsEMP,@HousingFundEMP,@HousingFundOverEMP,@InsuranceLoc,@HousingFundLoc
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