-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--、
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<wuliang E0004205>
-- Create date: <2017-12-18>
-- Description:	<同步pEmployeeEmolu的交通费(TrafficAllowance)、通讯费(CommAllowance)、
--				养老保险(个人)(EndowInsEMP)、养老保险(企业)(EndowInsGRP)、医疗保险(个人)(MedicalInsEMP)、医疗保险(企业)(MedicalInsGRP)、
--				失业保险(个人)(UnemployInsEMP)、失业保险(企业)(UnemployInsGRP)、生育保险(企业)(MaternityInsGRP)、工伤保险(企业)(InjuryInsGRP)、
--				公积金(个人)(HousingFundEMP)、公积金(企业)(HousingFundGRP)至月度工作数据表>
-- =============================================
ALTER TRIGGER Trigger_Update_pEmployeeEmolu
   ON  pEmployeeEmolu
   AFTER UPDATE
AS 
BEGIN
	-- Declare
	Declare @EID int,
	@TrafficAllowance decimal(10, 2),@CommAllowance decimal(10, 2)
	
	-- Initial
	select @EID=EID,@TrafficAllowance=TrafficAllowance,@CommAllowance=CommAllowance
	from inserted
	
	-- Update
    -- pEmployeeTraffic
    update pEmployeeTraffic
	set TrafficAllowance=@TrafficAllowance
	where EID=@EID
	---- pEmployeeEmoluAllowanceAT
	update pEmployeeEmoluAllowanceAT
	set CommAllowanceAT=@CommAllowance,
    AllowanceATTotal=ISNULL(@CommAllowance,CommAllowanceAT)+ISNULL(CommAllowancePlus,0)+ISNULL(AllowanceATOthers,0)
    where EID=@EID
    -- pEmployeeEmoluFundIns

END
GO