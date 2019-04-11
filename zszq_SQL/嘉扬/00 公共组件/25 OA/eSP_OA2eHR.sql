USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_OA2eHR]
-- skydatarefresh eSP_OA2eHR
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- OA2eHR程序
-- @URID 为年金员工对应ID
*/
Begin


    Begin TRANSACTION
    
    -- 拷贝OA(ZSZQ.VM_HR20151204)到eHR
    insert into pEmpOALeave_all(OAID,流程名称,标题,内容,创建日期,创建时间,完成日期,完成时间,发起人,请假开始时间,请假结束时间,假别,审批意见,审批部门,审批人,审批人ID,审批日期,审批时间)
    select ID,流程名称,标题,内容,创建日期,创建时间,完成日期,完成时间,发起人,请假开始时间,请假结束时间,假别,审批意见,审批部门,审批人,审批人ID,审批日期,审批时间
    from OPENQUERY(OAHR,'select * from ZSZQ.VM_HR20151204 
    where trim(流程名称) in (N''带薪年休假管理本级部门一般员工'',N''带薪年休假管理-本级部门中层管理人员'',N''带薪年休假管理-营业部财务(电脑)员工'',N''带薪年休假管理-营业部合规专员'',
    N''带薪年休假管理-营业部一般员工'',N''带薪年休假管理-营业部总经理室'',N''请休假管理-本级部门一般员工'',N''请休假管理-本级部门中层管理人员'',N''请休假管理-营业部财务(电脑)员工'',
    N''请休假管理-营业部合规专员'',N''请休假管理-营业部一般员工'',N''请休假管理-营业部总经理室'',N''考核定级-本级部门一般员工'',N''考核定级-营业部财务(电脑)员工'',N''考核定级-营业部一般员工'',
    N''考核定级-营业部总经理室'')')
    where ID not in (select OAID from pEmpOALeave_all)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM
    -- 拷贝OA(ZSZQ.VM_HR20171130)到eHR
    insert into pEmpOALeave_all(OAID,标题,内容,创建日期,创建时间,完成日期,完成时间,发起人,登录名,请假开始时间,请假结束时间,请假天数,请假种类,人员类型,审批意见,审批部门,审批人,审批人ID,审批日期,审批时间)
    select ID,标题,内容,创建日期,创建时间,完成日期,完成时间,发起人,登录名,请假开始时间,请假结束时间,请假天数,请假种类,人员类型,审批意见,审批部门,审批人,审批人ID,审批日期,审批时间
    from OPENQUERY(OAHR,'select * from ZSZQ.VM_HR20171130')
    where ID not in (select OAID from pEmpOALeave_all)
    -- 异常流程
	IF @@Error <> 0
	Goto ErrM


    -- 整理OA数据
    insert into pEmpOALeave (OAID,OAType,OATitle,OAContent,CreateDate,FinishDate,Name,EID,LeaveYear,LeaveDays,LeaveBeginDate,LeaveEndDate,
    LeaveType,ApprOpinion,ApprDep,ApprDirector,ApprDirectorID,ApprTime)
    select a.OAID,a.OAType,a.OATitle,a.OAContent,a.CreateDate,a.FinishDate,a.Name,a.EID,YEAR(LeaveBeginDate),
    (select COUNT(xType) from lCalendar where DATEDIFF(dd,a.LeaveBeginDate,Term)>=0 and DATEDIFF(dd,Term,a.LeaveEndDate)>=0 and xType=1)*1.0,
    a.LeaveBeginDate,a.LeaveEndDate,a.LeaveType,a.ApprOpinion,a.ApprDep,a.ApprDirector,a.ApprDirectorID,a.ApprTime
    from pVW_OAProcess a
    where a.OAID not in (select OAID from pEmpOALeave)
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