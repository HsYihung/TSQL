--  Module 10 欄位為空值時的查詢以及將查詢的結果予以排序
--		10-1 : Null Value (空值)的意義
--		10-2 : 使用 IS NULL 運算子 
--		10-3 : 使用 ORDER BY 子句將查詢結果排序

--	NULL 是資料庫中使用的特殊標記，代表的是未知的屬性值 (unknown property value)。
--	NULL 是一種狀態，不是空字串(針對字元或日期類型)，也不是零值(針對數值類型)。
--	將 Null 直接用於邏輯運算是沒有意義的。任何數值與 Null 進行運算其結果均為 Null 。
--  在 WHERE 的條件判斷是否為 NULL 時，例如  WHERE [address]=NULL 是無法正確執行的，
--				必須寫成 WHERE [address] IS NULL 或是 WHERE [address] IS NOT NULL 


--	Lab01 查詢 NULL , IS NULL 及 IS NOT NULL
use Northwind;
go

select 'Won'+null+'derful'				-- NULL is weired

select * from Orders						

--	show Null 欄位
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName
from Orders 
--where Freight = null
where Freight is null


--	Null 運算 NULL * NULL = NULL            EmployeeID*Freight
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName, EmployeeID*Freight
from Orders 


--	Null 字串相加 NULL + NULL = NULL   CustomerID+ShipName
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName, CustomerID+ShipName
from Orders


--	ISNULL 函式是判斷欄位的值，若為 Null 的時，可以將 Null 取代成自己所要的值。
--	在做數字運算時，可以先判斷欄位如果為 Null，就先給予預設值 0，再做計算
--	用指定的預設值來代替NULL
select OrderID, EmployeeID, isnull(EmployeeID, 0) as EmpID, CustomerID, Freight, 
			ShipCity, ShipName, isnull(CustomerID+ShipName, 'info missing')
from Orders


--	COALESCE 會傳回運算式中第一個非 Null 的值，下列會傳回第三個值。
--	COALESCE 的引數至少要有一個是非 Null 常數的運算式。

--	ISNULL 函數和 COALESCE 運算式具有相似的目的，但運作方式不同。
--	ISNULL 只會評估一次。 COALESCE 會評估多次運算式的輸入值。
--	ISNULL 只接受兩個參數，COALESCE 接受數目不定的參數。

select coalesce (null, null, 'third_value', 'fourth_value');

--	Error : COALESCE 的引數至少要有一個是非 NULL 常數的運算式。 
select coalesce (null, null, null, null, null);

--	傳回運算式中所有欄位中,第一個非 Null 的值
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName,
	coalesce (CustomerID,  ShipCity, ShipName) as FirstNotNull_coalesce,  
	isnull (CustomerID, isnull(ShipCity, ShipName)) as FirstNotNull_isnull 
from Orders


--	找出orders 資料表中，EmployeeID is not null 且Freight小於10的資料
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName
from Orders
where EmployeeID is not null and Freight < 10


--	找出有 shipname 的所有 orders
select OrderID, EmployeeID, CustomerID, Freight, ShipCity, ShipName
from Orders
where ShipName is not null			-- try ShipName != NULL
order by CustomerID                  -- 排序
