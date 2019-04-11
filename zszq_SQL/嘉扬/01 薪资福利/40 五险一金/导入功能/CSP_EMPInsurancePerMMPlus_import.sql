USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EMPInsurancePerMMPlus_import]--CSP_EMPInsurancePerMMPlus_import()
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @EndowInsEMPPlus decimal(10,2),
    @MedicalInsEMPPlus decimal(10,2),
    @UnemployInsEMPPlus decimal(10,2),
    @EndowInsGRPPlus decimal(10,2),
    @MedicalInsGRPPlus decimal(10,2),
    @UnemployInsGRPPlus decimal(10,2),
    @MaternityInsGRPPlus decimal(10,2),
    @InjuryInsGRPPlus decimal(10,2),
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


    Begin TRANSACTION

    -- 将导入的文件插入到pEMPInsurancePerMMPlus_import表项中
    insert into pEMPInsurancePerMMPlus_import (Badge,Name,EndowInsEMPPlus,MedicalInsEMPPlus,UnemployInsEMPPlus,EndowInsGRPPlus,MedicalInsGRPPlus,UnemployInsGRPPlus,
    MaternityInsGRPPlus,InjuryInsGRPPlus,EMPInsuranceDepart,Remark)
    select @Badge,@Name,@EndowInsEMPPlus,@MedicalInsEMPPlus,@UnemployInsEMPPlus,
    @EndowInsGRPPlus,@MedicalInsGRPPlus,@UnemployInsGRPPlus,@MaternityInsGRPPlus,@InjuryInsGRPPlus,@leftid,@Remark
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