USE [zszq]
GO
/****** Object:  UserDefinedFunction [dbo].[LFN_CalendarGetLunar]    Script Date: 03/20/2019 17:07:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  FUNCTION  [dbo].[LFN_CalendarGetLunar]
(@solarDay  DATETIME)          
RETURNS  varchar(10)      
AS          
BEGIN
    DECLARE  @solData  int
    DECLARE  @offset  int
    DECLARE  @iLunar  int
    DECLARE  @i  INT
    DECLARE  @j  INT
    DECLARE  @yDays  int
    DECLARE  @mDays  int
    DECLARE  @mLeap  int
    DECLARE  @mLeapNum  int
    DECLARE  @bLeap  smallint
    DECLARE  @temp  int

    DECLARE  @YEAR  INT
    DECLARE  @MONTH  INT
    DECLARE  @DAY  INT

    DECLARE  @OUTPUTDATE  varchar(10)

    --保证传进来的日期是不带时间          
    SET  @solarDay=Convert(Char(10),@solarDay,120)

    SET  @offset = datediff(day,'1900-01-30',@solarDay)

    --确定农历年开始          
    SET  @i=1900
    --SET  @offset=@solData          
    WHILE  @i<2050 AND @offset>0          
	BEGIN
        SET  @yDays=348
        SET  @mLeapNum=0
        SELECT @iLunar=dataInt
        FROM lCD_CalendarSolarData
        WHERE  xYear=@i

        --传回农历年的总天数          
        SET  @j=32768
        WHILE  @j>8          
		BEGIN
            IF  @iLunar  &  @j  >0          
		       SET  @yDays=@yDays+1
            SET  @j=@j/2
        END

        --传回农历年闰哪个月  1-12  ,  没闰传回  0          
        SET  @mLeap  =  @iLunar  &  15

        --传回农历年闰月的天数  ,加在年的总天数上          
        IF  @mLeap  >  0          
		BEGIN
            IF  @iLunar  &  65536  >  0          
		       SET  @mLeapNum=30          
		   ELSE            
		       SET  @mLeapNum=29

            SET  @yDays=@yDays+@mLeapNum
        END

        SET  @offset=@offset-@yDays
        SET  @i=@i+1
    END

    IF  @offset  <=  0          
	BEGIN
        SET  @offset=@offset+@yDays
        SET  @i=@i-1
    END
    --确定农历年结束              
    SET  @YEAR=@i

    --确定农历月开始          
    SET  @i  =  1
    SELECT @iLunar=dataInt
    FROM lCD_CalendarSolarData
    WHERE  xYear=@YEAR

    --判断那个月是润月          
    SET  @mLeap  =  @iLunar  &  15
    SET  @bLeap  =  0

    WHILE  @i  <  13 AND @offset  >  0          
	BEGIN
        --判断润月          
        SET  @mDays=0
        IF  (@mLeap  >  0 AND @i  =  (@mLeap+1) AND @bLeap=0)          
		BEGIN--是润月          
            SET  @i=@i-1
            SET  @bLeap=1
            --传回农历年闰月的天数          
            IF  @iLunar  &  65536  >  0          
		       SET  @mDays  =  30          
		   ELSE            
		       SET  @mDays  =  29
        END          
		ELSE          
		--不是润月          
		BEGIN
            SET  @j=1
            SET  @temp  =  65536
            WHILE  @j<=@i          
		   BEGIN
                SET  @temp=@temp/2
                SET  @j=@j+1
            END

            IF  @iLunar  &  @temp  >  0          
		       SET  @mDays  =  30          
		   ELSE          
		       SET  @mDays  =  29
        END

        --解除闰月      
        IF  @bLeap=1 AND @i=  (@mLeap+1)      
		   SET  @bLeap=0

        SET  @offset=@offset-@mDays
        SET  @i=@i+1
    END

    IF  @offset  <=  0          
	BEGIN
        SET  @offset=@offset+@mDays
        SET  @i=@i-1
    END

    --确定农历月结束              
    SET  @MONTH=@i

    --确定农历日结束              
    SET  @DAY=@offset

    SET  @OUTPUTDATE=CAST(@YEAR  AS  VARCHAR(4))+'-'
			+Case When @Month<10 Then '0' Else '' End + CAST(@MONTH  AS  VARCHAR(2))+'-'--
			+Case When @Day<10   Then '0' Else '' End + CAST(@DAY  AS  VARCHAR(2))
    --      
    RETURN  @OUTPUTDATE
END