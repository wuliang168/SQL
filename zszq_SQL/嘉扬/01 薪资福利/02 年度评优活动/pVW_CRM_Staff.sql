-- pVW_CRM_Staff
select (select xOrder from oDepartment where Title=REPLACE(a.YYB,CHAR(ASCII(RIGHT(a.YYB,1))),'') and ISNULL(isDisabled,0)=0 and xOrder<>9999999999999) as DepxOrder,a.YYB,
Convert(varchar(100),a.SFZ) as Identification,a.RYXM as Name,11 as CompID,
(select DepID from oDepartment where Title=REPLACE(a.YYB,CHAR(ASCII(RIGHT(a.YYB,1))),'') and ISNULL(isDisabled,0)=0 and xOrder<>9999999999999) as DepID,
(select DepAbbr from oDepartment where Title=REPLACE(a.YYB,CHAR(ASCII(RIGHT(a.YYB,1))),'') and ISNULL(isDisabled,0)=0 and xOrder<>9999999999999) as DepAbbr,
a.JJRJB as JobTitle,1 as Status,
convert(datetime,left(a.RZRQ,4)+'-'+right(left(a.RZRQ,6),2)+'-'+RIGHT(a.RZRQ,2)) as JoinDate,
convert(datetime,left(a.CYSJ,4)+'-'+right(a.CYSJ,2)+'-01') as WorkDate,
(select ID from eCD_Party where a.ZZMM=Title) as Party,
convert(datetime,left(a.HTKSRQ,4)+'-'+right(left(a.HTKSRQ,6),2)+'-'+RIGHT(a.HTKSRQ,2)) as ConBeginDate,
convert(datetime,left(a.HTJSRQ,4)+'-'+right(left(a.HTJSRQ,6),2)+'-'+RIGHT(a.HTJSRQ,2)) as ConEndDate,
(select ID from eCD_Edutype where LEFT(a.XL,2) like LEFT(Title,2)) as HighLevel,
(select ID from eCD_DegreeType where LEFT(a.XW,1) like LEFT(Title,1)) as HighDegree,
a.SJ as Mobile,a.DH as Telephone,
convert(datetime,left(a.LZRQ,4)+'-'+right(left(a.LZRQ,6),2)+'-'+RIGHT(a.LZRQ,2)) as LeaDate
from OPENQUERY(CRMDB, 'SELECT * FROM CRMII.VJJR_HR') a
where a.ZHZT=N'正常执业' and a.SFZ is not NULL and a.JJRJB not like N'%虚拟%'
order by DepxOrder