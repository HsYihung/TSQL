--	Module 2 - SQL Server 提供的系統資料類型(Data Types) 
--		2-1 : 數值資料類型-精確數值 vs. 近似數值 
--		2-2 : 字元字串資料類型 - 一般字元字串 vs. Unicode 字元字串   
--		2-3 : 日期時間資料類型與其它資料類型 

--	Lab01 建立一個LabDB做為往後Lab的測試用DB比較數字資料類型

--	SQL Server 2017/2019
--		p 3-21	正規化
--					https://hackmd.io/@TSMI_E7ORNeP8YBbWm-lFA/rykcj8kmM?type=view
--		p 7-2	資料類型
--                  https://docs.microsoft.com/zh-tw/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15
--		p 8-5	關聯運算子(operators) (p8-12, 14, 18, 21, 27)

use master;
go

--  執行指令如一般程式語言
declare @x int = 20
print @x								-- variable
print 'Hello SQL server'		-- string
print ('Hello SQL server')		-- string 也可以
print 'cos : '+str(cos(1))		-- Math.
print '1+1 = '+str(1+1)			-- str + str(expression)
go

print @x								-- error 
go


--	建立一資料庫
if db_id ('LabDB') is not null   -- master → view → sys.database  → database_id
    drop database LabDB;
go

drop database if exists LabDB;  -- 另一種寫法

create database LabDB;
go


use LabDB;
go

--	資料類型 (Transact-SQL)
--	https://docs.microsoft.com/zh-tw/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15


--	下列範例會使用 bigint、int、smallint，和 tinyint 資料類型建立資料表。 
--			SQL Server 中共有 tinyint，smallint，int，bigint 等四種整數類型。 
--			若要節省資料庫中的空間，請使用能夠包含所有可能值的最小資料類型。 

use LabDB;
go

create table Table1 (  
    BigIntColumn     bigint ,
    IntColumn          int,
    SmallIntColumn smallint,
    TinyIntColumn   tinyint
);  
select * from Table1;
go  


insert into Table1 values (9223372036854775807, 2147483647, 32767, 255);
go 5


select * from Table1;

select BigIntColumn, IntColumn, SmallIntColumn, TinyIntColumn 
from Table1
go


--	下列範例會使用 decimal 和 numeric 資料類型建立資料表。
--			decimal 與 numeric 是具有固定有效位數和小數位數的數值資料類型。 
--			decimal 與 numeric 相同功能，不同名稱，可以交換使用。
--			decimal宣告比較特別，decimal(p,s)   p代表所有位數，s代表小數點右邊的數量 比如 0.001  p=4 ,s=3
--			值會插入至每個資料行。 結果會使用 SELECT 陳述式傳回。

--  https://docs.microsoft.com/zh-tw/sql/t-sql/data-types/decimal-and-numeric-transact-sql?view=sql-server-ver15

create table Table2  (  
    DecimalColumn decimal(20,6) ,
    NumericColumn numeric(20,6)
); 
select * from Table2
go

insert into Table2 values (12345.678999888, 12345.678999);  
go  

--	select DecimalColumn, NumericColumn (全選可省)
select * from Table2;  
go


--	下列範例會使用 money 和 smallmoney 資料類型建立資料表。 
--	money 和 smallmoney 是代表貨幣的資料類型。
--	在儲存貨幣的類型上一般可以選擇 : int、float、money 和 smallmoney、decimal 和 numeric。
--	根據存儲數據的精確度可以有不同的選擇 :
--			int 只能儲存整數
--			money 和 smallmoney 精確到它們所代表的貨幣單位的萬分之一
--			decimal 和 numeric 可以定義小數位數和儲存的精確度，使用上會更有彈性
--			float 不適合對貨幣這種需要精確度的數值類型

create table Table3  (  
    MoneyColumn money ,                     --  Money 的定義相當於 Numeric(19,4)
    NumericColumn smallmoney
);  
go  

--	SQL Server中 Numric, Decimal, Money 三種欄位型別的區別
--  https://www.itread01.com/content/1546046649.html

insert into Table3 values (922337203685477.5807, 214748.3647);  
insert into Table3 values (2.15, 214748.3647);  

select * from Table3
go  


declare
    @mon1 money=100,             @mon2 money=339,            @mon3 money=10000,           @mon4 money,
    @dec1 decimal(19,4)=100,   @dec2 decimal(19,4)=339,  @dec3 decimal(19,4)=10000,  @dec4 decimal(19,4)

set	@mon4 = @mon1/@mon2*@mon3		-- 2949.00  怪怪的
set	@dec4 = @dec1/@dec2*@dec3		    -- 2949.8525

