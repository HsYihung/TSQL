--	Module 13 - Lab03 常見的資料型別轉換問題

--	在SQL Server 中有兩種資料轉換方法：一種是顯性資料轉換；另一種是隱性資料轉換。
--	顯性轉換是將資料型態使用轉換函式明確的轉換成另一種型態，常用的方式是 CAST 和 CONVERT 函式。
--	隱性轉換是指兩種不同資料類型進行比較或運算，因為內容可以彼此相容，
--			所以 SQL Server 會自動進行處理，自動判斷將資料型態轉換。
--			例如一個 smallint 的變數跟一個 int 的變數做算數運算，smallint 的變數在運算前會被隱性轉換為 int 型態。
--	隱性轉換或許方便，卻有可能包含未預期潛在的風險，如轉換的錯誤或是整體運行效能的降低。
--	隱性轉換因為要轉換成相同資料類型後才會進行運算，這會產生效能問題，要盡量避免。

-- 隱性轉換
select 1 + '2';
select '1' + 2;

-- 下列範例會定義一個 VARCHAR 類型的變數，將整數值指派給變數，然後使用字串將變數串連。
declare @str varchar(10);                  -- @str is varchar
set @str = 100;                                   --此時會將整數100轉換為字串
select @str + ' 為一字串' as Result;
select @str + 200 as Result;				--  300 好像又轉回 int 整數

--	因為 int 比 varchar 有更高的轉換優先順序，所以 SQL Server 會嘗試將字串轉換成整數，

--	但由於此字串無法轉換成整數，因此會回傳轉換失敗。 
declare @num1 int;
set @num1 = '100';
select @num1 + ' is not a string.' as Result;  -- Error : num1 is INT
-- select @num1 as Result;                 -- int is OK

-- 如果提供可進行轉換的字串，則陳述式會成功，如下列範例所示：
declare @num2 int;
set @num2 = '100';         -- str to int
select @num2 + ' 1' as Result;  -- int + int

-- 字串截斷
select cast (N'ab中文' as char(3));  -- 8 bytes to 3 bytes

use Northwind;
select * from dbo.Orders

select	cast (ShipName as varchar(5)), 
			cast (ShipAddress as char(5))
from dbo.Orders

--	CAST 數值轉換, 10.6496 轉換成 int 或 numeric 類型可能會被截斷或四捨五入
select  cast(10.6496 as int),               -- 被截斷
			cast(10.6496 as numeric);     -- 四捨五入

select cast(10.3496847 as money);     -- 四捨五入

--	Error : 轉換錯誤varchar 值 'A' 轉換成資料類型 int 時，轉換失敗。
select cast('A' as int);

--	當空字串 (' ') 被轉換為 numeric 或 decimal 時，SQL Server 也會傳回錯誤。

select cast(' ' as numeric);
select cast(' ' as decimal);

--	空字串轉為int會自動變為0
select cast(' ' as int);

