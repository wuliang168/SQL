USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_EMPHousingFundPerMMPlus_import]--CSP_EMPHousingFundPerMMPlus_import()
    @leftid int,
    @EID int,
    @BID int,
    @Badge varchar(10),
    @Name nvarchar(50),
    @HousingFundEMPPlus decimal(10,2),
    @Remark nvarchar(200),
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 月度公积金补缴信息导入
-- leftid 为 公积金缴纳归属部门DepID
*/
Begin

    -- 导入文件存在工号和姓名不匹配！
    If (@Name<>(select Name from pvw_Employee where ISNULL(EID,BID)=ISNULL(@EID,@BID)))
    Begin
        Set @RetVal = 930098
        Return @RetVal
    End


    Begin TRANSACTION

    -- 将导入的文件插入到pEMPHousingFundPerMMPlus_import表项中
    insert into pEMPHousingFundPerMMPlus_import (EID,BID,Name,HousingFundEMPPlus,EMPHousingFundDepart,Remark)
    select @EID,@BID,@Name,@HousingFundEMPPlus,@leftid,@Remark
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