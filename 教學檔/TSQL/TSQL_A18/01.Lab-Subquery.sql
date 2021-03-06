 --	Module 18 琩高(Subquery) 笲ノ
--		18-1 : 级糶肚虫秖琩高
--		18-2 : 级糶肚琩高
--		18-3 : 穎皌 EXISTS の NOT EXISTS 琩高

--	琩高嘿ず场琩高τ琩高朝瓃Α嘿场琩高
--	秈︽戈琩高埃ㄏノ羛挡(JOIN)ㄏノ SQL 琩高 (Subquery)
--	琩高碞琌 SELECT ず SELECT 秈︽琩高
--	琩高膀セ粂猭㎝ SELECT 琩高盢琩高挡狦暗戈ㄓ方┪琌耞
--	狦琩高璶暗戈ㄓ方ㄏノゲ斗璶倒SQL臛醚

--	2017/ 2019  SQL Server		p 9-22 

--	Lab01级糶肚虫秖琩高
use Northwind;
go

-- 琩高す砛笲衡Αヴ竚ㄏノ
--	тOrders 肚OrderID ,  Order Detail い琩Τ碭掸
--  琩高where い
select * from Orders
select * from [Order Details]

select count(*) 
from [Order Details]
where OrderID = (select OrderID from Orders where OrderID = '10248')	-- 璶 Orders い True 阀├
--where OrderID = (select OrderID from Orders where Freight= 32.38)
--where OrderID in (select OrderID from Orders where Freight>32.38)
							

select * from Products
select * from [Order Details]

--  琩高select い
--  Order Detail いΤ ProductID Product ダ郎い絋粄

select ProductID, ProductName,
			(select sum(od.UnitPrice) from [Order Details] as od where od.ProductID = p.ProductID) as sale
from Products as p
order by sale desc


--	朝瓃Α碝т﹚基キА﹚基┮Τ玻珇嘿
select * from [Order Details]

select OrderID, UnitPrice
from [Order Details]
where UnitPrice > (select avg(UnitPrice) from [Order Details])


--	琩高矗ㄑ ANY ゑ耕笲衡矗琩高絛ㄒ 
--	ウ穦碝т睲虫基┪单ヴ玻珇摸ぇ程睲虫基玻珇

select * from Orders
select * from [Order Details]

select OrderID, UnitPrice
from [Order Details]
where UnitPrice >=								--  > min in any (> = 9.8)
		any (select UnitPrice from [Order Details] where OrderID in ( '10248', '10249'))

--where UnitPrice >=								--  > max (42.4)
	--	all (select UnitPrice from [Order Details] where OrderID in ( '10248', '10249'))


--	ㄌ玻珇摸т┮Τ玻珇嘿
--	=ANY 笲衡单 IN
--	ㄢ絛ㄒ挡狦
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


--	琩高穦ノ羆基 >2000 т玻珇嘿
select * from Products
select * from [Order Details]

select ProductName
from products
where ProductID 
in (select distinct ProductID from [Order Details] where UnitPrice*Quantity>2000 )


--	闽琩高ボ絛
--		琩高玻珇膀セ戈程蔼虫基のキА虫基
select * from Products
select * from [Order Details]

--  猔種琩高よ ex. select, where
select ProductID, ProductName, 
	(select max(UnitPrice) from [Order Details]where ProductID = p.ProductID) as maxP,
	(select avg(UnitPrice) from [Order Details]where ProductID = p.ProductID) as avgP
from Products as p
order by maxP desc


--	EXISTS 狦琩高ヴ戈獽肚 TRUE
select * from Products				-- 77 records
select * from [Order Details]	-- 2,155 records

select ProductName, Quantity                -- 165,935 records
from Products, [Order Details] 

select ProductName, Quantity                -- 111,881 records, not null阀├
from Products as p, [Order Details] as od
where exists (select * from [Order Details] where ProductID = p.ProductID and
                         od.Quantity>12)
-- where 1=1

select ProductName                -- 54,054 records
from Products as p, [Order Details] as od
where not exists (select * from [Order Details] where ProductID = p.ProductID and
                         od.Quantity>12)


--	ㄏノINㄓボ挡狦絛ㄒ
select ProductName
from Products
where ProductID in (select ProductID from [Order Details] where Quantity>100)

--琩高ㄏノ = ANY
select ProductName
from Products
where ProductID = any (select ProductID from [Order Details] where Quantity>100)


--	т獶 'Mexico' , 'Germany' 跋めめ戈
select * from orders
select * from Customers

select orderID, CustomerID
from Orders
where CustomerID in 
	(select CustomerID from Customers where Country not in ('Mexico', 'Germany'))


--	琩高いㄏノ NULLご穦肚挡狦栋
select CustomerID, CompanyName, [Address]
from Customers
where exists (select null)		-- ┛菠奔 null 阀├


