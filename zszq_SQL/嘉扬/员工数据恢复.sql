-- 员工数据恢复

Declare  @Badge varchar(10),@oldEID int
Set @Badge='E001149'
Set @oldEID=(select eid from zszqtest1.dbo.eemployee where Badge=@Badge)

-- 删除ebg_congyezige中存在相同姓名的员工记录
if exists(select 1 from ebg_congyezige where Badge=@Badge)
Begin
    delete from ebg_congyezige where Badge=@Badge
End


-- 添加员工到eemployee(从已有数据库中拷贝)
insert into eemployee(Badge,Name,EName,CompID,DepID,JobID,Status,ReportTo,wfreportto,EmpType,EmpGrade,
EmpCategory,EmpProperty,EmpGroup,EmpKind,WorkCity,Remark,EZID,HRG,VirtualDep)
select Badge,Name,EName,CompID,DepID,JobID,Status,ReportTo,wfreportto,EmpType,EmpGrade,
EmpCategory,EmpProperty,EmpGroup,EmpKind,WorkCity,Remark,EZID,HRG,VirtualDep
from zszqtest1.dbo.eemployee
where zszqtest1.dbo.eemployee.Badge=@Badge
-- 验证结果
--select * from eemployee where Badge=@Badge
--select * from zszqtest1.dbo.eemployee where Badge=@Badge


-- 更新eStatus(从已有数据库中拷贝)
update a
set a.joindate=b.joindate,a.Cyear_adjust=b.Cyear_adjust,a.isReJoin=b.isReJoin,
a.isPrac=b.isPrac,a.PracTerm=b.PracTerm,a.PracEndDate=b.PracEndDate,
a.isprob=b.isProb,a.ProbTerm=b.ProbTerm,a.ProbEndDate=b.ProbEndDate,
a.ConCount=b.ConCount,a.contract=b.contract,a.ConType=b.ConType,a.ConProperty=b.ConProperty,
a.ConNo=b.ConNo,a.ConBeginDate=b.ConBeginDate,a.ConTerm=b.ConTerm,a.ConEndDate=b.ConEndDate,
a.isLeave=b.isLeave,a.LeaDate=b.LeaDate,a.LeaType=b.LeaType,a.LeaReason=b.LeaReason,a.IsBlackList=b.IsBlackList,
a.JobBegindate=b.JobBegindate,a.JobRepostdate=b.JobRepostdate,a.JobLeavedate=b.JobLeavedate,a.Remark=b.Remark
from estatus a,zszqtest1.dbo.eStatus b
where a.eid=(select eid from eemployee where Badge=@Badge)
and b.eid=@oldEID
-- 验证结果
--select * from estatus where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.estatus where eid=@oldEID


-- 更新eDetails(从已有数据库中拷贝)
update a
set a.Country=b.Country,a.CertType=b.CertType,a.CertNo=b.CertNo,
a.Gender=b.Gender,a.BirthDay=b.BirthDay,a.BirthPlace=b.BirthPlace,
a.Nation=b.Nation,a.party=b.party,a.partydate=b.partydate,
a.HighLevel=b.HighLevel,a.HighDegree=b.HighDegree,a.HighTitle=b.HighTitle,a.Major=b.Major,
a.Marriage=b.Marriage,a.Health=b.Health,a.WorkBeginDate=b.WorkBeginDate,a.workyear_adjust=b.workyear_adjust,
a.Resident=b.Resident,a.residentAddress=b.residentAddress,a.Address=b.Address,a.TEL=b.TEL,a.Postcode=b.Postcode,
a.Mobile=b.Mobile,a.email=b.email,a.office_phone=b.office_phone,a.MSN=b.MSN,a.QQ=b.QQ,a.JoinType=b.JoinType,a.remark=b.remark,
a.eMail_pers=b.eMail_pers,a.place=b.place,a.OA=b.OA,a.OA_mail=b.OA_mail,a.schoolname=b.schoolname,a.WORKYEARS=b.WORKYEARS,a.DANDAN=b.DANDAN,
a.Nianjin=b.Nianjin,a.zqzgdate=b.zqzgdate,a.qhzgdate=b.qhzgdate,a.conbegindate=b.conbegindate
from eDetails a,zszqtest1.dbo.eDetails b
where a.eid=(select eid from eemployee where Badge=@Badge)
and b.eid=@oldEID
-- 验证结果
--select * from eDetails where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.eDetails where eid=@oldEID


-- 插入eContract_all(从已有数据库中拷贝)
insert into eContract_all
select *
from zszqtest1.dbo.eContract_all
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from eContract_all a
where a.badge=@Badge
-- 验证结果
--select * from eContract_all where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.eContract_all where eid=@oldEID