select	@mon4 as mon4,	@dec4 as dec4


--	下列範例會使用 char 和 varchar 資料類型建立資料表。 建議使用 Unicode 編碼來儲存
--		char(n)  : 表示固定大小的字串資料。	n 為定義字串的大小，基本字元不可變動長度。
--						如果長度不足會自動補上空格(補滿到 n 個, 固定長度的概念)。
--		varchar(n | max) :  可變大小字串資料。可以使用 n 或 max (2G)來定義字串大小，長度可變動。
--		text :	 是最大長度的字串。可允許 2^31-1 (2,147,483,647) 的可變長度。

--	由於各國有不同的語言與文字，所以以往在儲存文字時會以特定的編碼來儲存，
--		如早前的繁體中文就使用 Big5，簡體中文使用 GB，但是由於同一個系統需要處理不同的語系時，
--		常會有亂碼的問題發生，後來為了統一所有的字元碼，
--		國際編碼組識(ISO/IEC) 便推出了 Unicode (UTF-8、UTF-16、UTF32)，簡稱為萬國碼。
--		資料欄位需要支援 Unicode，請使用 nchar，nvarchar，ntext 型態。
--		資料庫設計時，如果欄位會儲存到文字，都建議使用 Unicode 編碼來儲存。

create table Table4  (  
    CharColumn           char(6) ,
    VarcharColumn       varchar(6),
	nCharColumn          nchar(6) ,
    nVarcharColumn      nvarchar(6),
	VarcharmaxColumn varchar(max),
	TextColumn              text
);  
go  


--  Error on nCharColumn 發生 
insert into Table4 values ('better', 'best', 'abcdefg', 'hij', 'goodbetterbest', 'abcdefghijk');
select * from Table4
go


--	下列範例會使用 datetime 和 datetime2 資料類型建立資料表。 
--		在 SQL Server 中，使用 date 表示日期類型，使用 time 表示時間類型，
--		使用 DateTime 和 DateTime2 表示日期和時間的組合。這些數據類型佔用的存儲空間各不相同；
--		當存儲大量數據時，合理的選擇小數秒的精度，能夠節省數據的佔用空間。

create table Table5 (  
    DatetimeColumn datetime ,					-- Default (3)
    Datetime2Column datetime2,
	SmalldatetimeColumn smalldatetime,	-- 秒四捨五入 0.5 分
	DateColumn date,
	TimeColumn time(4),
	DatetimeoffetColumn datetimeoffset(3),
);  
go  

insert into Table5 values (
    '2020/10/11 12:20:30.2',     
	'10/12/2020 13:30:45.2',							-- 注意日期格式
	'2020/10/13 14:45:30',                             -- 30秒, 29捨30入
	'2020/10/14',
	'15:30:20',
	'2020/10/15 16:25:46 +08:00'					-- try UTC : getutcdate()
);
select * from Table5;
go

--	將'字串'轉換成各種 date 和 time 資料類型的結果
select
     cast ('2007-05-08 12:35:29. 1234567 +12:15' as time(7)) as 'time',  
     cast ('2007-05-08 12:35:29. 1234567 +12:15' as date) as 'date',   
     cast ('2007-05-08 12:35:29.123' as smalldatetime) as 'smalldatetime',  
     cast ('2007-05-08 12:35:29.123' as datetime) as 'datetime',
     cast ('2007-05-08 12:35:29. 1234567 +12:15' as datetime2(7)) as 'datetime2',
     cast ('2007-05-08 12:35:29.1234567 +12:15' as datetimeoffset(7)) as 'datetimeoffset'; 


--	下列範例會使用 bit 資料類型建立資料表。
--	bit是一種整數資料類型，它的值有1、0或NULL
--			TRUE 和 FALSE 可以轉換為 bit : TRUE 為 1，FALSE 為 0。
--			一般在儲存布林值的時候會使用 bit 資料類型。
--			binary(n)是固定長度的二進位資料，n 是 1 ~ 8000 的值。
--			varbinary(n | max)是可變長度的二進位資料，n 是 1 ~ 8000 的值，max 儲存體上限是 2GB。

create table Table6 (
	bitColumn bit,
	binaryColumn binary(10),
	varbinaryColumn varbinary(10)
);
insert into Table6 values(1, 1010, 1010) 
select * from Table6

--	介紹 datatype : photo and text 
--	https://docs.microsoft.com/zh-tw/sql/t-sql/data-types/ntext-text-and-image-transact-sql?view=sql-server-ver15

drop table if exists Table1, Table2, Table3, Table4, Table5, Table6