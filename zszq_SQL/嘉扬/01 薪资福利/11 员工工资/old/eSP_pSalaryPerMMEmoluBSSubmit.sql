USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMEmoluBSSubmit]
-- skydatarefresh eSP_pSalaryPerMMEmoluBSSubmit
    @leftid int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资薪酬信息确认(基于SalaryPayID的leftid)
-- @leftid为SalaryPayID信息，表示薪酬发薪类型
*/
Begin

    -- 考核鉴定和考核鉴定日期错误!
    ---- 考核鉴定状态为否，考核鉴定日期非空
    If Exists(Select 1 From pEmployeeEmolu Where SalaryPayID=@leftid and ISNULL(IsAppraised,0)=0 and AppraisedDate is not NULL)
    Begin
        Set @RetVal = 930101
        Return @RetVal
    End
    ---- 考核鉴定状态为是，考核鉴定日期为空
    If Exists(Select 1 From pEmployeeEmolu Where SalaryPayID=@leftid and ISNULL(IsAppraised,0)=1 and AppraisedDate is NULL)
    Begin
        Set @RetVal = 930101
        Return @RetVal
    End

    -- 月薪发放地为空!
    If Exists(Select 1 From pEmployeeEmolu Where SalaryPayID=@leftid and SalaryPerMMLoc is NULL)
    Begin
        Set @RetVal = 930102
        Return @RetVal
    End


    Begin TRANSACTION

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