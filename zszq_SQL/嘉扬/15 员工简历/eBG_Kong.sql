SELECT a.EID, a.Badge, a.Name, b.ifjz, b.waiyu, b.hshccj, b.yhywjs, b.hnhyz, b.hshycg, c.jiangli, d.chengfa
FROM dbo.eEmployee AS a 
LEFT OUTER JOIN dbo.ebg_qita AS b ON a.EID = b.eid 
LEFT OUTER JOIN (SELECT EID, HortationType, dbo.f_str(EID, HortationType) AS jiangli FROM dbo.eBG_Hortation GROUP BY EID, HortationType) AS c ON a.EID = c.EID AND c.HortationType = 1 
LEFT OUTER JOIN (SELECT EID, HortationType, dbo.f_str(EID, HortationType) AS chengfa FROM dbo.eBG_Hortation GROUP BY EID, HortationType) AS d ON a.EID = d.EID AND d.HortationType = 2