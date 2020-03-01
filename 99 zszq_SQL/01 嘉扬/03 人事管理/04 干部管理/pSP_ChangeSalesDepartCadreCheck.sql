USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Proc  [dbo].[pSP_ChangeSalesDepartCadreCheck]
-- skydatarefresh pSP_ChangeSalesDepartCadreCheck
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 营业部干部调动登记表的确认检查程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 数据已经确认
    If Exists(Select 1 From pChangeSalesDepartCadre_Register
    Where ID=@ID And ISNULL(Submit,0)=1)
    Begin
        Set @RetVal = 910000
        Return @RetVal
    End
               
    -- 营业部干部调动登记表的检查程序
    -- 营业部干部调动类型为空！
    if Exists(Select 1 from pChangeSalesDepartCadre_Register a Where a.ID=@ID and ISNULL(ChangeType,0)=0)
    Begin
        Set @RetVal=930051
        Return @RetVal
    End
    -- 异常流程
    If @RetVal <> 0
    Return @RetVal

    -- 营业部干部调动日期为空！
    if Exists(Select 1 from pChangeSalesDepartCadre_Register a Where a.ID=@ID and ISNULL(Changedate,0)=0)
    Begin
        Set @RetVal=930052
        Return @RetVal
    End
    -- 异常流程
    If @RetVal <> 0
    Return @RetVal

    -- 营业部干部替岗人为空！
    if Exists(Select 1 from pChangeSalesDepartCadre_Register a Where a.ID=@ID and FtgBy is NULL)
    Begin
        Set @RetVal=930053
        Return @RetVal
    End
    -- 异常流程
    If @RetVal <> 0
    Return @RetVal

    -- 更新营业部干部调动登记表
    Update a
    Set a.Submit = 1,a.SubmitBy = @URID,a.SubmitTime = GetDate()
    From  pChangeSalesDepartCadre_Register a
    Where a.ID=@ID
    -- 异常状态判断
    If @@Error<>0
    Goto ErrM

    -- 正常处理流程
    Set @RetVal=0
    Return @RetVal

    -- 异常处理流程
    ErrM:
    If isnull(@RetVal,0)=0
        Set @RetVal=-1
        Return @RetVal

End