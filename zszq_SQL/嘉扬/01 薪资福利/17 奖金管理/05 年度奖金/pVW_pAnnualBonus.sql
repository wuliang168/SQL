-- pVW_pAnnualBonus

select a.Year as Year,a.Date as Date,a.AnnualBonusDepID as AnnualBonusDepID,a.EMPDepID as EMPDepID,
a.EID as EID,a.BID as BID,a.Identification as Identification,a.AnnualBonusType as AnnualBonusType,a.AnnualBonus as AnnualBonus
from pYear_AnnualBonus a

UNION ALL
select a.Year as Year,a.Date as Date,a.AnnualBonusDepID as AnnualBonusDepID,a.EMPDepID as EMPDepID,
a.EID as EID,a.BID as BID,a.Identification as Identification,a.AnnualBonusType as AnnualBonusType,a.AnnualBonus as AnnualBonus
from pYear_AnnualBonus_all a