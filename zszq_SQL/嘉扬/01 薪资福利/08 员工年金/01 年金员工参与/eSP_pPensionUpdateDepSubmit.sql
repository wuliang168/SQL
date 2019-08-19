USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionUpdateDepSubmit]
-- skydatarefresh eSP_pPensionUpdateDepSubmit
    @leftid varchar(50),
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 分支机构年金参与确认程序
-- @leftid 为营业部对应DepID
*/
Begin

    declare @DepID int,@YEAR int
    set @DepID=SUBSTRING(@leftid,0,CHARINDEX('-',@leftid))
    set @YEAR=REVERSE(SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid))))

    Begin TRANSACTION


    -- 更新员工年金确认状态
    ---- 分支机构后台员工
    Update a
    Set a.IsSubmit=1
    From pPensionUpdatePerEmp a,pVW_Employee b
    Where ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID) and ISNULL(a.IsClosed,0)=0
    and b.DepID=@DepID and YEAR(a.PensionYear)=@YEAR
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 分支机构
    Update a
    Set a.IsSubmit=1
    From pPensionUpdatePerDep a
    Where ISNULL(a.DepID,a.SupDepID)=@DepID and YEAR(a.PensionYear)=@YEAR 
    and ISNULL(a.IsClosed,0)=0
    -- 异常流程
    If @@Error<>0
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