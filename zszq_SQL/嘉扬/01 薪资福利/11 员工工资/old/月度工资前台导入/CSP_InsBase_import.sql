USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_InsBase_import]--CSP_InsBase_import()
    @URID int,
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @InsuranceLoc nvarchar(100),
    @EndowInsEMP decimal(10, 2),
    @EndowInsGRP decimal(10, 2),
    @MedicalInsEMP decimal(10, 2),
    @MedicalInsGRP decimal(10, 2),
    @UnemployInsEMP decimal(10, 2),
    @UnemployInsGRP decimal(10, 2),
    @MaternityInsGRP decimal(10, 2),
    @InjuryInsGRP decimal(10, 2),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 社保缴费金额导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pInsBase_import表项中
    insert into pInsBase_import (SalaryPayID,SalaryContact,Badge,InsuranceLoc,
    EndowInsEMP,EndowInsGRP,MedicalInsEMP,MedicalInsGRP,UnemployInsEMP,UnemployInsGRP,
    MaternityInsGRP,InjuryInsGRP)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@InsuranceLoc,@EndowInsEMP,
    @EndowInsGRP,@MedicalInsEMP,@MedicalInsGRP,@UnemployInsEMP,@UnemployInsGRP,@MaternityInsGRP,
    @InjuryInsGRP
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