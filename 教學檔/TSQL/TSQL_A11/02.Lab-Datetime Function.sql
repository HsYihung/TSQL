--	Module 11 - Lab02 日期時間函數

--	在SQL中有時我們會需要提取 datetime 中的部分數值來做判斷。
--	DATENAME		: 傳回表示指定日期的指定 datepart 的字串。
--		datepart 參數有 : year，quarter，month，week，weekday，dayofyear，day，
--									hour，minute，second，millisecond，microsecond，nanosecond
--	DATEPART		: 傳回表示指定日期的指定 datepart 的整數。
--	DAY					: 傳回表示指定日期的”天”的整數。
--	MONTH			: 傳回表示指定日期的”月”的整數。
--	YEAR				: 傳回表示指定日期的”年”的整數。

select DateName (year, '2020-4-6 11:40');		-- yy-mm-dd
select DatePart (year, '2020-4-6 11:40');
select day ('4/6/2020 11:40');							-- mm/dd/yy
select month ('2020/4/6 11:40');
select year ('2020/4/6 11:40');

-- 傳回對應至指定年份、月份和日期值的 date 值
select DateFromParts (2020, 4, 7) as MyDate;                      -- Date

-- 傳回指定日期和時間引數的 datetime2 值
select DateTime2FromParts (2020, 4, 7, 23, 59, 59, 0, 7) as MyDate;     -- DateTime

-- 傳回指定日期和時間引數的 datetime 值
select DateTimeFromParts(2020, 4, 7, 23, 59, 59, 0) as MyDate; 

-- 傳回指定日期和時間的 smlldatetime 值
select SmallDateTimeFromParts (2020, 4, 7, 23, 59) as MyDate;   -- no second

-- 傳回包含指定精確度之指定時間的 time 值
select TimeFromParts (23, 59, 59, 0, 5) as MyTime;

-- DATEADD 會將指定的 number 值(以帶正負號的整數形式) 
-- 加到輸入 date 值的指定 datepart，然後傳回該修改過的值。
-- 以下都會以 1 為間隔遞增 datepart
declare @datetime2 datetime2 = '2020-04-06 12:49:10.1111111';  
select 
DateAdd (year, 1, @datetime2) as 'year',
DateAdd(quarter, 1, @datetime2) as 'quarter',       -- 季
DateAdd(month, 1, @datetime2) as 'month',
DateAdd(dayofyear, 1, @datetime2) as 'dayofyear',
DateAdd(day, 1, @datetime2) as 'day', 
DateAdd(week, 1, @datetime2) as 'week', 
DateAdd(weekday, 1, @datetime2) as 'weekday',
DateAdd(hour, 1, @datetime2) as 'hour',
DateAdd(minute, 1, @datetime2) as 'minute',
DateAdd(second, 1, @datetime2) as 'second',
DateAdd(millisecond, 1, @datetime2) as 'millisecond',
DateAdd(microsecond, 1, @datetime2) as 'microsecond', 
DateAdd(nanosecond, 1, @datetime2) as 'nanosecond';


--	EOMONTH 傳回包含指定日期的當月最後一天
declare @date datetime = getdate();  
select @date
select eoMonth ( @date ) as 'This Month';       -- end of month
select eoMonth ( @date, 1 ) as 'Next Month';  
select eoMonth ( @date, -1 ) as 'Last Month';  

--	ISDATE
if isdate ('2021-6-30 11:49:41.177') = 1
    print '有效日期'  
else  
    print '無效日期'; 

--	FORMAT傳回以指定格式與選擇性文化特性所格式化的值
declare @date1 datetime2 = sysdatetime ();
select 
format ( @date1, 'd') as '簡短日期', 
format ( @date1, 'D') as '完整日期',
format ( @date1, 'f') as '完整日期和簡短時間',
format ( @date1, 'F') as '完整日期和完整時間',
format ( @date1, 't') as '簡短時間',
format ( @date1, 'T') as '完整時間';
go

-- FORMAT 字串函數：使用文化特性與格式化日期
select 
format (getdate(), 'F', 'en-US') as 'en-US_英文 - 美國',
format (getdate(), 'F', 'de-DE') as 'de-DE_德文 - 德國', 
format (getdate(), 'F', 'zh-TW') as 'zh-TW_中文 - 台灣', 
format (getdate(), 'F', 'zh-CN') as 'zh-CN_中文 - 中國',
format (getdate(), 'F', 'ko-KR') as 'ko-KR_韓文 - 韓國';
go


--	取得系統日期和時間的函式
--		專案在規劃時，如果有可能是跨國交易，務必考慮使用 UTC 國際標準時間，
--		避免各國時區的差異造成系統錯亂，例如點數兌換、商品特惠期間…等。

select 
SysDateTime() as 'SysDateTime',
SysDateTimeOffset() as 'SysDateTimeOffset' ,
SysUtcDateTime() as 'SysUtcDateTime',
current_timestamp as 'current_timestamp',
getdate() as 'getdate' ,
GetUtcDate() as 'GetUtcDate';  


--  此函式會傳回跨越指定 startdate 和 enddate 之指定 datepart 界限的計數 (作為帶正負號的整數值)。
--  startdate 和 enddate 之間的 int 差異，以 datepart 所設定的界限表示。
declare @dt1 datetime2 = '2006-01-01 00:00:00.0000000';  
declare @dt2 datetime2 = getdate();  

select @dt1 as dt1, @dt2 as dt2                                             --@dt2-@dt1
select DateDiff (year,				@dt1, @dt2) as diff_year;
select DateDiff (quarter,			@dt1, @dt2) as diff_quarter;
select DateDiff (month,			@dt1, @dt2) as diff_month;
select DateDiff (dayofyear,		@dt1, @dt2) as diff_dayofyear;
select DateDiff (day,				@dt1, @dt2) as diff_day;
select DateDiff (week,				@dt1, @dt2) as diff_week;
select DateDiff (hour,				@dt1, @dt2) as diff_hour;
select DateDiff (minute,			@dt1, @dt2) as diff_minute;
select DateDiff (second,			@dt1, @dt2) as diff_second;
--select DateDiff (millisecond,	@dt1, @dt2) as diff_ms;
--select DateDiff (microsecond,@dt1, @dt2) as diff_us;
