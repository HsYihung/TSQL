--	Module 6 - Lab02 日期表達格式

--	SQL Server 預設的日期類型 datetime 的預設格式是 yyyy-mm-dd hh:mm:ss.mmm
--	在 INSERT 或 UPDATE 的時候，文字或日期的欄位值須用單引號括起來。
--	單引號包起來的日期字串值必須符合 SQL Server 可接受的表達格式。
--	datetime2 比 datetime 更為精確。
--	datetimeoffset 結合了具有時區的日期時間。


use LabDB;
go

drop table if exists DateTimeTable;
go

create table DateTimeTable (
	TestID int identity,
	TestTime time null,
	TestDate date null,
	TestSmallDateTime smalldatetime null,
	TestDateTime datetime null,
	TestDateTime2 datetime2 null,
	TestDateTimeOffset datetimeoffset null
);
select * from DateTimeTable
go

--  新增 time 資料類型
insert DateTimeTable(TestTime) values('15:25:28');
select * from DateTimeTable
go

--  新增 date 資料類型
insert into DateTimeTable(TestDate) values('1998-3-21');
select * from DateTimeTable
go

--  新增 smalldatetime 資料類型
insert into DateTimeTable(TestSmallDateTime) values('1998-3-21 18:23:36');
select * from DateTimeTable
go

--  新增 datetime 資料類型
insert into DateTimeTable(TestDateTime) values('1998-3-21 18:23:36.123');
select * from DateTimeTable
go

--  新增 datetime2 資料類型
insert into DateTimeTable(TestDateTime2) values('1998-3-21 23:59:59.12345678');
select * from DateTimeTable
go

--  使用較高精確度的系統日期和時間函數來新增日期資料類型
--	SYSDATETIME() 比 GETDATE() 有更高的精確度。

insert into DateTimeTable(TestTime, TestDate, TestSmallDateTime, TestDateTime, TestDateTime2, TestDateTimeOffset) 
values(sysdatetime(), sysdatetime(),  sysdatetime(), sysdatetime(),  sysdatetime(), sysdatetime());
select * from DateTimeTable
go


--  取得目前的系統日期和時間
select 'SysDatetime()'         , SysDatetime();  
select 'SysDatetimeOffset()', SysDatetimeOffset();  
select 'SysUtcDatetime()'    , SysUtcDatetime();  
select 'Current_TimeStamp', Current_TimeStamp;   -- no ()
select 'GetDate() '               , GetDate();  
select 'GetUtcDate()'           , GetUtcDate();  


--  傳回字元字串，代表指定之 date 的指定 datepart。
select	datename(year, getdate())			as 'Year',
			datename (month, getdate())		as 'Month',
			datename (day, getdate())			as 'Day',
			datename (hour, getdate())			as 'Hour',
			datename (week, getdate())		as 'Week',
			datename (weekday, getdate())	as 'WeekDay',
			datename (hour, getdate())			as 'Hour',
			datename (minute, getdate())		as 'Minute',
			datename (second, getdate())		as 'Second';



--  ISDATE 判斷是否為正確日期格式
--  datetime  資料範圍為 1753-01-01 到 9999-12-31
--  datetime2 資料範圍是 0001-01-01 到 9999-12-31。
select isdate ('2019-05-12 10:19:41.177');
select isdate ('2019-05-12');
select isdate ('1752-1-1');
select isdate ('abc');


-- https://docs.microsoft.com/zh-tw/sql/t-sql/functions/getdate-transact-sql?view=sql-server-ver15

drop table if exists DateTimeTable
