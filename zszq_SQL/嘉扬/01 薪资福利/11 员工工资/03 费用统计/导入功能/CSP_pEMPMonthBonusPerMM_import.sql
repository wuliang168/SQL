USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_pEMPMonthBonusPerMM_import]--CSP_pEMPMonthBonusPerMM_import()
    @Badge varchar(10),
    @Name nvarchar(50),
    @Date varchar(20),
    @GeneralBonus decimal(10,2),
    @OneTimeAnnualBonus decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 月度员工分配信息导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    -- 导入文件日期格式错误！
    If (select ISDATE(@Date+'-01 0:0:0'))<>1 and @Date is not NULL
    Begin
        Set @RetVal = 931010
        Return @RetVal
    End


    Begin TRANSACTION

    -- 将导入的文件插入到pEMPMonthBonusPerMM_import表项中
    insert into pEMPMonthBonusPerMM_import (Badge,Name,Date,GeneralBonus,OneTimeAnnualBonus,Remark)
    select @Badge,@Name,@Date+'-01 0:0:0',@GeneralBonus,@OneTimeAnnualBonus,@Remark
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