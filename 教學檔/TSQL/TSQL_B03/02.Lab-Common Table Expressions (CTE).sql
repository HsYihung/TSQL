--	Module 3 02.Lab - Common Table Expressions (CTE).sql

--			定稱為通用資料表運算式 (CTE) 的暫存具名結果集。 這是從簡單查詢衍生而來，
--			用來建立暫存資料表提供子查詢使用，當該查詢使用後，該暫存資料表將會自動釋放
--			定義在單一 SELECT、INSERT、UPDATE、DELETE 或 MERGE 陳述式的執行範圍內。 
--			您也可以在 CREATE VIEW 陳述式中使用這個子句，作為用來定義 SELECT 陳述式的一部分。 
--			通用資料表運算式可以包括指向本身的參考。 這稱為遞迴通用資料表運算式。check PDF


--		三個資料庫的三角關係 2007, 2008 & Sales.Customer
use AdventureWorks;

--	建一暫存資料表 y8,   y7也可用同樣的方法
with y8 (custid, salesamt2008) 
as (select customerID, sum(subTotal)
	from Sales.SalesOrderHeader					--  from SalesOrderHeader 2008
	where year(orderdate) =2008
	group by customerID
)
select * from y8;	-- 瞬間存在, 並未寫入tempDB, 當該查詢使用後，該暫存資料表將會自動釋放 like @table, 可再執行一次

-- 類似宣告 @xxxxx 變數

-- Error : 單獨 select 訪問會出錯
select * from y8			-- 不存在
go;

--	建兩個暫存資料表c2008, c2007
with y8 (custid, salesamt2008) 
as (select CustomerID, sum(subTotal)
	from Sales.SalesOrderHeader				--  from SalesOrderHeader 2008
	where year (orderdate) =2008
	group by customerID
),
y7 (custid, salesamt2007)  
as (select	customerID, sum (subTotal)
	from Sales.SalesOrderHeader				--  from SalesOrderHeader  2007
	where year (orderdate) =2007
	group by customerid
)
select	c.customerid, c.storeid, y8.salesamt2008, y7.salesamt2007,
			coalesce ((y8.salesamt2008 - y7.salesamt2007) /
							y7.salesamt2007 *100., 0) as PercentGrow
from Sales.Customer as c							-- from Customer and join with 2007 & 2008 by customer ID
left join y8 on c.customerid = y8.custid
left join y7 on c.customerid = y7.custid
order by PercentGrow desc ;
go
