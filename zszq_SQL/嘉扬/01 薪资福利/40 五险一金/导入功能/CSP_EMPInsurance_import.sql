USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EMPInsurance_import]--CSP_EMPInsurance_import()
    @leftid int,
    @EID int,
    @BID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @EMPInsuranceBase decimal(10,2),
    @EMPEndowBase decimal(10,2),
    @EMPMedicalBase decimal(10,2),
    @EMPUnemployBase decimal(10,2),
    @EMPMaternityBase decimal(10,2),
    @EMPInjuryBase decimal(10,2),
    @EMPInsuranceDate varchar(20),
    @EMPMedicalDate varchar(20),
    @EMPInsuranceLoc nvarchar(50),
    @EMPInsuranceDepart nvarchar(50),
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
    If (@Name<>(select Name from pVW_Employee where ISNULL(EID,BID)=ISNULL(@EID,@BID)))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    -- 导入文件日期格式错误！
    If (select ISDATE(@EMPInsuranceDate+'-01 0:0:0'))<>1 and @EMPInsuranceDate is not NULL
    Begin
        Set @RetVal = 931010
        Return @RetVal
    End
    If (select ISDATE(@EMPMedicalDate+'-01 0:0:0'))<>1 and @EMPMedicalDate is not NULL
    Begin
        Set @RetVal = 931010
        Return @RetVal
    End

    -- 导入文件缴纳地错误！
    --If not Exists(select 1 from oCD_InsuranceRatioLoc where Title=@EMPInsuranceLoc and ISNULL(IsDisabled,0)=0 and @EMPInsuranceLoc is not NULL)
    --Begin
    --    Set @RetVal = 931020
    --    Return @RetVal
    --End

    -- 导入文件归属部门错误！
    --If not Exists(select 1 from oDepartment where DepAbbr=@EMPInsuranceDepart and ISNULL(IsDisabled,0)=0 and xOrder <> 9999999999999 and @EMPInsuranceDepart is not NULL)
    --Begin
    --    Set @RetVal = 931030
    --    Return @RetVal
    --End


    Begin TRANSACTION

    -- 将导入的文件插入到pEMPInsurance_import表项中
    insert into pEMPInsurance_import (EID,BID,EMPInsuranceBase,EMPEndowBase,EMPMedicalBase,EMPUnemployBase,EMPMaternityBase,EMPInjuryBase,
    EMPInsuranceDate,EMPMedicalDate,Remark)
    select @EID,@BID,@EMPInsuranceBase,@EMPEndowBase,@EMPMedicalBase,@EMPUnemployBase,@EMPMaternityBase,@EMPInjuryBase,
    @EMPInsuranceDate+'-01 0:0:0',@EMPMedicalDate+'-01 0:0:0',@Remark
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