-- 插入ebg_education(从已有数据库中拷贝)
insert into ebg_education(EID,badge,BeginDate,endDate,SchoolName,GradType,StudyType,EduType,DegreeType,DegreeName,
Major,EduNo,EduNoDate,DegreeNo,DegreeNoDate,SchoolPlace,Reference,Tel,isout,remark,depid2,majortype,Initialized)
select EID,badge,BeginDate,endDate,SchoolName,GradType,StudyType,EduType,DegreeType,DegreeName,
Major,EduNo,EduNoDate,DegreeNo,DegreeNoDate,SchoolPlace,Reference,Tel,isout,remark,depid2,majortype,Initialized
from zszqtest1.dbo.ebg_education
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from ebg_education a
where a.badge=@Badge
-- 验证结果
--select * from ebg_education where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.ebg_education where eid=@oldEID


-- 插入ebg_working(从已有数据库中拷贝)
insert into ebg_working(EID,badge,BeginDate,endDate,company,job,workplace,Reference,Tel,isout,remark,depid2,Wyear,
institution,leavereason,Initialized)
select EID,badge,BeginDate,endDate,company,job,workplace,Reference,Tel,isout,remark,depid2,Wyear,
institution,leavereason,Initialized
from zszqtest1.dbo.ebg_working
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from ebg_working a
where a.badge=@Badge
-- 验证结果
--select * from ebg_working where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.ebg_working where eid=@oldEID


-- 插入ebg_title(从已有数据库中拷贝)
insert into ebg_title(EID,badge,Title,Titletype,TitleGrade,describe,effectdate,certNo,Remark,depid2,Initialized)
select EID,badge,Title,Titletype,TitleGrade,describe,effectdate,certNo,Remark,depid2,Initialized
from zszqtest1.dbo.ebg_title
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from ebg_title a
where a.badge=@Badge
-- 验证结果
--select * from ebg_title where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.ebg_title where eid=@oldEID


-- 插入eBG_Hortation(从已有数据库中拷贝)
insert into eBG_Hortation(EID,badge,InOut,HortationType,HortationKind,HappenDate,Organizer,Reason,Description,Remark,depid2,Initialized)
select EID,badge,InOut,HortationType,HortationKind,HappenDate,Organizer,Reason,Description,Remark,depid2,Initialized
from zszqtest1.dbo.eBG_Hortation
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from eBG_Hortation a
where a.badge=@Badge
-- 验证结果
--select * from eBG_Hortation where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.eBG_Hortation where eid=@oldEID


-- 插入eBG_Family(从已有数据库中拷贝)
insert into eBG_Family(eid,badge,Fname,relation,gender,Birthday,Company,Job,status,remark,depid2,tel,address,Initialized,CERTID,isyj)
select eid,badge,Fname,relation,gender,Birthday,Company,Job,status,remark,depid2,tel,address,Initialized,CERTID,isyj
from zszqtest1.dbo.eBG_Family
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from eBG_Family a
where a.badge=@Badge
-- 验证结果
--select * from eBG_Family where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.eBG_Family where eid=@oldEID


-- 插入eBG_Emergency(从已有数据库中拷贝)
insert into eBG_Emergency(EID,badge,EmergencyName,Relation,Telephone,address,email,PostCode,Remark,depid2,Initialized)
select EID,badge,EmergencyName,Relation,Telephone,address,email,PostCode,Remark,depid2,Initialized
from zszqtest1.dbo.eBG_Emergency
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from eBG_Emergency a
where a.badge=@Badge
-- 验证结果
--select * from eBG_Emergency where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.eBG_Emergency where eid=@oldEID


-- 插入eBG_Certificate(从已有数据库中拷贝)
insert into eBG_Certificate(eid,badge,certtype,certno,payOrg,begindate,term,enddate,isDisable,remark,isphoto,photo,depid2,photoIMG,Initialized)
select eid,badge,certtype,certno,payOrg,begindate,term,enddate,isDisable,remark,isphoto,photo,depid2,photoIMG,Initialized
from zszqtest1.dbo.eBG_Certificate
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from eBG_Certificate a
where a.badge=@Badge
-- 验证结果
--select * from eBG_Certificate where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.eBG_Certificate where eid=@oldEID


