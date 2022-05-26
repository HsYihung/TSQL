--	Module 14 系統內建函數其餘函數以及CASE 運算式介紹
--		14-1 : 使用邏輯函數
--		14-2 : 空值(NULL) 處理函數:ISNULL() vs. COALESCE()
--		14-3 : IIF()、CHOOSE()、CASE 運算式 

--		ISNULL 用指定的取代值來取代 NULL。
--				語法 : ISNULL ( check_expression , replacement_value )

--		COALESCE 依照傳入值的順序依序判斷非NULL的值，並傳回第一個判斷為非NULL的值。
--				語法 : COALESCE ( expression [ ,...n ] )

--		ISNULL只會判斷一次，COALESCE 可能會判斷多次


--	Lab01 空值(NULL) 處理函數 : ISNULL()、COALESCE() 

use Northwind;
go

select  * from Orders

--	下列範例會尋找訂單資料表中所有Freight , ShipVia 數值的加權平均值
--	會將 Weight 的資料欄位中用 10 來取代NULL
select  avg(isnull(Freight, 10)),  avg(Freight), avg(ShipVia),  avg(ShipVia*1.0), avg(convert(decimal, ShipVia))
from Orders;  

select sum(isnull(Freight, 10)),  sum(Freight), sum(ShipVia), sum(ShipVia*1.0), sum(convert(decimal(10, 2), ShipVia))
from Orders;  


--	下列範例使用 ISNULL 測試資料行中的 NULL 值，如果為NULL就顯示 0。
select Freight, isnull(Freight, 0) as MinPayment, CustomerID, isnull(CustomerID, 0)
from Orders  
--order by CustomerID
order by Freight


--	下列範例示範 COALESCE 傳回第一個判斷為非NULL的值。
select CustomerID, ShipName, ShipAddress, Freight,
              coalesce (ShipName, ShipAddress) as FirstNotNull,
			  isnull(ShipName, isnull(CustomerID, '000000')) as isnull_func
from Orders 
 