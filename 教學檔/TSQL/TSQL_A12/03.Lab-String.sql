--	Module 12 - Lab03 T-SQL 常用字串函數 : 
--		STR、TRIM、LTRIM、RTRIM、UPPER、LOWER、REPLACE
--			TRIM :移除字串頭尾的空白字元並回傳。
--			LTRIM : 移除字串開頭的空白字元。
--			RTRIM : 移除字串結尾的空白字元。
--			字串是應移除字元的任何字元類型 (nvarchar、varchar、nchar 或 char) 的運算式。
--			字串不允許 nvarchar(max) 和 varchar(max) 類型。
--			傳回類型為 varchar 或 nvarchar。如果輸入字串為 NULL，傳回 NULL。

--  https://docs.microsoft.com/zh-tw/sql/t-sql/functions/string-functions-transact-sql?view=sql-server-ver15

-- 下列範例會將123.45組成的運算式轉換成六個位數的字元字串，小數點後第一位會四捨五入。
select str (123.45, 6, 1);     -- INT to STR,  try 16

-- 當運算式超出指定長度時，字串會傳回 **
select str (123.45, 2, 2);  

-- Error : 運算式非數值時會發生類型轉換錯誤
select str ('ABC');

-- 字元資料靠右對齊，左邊會補空格，右邊會補0
select str (123.45, 20, 5);

-- 下列範例會移除 test 這個字前面和後面的空格。
select trim ( '     test    ') as result;

--下列範例會利用 LTRIM 來移除字串開頭的空白字元。
select ltrim('     Five spaces are at the beginning of this string.');

--下列範例傳回句尾沒有空格的文字。
select rtrim('Removes trailing spaces.   ');  

--大小寫轉換
select upper ('abcdefg');
select lower ('ABCDEFG');


--	利用 Lower, upper 和 RTRIM 函數 來組合並串連姓名。
use Northwind;
go

select * from Orders

select lower(rtrim(CustomerID)) + ', ' + upper (CustomerID) as 'Name', CustomerID
from Orders  
order by CustomerID;  
go


--	並且利用 LOWER、UPPER，且將 UPPER 函數巢狀放置於 LOWER 函數內。
select	lower(SubString(CustomerID, 1, 20)) as 'Lower',
			upper(SubString(CustomerID, 1, 20)) as 'Upper',
			lower(upper(SubString(ShipName, 1, 20))) as 'LowerUpper', CustomerID, ShipName
from Orders  
order by CustomerID;  
go


select	lower(SubString(CustomerID, 1, 20)) as 'Lower',
			upper(SubString (CustomerID, 1, 20)) as 'Upper',
			lower(upper(SubString(ShipName, 1, 20))) as 'LowerUpper', CustomerID, Freight, ShipName
from Orders  
where Freight between 11.00 and 20.00;  


--下列範例將字串中的 cde 取代為 xxx 字串。
select replace ('abcdefghicde', 'cde', 'xxx');  

--  stuff() 函數用於從源字符串中刪除給定長度的字符序列，並從指定的起始索引插入給定的字符序列。
-- STUFF (source_string, start, length, add_string)
--			1. source_string：要修改的原始字符串。
--			2.開始：將刪除給定字符長度並插入新字符序列的起始索引。
--			3.長度：要從原始字符串的起始索引中刪除的字符數。
--			4. add_string：要插入的新字符集(字符串)代替從起始索引中刪除的字符。

select stuff('GoogleFacebookGoogle', 7, 8, 'Google')
select stuff('GoogleFacebookGoogle', 1, 20, 'Google')


--下列範例將字串中的 abcde 反轉為 edcba 字串。
select reverse('abcde')

--下列範例將字串中的 abc 複製 10 次。
select replicate('abc', 10)


