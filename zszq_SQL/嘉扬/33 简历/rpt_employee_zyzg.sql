SELECT a.EID, a.Badge, a.Title, a.sdate, a.score, a1.Title AS SUBJECT1, a1.sdate AS sdate1, a1.score AS score1/* ,a2.Title as SUBJECT2,a2.sdate as sdate2,a2.score  as score2,*/ , e.zqzgdate,
    e.qhzgdate
FROM (SELECT * FROM (SELECT c.*, c1.Title, ROW_NUMBER() OVER (PARTITION BY eid
                                               ORDER BY xorder) AS rowid
        FROM EBG_ZYZG c, ecd_zyzg c1
        WHERE      c.SUBJECT = c1.id) b
    WHERE     (rowid - 1) % 2 = 0) a LEFT JOIN
    (SELECT *
    FROM (SELECT c.*, c1.Title, ROW_NUMBER() OVER (PARTITION BY eid
                              ORDER BY xorder) AS rowid
        FROM EBG_ZYZG c, ecd_zyzg c1
        WHERE      c.SUBJECT = c1.id) b1
    WHERE (rowid - 1) % 2 = 1) a1 ON a.EID = a1.EID AND a.rowid = a1.rowid - 1 /*ON a.EID=a2.EID and a.rowid=a2.rowid-2  */ 
    LEFT JOIN edetails e ON a.eid = e.eid