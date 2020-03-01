USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_Bonus_import]--CSP_Bonus_import()
    @URID int,
    @leftid int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @GeneralBonus decimal(10, 2),
    @OneTimeAnnualBonus decimal(10, 2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 奖金导入
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from eEmployee where Badge=@Badge))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End
    
    -- 导入普通奖金和一次性奖金总和不等于月度奖金总额！
    If Exists(Select 1 From pEmployeeEmoluBonus
    where (select EID from eEmployee where badge=@Badge)=EID and (@GeneralBonus is not NULL and @OneTimeAnnualBonus is not NULL)
    and ISNULL(@GeneralBonus,0)+ISNULL(@OneTimeAnnualBonus,0)<>ISNULL(BonusTotalMM,0))
    Begin
        Set @RetVal = 930100
        Return @RetVal
    End


    Begin TRANSACTION

    -- 将导入的文件插入到pEmpEmoluBonus_import表项中
    insert into  pBonus_import (SalaryPayID,SalaryContact,Badge,GeneralBonus,OneTimeAnnualBonus,Remark)
    select @leftid,(select EID from SkySecUser where ID=@URID),@Badge,@GeneralBonus,@OneTimeAnnualBonus,@Remark
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