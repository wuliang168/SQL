USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_GrpFundIns_import]--CSP_GrpFundIns_import()
    @URID int,
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @EndowInsGRP decimal(10,2),
    @EndowInsGRPPlus decimal(10,2),
    @MedicalInsGRP decimal(10,2),
    @MedicalInsGRPPlus decimal(10,2),
    @UnemployInsGRP decimal(10,2),
    @UnemployInsGRPPlus decimal(10,2),
    @MaternityInsGRP decimal(10,2),
    @MaternityInsGRPPlus decimal(10,2),
    @InjuryInsGRP decimal(10,2),
    @InjuryInsGRPPlus decimal(10,2),
    @HousingFundGRP decimal(10,2),
    @HousingFundGRPPlus decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 五险一金(公司)导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pGrpFundIns_import表项中
    insert into pGrpFundIns_import (SalaryPayID,SalaryContact,Badge,EndowInsGRP,EndowInsGRPPlus,
    MedicalInsGRP,MedicalInsGRPPlus,UnemployInsGRP,UnemployInsGRPPlus,MaternityInsGRP,MaternityInsGRPPlus,
    InjuryInsGRP,InjuryInsGRPPlus,HousingFundGRP,HousingFundGRPPlus,Remark)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@EndowInsGRP,@EndowInsGRPPlus,@MedicalInsGRP,
    @MedicalInsGRPPlus,@UnemployInsGRP,@UnemployInsGRPPlus,@MaternityInsGRP,@MaternityInsGRPPlus,@InjuryInsGRP,
    @InjuryInsGRPPlus,@HousingFundGRP,@HousingFundGRPPlus,@Remark
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