-- 插入HPOSITIONW_REGIST(从已有数据库中拷贝)
insert into HPOSITIONW_REGIST(badge,name,compid,depid,depid2,jobid,status,joindate,Willtype,Willstatus,Willdate,Adepid,Ajob,ANO,Adate,
Empgrade,directortype,remark,rebby,rebdate,Acompid,Adepid2)
select badge,name,compid,depid,depid2,jobid,status,joindate,Willtype,Willstatus,Willdate,Adepid,Ajob,ANO,Adate,
Empgrade,directortype,remark,rebby,rebdate,Acompid,Adepid2
from zszqtest1.dbo.HPOSITIONW_REGIST
where Badge=@Badge
-- 验证结果
--select * from HPOSITIONW_REGIST where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.HPOSITIONW_REGIST where eid=@oldEID


-- 插入EHIGHMANAGER_REGIST(从已有数据库中拷贝)
insert into EHIGHMANAGER_REGIST(badge,name,compid,depid,depid2,jobid,status,joindate,ishigh,ishigh_year,hightype,highNo,highdate,
remark,rebby,submitdate,dep_title,dep2_title,job_title,isdisabled)
select badge,name,compid,depid,depid2,jobid,status,joindate,ishigh,ishigh_year,hightype,highNo,highdate,
remark,rebby,submitdate,dep_title,dep2_title,job_title,isdisabled
from zszqtest1.dbo.EHIGHMANAGER_REGIST
where badge=@Badge
-- 验证结果
--select * from EHIGHMANAGER_REGIST where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.EHIGHMANAGER_REGIST where eid=@oldEID


-- 更新ebg_qita
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from ebg_qita a
where a.badge=@Badge
-- 验证结果
--select * from ebg_qita where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.ebg_qita where eid=@oldEID


-- 更新pEmployeeEmolu
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from pEmployeeEmolu a
where a.eid=@oldEID
-- 验证结果
--select * from pEmployeeEmolu where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.pEmployeeEmolu where eid=@oldEID


-- 更新ebg_zqqh
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from ebg_zqqh a
where a.badge=@Badge
-- 验证结果
--select * from ebg_zqqh where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.ebg_zqqh where eid=@oldEID


-- 插入eEvent(从已有数据库中拷贝)
insert into eEvent(Type,effectdate,EID,CompID,DepID,JobID,Status,ReportTo,wfreportto,
EmpType,EmpGrade,EmpCategory,EmpProperty,EmpGroup,EmpKind,WorkCity,Remark,EZID)
select Type,effectdate,EID,CompID,DepID,JobID,Status,ReportTo,wfreportto,
EmpType,EmpGrade,EmpCategory,EmpProperty,EmpGroup,EmpKind,WorkCity,Remark,EZID
from zszqtest1.dbo.eEvent
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from eEvent a
where a.eid=@oldEID
-- 验证结果
--select * from eEvent where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.eEvent where eid=@oldEID


-- 插入estaff_all(从已有数据库中拷贝)
insert into estaff_all
select *
from zszqtest1.dbo.estaff_all
where badge=@Badge
-- 验证结果
--select * from estaff_all where badge=@Badge
--select * from zszqtest1.dbo.estaff_all where badge=@Badge


-- 插入skysecuser(从已有数据库中拷贝)
insert into skysecuser(Title,Account,Password1,Password,EID,Badge,Name,GEID,GCPID,GSVID,GVNID,AUID,AZID,
SSID,StartDate,EndDate,DefRUID,DefFCID,AGID,LGID,LoginHostName,LoginLocalUSer,Status,StatusTIme,LoginTime,LoginTimes,
OPID,OPText,OPData,OPStatus,OPTime,OPHostName,OPLocalUser,Submit,SubmitTime,System,Disabled,Remark,NTDomainUser,xUserType,xPassword)
select Title,Account,Password1,Password,EID,Badge,Name,GEID,GCPID,GSVID,GVNID,AUID,AZID,
SSID,StartDate,EndDate,DefRUID,DefFCID,AGID,LGID,LoginHostName,LoginLocalUSer,Status,StatusTIme,LoginTime,LoginTimes,
OPID,OPText,OPData,OPStatus,OPTime,OPHostName,OPLocalUser,Submit,SubmitTime,System,Disabled,Remark,NTDomainUser,xUserType,xPassword
from zszqtest1.dbo.skysecuser
where eid=@oldEID
---- 更新EID为新申请到的EID编号
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from skysecuser a
where a.badge=@Badge
-- 验证结果
--select * from skysecuser where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.skysecuser where eid=@oldEID


