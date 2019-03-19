-- pVW_SuppMedInsMM
---- 新增员工
select N'新增员工及子女' as Action,a.Name as Name,c.CertNo as CertNo,
(Case when a.EmpGrade in (3,4,12,8,17) then N'在职普通人员' when a.EmpGrade in (2,9,5,16) then N'在职中层管理人员' when a.EmpGrade in (1,15) then N'在职高层管理人员' end) as EMPGrade,
b.JoinDate as JoinDate,b.LeaDate as LeaDate,
ISNULL((select Title from eCD_LeaveType where ID=e.leavetype),N'') as LeaType,ISNULL(d.Fname,N'') as Fname,
ISNULL((select title from eCD_Relation where ID=d.relation),N'') as Frelation,
ISNULL((select Title from eCD_Gender where ID=d.gender),N'') as Fgender,d.Birthday as Fbirthday,ISNULL(d.CERTID,N'') as FcertID,ISNULL(d.IsSuppMedIns,N'') as FisSuppMedIns
from eEmployee a
inner join eStatus b on a.EID=b.EID and datediff(mm,b.JoinDate,GETDATE())=1
inner join eDetails c on a.EID=c.EID
left join ebg_family d on a.EID=d.EID and d.relation=6
left join eLeave_all e on a.EID=e.EID and e.leavetype<>5
where a.Status not in (4,5)

---- 离职员工
------ 不含转前台员工
Union
select N'减少员工及子女' as Action,a.Name as Name,c.CertNo as CertNo,N'' as EMPGrade,
b.JoinDate as JoinDate,b.LeaDate as LeaDate,
(select Title from eCD_LeaveType where ID=e.leavetype) as LeaType,ISNULL(d.Fname,N'') as Fname,
ISNULL((select title from eCD_Relation where ID=d.relation),N'') as Frelation,
ISNULL((select Title from eCD_Gender where ID=d.gender),N'') as Fgender,d.Birthday as Fbirthday,ISNULL(d.CERTID,N'') as FcertID,ISNULL(d.IsSuppMedIns,N'') as FisSuppMedIns
from eEmployee a
inner join eStatus b on a.EID=b.EID and datediff(mm,b.LeaDate,GETDATE())=1
inner join eDetails c on a.EID=c.EID
left join ebg_family d on a.EID=d.EID and d.relation=6
left join eLeave_all e on a.EID=e.EID and e.leavetype<>5
where a.Status=4