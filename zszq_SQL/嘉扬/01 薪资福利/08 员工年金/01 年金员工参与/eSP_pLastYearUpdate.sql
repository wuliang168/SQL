USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_pLastYearUpdate]
-- skydatarefresh eSP_pLastYearUpdate
    @URID int,
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 年金员工分配确认程序
-- @URID 为年金更新对应操作员ID
*/
Begin


    Begin TRANSACTION

    -- 添加后台在职员工系数到历史数据库表
    insert into pPension_LastYearUpdate (EID,LastYearAdminID,LastYearMDID,SubmitBy,SubmitTime)
    select a.EID,a.LastYearAdminID,a.LastYearMDID,@URID,GETDATE()
    from pEmployeeEmolu a,eEmployee b
    where a.EID=b.EID and b.Status not in (4,5) and a.EID=@EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新后台在职员工行政系数和MD系数
    update a
    set a.LastYearAdminID=ISNULL(a.AdminID,a.LastYearAdminID),a.LastYearMDID=ISNULL(a.MDID,a.LastYearMDID)
    from pEmployeeEmolu a,eEmployee b
    where a.EID=b.EID and b.Status not in (4,5) and a.EID=@EID
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