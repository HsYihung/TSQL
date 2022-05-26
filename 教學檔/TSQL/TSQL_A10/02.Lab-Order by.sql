--	Module 10 - Lab02 使用 ORDER BY 子句將查詢結果排序
--		ORDER BY 關鍵字 (SQL ORDER BY Keyword)
--		將 SELECT 取得的資料集依某欄位來作排序，而排序分別可以由小至大 (ascending; 預設 / asc)，
--		或由大至小 (descending / desc)。

--  依據指定的資料行清單排序查詢的結果集，並選擇性地將傳回的資料列限制在指定範圍內。 
--  除非指定 ORDER BY 子句，否則不保證結果集中傳回資料列的順序。

--  指定要排序查詢結果集的資料行或運算式。 排序資料行可以指定為名稱或資料行別名，
--			或代表選取清單中資料行位置的非負整數。

--  您可以指定多個排序資料行。 資料行名稱必須是唯一名稱。 ORDER BY 子句中的排序資料行順序
--			用來定義排序結果集的組織。 也就是說，結果集依據第一個資料行來排序，然後該排序的清單
--			依據第二個資料行來排序，依此類推。

--  ORDER BY 子句中所參考資料行名稱必須對應到選取清單中的資料行，或語意明確之 
--			FROM 子句中所指定資料表的已定義資料行。 如果 ORDER BY 子句參考選取清單中的
--			資料行別名，資料行別名必須單獨使用，而不是在 ORDER BY 子句中作為某個運算式的一部分

use Northwind;
go

-- 找出 CustomerID 為 V字母開頭的orders
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like 'V%'

--以 CustomerID 為 V字母開頭, ShipCity 排序，因未指定排序方式，會使用預設(ASC)
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode
from Orders 
where CustomerID like 'V%'
order by ShipCity


--排序依據的資料欄位並未包含在SELECT欄位清單中
select OrderID, CustomerID, Freight, ShipName, ShipPostalCode
from Orders 
order by ShipCity           -- ShipCity 未包含

--依別名排序
select OrderID, CustomerID, Freight, ShipCity as  'C_NAME', ShipName, ShipPostalCode
from Orders 
order by C_NAME                           -- C_NAME


--使用運算式做為排序資料行
select * from dbo.Orders 

select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
order by datepart(year, OrderDate)  -- try month, day


--指定遞減順序
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
order by OrderDate desc;


--指定遞增順序
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
order by OrderDate  asc; 


select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
--order by Freight
order by 3                          --  3 is column index location


--指定遞增和遞減順序
select OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
where Freight >10
order by OrderDate desc, Freight asc;

--top 5 隨機亂數排序
select TOP 5 OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
where Freight >10
order by newid(); 

--搭配 ROW_NUMBER 函數,顯示資料列號碼, 並用 * 號傳回資料表所有的欄位
--select row_number () over (order by OrderID) as ROWID,
select row_number () over (order by CustomerID) as ROWID,
OrderID, CustomerID, Freight, ShipCity, ShipName, ShipPostalCode, OrderDate
from Orders 
order by OrderDate

--	IS NULL 或 IS NOT NULL 判斷運算式是否為 NULL，並傳回布林值結果。
--	IS NULL : 如果判斷式的值是 Null，就會傳回 true；否則會傳回 false
--	IS NOT NULL : 如果判斷式的值是 Null，就會傳回 false；否則會傳回 true
--	WHERE 條件式去判斷 id 欄位是否為 Null 時，必須寫成 where id is null ；反之若要判斷為 id 欄位是否為非 Null 時，則用 where id is not null
--	where id = null 雖然執行上不會產生錯誤，但是是無法得出正確的結果。
