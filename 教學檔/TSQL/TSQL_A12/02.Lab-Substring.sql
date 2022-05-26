--	Module 12 - Lab02 SUBSTRING() LEFT() RIGHT() 函數

--  SUBSTRING() 是回傳運算式指定部份的函數。
--	運算式可以是 character、binary、text、ntext 或 image。
--	語法是 SUBSTRING ( expression, start, length )
--	需要指定從哪裡開始切割字串，切割出幾個字組成一個字串。

--	start 編號是以 1 為基礎，這表示運算式中的第一個字元為 1。如果超過範圍，會回傳空字串。
--	length 如果超過範圍，會回傳從 start 到字串結尾的字串。如果為負數，會產生錯誤。


select SubString ('abcdef', 2, 3);
select SubString ('SQL Server 科技股份有限公司', 5, 9);

-- start 大於運算式中的字元數,會回傳空字串
select SubString ('abcdef', 10, 1);

--	Error :　length 如果為負數，會產生錯誤。
select SubString ('abcdef', 2, -1);


--	SUBSTRING + LEN 函數,取字串最後一個字元
declare @str varchar(40);
set @str = 'SQL Server 科技股份有限公司';
select SubString (@str, 1, 13) +'(' +SubString (@str, 14, 1) +')'+ SubString (@str, len(@str)-1, 2);
	

--	LEFT() 會回傳最左邊的 N 個字元數。
--	語法 LEFT ( character_expression , integer_expression )
--	character_expression 可以是常數、變數或資料行。
---	character_expression 是 Unicode 資料類型時會傳回 nvarchar ，否則是傳回 varchar。
--	integer_expression 指定長度如果超過字串長度，會傳回全部的字串內容。
--	integer_expression 如果為負數會產生錯誤。

--	LEFT() 回傳字串左側算起的兩個字元
select left ('abcdefg', 2);

--	回傳全部字串
select left ('abcdefg', 20);

--	Error : 如果為負數，會產生錯誤。
select left('abcdefg', -2);


--	RIGHT() 會回傳最右邊的N個字元數
--	語法 : RIGHT ( character_expression , integer_expression )
--	character_expression 可以是常數、變數或資料行。
---	character_expression 是 Unicode 資料類型時會傳回 nvarchar ，否則是傳回 varchar。
--	integer_expression 指定長度如果超過字串長度，會傳回全部的字串內容。
--	integer_expression 如果為負數會產生錯誤。

--	RIGHT() 回傳字串右側算起的兩個字元
select right ('abcdefg', 2);

--	回傳全部字串
select right ('abcdefg', 20);

--	Error : 如果為負數，會產生錯誤。
select right ('abcdefg', -2);


--	此函式會在第二個字元運算式內搜尋一個字元運算式，並傳回第一個運算式的"開始位置" (如果找到的話)。
--	charindex ( expressionToFind , expressionToSearch [ , start_location ] ) 
select charindex('is', 'This is a string')
select charindex('is', 'This is a string', 4)

--  用指令 charindex(),  substring 找出 NorthWind 中 Employees 中 
--  欄位HomePhone 中的區域號碼不含()
use Northwind
select HomePhone from Employees
























use Northwind
select	HomePhone, 
			charindex('(', HomePhone),
			charindex(')', HomePhone),
			SubString (HomePhone, charindex('(', HomePhone)+1, charindex(')', HomePhone)-2)
from employees