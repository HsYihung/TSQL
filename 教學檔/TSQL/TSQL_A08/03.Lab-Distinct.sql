--	Module 8 - Lab03 使用 DISTINCT

--	一個資料表的 "某些欄位" 中可能會有多筆紀錄都是相同的情況，
--	在 SELECT 查詢語法中我們可以使用 DISTINCT 關鍵字過濾重複出現的紀錄值。
--	如果 SELECT DISTINCT 後面有指定多個欄位，則要符合所有欄位都重複的情況下，
--	該筆資料行才會被過濾掉，否則就仍會取這該筆資料。

--	DISTINCT 關鍵字用於返回唯一不同的值。
--	在 SQL 中是用於查詢某個欄位中不重複的資料值。
--	DISTINCT 可以用於統計 : COUNT、AVG、MAX etc…
--	一個查詢語法只能使用一次 DISTINCT 關鍵字， 不支持多個 DISTINCT。

use Northwind;
go

select * from Orders

--	列出產品資料中不重覆的 CustomerID 資料
select distinct CustomerID from Orders;
go

--	算出產品資料中共有幾種 CustomerID
select count(distinct CustomerID) from Orders;		-- Count uncount NULL
select distinct CustomerID from Orders;					-- Distinct count in NULL 
select count (CustomerID) from Orders;
go

--	列出產品資料中不重覆的 CustomerID + ShipName 資料
select distinct CustomerID, ShipName from Orders;
go
