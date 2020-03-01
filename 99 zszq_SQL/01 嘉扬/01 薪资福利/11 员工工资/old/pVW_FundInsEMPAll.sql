SELECT a.Date as Date,a.EID as EID,a.HousingFundEMP as HousingFundEMP,a.HousingFundEMPPlus as HousingFundEMPPlus,a.EndowInsEMP as EndowInsEMP,a.EndowInsEMPPlus as EndowInsEMPPlus,
a.MedicalInsEMP as MedicalInsEMP,a.MedicalInsEMPPlus as MedicalInsEMPPlus,a.UnemployInsEMP as UnemployInsEMP,a.UnemployInsEMPPlus as UnemployInsEMPPlus,
b.InsuranceLoc as InsuranceLoc,b.HousingFundLoc as HousingFundLoc
FROM pEmployeeEmoluFundIns_all as a
inner join pEmployeeEmolu as b on a.EID=b.EID