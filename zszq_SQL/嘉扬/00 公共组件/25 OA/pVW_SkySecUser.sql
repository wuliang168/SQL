-- pVW_SkySecUser

select a.ID as URID,a.Account as OAAccount,a.Password as PWDEncrypt,dbo.skyDeCryptFMBase64String(a.Password,0x6B08315047660D2C) as PWDDecrypt,
a.EID as EID,a.Badge as Badge,a.Name as Name,a.LoginTime as LoginTime,a.LoginTimes as LoginTimes,a.OPID as OPID,a.OPText as OPText,a.OPStatus as OPStatus,
a.OPTime as OPTime,a.OPHostName as OPHostName,a.OPLocalUser as OPLocalUser,a.Remark as Remark
from skySecUser a