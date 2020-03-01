USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EmpFundIns_import]--CSP_EmpFundIns_import()
    @URID int,
    @leftid int,
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
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 五险一金(个人)导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    Begin TRANSACTION

    -- 将导入的文件插入到pEmpFundIns_import表项中
    insert into pEmpFundIns_import (SalaryPayID,SalaryContact,Badge,EndowInsEMP,EndowInsEMPPlus,
    MedicalInsEMP,MedicalInsEMPPlus,UnemployInsEMP,UnemployInsEMPPlus,HousingFundEMP,HousingFundEMPPlus,Remark)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@EndowInsEMP,@EndowInsEMPPlus,@MedicalInsEMP,
    @MedicalInsEMPPlus,@UnemployInsEMP,@UnemployInsEMPPlus,@HousingFundEMP,@HousingFundEMPPlus,@Remark
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