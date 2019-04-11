USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_pEMPMonthBonusAddEMP_import]--CSP_pEMPMonthBonusAddEMP_import()
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @BonusYear varchar(20),
    @BonusType nvarchar(50),
    @BonusTitle nvarchar(50),
    @BonusAmount decimal(10, 2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 月度奖金员工信息导入
-- leftid 为 月度奖金归属部门DepID
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End

    -- 导入文件日期格式错误！
    If (select ISDATE(@BonusYear+'-01-01 0:0:0'))<>1 and @BonusYear is not NULL
    Begin
        Set @RetVal = 931010
        Return @RetVal
    End
    
    -- 导入文件字段内容错误！
    If not Exists(select 1 from oCD_MonthBonusType where Title=@BonusType and ISNULL(IsDisabled,0)=0)
    Begin
        Set @RetVal = 931040
        Return @RetVal
    End


    Begin TRANSACTION

    -- 将导入的文件插入到pEMPMonthBonusAddEMP_import表项中
    insert into pEMPMonthBonusAddEMP_import (Badge,Name,BonusYear,BonusType,BonusTitle,BonusAmount,BonusDepID,Remark)
    select @Badge,@Name,@BonusYear+'-01-01 0:0:0',(select ID from oCD_MonthBonusType where Title=@BonusType and ISNULL(IsDisabled,0)=0),@BonusTitle,@BonusAmount,@leftid,@Remark
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