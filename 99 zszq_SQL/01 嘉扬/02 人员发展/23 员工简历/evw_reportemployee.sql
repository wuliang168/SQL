-- evw_reportemployee

SELECT a.EID, a.Badge, a.Name, a.EName, c.BirthDay, c.partydate, c.BirthPlace, c.Address, c.TEL, c.Mobile, c.residentAddress, c.eMail_pers AS email, d.Photo, 
(CASE WHEN dbo.eFN_getdeptype(a.DepID)<>2 or (dbo.eFN_getdepgrade(a.DepID)=1 and dbo.eFN_getdeptype(a.DepID)=2) 
THEN (SELECT DepAbbr + ' ' FROM oDepartment WHERE DepID = dbo.eFN_getdepid1st(a.DepID)) 
WHEN dbo.eFN_getdepgrade(a.DepID)=2 and dbo.eFN_getdeptype(a.DepID)=2 THEN '' END)
+ISNULL((SELECT DepAbbr FROM dbo.oDepartment WHERE (DepID = dbo.eFN_getdepid2nd(a.DepID))),'')+' '+e.Title AS jobtitle, 
b.ConBeginDate,b.ConEndDate, f.takedate, f.certid,
(SELECT Title FROM dbo.eCD_Gender WHERE (ID = ISNULL(c.Gender, 0))) AS Gender,
(SELECT Title FROM dbo.eCD_Nation WHERE (ID = ISNULL(c.Nation, 0))) AS Nation, 
CASE WHEN isnull(c.CertType, 0) = 1 THEN c.CertNo ELSE NULL END AS CertNo, CASE WHEN isnull(c.CertType, 0) = 11 THEN c.CertNo ELSE NULL END AS huzhao,
(SELECT Title FROM dbo.eCD_Party WHERE (ID = ISNULL(c.party, 0))) AS party,
(SELECT Title FROM dbo.eCD_Place WHERE (ID = ISNULL(c.place, 0))) AS Country,
(SELECT Title FROM dbo.eCD_Marriage WHERE (ID = ISNULL(c.Marriage, 0))) AS Marriage,
(SELECT TOP (1) Title FROM dbo.eBG_Title WHERE (EID = a.EID) ORDER BY effectdate DESC) AS eBGTitle1,
(SELECT TOP (1) effectdate FROM dbo.eBG_Title AS eBG_Title_5 WHERE (EID = a.EID) ORDER BY effectdate DESC) AS effectdate1,
(SELECT TOP (1) Title FROM dbo.eBG_Title AS eBG_Title_4 WHERE (EID = a.EID) 
AND (ID NOT IN (SELECT TOP (1) ID FROM dbo.eBG_Title AS eBG_Title_3 WHERE (EID = a.EID) ORDER BY effectdate DESC)) ORDER BY effectdate DESC) AS eBGTitle2,
(SELECT TOP (1) effectdate FROM dbo.eBG_Title AS eBG_Title_2 WHERE (EID = a.EID) AND (ID NOT IN
(SELECT TOP (1) ID FROM dbo.eBG_Title AS eBG_Title_1 WHERE (EID = a.EID) ORDER BY effectdate DESC)) ORDER BY effectdate DESC) AS effectdate2
FROM dbo.eEmployee AS a 
LEFT OUTER JOIN dbo.eStatus AS b ON a.EID = b.EID 
LEFT OUTER JOIN dbo.eDetails AS c ON a.EID = c.EID 
LEFT OUTER JOIN dbo.ePhoto AS d ON a.EID = d.EID 
LEFT OUTER JOIN dbo.oJob AS e ON a.JobID = e.JobID 
LEFT OUTER JOIN dbo.ebg_congyezige AS f ON a.Badge = f.badge