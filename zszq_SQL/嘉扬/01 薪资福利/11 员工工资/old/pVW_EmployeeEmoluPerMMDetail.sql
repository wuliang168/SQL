SELECT c.Date as Date,a.EID as EID,a.SalaryPerMM as SalaryPerMM,a.SponsorAllowance as SponsorAllowance,b.PensionEMPBT as PensionEMPBT,b.PensionEMPAT as PensionEMPAT,
c.HousingFundEMP as HousingFundEMP,c.HousingFundGRP as HousingFundGRP,c.HousingFundEMPPlus as HousingFundEMPPlus,c.HousingFundGRPPlus as HousingFundGRPPlus,
c.EndowInsEMP as EndowInsEMP,c.EndowInsGRP as EndowInsGRP,c.EndowInsEMPPlus as EndowInsEMPPlus,c.EndowInsGRPPlus as EndowInsGRPPlus,c.MedicalInsEMP as MedicalInsEMP,
c.MedicalInsGRP as MedicalInsGRP,c.MedicalInsEMPPlus as MedicalInsEMPPlus,c.MedicalInsGRPPlus as MedicalInsGRPPlus,c.UnemployInsEMP as UnemployInsEMP,
c.UnemployInsGRP as UnemployInsGRP,c.UnemployInsEMPPlus as UnemployInsEMPPlus,c.UnemployInsGRPPlus as UnemployInsGRPPlus,c.MaternityInsGRP as MaternityInsGRP,
c.MaternityInsGRPPlus as MaternityInsGRPPlus,c.InjuryInsGRP as InjuryInsGRP,c.InjuryInsGRPPlus as InjuryInsGRPPlus,d.GeneralBonus as GeneralBonus,
d.OneTimeAnnualBonus as OneTimeAnnualBonus,e.FestivalFee1 as FestivalFee1,e.FestivalFee2 as FestivalFee2,e.FestivalFee3 as FestivalFee3,
--e.BenefitsInKind as BenefitsInKind,
f.ProbationBackPay as ProbationBackPay,f.NewStaffBackPay as NewStaffBackPay,f.AppointBackPay as AppointBackPay,f.AppraisalBackPay as AppraisalBackPay,
f.ToSponsorBackPay as ToSponsorBackPay,f.OvertimeBackPay as OvertimeBackPay,f.TransPostBackPay as TransPostBackPay,g.SponsorAllowanceBT as SponsorAllowanceBT,
g.DirverAllowanceBT as DirverAllowanceBT,g.ComplAllowanceBT as ComplAllowanceBT,g.RegFinMGAllowanceBT as RegFinMGAllowanceBT,g.SalesMGAllowanceBT as SalesMGAllowanceBT,
h.SickDeductionBT as SickDeductionBT,h.CompassDeductionBT as CompassDeductionBT,h.PunishDeductionBT as PunishDeductionBT,h.OthersDeductionBT as OthersDeductionBT,
i.ComputerDeductionAT as ComputerDeductionAT,i.TaxDeductionAT as TaxDeductionAT,i.OthersDeductionAT as OthersDeductionAT,j.CommAllowanceAT as CommAllowanceAT,
j.CommAllowancePlus as CommAllowancePlus,j.AllowanceATOthers as AllowanceATOthers,k.TaxDeductionModifAT as TaxDeductionModifAT,k.TaxFeeReturnAT as TaxFeeReturnAT,
k.TaxAllowanceAT as TaxAllowanceAT,k.DonationRebateBT as DonationRebateBT
FROM pEmployeeEmolu as a
left join pEmployeePension as b on a.EID=b.EID
inner join pEmployeeEmoluFundIns as c on a.EID=c.EID
inner join pEmployeeEmoluBonus as d on a.EID=d.EID
inner join pEMPFestivalFeePerMM as e on a.EID=e.EID
inner join pEmployeeEmoluBackPay as f on a.EID=f.EID
inner join pEmployeeEmoluAllowanceBT as g on a.EID=g.EID
inner join pEmployeeEmoluDeductionBT as h on a.EID=h.EID
inner join pEmployeeEmoluDeductionAT as i on a.EID=i.EID
inner join pEmployeeEmoluAllowanceAT as j on a.EID=j.EID
inner join pEmployeeEmoluTax as k on a.EID=k.EID