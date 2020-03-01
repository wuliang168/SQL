USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMMBonusSubmit]
-- skydatarefresh eSP_pSalaryPerMMBonusSubmit
    @ID int,
    @URID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 奖金确认递交
-- @ID 为员工奖项递交确认的ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin
    Declare @num1 int,@num2 int,@nummax int,@DIFFReturn int,@Date1 varchar(20),@Date2 varchar(20),@name varchar(10),@sql nvarchar(max)
    set @num1=1
    set @name='BonusMonth'
    set @nummax=(select MAX(CONVERT(int,(CASE when left(name,10)=@name then SUBSTRING(name,11,2) else NULL end))) from syscolumns where id=object_id('pEmpEmoluBonusAdd'))

    -- 员工月度奖项已确认递交！
    --If Exists(Select 1 From pEmpEmoluBonusAdd a where a.ID=@ID and ISNULL(a.Submit,0)=1)
    --Begin
    --    Set @RetVal = 930141
    --    Return @RetVal
    --End

    -- 员工月度奖项的奖金所属年份为空！
    If Exists(Select 1 From pEmpEmoluBonusAdd a where a.ID=@ID and a.BonusYear is NULL)
    Begin
        Set @RetVal = 930142
        Return @RetVal
    End

    -- 员工月度奖项的奖金类型为空！
    If Exists(Select 1 From pEmpEmoluBonusAdd a where a.ID=@ID and a.BonusType is NULL)
    Begin
        Set @RetVal = 930143
        Return @RetVal
    End

    -- 员工月度奖项的奖金总额为空！
    If Exists(Select 1 From pEmpEmoluBonusAdd a where a.ID=@ID and a.BonusAmount is NULL)
    Begin
        Set @RetVal = 930144
        Return @RetVal
    End

    -- 员工月度奖项的奖金所属部门为空！
    --If Exists(Select 1 From pEmpEmoluBonusAdd a where a.ID=@ID and a.BonusDepID is NULL)
    --Begin
    --    Set @RetVal = 930145
    --    Return @RetVal
    --End

    -- 员工月度奖项的奖金发放月份至少需填写一个！
    If Exists(Select 1 From pEmpEmoluBonusAdd a where a.ID=@ID
    and (a.BonusMonth1 is NULL and a.BonusMonth2 is NULL and a.BonusMonth3 is NULL and a.BonusMonth4 is NULL
    and a.BonusMonth5 is NULL and a.BonusMonth6 is NULL and a.BonusMonth7 is NULL and a.BonusMonth8 is NULL
    and a.BonusMonth9 is NULL and a.BonusMonth10 is NULL and a.BonusMonth11 is NULL and a.BonusMonth12 is NULL))
    Begin
        Set @RetVal = 930146
        Return @RetVal
    End

    -- 员工月度奖项的奖金发放月份对应的奖金发放金额为空！
    If Exists(Select 1 From pEmpEmoluBonusAdd a where a.ID=@ID
    and ((a.BonusMonth1 is not NULL and a.BonusAmount1 is NULL) or (a.BonusMonth2 is not NULL and a.BonusAmount2 is NULL) or (a.BonusMonth3 is not NULL and a.BonusAmount3 is NULL)
    or (a.BonusMonth4 is not NULL and a.BonusAmount4 is NULL) or (a.BonusMonth5 is not NULL and a.BonusAmount5 is NULL) or (a.BonusMonth6 is not NULL and a.BonusAmount6 is NULL)
    or (a.BonusMonth7 is not NULL and a.BonusAmount7 is NULL) or (a.BonusMonth8 is not NULL and a.BonusAmount8 is NULL) or (a.BonusMonth9 is not NULL and a.BonusAmount9 is NULL)
    or (a.BonusMonth10 is not NULL and a.BonusAmount10 is NULL) or (a.BonusMonth11 is not NULL and a.BonusAmount11 is NULL) or (a.BonusMonth12 is not NULL and a.BonusAmount12 is NULL)))
    Begin
        Set @RetVal = 930147
        Return @RetVal
    End

    -- 员工月度奖项的奖金发放月份存在相同月份！
    While @num1<@nummax
    Begin
        set @num2=@num1+1
        while @num2<@nummax
        Begin
            set @Date1=@name+CONVERT(varchar(2),@num1)
		    set @Date2=@name+CONVERT(varchar(2),@num2)
		    set @sql='select @DIFFReturn=DATEDIFF(mm,'+@Date1+','+@Date2+') from pEmpEmoluBonusAdd a where a.ID='+CONVERT(VARCHAR(max),@ID)
		    exec sp_executesql @sql,N'@DIFFReturn int output',@DIFFReturn output
		    If Exists(Select 1 where @DIFFReturn=0)
		    Begin
			    Set @RetVal = 930148
                Return @RetVal
		    End
		    set @num2=@num2+1
	    End
	    set @num1=@num1+1
    End

    -- 员工月度奖项的奖金发放金额总数未等于奖金总额！
    If Exists(Select 1 From pEmpEmoluBonusAdd a where a.ID=@ID 
    and (ISNULL(a.BonusAmount1,0)+ISNULL(a.BonusAmount2,0)+ISNULL(a.BonusAmount3,0)+ISNULL(a.BonusAmount4,0)+ISNULL(a.BonusAmount5,0)
    +ISNULL(a.BonusAmount6,0+ISNULL(a.BonusAmount7,0)+ISNULL(a.BonusAmount8,0)+ISNULL(a.BonusAmount9,0)+ISNULL(a.BonusAmount10,0)+ISNULL(a.BonusAmount11,0)
    +ISNULL(a.BonusAmount12,0))) <> a.BonusAmount)
    Begin
        Set @RetVal = 930149
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新员工月度奖项表项
    update a
    set Submit=1,SubmitBy=@URID,SubmitTime=GETDATE()
    from pEmpEmoluBonusAdd a
    where a.ID=@ID


    -- 更新月度工资流程的奖金表项pEmployeeEmoluBonus
    --- 确认递交后，将会更新pEmployeeEmoluBonus。后续发放月份由月度开启eSP_pSalaryPerMonthStart更新pEmployeeEmoluBonus
    ---- 默认奖金类型为普通奖金
    update a
    set a.GeneralBonus=ISNULL(a.GeneralBonus,0)
    +(CASE When DateDiff(mm,b.BonusMonth1,a.Date)=0 Then b.BonusAmount1 
    When DateDiff(mm,b.BonusMonth2,a.Date)=0 Then b.BonusAmount2
    When DateDiff(mm,b.BonusMonth3,a.Date)=0 Then b.BonusAmount3
    When DateDiff(mm,b.BonusMonth4,a.Date)=0 Then b.BonusAmount4
    When DateDiff(mm,b.BonusMonth5,a.Date)=0 Then b.BonusAmount5
    When DateDiff(mm,b.BonusMonth6,a.Date)=0 Then b.BonusAmount6
    When DateDiff(mm,b.BonusMonth7,a.Date)=0 Then b.BonusAmount7
    When DateDiff(mm,b.BonusMonth8,a.Date)=0 Then b.BonusAmount8
    When DateDiff(mm,b.BonusMonth9,a.Date)=0 Then b.BonusAmount9
    When DateDiff(mm,b.BonusMonth10,a.Date)=0 Then b.BonusAmount10
    When DateDiff(mm,b.BonusMonth11,a.Date)=0 Then b.BonusAmount11
    When DateDiff(mm,b.BonusMonth12,a.Date)=0 Then b.BonusAmount12
    Else NULL END),
    a.BonusTotalMM=ISNULL(a.BonusTotalMM,0)
    +(CASE When DateDiff(mm,b.BonusMonth1,a.Date)=0 Then b.BonusAmount1 
    When DateDiff(mm,b.BonusMonth2,a.Date)=0 Then b.BonusAmount2
    When DateDiff(mm,b.BonusMonth3,a.Date)=0 Then b.BonusAmount3
    When DateDiff(mm,b.BonusMonth4,a.Date)=0 Then b.BonusAmount4
    When DateDiff(mm,b.BonusMonth5,a.Date)=0 Then b.BonusAmount5
    When DateDiff(mm,b.BonusMonth6,a.Date)=0 Then b.BonusAmount6
    When DateDiff(mm,b.BonusMonth7,a.Date)=0 Then b.BonusAmount7
    When DateDiff(mm,b.BonusMonth8,a.Date)=0 Then b.BonusAmount8
    When DateDiff(mm,b.BonusMonth9,a.Date)=0 Then b.BonusAmount9
    When DateDiff(mm,b.BonusMonth10,a.Date)=0 Then b.BonusAmount10
    When DateDiff(mm,b.BonusMonth11,a.Date)=0 Then b.BonusAmount11
    When DateDiff(mm,b.BonusMonth12,a.Date)=0 Then b.BonusAmount12
    Else NULL END)
    from pEmployeeEmoluBonus a,pEmpEmoluBonusAdd b
    where b.ID=@ID and a.EID=b.EID
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