--	Module 13 - Lab02  TRY_CAST()、 TRY_CONVERT() 以及 TRY_PARSE() 

--	TRY_CAST, TRY_CONVERT, TRY_PARSE傳回指定資料類型的值，如果失敗會傳回NULL
--			語法 : TRY_CAST ( expression AS data_type [ ( length ) ] ) 
--			語法 : TRY_CONVERT ( data_type [ ( length ) ], expression [, style ] ) 
--			語法 : TRY_PARSE ( string_value AS data_type [ USING culture ] )

--	以下的範例示範當轉換失敗時，TRY_CAST 會傳回 null。
select cast ('test' as float);								-- error : str to float
select try_cast ('test' as float);                         -- NULL

--  Error :　以下的範例示範當明確不允許轉換時，TRY_CAST 會傳回錯誤。
select try_cast(4 as xml); 

--TRY_CAST 成功
select try_cast ('2020-4-14' as datetime2) as result;  

--使用 CAST 及 TRY_CAST 轉換不存在的日期
select cast ('2020-2-30' as datetime2) as Result;
select try_cast ('2020-2-30' as datetime2) as Result;


--轉換失敗時，TRY_CONVERT 會傳回 null
select try_convert (float, 'test');

--當明確不允許轉換時，TRY_CONVERT 會傳回錯誤。
select try_convert (xml, 4) as result;   -- 不允許從資料類型 int 明確轉換至 xml。

--TRY_CONVERT 成功
select try_convert (datetime2, '12/31/2019') as result; 

--用 CONVERT 及 TRY_CONVERT 轉換不存在的日期
select convert (datetime2, '2/31/2019') as result; 
select try_convert (datetime2, '2/31/2019') as result; 


--TRY_PARSE 轉換失敗
select try_parse ('abcdefg' as datetime2 using 'en-US') AS Result;

-- TRY_PARSE() 轉換函數：去除貨幣符號
select try_parse ('NT$123,456' as money using 'zh-TW') N'金額(台幣)'
go
 

-- TRY_PARSE() 判斷輸入的字串，是否可以轉換為指定的貨幣
declare		@Input varchar(20)='NT$1234.567', 
				@Price money;
set @Price = try_parse (@Input as money using 'zh-TW');
if @Price is not null
	select @Price as '金額(台幣)';  -- 很像異常處理程式不會斷掉 try ... catch
else
	select '轉換失敗';
go

use Northwind
select  PostalCode from Suppliers
select cast (PostalCode as int)  from Suppliers; 　　　-- Error 'PostalCode' 中有文字
select convert (int, PostalCode) from Suppliers;  　　　-- Error 'PostalCode' 中有文字
select parse (PostalCode as int using 'en-US') from Suppliers;  -- Error 'PostalCode' 中有文字

--  程式不會斷掉, 如果再加上 isnull or coalesce 就更完美了
select coalesce (try_cast (PostalCode as int), 0)  from Suppliers; 
select try_convert (int, PostalCode) from Suppliers;							--  try to add "coalesce"
select try_parse (PostalCode as int using 'en-US') from Suppliers;	--  try to add "coalesce"
