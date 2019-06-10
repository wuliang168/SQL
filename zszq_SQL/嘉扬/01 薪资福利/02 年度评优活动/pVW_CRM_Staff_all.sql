-- pVW_CRM_Staff_all

select (select xOrder
    from oDepartment
    where Title=REPLACE(a.YYB,CHAR(ASCII(RIGHT(a.YYB,1))),'') and ISNULL(isDisabled,0)=0 and xOrder<>9999999999999) as DepxOrder, a.YYB,
    (case when right(LTRIM(RTRIM(a.SFZ)),1)='x' then 
(case when LEN(Convert(varchar(100),REPLACE(LTRIM(RTRIM(a.SFZ)),'x','X'))  )=15 and ISNUMERIC(LEFT(Convert(varchar(100),REPLACE(LTRIM(RTRIM(a.SFZ)),'x','X'))  ,1))=1 
then dbo.eFN_CID18CheckSum(LEFT(Convert(varchar(100),REPLACE(LTRIM(RTRIM(a.SFZ)),'x','X'))  ,6)+'19'+RIGHT(Convert(varchar(100),REPLACE(LTRIM(RTRIM(a.SFZ)),'x','X'))  ,9)+'0') 
    when LEN(Convert(varchar(100),REPLACE(LTRIM(RTRIM(a.SFZ)),'x','X'))  )=18 and ISNUMERIC(LEFT(Convert(varchar(100),REPLACE(LTRIM(RTRIM(a.SFZ)),'x','X'))  ,1))=1 
    then dbo.eFN_CID18CheckSum(Convert(varchar(100),REPLACE(LTRIM(RTRIM(a.SFZ)),'x','X'))  )
    else Convert(varchar(100),REPLACE(LTRIM(RTRIM(a.SFZ)),'x','X'))   end)
    else (case when LEN(Convert(varchar(100),LTRIM(RTRIM(a.SFZ))))=15 and ISNUMERIC(LEFT(Convert(varchar(100),LTRIM(RTRIM(a.SFZ))),1))=1 
    then dbo.eFN_CID18CheckSum(LEFT(Convert(varchar(100),LTRIM(RTRIM(a.SFZ))),6)+'19'+RIGHT(Convert(varchar(100),LTRIM(RTRIM(a.SFZ))),9)+'0') 
        when LEN(Convert(varchar(100),LTRIM(RTRIM(a.SFZ))))=18 and ISNUMERIC(LEFT(Convert(varchar(100),LTRIM(RTRIM(a.SFZ))),1))=1 
        then dbo.eFN_CID18CheckSum(Convert(varchar(100),LTRIM(RTRIM(a.SFZ))))
        else Convert(varchar(100),LTRIM(RTRIM(a.SFZ))) end) 
             end)
as Identification,
    a.RYXM as Name, 11 as CompID,
    (select DepID
    from oDepartment
    where Title=REPLACE(a.YYB,CHAR(ASCII(RIGHT(a.YYB,1))),'') and ISNULL(isDisabled,0)=0 and xOrder<>9999999999999) as DepID,
    (select DepAbbr
    from oDepartment
    where Title=REPLACE(a.YYB,CHAR(ASCII(RIGHT(a.YYB,1))),'') and ISNULL(isDisabled,0)=0 and xOrder<>9999999999999) as DepAbbr,
    a.JJRJB as JobTitle, (case when a.ZHZT=N'正常执业' then 1 when a.ZHZT=N'停止执业' then 4 end) as Status,
    convert(datetime,left(a.RZRQ,4)+'-'+right(left(a.RZRQ,6),2)+'-'+RIGHT(a.RZRQ,2)) as JoinDate,
    convert(datetime,left(a.CYSJ,4)+'-'+right(a.CYSJ,2)+'-01') as WorkDate,
    (select ID
    from eCD_Party
    where a.ZZMM=Title) as Party,
    convert(datetime,left(a.HTKSRQ,4)+'-'+right(left(a.HTKSRQ,6),2)+'-'+RIGHT(a.HTKSRQ,2)) as ConBeginDate,
    convert(datetime,left(a.HTJSRQ,4)+'-'+right(left(a.HTJSRQ,6),2)+'-'+RIGHT(a.HTJSRQ,2)) as ConEndDate,
    (select ID
    from eCD_Edutype
    where LEFT(a.XL,2) like LEFT(Title,2)) as HighLevel,
    (select ID
    from eCD_DegreeType
    where LEFT(a.XW,1) like LEFT(Title,1)) as HighDegree,
    a.SJ as Mobile, a.DH as Telephone,
    convert(datetime,left(a.LZRQ,4)+'-'+right(left(a.LZRQ,6),2)+'-'+RIGHT(a.LZRQ,2)) as LeaDate
from OPENQUERY(CRMDB, 'SELECT * FROM CRMII.VJJR_HR') a
where a.SFZ is not NULL and ISNULL(a.JJRJB,0) not like N'%虚拟%'
order by DepxOrder