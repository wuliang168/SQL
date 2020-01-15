USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Proc [dbo].[eSP_contractAddEmp]
   -- skydatarefresh eSP_contractAddEmp
   @EID int,
   @type int,
   @URID int,
   @RetVal int=0 Output
AS
/*
-- Create By kayang
-- 合同管理的添加员工程序，通过type(1-新签|2-变更|3-续签|4-终止|5-解除)分别处理
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

   --登记表已经添加该员工!
   IF Exists(Select 1 From econtract_Register Where EID=@EID and type=@type)
   Begin
      Set @RetVal=920065
      Return @RetVal
   End

   ---新签
   if @type=1
   begin
      Insert Into econtract_Register(type,EID,Badge,Name,compid,DepID,depid2,jobid,conCount,RegBy,RegDate,EZID,
      conProperty,conBeginDate,conTerm,conEndDate,effectDate)
      Select @type, a.EID, a.Badge, a.Name, a.compid, dbo.efn_getdepid(a.DepID), dbo.efn_getdepid2(a.DepID), a.jobid, 1, @URID, getdate(), a.EZID,
      1,b.JoinDate,36,dateadd(dd,-1,dateadd(mm,36,b.JoinDate)),GETDATE()
      From eemployee a, estatus b
      Where a.EID=@EID and a.eid=b.eid

      If @@Error<>0
      Goto ErrM
   end

   ---变更
   if @type=2
   begin
      Insert Into econtract_Register(type,EID,Badge,Name,compid,DepID,depid2,jobid,conCount,contract,contype,conProperty,
      conNo,conBeginDate,conTerm,conEndDate,New_conCount,New_contract,New_contype,New_conProperty,New_conNo,
      New_conBeginDate,New_conTerm,New_conEndDate,RegBy,RegDate,EZID,effectDate)
      Select @type, a.EID, a.Badge, a.Name, a.compid, dbo.efn_getdepid(a.DepID), dbo.efn_getdepid2(a.DepID), a.jobid, b.conCount, b.contract, b.contype, b.conProperty,
         b.conNo, b.conBeginDate, b.conTerm, b.conEndDate, b.conCount, b.contract, b.contype, b.conProperty, b.conNo,
         b.conBeginDate, b.conTerm, b.conEndDate, @URID, getdate(), a.EZID, GETDATE()
      From eemployee a, estatus b
      Where a.EID=@EID And a.eid=b.eid

      If @@Error<>0
      Goto ErrM
   end


   ---续签 (固定/非固定期)
   if @type=3
   begin
      Insert Into econtract_Register
         (type,EID,Badge,Name,compid,DepID,depid2,jobid,conCount,contract,contype,conProperty,
         conNo,conBeginDate,conTerm,conEndDate,New_conCount,RegBy,RegDate,EZID,Remark,effectDate
         ,New_contract,New_contype,New_conProperty,New_conTerm,New_conBeginDate,New_conEndDate)
      Select @type, a.EID, a.Badge, a.Name, a.compid, dbo.efn_getdepid(a.DepID), dbo.efn_getdepid2(a.DepID),a.jobid,b.conCount,b.contract,b.contype,b.conProperty, 
      b.conNo, b.conBeginDate,b.conTerm, b.conEndDate, isnull(b.conCount,0)+1,@URID, getdate(), a.EZID,case when isnull(b.concount,0)>=2 then N'建议签非固定期合同' else null end, GETDATE()
         ,b.contract, b.ConType,(case when isnull(b.concount,0)>=2 then 2 else 1 end),(case when isnull(b.concount,0)>2 then NULL else 60 end),
         dateadd(dd,1,conendDate),(case when isnull(b.concount,0)>=2 then NULL else dateadd(month,60,conendDate) end)
      From eEmployee a, eStatus b
      Where a.EID=@EID And a.EID=b.EID

      If @@Error<>0
      Goto ErrM
   end

   ---解除/终止
   if @type in (4,5)
   begin
      Insert Into econtract_Register
         (type,EID,Badge,Name,compid,DepID,depid2,jobid,conCount,contract,contype,conProperty,
         conNo,conBeginDate,conTerm,conEndDate,effectdate,RegBy,RegDate,EZID)
      Select @type, a.EID, a.Badge, a.Name, a.compid, dbo.efn_getdepid(a.DepID), dbo.efn_getdepid2(a.DepID), a.jobid,
         b.conCount, b.contract, b.contype, b.conProperty, b.conNo, b.conBeginDate,
         b.conTerm, b.conEndDate, dateadd(day,1,b.conEndDate), @URID, getdate(), a.EZID
      From eEmployee a, eStatus b
      Where a.EID=@EID And a.EID=b.EID

      If @@Error<>0
      Goto ErrM
   end

   Set @RetVal = 0
   Return @RetVal

   ErrM:
   if isnull(@RetVal,0)=0
   Set @RetVal = -1
   Return @RetVal

End 