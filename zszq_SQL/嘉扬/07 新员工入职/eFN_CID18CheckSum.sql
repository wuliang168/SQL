USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    ALTER function [dbo].[eFN_CID18CheckSum] (@cid char(18)) 
    returns char(18)
AS
/*
-- Create By wuliang E004205
-- 返回包含18位身份证校验码的身份证号码
*/
Begin
    Declare @R char(18)
    Declare @validFactors VARCHAR(17),@validCodes VARCHAR(11),@i TINYINT,@iTemp INT

    SELECT @validFactors='79A584216379A5842',@validCodes='10X98765432',@i=1,@iTemp=0
    WHILE @i<18
        BEGIN
            SELECT @iTemp=@iTemp+CAST(SUBSTRING(@cid,@i,1) AS INT)*(CASE SUBSTRING(@validFactors,@i,1) WHEN 'A' THEN 10 ELSE SUBSTRING(@validFactors,@i,1) END),@i=@i+1
        END

    select @R=LEFT(@cid,17)+SUBSTRING(@validCodes,@iTemp%11+1,1)

    return @R
End 