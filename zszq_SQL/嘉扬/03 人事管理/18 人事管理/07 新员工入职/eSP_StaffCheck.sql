USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Proc  [dbo].[eSP_StaffCheck]
 --skydatarefresh  eSP_StaffCheck
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By kayang
-- 员工入职的信息检查程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
alter by Jimmy 2013-11-10
*/
Begin

    -- 数据已经确认！
    If Exists(Select 1 From eStaff_Register
    Where ID=@ID And Isnull(Initialized,0)=1)
    Begin
        Set @RetVal = 910000
        Return @RetVal
    End

    -- 新员工入职等级检查表填写内容检查
    -- Exec eSP_StaffCheckSub @ID,@RetVal output
    -- 入职时间不能为空！
    IF Exists()
    BEGIN
    END

    -- 姓名不能为空!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And name is null)
    Begin
         Set @RetVal=920000
         Return @RetVal
    End

    -- 入职日期不能早于当天!
    if Exists(Select 1 from eStaff_Register
    Where ID=@ID
    and datediff(day,isnull(joindate,'2049-12-31'),getdate())<0
    and (select min(RUID) from skySecRoleMemberMaker where URID=@URID)<>1000
    )
    Begin
        Set @RetVal=920014
        Return @RetVal
    End
    -- 异常处理
    If @RetVal <> 0
    Return @RetVal

    -- 公司、部门、岗位不能为空!
    if Exists(Select 1 from eStaff_Register Where ID=@ID And (Compid is null or Depid is null or Jobid is null))
    Begin
         Set @RetVal=920001
         Return @RetVal
    End

    

    -- 
    Update a
    Set  a.Initialized = 1,a.InitializedBy = @URID,a.InitializedTime = GetDate()
    from eStaff_Register a
    Where a.ID=@ID
    -- 异常处理
    If @RetVal <> 0
    Return @RetVal

    -- 正常处理流程
    Set @RetVal=0
    Return @RetVal

    -- 异常处理流程
    ErrM:
    If isnull(@RetVal,0)=0
        Set @RetVal=-1
        Return @RetVal

End
    
                                                   

  
  