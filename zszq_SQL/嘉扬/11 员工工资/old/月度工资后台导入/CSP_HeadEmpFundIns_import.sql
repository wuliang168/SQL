USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_HeadEmpFundIns_import]--CSP_HeadEmpFundIns_import()
    @URID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @EndowInsEMP decimal(10,2),
    @EndowInsEMPPlus decimal(10,2),
    @MedicalInsEMP decimal(10,2),
    @MedicalInsEMPPlus decimal(10,2),
    @UnemployInsEMP decimal(10,2),
    @UnemployInsEMPPlus decimal(10,2),
    @HousingFundEMP decimal(10,2),
    @HousingFundEMPPlus decimal(10,2),
    @HousingFundOverEMP decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 薪酬室五险一金(个人)导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pHeadEmpFundIns_import表项中
    insert into pHeadEmpFundIns_import (HeadContact,Badge,EndowInsEMP,EndowInsEMPPlus,MedicalInsEMP,MedicalInsEMPPlus,
    UnemployInsEMP,UnemployInsEMPPlus,HousingFundEMP,HousingFundEMPPlus,HousingFundOverEMP,Remark)
    select (select EID from SkySecUser where ID=@URID),@Badge,@EndowInsEMP,@EndowInsEMPPlus,@MedicalInsEMP,@MedicalInsEMPPlus,
    @UnemployInsEMP,@UnemployInsEMPPlus,@HousingFundEMP,@HousingFundEMPPlus,@HousingFundOverEMP,@Remark
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