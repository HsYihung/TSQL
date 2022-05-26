--	Module 8 撰寫簡易的 SELECT 查詢語句
--		8-1 : SELECT 查詢語句
--		8-2 : 使用欄位(Column) 的別名
--		8-3 : 使用 DISTINCT

--	SELECT 是最常用到的 SQL 語句，它是用來從資料庫取得資料，這個動作我們通常稱為查詢(query)
--	SELECT 可以從 SQL Server 中的一個或多個資料表中，選取一個或多個資料行 column。
--	配合使用的子語句大多是用於篩選資料的條件，會在後面章節仔細的講各種子語句條件。
--	SELECT 後面接 * 號代表傳回資料表的所有欄位。
--	FROM 後所接的資料表名稱為待查資料庫的"資料表名稱" table name。
--	SELECT 也可以用於計算，如 : SELECT (1+1);

--  TSQL Select 完整句法 : 
--			SELECT select_list [ INTO new_table ]
--			[ FROM table_source ]
--			[ WHERE search_condition ]
--			[ GROUP BY group_by_expression ]
--			[ HAVING search_condition ] 
--			[ ORDER BY order_expression [ ASC | DESC ]]
--	https://docs.microsoft.com/zh-tw/sql/t-sql/queries/select-transact-sql?view=sql-server-ver15


--	在系統開發時，若非必要盡量避免使用 SELECT *，會耗費較多的系統資源，
--			每次查詢時取得需要的欄位即可。

--	可以傳回 *,  column_name 資料表中指定的欄位。
--	COUNT(*) 可以傳回資料表中所包含的資料筆數。
--	TOP(n) 可以指定傳回資料的數量。


--	Lab01 SELECT 查詢語句
use Northwind;
go

-- 傳回所有資料列
select * from Employees;

-- 傳回特定欄位
select * from Employees

select LastName+' '+FirstName as name, Title, BirthDate
from Employees;

--	搭配 ROW_NUMBER 函數,顯示資料列號碼, 並用 * 號傳回資料表所有的欄位
select row_number() over (order by EmployeeID desc) as rowid, * 
from Employees;

--	傳回特定筆數的資料列, 沒有tail 或 bottom 
select top 3 * from Employees where TitleOfCourtesy='Ms.';

--	傳回 50% 的資料列
select top(50) percent * from Employees where TitleOfCourtesy='Ms.';

--	傳回共有幾筆資料數
select count (*) from Employees where TitleOfCourtesy='Ms.';

--	SELECT 陳述式的邏輯處理順序
--  https://docs.microsoft.com/zh-tw/sql/t-sql/queries/select-transact-sql?view=sql-server-ver15


-- select 1 傳回的值可做布林值來用, 經常搭配 exist 使用
select  2 from Employees where TitleOfCourtesy='Ms.';					-- 存在
select  1 from Employees where TitleOfCourtesy='MD.';				-- 不存在

