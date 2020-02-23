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

    declare @DepID int,@pPensionUpdateID int
    set @DepID=convert(int,SUBSTRING(@leftid,0,CHARINDEX('-',@leftid)))
    set @pPensionUpdateID=convert(int,REVERSE(SUBSTRING(REVERSE(@leftid),0,CHARINDEX('-',REVERSE(@leftid)))))

    -- 身份证校验码判断!
    IF Exists(Select 1 From pPensionUpdatePerEmp_register a,pVW_employee b 
    Where ISNULL(a.BID,a.EID)=ISNULL(b.BID,b.EID) AND a.pPensionUpdateID=@pPensionUpdateID AND b.DepID=@DepID
    AND a.Identification_update <> dbo.eFN_CID18CheckSum(a.Identification_update)
    AND Len(a.Identification_update)=18 AND a.Identification_update IS NOT NULL)
    Begin
        Set @RetVal=920033
        Return @RetVal
    End

    -- 存在相同身份证号员工参与年金，无法递交!
    IF Exists(Select 1 From pPensionUpdatePerEmp_register a,pVW_employee b 
    Where ISNULL(a.BID,a.EID)=ISNULL(b.BID,b.EID) AND a.pPensionUpdateID=@pPensionUpdateID AND b.DepID=@DepID
    AND a.Identification_update in (SELECT Identification_update FROM pPensionUpdatePerEmp_register 
    where pPensionUpdateID=@pPensionUpdateID and ISNULL(IsPensionNow,0)=1 GROUP BY Identification_update HAVING COUNT(Identification_update) > 1))
    Begin
        Set @RetVal=1004055
        Return @RetVal
    End

    Begin TRANSACTION


    -- 更新员工年金确认状态
    ---- 员工状态
    Update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    From pPensionUpdatePerEmp_register a,pVW_employee b
    Where ISNULL(a.BID,a.EID)=ISNULL(b.BID,b.EID)
    AND a.pPensionUpdateID=@pPensionUpdateID AND b.DepID=@DepID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 分支机构
    Update a
    Set a.IsSubmit=1
    From pPensionUpdatePerDep a
    Where ISNULL(a.DepID,a.SupDepID)=@DepID and a.pPensionUpdateID=@pPensionUpdateID 
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