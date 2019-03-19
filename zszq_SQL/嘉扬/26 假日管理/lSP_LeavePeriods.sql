USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	Proc [dbo].[lSP_LeavePeriods]
    @Term smalldatetime,
    @EZID int,
	@RetVal int output
as
/* 
-- Create By kayang 
-- 假期管理的年度期间和日历的初始化程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/ 
Begin  
	--declare @Term smalldatetime,@EZID int
	--set @Term=GETDATE()
	--set @EZID=100
	select @term=cast((cast(year(@term) as varchar(4))+'-1-1') as smalldatetime)

	declare @xTerm   SmallDateTime,
			@BeginDate  SmallDateTime,
			@EndDate    SmallDateTime,
			@xBeginDate  SmallDateTime,
			@xEndDate    SmallDateTime,
			@yBeginDate  SmallDateTime,
			@yEndDate    SmallDateTime,
			@Record  int,
			@i   tinyint

	set nocount on

	--生成年度的第1个月的开始日期/结束日期
	set @i=1

	--求出当年的1月1日
	set @xTerm =DateAdd(Month,1-Month(@Term),@Term)
    set @xTerm= @xTerm -Day(@xTerm)+1

	--根据之前的最后一条记录的结束日期+1得出当前的开始日期
	if Exists(Select 1 from Lleave_Periods where ezid=@ezid and datediff(month,Term,@xTerm)=1 )
	Begin
		Select @BeginDate= EndDate+1
		from Lleave_Periods
		where ezid=@Ezid And datediff(month,Term,@xTerm)=1

		set @EndDate=DateAdd(month,1,dbo.LFN_DBeginDate('M',@EZID,@xTerm ))-1

	End
	Else
	Begin
		set @BeginDate=dbo.LFN_DBeginDate('M',@EZID,@xTerm )

		set @EndDate=DateAdd(Month,1,@BeginDate)-1
	End

	Begin Tran

	While @i<13
	Begin
		--删除没有确认的假期期间
		Delete from Lleave_Periods  Where Ezid=@EZID And datediff(month,Term,@xTerm)=0 And isnull(Initialized,0)=0

		if @@Error <>0
		goto errM

		--生成每个月的假期期间
		Insert Lleave_Periods(EZid,Term,BeginDate,EndDate,initialized)
			Select @ezid,@xTerm ,@BeginDate,@EndDate ,0
		Where Not Exists(select 1 from Lleave_Periods
			where ezid=@ezid And datediff(month,Term,@xTerm)=0
			)

		if @@Error <>0
		goto errM

		set @xTerm=DateAdd(Month,1,@xTerm)

		set @BeginDate=@EndDate+1

		set @EndDate=DateAdd(Month,1,@BeginDate)-1

		set @i=@i+1
	End


	--每个月是否存在Lleave_Periods,如果存在重新生成
	While Exists(Select 1 from Lleave_Periods     
		Where EZID=@EZID And  datediff(month,Term,@xTerm)=0     
		And isnull(Initialized,0)=0    
		)    
	Begin   
	  
	--删除没有确认的考勤期间    
		Delete from Lleave_Periods    
		Where EZID=@EZID And datediff(month,Term,@xTerm)=0     
		And isnull(Initialized,0)=0    

		if @@Error <>0     
		goto errM    
    
		--生成每个月的考勤期间    
		Insert Lleave_Periods(EZID,Term,BeginDate,EndDate)    
		Select @EZID,@xTerm ,@BeginDate,@EndDate      
		Where Not Exists(select 1 from Lleave_Periods     
				where ezid=@ezid And datediff(month,Term,@xTerm)=0     
				)    

		if @@Error <>0     
		goto errM    
      
		set @xTerm=DateAdd(Month,1,@xTerm)    
		set @BeginDate=@EndDate+1    
		set @EndDate=DateAdd(Month,1,@BeginDate)-1  
		  
	End     
 
	--超出考勤期间的删除    
	select @xEndDate = Max(EndDate) from Lleave_Periods        
    
	Delete from a     
	from LCalendar a     
	Where EZID=@EZID And Term>@xEndDate     
    
	if @@Error <>0     
	goto errM  
  
	--缺少的日历补足    
	Select  @BeginDate= Min(Term),    
			@EndDate = Max(Term)    
	from LCalendar     
     
	--日历没有初始化    
	if @BeginDate is null     
	Begin     
		Select @xBeginDate= Min(BeginDate)     
		from lleave_Periods   
		Where ezid=@ezid 
	End    
	Else     
		Begin     
		select @xBeginDate = @EndDate     
	End    
    
	--全部重新生成，或补足     
	if @xBeginDate < @xEndDate     
	Begin     

	exec LSP_CalendarGenSub  @ezid,@xBeginDate,@xEndDate,@RetVal output     

	if @RetVal <> 0     
		Goto ErrM     
	End     
    
 
	Commit Tran     

	set nocount off     
    
	set @RetVal=0     
	Return @RetVal     
    
errM:    
RollBack  Tran     
Drop Table #aCD_HourlyWagesValue    
set nocount off     
if isnull(@RetVal,0)=0    
set @RetVal=-1     
Return @RetVal     
          
End     

