USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pPensionUpdateClose]
-- skydatarefresh eSP_pPensionUpdateClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金参与关闭程序
-- @ID 为年金参与对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 年金参与未开启!
    If Exists(Select 1 From pPensionUpdate Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930076
        Return @RetVal
    End

    -- 年金参与已关闭!
    If Exists(Select 1 From pPensionUpdate Where ID=@ID And Isnull(Closed,0)=1)
    Begin
        Set @RetVal = 930077
        Return @RetVal
    End


    Begin TRANSACTION


    -- 设置年金参与数据
    ---- 更新参与人员状态
    ------ 后台员工
    update a
    set a.IsClosed=1
    from pPensionUpdatePerEmp a,pPensionUpdate b
    where DATEDIFF(yy,a.PensionYear,b.PensionYear)=0 and b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ------ 分支机构
    update a
    set a.IsClosed=1
    from pPensionUpdatePerDep a,pPensionUpdate b
    where DATEDIFF(yy,a.PensionYear,b.PensionYear)=0 and b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    ---- 企业年金参与人员总人数
    update a
    set a.PensionTotalNum=(select COUNT(IsPension) from pPensionUpdatePerEmp where DATEDIFF(yy,PensionYear,a.PensionYear)=0)
    from pPensionUpdate a
    Where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新年金月度表项pPensionUpdate
    Update a
    Set a.Closed=1,ClosedBy=@URID,ClosedTime=GETDATE()
    From pPensionUpdate a
    Where a.ID=@ID
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