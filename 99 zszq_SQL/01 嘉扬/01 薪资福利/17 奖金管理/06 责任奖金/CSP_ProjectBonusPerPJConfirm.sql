USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[CSP_ProjectBonusPerPJConfirm]
    -- skydatarefresh CSP_ProjectBonusPerPJConfirm
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 责任奖金确认程序
-- @ID 为年度奖金流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 责任奖金已确认!
    If Exists(Select 1
    From pProjectBonusPerPJ
    Where ID=@ID and ISNULL(IsConfirm,0)=1)
    Begin
        Set @RetVal = 930395
        Return @RetVal
    End

    Begin TRANSACTION

    -- 申明及定义项目奖金发放最长年限
    declare @ProjectBonusYearMAXN decimal(4,2),@YEARN decimal(4,2)
    set @ProjectBonusYearMAXN=(select ProjectBonusYearMAXN from pVW_ProjectBonusPerPJ where ID=@ID)
    set @YEARN=1

    -- pProjectBonusPerYear
    WHILE (@ProjectBonusYearMAXN>=@YEARN)
	    BEGIN
        insert into pProjectBonusPerYear
            (ProjectBonusDISYear,DepID,ProjectTitleID,
            ProjectBonusCTDISPerYear,ProjectBonusUTDISPerYear,ProjectBonusDSDISPerYear,ProjectBonusCSDISPerYear,
            ProjectBonusOTDISPerYear,ProjectBonusSPDISPerYear,ProjectBonusDISPerYearSUM,ProjectBonusSSDISPerYear)
        select DATEADD(yy,@YEARN-1,a.ProjectBonusYear) as ProjectBonusDISYear, a.DepID as DepID, a.ID as ProjectTitleID,
            (case when @YEARN=1 then ISNULL(a.ProjectBonusCT,0) else 0 end) as ProjectBonusCTDISPerYear,
            (case when @YEARN=1 then ISNULL(a.ProjectBonusUTDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusUTDIS2ndYear,0) 
            when @YEARN=3 then ISNULL(a.ProjectBonusUTDIS3thYear,0) else 0 end) as ProjectBonusUTDISPerYear,
            (case when @YEARN=1 then ISNULL(a.ProjectBonusDSDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusDSDIS2ndYear,0) 
            when @YEARN=3 then ISNULL(a.ProjectBonusDSDIS3thYear,0) else 0 end) as ProjectBonusDSDISPerYear,
            (case when @YEARN=1 then ISNULL(a.ProjectBonusCSDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusCSDIS2ndYear,0) 
            when @YEARN=3 then ISNULL(a.ProjectBonusCSDIS3thYear,0) else 0 end) as ProjectBonusCSDISPerYear,
            (case when @YEARN=1 then ISNULL(a.ProjectBonusOTDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusOTDIS2ndYear,0) 
            when @YEARN=3 then ISNULL(a.ProjectBonusOTDIS3thYear,0) else 0 end) as ProjectBonusOTDISPerYear,
            (case when @YEARN=1 then ISNULL(a.ProjectBonusSP,0) else 0 end) as ProjectBonusSPDISPerYear,
            (case when @YEARN=1 then ISNULL(a.ProjectBonusCT,0) else 0 end)
            +(case when @YEARN=1 then ISNULL(a.ProjectBonusUTDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusUTDIS2ndYear,0) 
            when @YEARN=3 then ISNULL(a.ProjectBonusUTDIS3thYear,0) else 0 end)
            +(case when @YEARN=1 then ISNULL(a.ProjectBonusCSDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusCSDIS2ndYear,0) 
            when @YEARN=3 then ISNULL(a.ProjectBonusCSDIS3thYear,0) else 0 end)
            +(case when @YEARN=1 then ISNULL(a.ProjectBonusDSDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusDSDIS2ndYear,0) 
            when @YEARN=3 then ISNULL(a.ProjectBonusDSDIS3thYear,0) else 0 end)
            +(case when @YEARN=1 then ISNULL(a.ProjectBonusOTDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusOTDIS2ndYear,0) 
            when @YEARN=3 then ISNULL(a.ProjectBonusOTDIS3thYear,0) else 0 end)
            +(case when @YEARN=1 then ISNULL(a.ProjectBonusSP,0) else 0 end) as ProjectBonusDISPerYearSUM,
            (case when @YEARN=1 then ISNULL(ISNULL(a.ProjectBonusSSSub1DIS1stYear+a.ProjectBonusSSSub2DIS1stYear+a.ProjectBonusSSSub3DIS1stYear,a.ProjectBonusSSDIS1stYear),0)
            when a.ProjectBonusSSYearN>@YEARN-1 and ISNULL(a.ProjectBonusSSSub1AVGY,0)+ISNULL(a.ProjectBonusSSSub2AVGY,0)+ISNULL(a.ProjectBonusSSSub3AVGY,0)=0 then a.ProjectBonusSSAVGY
            when a.ProjectBonusSSYearN=@YEARN-1 and ISNULL(a.ProjectBonusSSSub1AVGY,0)+ISNULL(a.ProjectBonusSSSub2AVGY,0)+ISNULL(a.ProjectBonusSSSub3AVGY,0)=0 then a.ProjectBonusSS-a.ProjectBonusSSAVGY*(a.ProjectBonusSSYearN-1)
            else 
            (case when a.ProjectBonusSSSub1YearN>@YEARN-1 then a.ProjectBonusSSSub1AVGY when a.ProjectBonusSSSub1YearN=@YEARN-1 then a.ProjectBonusSSSub1-a.ProjectBonusSSSub1AVGY*(a.ProjectBonusSSSub1YearN-1) else 0 end)
            +(case when a.ProjectBonusSSSub2YearN>@YEARN-1 then a.ProjectBonusSSSub2AVGY when a.ProjectBonusSSSub2YearN=@YEARN-1 then a.ProjectBonusSSSub2-a.ProjectBonusSSSub2AVGY*(a.ProjectBonusSSSub2YearN-1) else 0 end)
            +(case when a.ProjectBonusSSSub3YearN>@YEARN-1 then a.ProjectBonusSSSub3AVGY when a.ProjectBonusSSSub3YearN=@YEARN-1 then a.ProjectBonusSSSub3-a.ProjectBonusSSSub3AVGY*(a.ProjectBonusSSSub3YearN-1) else 0 end) end) as ProjectBonusSSDISPerYear
        from pVW_ProjectBonusPerPJ a
        where a.ID=@ID
        -- 异常流程
        If @@Error<>0
            Goto ErrM

        SET @YEARN=@YEARN+1
    END

    -- pProjectBonusDepPerYear
    -- 初始化起始年限
    set @YEARN=1
    ---- 添加责任奖金发放年度(ProjectBonusDISYear)和部门名称(DepID)
    WHILE (@ProjectBonusYearMAXN>=@YEARN)
	    BEGIN
        insert into pProjectBonusDepPerYear
            (ProjectBonusDISYear,DepID)
        select DATEADD(yy,@YEARN-1,a.ProjectBonusYear) as ProjectBonusDISYear, a.DepID as DepID
        from pVW_ProjectBonusPerPJ a
        where a.ID=@ID 
        and not Exists(select 1 from pProjectBonusDepPerYear where DepID=a.DepID and ProjectBonusDISYear=DATEADD(yy,@YEARN-1,a.ProjectBonusYear))
        -- 异常流程
        If @@Error<>0
            Goto ErrM

        SET @YEARN=@YEARN+1
    END
    -- 初始化起始年限
    set @YEARN=1
    ---- 更新奖金金额
    WHILE (@ProjectBonusYearMAXN>=@YEARN)
	    BEGIN
        update b
        set b.PBCTDISTTPY=ISNULL(b.PBCTDISTTPY,0)+(case when @YEARN=1 then ISNULL(a.ProjectBonusCT,0) else 0 end),
        b.PBUTDISTTPY=ISNULL(b.PBUTDISTTPY,0)+(case when @YEARN=1 then ISNULL(a.ProjectBonusUTDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusUTDIS2ndYear,0) when @YEARN=3 then ISNULL(a.ProjectBonusUTDIS3thYear,0) else 0 end),
        b.PBDSDISTTPY=ISNULL(b.PBDSDISTTPY,0)+(case when @YEARN=1 then ISNULL(a.ProjectBonusDSDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusDSDIS2ndYear,0) when @YEARN=3 then ISNULL(a.ProjectBonusDSDIS3thYear,0) else 0 end),
        b.PBCSDISTTPY=ISNULL(b.PBCSDISTTPY,0)+(case when @YEARN=1 then ISNULL(a.ProjectBonusCSDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusCSDIS2ndYear,0) when @YEARN=3 then ISNULL(a.ProjectBonusCSDIS3thYear,0) else 0 end),
        b.PBOTDISTTPY=ISNULL(b.PBOTDISTTPY,0)+(case when @YEARN=1 then ISNULL(a.ProjectBonusOTDIS1stYear,0) when @YEARN=2 then ISNULL(a.ProjectBonusOTDIS2ndYear,0) when @YEARN=3 then ISNULL(a.ProjectBonusOTDIS3thYear,0) else 0 end),
        b.PBSPDISTTPY=ISNULL(b.PBSPDISTTPY,0)+(case when @YEARN=1 then ISNULL(a.ProjectBonusSP,0) else 0 end),
        b.PBSSDISTTPY=ISNULL(b.PBSSDISTTPY,0)+(case when @YEARN=1 then ISNULL(ISNULL(a.ProjectBonusSSSub1DIS1stYear+a.ProjectBonusSSSub2DIS1stYear+a.ProjectBonusSSSub3DIS1stYear,a.ProjectBonusSSDIS1stYear),0)
            when a.ProjectBonusSSYearN>@YEARN-1 and ISNULL(a.ProjectBonusSSSub1AVGY,0)+ISNULL(a.ProjectBonusSSSub2AVGY,0)+ISNULL(a.ProjectBonusSSSub3AVGY,0)=0 then a.ProjectBonusSSAVGY
            when a.ProjectBonusSSYearN=@YEARN-1 and ISNULL(a.ProjectBonusSSSub1AVGY,0)+ISNULL(a.ProjectBonusSSSub2AVGY,0)+ISNULL(a.ProjectBonusSSSub3AVGY,0)=0 then a.ProjectBonusSS-a.ProjectBonusSSAVGY*(a.ProjectBonusSSYearN-1)
            else 
            (case when a.ProjectBonusSSSub1YearN>@YEARN-1 then a.ProjectBonusSSSub1AVGY when a.ProjectBonusSSSub1YearN=@YEARN-1 then a.ProjectBonusSSSub1-a.ProjectBonusSSSub1AVGY*(a.ProjectBonusSSSub1YearN-1) else 0 end)
            +(case when a.ProjectBonusSSSub2YearN>@YEARN-1 then a.ProjectBonusSSSub2AVGY when a.ProjectBonusSSSub2YearN=@YEARN-1 then a.ProjectBonusSSSub2-a.ProjectBonusSSSub2AVGY*(a.ProjectBonusSSSub2YearN-1) else 0 end)
            +(case when a.ProjectBonusSSSub3YearN>@YEARN-1 then a.ProjectBonusSSSub3AVGY when a.ProjectBonusSSSub3YearN=@YEARN-1 then a.ProjectBonusSSSub3-a.ProjectBonusSSSub3AVGY*(a.ProjectBonusSSSub3YearN-1) else 0 end) end)
        from pVW_ProjectBonusPerPJ a,pProjectBonusDepPerYear b
        where a.ID=@ID and DATEADD(yy,@YEARN-1,a.ProjectBonusYear)=b.ProjectBonusDISYear
        -- 异常流程
        If @@Error<>0
            Goto ErrM

        SET @YEARN=@YEARN+1
    END

    -- 更新pProjectBonusPerPJ
    update a
    set a.IsConfirm=1,a.ConfirmURID=@URID,a.ConfirmDate=GETDATE()
    from pProjectBonusPerPJ a
    where a.ID=@ID and ISNULL(a.IsConfirm,0)=0
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