-- 插入skySecRoleMemberMaker(从已有数据库中拷贝)
insert into skySecRoleMemberMaker(RUID,URID,HRID,FCID,RZID,PZID,AZID,xOrder,Remark,System)
select RUID,(select id from skysecuser where Badge=@Badge),HRID,FCID,RZID,PZID,AZID,xOrder,Remark,System
from zszqtest1.dbo.skySecRoleMemberMaker
where URID=(select id from zszqtest1.dbo.skysecuser where Badge=@Badge)
-- 验证结果
--select * from skySecRoleMemberMaker where urid=(select id from skysecuser where Badge=@Badge)
--select * from zszqtest1.dbo.skySecRoleMemberMaker where urid=(select id from zszqtest1.dbo.skysecuser where Badge=@Badge)


-- 插入skysecrolemember(从已有数据库中拷贝)
insert into dbo.skysecrolemember(id,ruid,urid,hrid)
select id,ruid,urid,hrid
from dbo.skySecRoleMemberMaker
where id not in(select id from dbo.skysecrolemember)
-- 验证结果
--select * from skysecrolemember where urid=(select id from skysecuser where Badge=@Badge)
--select * from zszqtest1.dbo.skysecrolemember where urid=(select id from zszqtest1.dbo.skysecuser where Badge=@Badge)


-- 更新pEmployee
---- 删除pEmployee
delete from pEmployee
where badge=@Badge
---- 插入pEmployee
insert into pEmployee(EID,Badge,Name,EName,CompID,DepID,JobID,Status,ReportTo,wfreportto,
EmpType,EmpGrade,EmpCategory,EmpProperty,EmpGroup,EmpKind,
WorkCity,Remark,EZID,kpidepid,pegroup,perole,pstatus,compliance,
kpiReportTo,kpieid1,modulus1,kpieid2,modulus2,kpieid3,modulus3,kpieid4,modulus4,kpieid5,modulus5,kpieid6,modulus6,Templet_GS)
select (select eid from eemployee where Badge=@Badge),Badge,Name,EName,CompID,DepID,JobID,Status,ReportTo,wfreportto,
EmpType,EmpGrade,EmpCategory,EmpProperty,EmpGroup,EmpKind,
WorkCity,Remark,EZID,kpidepid,pegroup,perole,pstatus,compliance,
kpiReportTo,kpieid1,modulus1,kpieid2,modulus2,kpieid3,modulus3,kpieid4,modulus4,kpieid5,modulus5,kpieid6,modulus6,Templet_GS
from zszqtest1.dbo.pEmployee a
where a.badge=@Badge
-- 验证结果
--select * from pEmployee where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.pEmployee where eid=@oldEID


-- 更新PEMPLOYEE_CHANGE
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from PEMPLOYEE_CHANGE a
where a.badge=@Badge
-- 验证结果
--select * from PEMPLOYEE_CHANGE where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.PEMPLOYEE_CHANGE where eid=@oldEID


-- 更新PEMPLOYEE_REGISTER
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from PEMPLOYEE_REGISTER a
where a.badge=@Badge
-- 验证结果
--select * from PEMPLOYEE_REGISTER where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.PEMPLOYEE_REGISTER where eid=@oldEID


-- 更新BS_YC_DK
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from BS_YC_DK a
where a.badge=@Badge
-- 验证结果
--select * from BS_YC_DK where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.BS_YC_DK where eid=@oldEID


-- 更新WORKRECORD
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from WORKRECORD a
where a.eid=@oldEID
-- 验证结果
--select * from WORKRECORD where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.WORKRECORD where eid=@oldEID


-- 更新pscore
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from pscore a
where a.eid=@oldEID
-- 验证结果
--select * from pscore where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.pscore where eid=@oldEID


-- 更新pscore_all
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from pscore_all a
where a.eid=@oldEID
-- 验证结果
--select * from pscore_all where eid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.pscore_all where eid=@oldEID


-- 更新pempprocess_year_mutual
update a
set a.evaleid=(select eid from eemployee where Badge=@Badge)
from pempprocess_year_mutual a
where a.evaleid=@oldEID
-- 验证结果
--select * from pempprocess_year_mutual where evaleid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.pempprocess_year_mutual where evaleid=@oldEID


-- 更新pempprocess_year_mutual
update a
set a.byEvaleid=(select eid from eemployee where Badge=@Badge)
from pempprocess_year_mutual a
where a.byEvaleid=@oldEID
-- 验证结果
--select * from pempprocess_year_mutual where byEvaleid=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.pempprocess_year_mutual where byEvaleid=@oldEID


-- 更新pYear_LZ
update a
set a.EID=(select eid from eemployee where Badge=@Badge)
from pYear_LZ a
where a.EID=@oldEID
-- 验证结果
--select * from WORKRECORD where pYear_LZ=(select eid from eemployee where Badge=@Badge)
--select * from zszqtest1.dbo.WORKRECORD where pYear_LZ=@oldEID
