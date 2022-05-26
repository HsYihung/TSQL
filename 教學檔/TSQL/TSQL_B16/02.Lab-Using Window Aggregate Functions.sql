--  Module 16.   02.Lab - Using Window Aggregate Functions.sql

--  彙總函式會根據一組值來執行計算，並傳回單一值。 除了 COUNT(*) 之外，
--  彙總函式會忽略 Null 值。 彙總函式經常用來搭配 SELECT 陳述式的 GROUP BY 子句使用。

--  所有彙總函式都具有決定性。 換句話說，使用一組特定輸入值呼叫時，
--  彙總函式會在每次呼叫時傳回相同的值。 如需函式確定性的詳細資訊，
--  請參閱決定性和非決定性函式。 OVER 子句可以跟在所有彙總函式之後，
--  但 STRING_AGG、GROUPING 和 GROUPING_ID 函式除外。

use AdventureWorks ;
go

-- Using 【OVER】:
-- Rank products by price from high to low
select * from Purchasing.PurchaseOrderDetail

select PurchaseOrderID, OrderQty, ProductID, UnitPrice,
			rank() over (order by UnitPrice desc) as PriceRank,			
			dense_rank() over (order by UnitPrice desc) as PriceDense_Rank,
			row_number() over (order by UnitPrice desc) as PriceRow_Number,
			NTILE(100) over (order by UnitPrice desc) as PriceNTILE			-- try dense_rank
from Purchasing.PurchaseOrderDetail
order by PriceRank


-- Rank products by price in descending, order in each category.
select PurchaseOrderID, OrderQty, ProductID, UnitPrice,	
			rank() over (Partition by PurchaseOrderID order by UnitPrice desc) as PriceRank,
			dense_rank() over (Partition by PurchaseOrderID order by UnitPrice desc) as PriceDense_Rank,
			row_number() over (Partition by PurchaseOrderID order by UnitPrice desc) as PriceRow_Number,
			NTILE(3) over (Partition by PurchaseOrderID order by UnitPrice desc) as PriceRank_NTILE
from Purchasing.PurchaseOrderDetail
order by PriceRank



select PurchaseOrderID, OrderQty, ProductID, UnitPrice,
			sum(UnitPrice) over (Partition by PurchaseOrderID order by UnitPrice desc) as PriceSum,
			sum(UnitPrice) over (Partition by PurchaseOrderID) as PriceSum,
			sum(UnitPrice) over (order by UnitPrice desc) as PriceSum,
			sum(UnitPrice) over () as PriceSum
from Purchasing.PurchaseOrderDetail
order by PurchaseOrderID


