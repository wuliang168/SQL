SELECT AAA.kpidepid, BB.Title kpidepname, 部门 depname, 未完成 undo, 待审 doit, 已完成 done, 绩效考核人数 countNum, 提交率 doitRate, 完成率 doneRate
FROM (SELECT kpidepid, 部门, 未完成, 待审, 已完成, 未完成 + 待审 + 已完成 绩效考核人数, CONVERT(decimal, (待审 + 已完成)) / (未完成 + 待审 + 已完成) 提交率, 
CONVERT(decimal, 已完成)/ (未完成 + 待审 + 已完成) 完成率
FROM (
SELECT kpidepid, b.Title 部门, c.Title 考核单位, 
CASE WHEN a.pstatus IN (1, 2, 6) THEN N'未完成' 
WHEN a.pstatus IN (3, 4) THEN N'待审' 
WHEN a.pstatus = 5 THEN N'已完成' 
END 状态 FROM PEMPPROCESS_MONTH a 
LEFT JOIN odepartment b ON a.depid = b.DepID
LEFT JOIN odepartment c ON a.depid = c.DepID
WHERE a.monthID = 20) AS a PIVOT (count(状态) FOR 状态 IN (未完成, 待审, 已完成)) AS p) AS AAA 
LEFT JOIN odepartment BB ON AAA.kpidepid = BB.depid