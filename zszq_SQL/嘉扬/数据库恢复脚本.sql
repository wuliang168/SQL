GO
Use zszqtest1

--ALTER LOGIN [HRKayang] DISABLE
GO
--����ҵ����½
/****** Object:  Login [HRSYS]    Script Date: 11/10/2006 10:11:28 ******/
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'HRSYS')
	DROP LOGIN [HRSYS]
/* For security reasons the login is created disabled and with a random password. */
GO
/****** Object:  Login [HRSYS]    Script Date: 11/10/2006 10:11:28 ******/

exec sp_addlogin @loginame = 'HRSYS' 
     ,  @passwd =   0x0100CE1D490E08B06C0A91F446F14C3E3955F66E2E27CF35B4809D92696BF50B72FE6A845C688C0E26B4FB312C95 
     ,  @defdb =  'master'  
     ,  @deflanguage =  'us_english'  
     ,  @encryptopt=  'skip_encryption' 

--CREATE LOGIN [HRSYS] WITH PASSWORD=0x01006F5FAD0247BC628B52781B313979D1E2BAFFB1E5F306E5C500, DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
--ALTER LOGIN [HRSYS] DISABLE
GO
--Use HRMaster
GO

Use zszqtest1

GO
--�������û�ӳ�䵽��½���������µ���Ϣ
--exec sp_change_users_login 'UPDATE_ONE','HRKayang','HRKayang'
GO
Update skySecHResource
        Set Password='k6mdRv2jrjSTmkO9Mw6e7A==',Server='10.51.190.161',DBName='zszqtest1',Login='HRSYS'
GO
GO
Use zszqtest1
GO
--�������û�����ΪDBO
exec sp_changedbowner HRSYS
GO
update skysecuser set password=null