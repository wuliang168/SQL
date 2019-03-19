USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[CSP_Prize_import_AF]--CSP_Prize_import_AF()
    @URID int,
    @leftid int,
    @RetVal int=0 output
AS
/*
-- Create By wuliang E004205
-- 奖金导入
*/
Begin

    Begin TRANSACTION

    -- 拷贝pPrize_import的奖金到pEmpEmoluBonusAdd
    insert into pEmpEmoluBonusAdd(EID,BonusYear,BonusType,BonusAmount,BonusDepID,BonusMonth1,BonusAmount1,BonusMonth2,BonusAmount2,
    BonusMonth3,BonusAmount3,BonusMonth4,BonusAmount4,BonusMonth5,BonusAmount5,BonusMonth6,BonusAmount6,BonusMonth7,BonusAmount7,
    BonusMonth8,BonusAmount8,BonusMonth9,BonusAmount9,BonusMonth10,BonusAmount10,BonusMonth11,BonusAmount11,BonusMonth12,BonusAmount12,Remark)
    select (select EID from eEmployee where Badge=a.Badge),
    (Case when ISNUMERIC(a.BonusYear)=1 and LEN(a.BonusYear)=4 then CONVERT(datetime,CONVERT(varchar(4),a.BonusYear),101) else NULL end),
    (select ID from oCD_BonusType where Title=a.BonusType),a.BonusAmount,(select DepID from oDepartment where DepAbbr=a.BonusDepID),
    CONVERT(datetime,a.BonusMonth1+'-1',120),a.BonusAmount1,CONVERT(datetime,a.BonusMonth2+'-1',120),a.BonusAmount2,
    CONVERT(datetime,a.BonusMonth3+'-1',120),a.BonusAmount3,CONVERT(datetime,a.BonusMonth4+'-1',120),a.BonusAmount4,
    CONVERT(datetime,a.BonusMonth5+'-1',120),a.BonusAmount5,CONVERT(datetime,a.BonusMonth6+'-1',120),a.BonusAmount6,
    CONVERT(datetime,a.BonusMonth7+'-1',120),a.BonusAmount7,CONVERT(datetime,a.BonusMonth8+'-1',120),a.BonusAmount8,
    CONVERT(datetime,a.BonusMonth9+'-1',120),a.BonusAmount9,CONVERT(datetime,a.BonusMonth10+'-1',120),a.BonusAmount10,
    CONVERT(datetime,a.BonusMonth11+'-1',120),a.BonusAmount11,CONVERT(datetime,a.BonusMonth12+'-1',120),a.BonusAmount12,a.Remark
    from pPrize_import a
    where a.SalaryPayID=@leftid and a.SalaryContact=(select EID from SkySecUser where ID=@URID)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 清除导入员工奖金pPrize_import
    delete from pPrize_import where SalaryPayID=@leftid and SalaryContact=(select EID from SkySecUser where ID=@URID)
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