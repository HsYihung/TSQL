 --	Module 15 多表格聯結(Join) 的基本查詢語法
--		15-1 : 聯結(Join) 
--		15-2 : 內部聯結(Inner Joins) 
--		15-3 : 使用資料表的別名(Table Aliases)

--			聯結(JOIN) 是利用不同資料表之間欄位的關連性，來結合二個或多個資料表的資料合併查詢的語法。
--			聯結(JOIN) 是 SQL Server 中如何使用一個資料表的資料，來選取另一個資料表的資料列。
--			在原來各資料表中之紀錄及結構不會因為聯結查詢而改變。
--			透過聯結可以將正規化之後的資料表重新還原成便於使用者理解的資料型態。

--			內部聯結(Inner Joins) : 將所有資料表內的資料視為一個資料表。
--			Inner Join (內部連接) 最頻繁被使用，也是最重要的聯結方式。

--	2017/2019 SQL Server (p 9-3~6)

--  觀察 Orders & [Order Details] 關係

use Northwind;
go

select * from Orders
select * from [Order Details]

--	Lab01 INNER JOIN - 內部連接

--	不指定 join_type, 並且在 WHERE 子句指定聯結條件
select count(*) from Orders								-- 830
select count(*) from [Order Details]					--2155

select * from Orders, [Order Details]               -- 830 * 2155 = 1,788,650


--	take a look column contents
select * from Orders
select * from [Order Details]


--	以下二寫法完全相同
--	使用 Where 查詢, 並且在 = 指定聯結根據的條件。
select o.OrderID, CustomerID, ShipCity, ProductID -- Orders.OrderID 兩資料表都有, 不能模稜兩可
from Orders as o, [Order Details] as od
where o.OrderID = od.OrderID                                  -- Orders.OrderID 兩資料表都有, 不能模稜兩可
--where o.OrderID = 10248 and od.OrderID=10248


--	使用 INNER JOIN 查詢,並且在 ON 指定聯結根據的條件。
select o.OrderID, CustomerID, ShipCity, ProductID -- Orders.OrderID 不能模稜兩可
from Orders as o
inner join [Order Details] as od					-- default join = inner join 
on o.OrderID = od.OrderID


--	欄位名稱加資料庫別名, default join = inner join
select o.OrderID, o.CustomerID, o.ShipCity, od.ProductID -- Orders.OrderID 不能模稜兩可
from Orders as o
join [Order Details] as od
on o.OrderID = od.OrderID


--	指定資料表的所有欄位或特定欄位名稱
select o.*, ProductID			--  try 拿掉 'o.'
from Orders as o
join [Order Details] as od
on o.OrderID = od.OrderID

--  Show :  Northwind  →  資料庫圖表 →  右鍵 → 新增資料庫圖表 (order, order detail, employees, customers)

-- 若以上無法顯示,  請執行下列指令 :
--ALTER AUTHORIZATION ON DATABASE:: Northwind TO [sa]  

-- 目前各個 DB 的擁有者:
--select name, suser_sname(owner_sid) from sys.databases
-- [NewLogin] 改成跟 Northwind  →  右鍵屬性  →  資料庫  →  擁有者 寫的一樣
-- https://dev-felix72.blogspot.com/2017/05/sql-server-error-15404.html

-- https://docs.microsoft.com/zh-tw/sql/relational-databases/errors-events/mssqlserver-15517-database-engine-error?view=sql-server-ver15


--	INNER JOIN 三個資料表
select o.OrderID, od.ProductID, c.CompanyName 
from Orders as o
join [Order Details] as od
on o.OrderID = od.OrderID
join Customers as c
on o.CustomerID = c.CustomerID 


--	資料表別名的使用WHERE
select o.OrderID, od.ProductID, c.CompanyName -- Orders.OrderID 不能模稜兩可
from Orders as o
join [Order Details] as od
on o.OrderID = od.OrderID
join Customers  as c
on o.CustomerID = c.CustomerID 
where o.OrderID = 10248					--  one to many
