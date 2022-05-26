--	Module 13 系統內建函數轉換函數介紹
--		13-1 : CAST()、 CONVERT() 以及 PARSE() 
--		13-2 : TRY_CAST()、TRY_CONVERT() 以及 TRY_PARSE() 
--		13-3 : 常見的轉換問題 

-- Lab01 CAST()、 CONVERT() 以及 PARSE()

--		這些函式會將某種資料類型的運算式轉換成另一種資料類型。
--		CAST屬於ANSI 標準SQL語法格式，所有的資料庫都支持CAST，其語法格式也一致。
--				語法 : CAST ( expression AS data_type [ ( length ) ] )
				select cast(10.6496 as int), cast(10.6496 as numeric), cast(10.649666 as money);
				select cast('123' as int) + 1000;

--		CONVERT不算是SQL標準規定的語法，有些資料庫支持、有些不支持，而且含義也會不同
--				語法 : CONVERT ( data_type [ ( length ) ] , expression [ , style ] )
				select convert(int, '123') + convert(int, '456'); 
				select convert(varchar, getdate(), 111);

--		PARSE 僅適用於從字串轉換到日期/時間及數字類型, 傳回 T-SQL 要求資料類型的運算式結果
--				語法 : PARSE ( string_value AS data_type [ USING culture ] ) 
				select parse ('1234' as int) + 4567;
				select parse ('Monday, 13 December 2010' as date using 'zh-TW'); 

-- 使用CAST字串轉數字

--	文字轉換成整數
select cast ('123' as int) + 1000; 
select 1000+'123'
select '123'+1000
select 'Price : '+1000   -- error

use LabDB;
select * from Northwind.dbo.Orders

--  使用 CAST 來串連數值及字串運算式
select 'Price : '+cast (Freight as varchar(10)) as F_Price, Freight
from  Northwind.dbo.Orders
where Freight between 10.00 and 20.00;  
go

--  CAST 日期轉換
select	cast(getdate() as date) as [datetime as date],     -- 為何用中括號[ ]? 因為空格  
			cast(getdate() as time) as [datetime as time];  

--  如果不考慮 style 這個可選參數，CAST 和 CONVERT 功能並無差別
declare @N1 varchar(30)='123', @N2 varchar(30)='456'
select @N1 + @N2; 
select cast(@N1 as int) + cast(@N2 as int); 
select convert (int, @N1) + convert(int, @N2); 
select cast(@N1 as int) + convert(int, @N2);


--  CONVERT 指定"第三個參數" STYLE "日期格式樣式" 格式轉換
select getdate()
select convert(varchar, getdate(), 100); -- mon dd yyyy hh:mmAM (or PM)  -- 10  2 2008 11:01AM          
select convert(varchar, getdate(), 101); -- mm/dd/yyyy - 10/02/2008                  
select convert(varchar, getdate(), 102); -- yyyy.mm.dd - 2008.10.02           
select convert(varchar, getdate(), 103); -- dd/mm/yyyy
select convert(varchar, getdate(), 104); -- dd.mm.yyyy
select convert(varchar, getdate(), 105); -- dd-mm-yyyy
select convert(varchar, getdate(), 106); -- dd mon yyyy
select convert(varchar, getdate(), 107); -- mon dd, yyyy
select convert(varchar, getdate(), 108); -- hh:mm:ss
select convert(varchar, getdate(), 109); -- mon dd yyyy hh:mm:ss:mmmAM (or PM)  -- Oct  2 2008 11:02:44:013AM   
select convert(varchar, getdate(), 110); -- mm-dd-yyyy
select convert(varchar, getdate(), 111); -- yyyy/mm/dd
select convert(varchar, getdate(), 112); -- yyyymmdd
select convert(varchar, getdate(), 113); -- dd mon yyyy hh:mm:ss:mmm  -- 02 Oct 2008 11:02:07:577     
select convert(varchar, getdate(), 114); -- hh:mm:ss:mmm(24h)
select convert(varchar, getdate(), 120); -- yyyy-mm-dd hh:mm:ss(24h)
select convert(varchar, getdate(), 121); -- yyyy-mm-dd hh:mm:ss.mmm
select convert(varchar, getdate(), 126); -- yyyy-mm-ddThh:mm:ss.mmm  -- 2008-10-02T10:52:47.513
select convert(varchar(7), getdate(), 126)                 -- yyyy-mm
select right (convert(varchar, getdate(), 106), 8)          -- mon yyyy

-- https://docs.microsoft.com/zh-tw/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15

--PARSE 字串轉數值
select parse ('1234' as int) + 4567;

--PARSE  繁體中文 zh-TW，日期的順序是：ymd
--英文 en-US，日期的順序是：mdy
select	parse('01/02/03' as date using 'zh-TW') ,	-- yy/mm/dd
			parse('01/02/03' as date using 'de-DE') ,		--	dd/mm/yy
			parse('01/02/03' as date using 'en-US') ,		--	mm/dd/yy
			parse('01/02/03' as date );							--	yy/mm/dd

--PARSE 使用貨幣符號
select	parse ('NT$123,456.789' as money using 'zh-TW') as '台幣',
			parse ('€123.456,789' as money using 'de-DE') as '歐元',		--  注意撇節和小數點的差異
--    		parse ('€123,456.789' as money using 'de-DE') as '歐元',		-- Error : ","   "."
			parse ('$123,456.789' as money using 'en-US') as '美金';
			   
select parse ('€345,98' as money using 'de-DE') as Result

--CAST、CONVERT、PARSE 使用方式比較
select cast ('123' as int), convert (int, '456'), parse ('789' as int);
select cast ('123' as int) + convert (int, '456') + parse ('789' as int);


--使用 CAST、CONVERT、PARSE 日期轉換
declare @d varchar(20);
set @d = '2020-4-14';
select	cast (@d as datetime ),
			convert (datetime, @d, 111),
			parse (@d as datetime using 'zh-TW');
