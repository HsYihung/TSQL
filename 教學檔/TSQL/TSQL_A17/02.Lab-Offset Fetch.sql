--	Module 17 - Lab02 SELECT敘述的進階查詢
--	使用 TOP 以及 OFFSET-FETCH 來篩選資料

--	使用 OFFSET 和 FETCH 可以限制傳回的資料列，可以過濾篩選特定範圍的資料列。
--	OFFSET-FETCH 是配合 ORDER BY 子句的延伸功能。
--	OFFSET 和 FETCH 子句是依據 ANSI標準，所以比TOP有更好的相容性。
--	OFFSET 可以指定跳過行數。	FETCH 可以指定需要取出的資料數量。


use Northwind;
go

select * from Orders

--	傳回以 ShipCity 排序後的前20個訂單
select top (20) ShipName, ShipAddress, ShipCity  
from Orders 
order by ShipCity;  


--	傳回以 ShipCity 排序後的前 20% 訂單
select top (20) percent ShipName, ShipAddress, ShipCity  
from Orders 
order by ShipCity;


--	傳回所有的訂單資料
select ShipName, ShipAddress, ShipCity  
from Orders 
order by ShipCity;


--	使用子句 OFFSET 100 ROWS 略過前 100 筆資料列
select ShipName, ShipAddress, ShipCity     -- try top 20/ 5 percent
from Orders 
order by ShipCity 
offset 100 rows;


--	使用子句 OFFSET 0 ROWS 從第一個資料列開始，
--	然後再使用 FETCH NEXT 10 ROWS ONLY，將傳回的資料列限制在已排序結果內的10筆資料列。

select * from Orders

select  row_number() over(order by orderid) as RowNo, orderid, ShipName, ShipAddress, ShipCity     -- try top 20/ 5 percent
from Orders 
order by ShipCity 
offset 10 rows 
fetch next 100 rows only; 

--	以下範例使用 OFFSET 和 FETCH 子句，來實作查詢的分頁
--	宣告3個變數 @Pages(頁數)、@PageSize(每頁筆數)、@RowNumber(第N筆資料開始)
--	可以手動指定@Page值為 1~10(總筆數為830)
--	使用 @RowNumber = ((@Pages-1)*@PageSize) + 1 運算式來指定OFFSET值

declare		@Pages int = 80, @PageSize int = 10,  @RowNumber int;
set @RowNumber = ((@Pages-1)*@PageSize) + 1; -- ((80-1)*10)+1=791

select  ShipName, ShipAddress, ShipCity
from Orders 
order by ShipCity 
	offset @RowNumber - 1 rows 
 	fetch next @PageSize rows only;


-- 使用 OFFSET 和 FETCH
-- 依據日期排序，但是跳過前 10 筆資料列，再取 10 筆資料列；也就是說：依據日期排序，
-- 但僅查詢第 11 到 20 筆的資料列。
use Northwind

declare @offset tinyint =10, @fetch tinyint =10
select OrderID, CustomerID, EmployeeID, OrderDate
from Orders
order by OrderDate desc
offset @offset rows
fetch next @fetch rows only

