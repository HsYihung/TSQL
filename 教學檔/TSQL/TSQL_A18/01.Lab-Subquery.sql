 --	Module 18 子查詢(Subquery) 的運用
--		18-1 : 撰寫傳回單一純量值的子查詢
--		18-2 : 撰寫傳回多個值的子查詢
--		18-3 : 搭配 EXISTS 以及 NOT EXISTS 的子查詢

--	子查詢也稱為內部查詢，而包含子查詢的陳述式又稱為外部查詢。
--	進行多個資料表的查詢，除了使用聯結(JOIN)外，也可以使用 SQL 子查詢 (Subquery)。
--	子查詢就是在一個 SELECT 指令內再放入一個 SELECT 進行查詢。
--	子查詢基本語法和 SELECT 查詢相同。可以將查詢結果做為資料來源或者是判斷值。
--	如果子查詢要做為資料來源使用，必須要給別名，以利於SQL辯識。

--	2017/ 2019  SQL Server		p 9-22 

--	Lab01撰寫傳回單一純量值的子查詢
use Northwind;
go

-- 子查詢允許在運算式的任何位置使用
--	找出Orders 傳回OrderID 後, 再到 Order Detail 中查有幾筆
--  子查詢可在where 中
select * from Orders
select * from [Order Details]

select count(*) 
from [Order Details]
where OrderID = (select OrderID from Orders where OrderID = '10248')	-- 要存在 Orders 中為 True 的概念
--where OrderID = (select OrderID from Orders where Freight= 32.38)
--where OrderID in (select OrderID from Orders where Freight>32.38)
							

select * from Products
select * from [Order Details]

--  子查詢也可在select 中
--  Order Detail 中有的 ProductID 去Product 母檔中確認

select ProductID, ProductName,
			(select sum(od.UnitPrice) from [Order Details] as od where od.ProductID = p.ProductID) as sale
from Products as p
order by sale desc


--	下列陳述式尋找定價大於平均定價的所有產品名稱。
select * from [Order Details]

select OrderID, UnitPrice
from [Order Details]
where UnitPrice > (select avg(UnitPrice) from [Order Details])


--	下列查詢提供了一個以 ANY 比較運算子提出的子查詢範例。 
--	它會尋找清單價格大於或等於任何產品子類別之最大清單價格的產品。

select * from Orders
select * from [Order Details]

select OrderID, UnitPrice
from [Order Details]
where UnitPrice >=								--  > min in any (> = 9.8)
		any (select UnitPrice from [Order Details] where OrderID in ( '10248', '10249'))

--where UnitPrice >=								--  > max (42.4)
	--	all (select UnitPrice from [Order Details] where OrderID in ( '10248', '10249'))


--	依產品類別找出所有產品的名稱
--	=ANY 運算子等同於 IN
--	以下兩個範例結果相同
select * from Products
select * from [Order Details]

select ProductID, ProductName
from Products
where ProductID = any (select ProductID from [Order Details] where Quantity > 10)
-- where ProductID = any (select distinct  ProductID from [Order Details] where Quantity > 10)

-- same as above
select ProductID, ProductName
from Products
where ProductID in (select ProductID from [Order Details] where Quantity > 10)


--	下列查詢會用總價 >2000 找出產品名稱。
select * from Products
select * from [Order Details]

select ProductName
from products
where ProductID 
in (select distinct ProductID from [Order Details] where UnitPrice*Quantity>2000 )


--	『相關子查詢』示範
--		查詢產品基本資料、最高單價及平均單價
select * from Products
select * from [Order Details]

--  注意子查詢可在很多放在地方 ex. select, where
select ProductID, ProductName, 
	(select max(UnitPrice) from [Order Details]where ProductID = p.ProductID) as maxP,
	(select avg(UnitPrice) from [Order Details]where ProductID = p.ProductID) as avgP
from Products as p
order by maxP desc


--	EXISTS 如果子查詢包含任何資料列，便傳回 TRUE。
select * from Products				-- 77 records
select * from [Order Details]	-- 2,155 records

select ProductName, Quantity                -- 165,935 records
from Products, [Order Details] 

select ProductName, Quantity                -- 111,881 records, not null的概念
from Products as p, [Order Details] as od
where exists (select * from [Order Details] where ProductID = p.ProductID and
                         od.Quantity>12)
-- where 1=1

select ProductName                -- 54,054 records
from Products as p, [Order Details] as od
where not exists (select * from [Order Details] where ProductID = p.ProductID and
                         od.Quantity>12)


--	使用IN來表示，結果同上一範例
select ProductName
from Products
where ProductID in (select ProductID from [Order Details] where Quantity>100)

--下列查詢使用 = ANY。
select ProductName
from Products
where ProductID = any (select ProductID from [Order Details] where Quantity>100)


--	找出非 'Mexico' , 'Germany' 地區的客戶客戶資料
select * from orders
select * from Customers

select orderID, CustomerID
from Orders
where CustomerID in 
	(select CustomerID from Customers where Country not in ('Mexico', 'Germany'))


--	在子查詢中使用 NULL，仍會傳回結果集
select CustomerID, CompanyName, [Address]
from Customers
where exists (select null)		-- 忽略掉 null 的概念


