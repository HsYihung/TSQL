 --	Module 9 基本資料的查詢與篩選
--		9-1 : 使用 WHERE 子句來篩選資料
--		9-2 : T-SQL中運算子執行的優先序
--		9-3 : 使用 LIKE 搭配萬用字元(Wildcard characters) 來 "比對字串資料"

--	在 SELECT 查詢語句使用 WHERE 關鍵字搭配運算子來指定”符合條件”的資料。
--	也可用於UPDATE、DELETE，如果是 UPDATE ，便是指定要更新的資料"列"。 
--	如果是 DELETE，便是指定要刪除的資料列。

--	WHERE 子句為指定查詢所傳回之資料列的搜尋條件。
--	WHERE 可以使用多個條件來判斷所需要的資料。
--	可以使用 AND 或 OR 運算子來下達多個 WHERE 條件式 :
--			AND : 左右兩條件皆須符合。
--			OR : 左右兩條件至少須符合一個。
--	可以使用小括號()來執行更複雜的查詢條件，小括號內的條件式會優先判斷。
--			例如 : WHERE 條件A AND (條件B OR 條件C)，SQL會優先對條件B和條件C做 OR 邏輯運算，
--			所得出的結果再與條件A做AND邏輯運算。


-- Lab01 使用 WHERE 條件式
use Northwind;
go

select * from Customers

--	(1)使用簡單的等式
select CustomerID, ContactName, City
from Customers  
where City = 'Mexico D.F.';   -- 大小寫一樣

select CustomerID, ContactName, City
from Customers  
where City != 'Mexico D.F.';
--where City <> 'Mexico D.F.';
--where NOT City = 'Mexico D.F.';    -- not prefer


--	(2)尋找所含值為字串的一部份
select CustomerID, ContactName,City
from Customers
--where City like ('M%');    -- 字首是 M
--where City like ('%M');
where City like ('%M%');

--	(3)使用比較運算子
select * from Orders

select OrderID, CustomerID, Freight, ShipCity, ShipName
from Orders 
where Freight >10
--where Freight !>10


--	(4)符合多個條件中任何一個條件的資料列
select OrderID, CustomerID, Freight, ShipCity, ShipName
from Orders
where Freight > 10 and ShipCity = 'Oulu'

--	(5)尋找符合數個條件的資料列
select OrderID, CustomerID, Freight, ShipCity, ShipName 
from Orders 
where Freight > 10 and CustomerID like '%VI%' and ShipName like '%VI%'

--	(6)尋找位於值清單中的資料列
select OrderID, CustomerID, Freight, ShipCity, ShipName 
from Orders
where CustomerID in ('VINET', 'TOMSP')
-- where CustomerID ='VINET' or CustomerID ='TOMSP'

--	(7)尋找位於兩個值之間的資料列
select OrderID, CustomerID, Freight, ShipCity, ShipName 
from Orders 
where Freight between 10 and 20; 

--	跟上面(7)的結果一樣
select OrderID, CustomerID, Freight, ShipCity, ShipName 
from Orders 
where Freight >= 10 and Freight <= 20; 



--  請找出 Northwind 資料庫中 [Order Details] 中總售價 (UnitPrice*Quantity)> 1000 清單






